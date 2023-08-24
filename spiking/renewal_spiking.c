#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include <omp.h>
#include "utils.h"
#include "renewal_spiking.h"

/*
=============
 Simulations
=============
*/

void begin_simulation(int intervention, double *vec) {
    printf("Beginning simulations...\n");

	srand ( (float) time(NULL) );
    parameters *params = init_parameters(intervention);
    record_buffer *r_buffer = init_record_buffer(params);

    int num_simulations = params->num_simulations;
    #pragma omp parallel for
    for (int simulation = 0; simulation < num_simulations; simulation++) {
        printf("simulating iteration - %i\n", simulation);
        run_simulation(params, r_buffer, simulation, vec);
        shuffle_stimuli(params);
    }

    compute_average_results(params, r_buffer);
    write_data_file(intervention, params, r_buffer);

    free_parameters(params);
    free_record_buffer(r_buffer);

    printf("finished\n");
}

void run_simulation(parameters *params, record_buffer* r_buffer, int simulation, double* vec) {
    spiking_network *network = init_spiking_network(params, vec);

    for (int trial = 0; trial < params->num_trials; trial++) {
        update_pf(trial, params, network);
        update_vis(trial, params, network);

        for (int step=0; step< params->num_steps; step++) {
            update_tan(step, params, network);
            update_msn(step, params, network);
            update_motor(step, params, network);
            update_response(step, params, network);

            if (network->response != -1) {
                network->response_time = step;

                for (int tt=network->response_time; tt<params->num_steps; tt++) {
                    update_tan(tt, params, network);
                    update_msn(tt, params, network);
                    update_motor(tt, params, network);
                }
                break;
            }
        }

        if (trial < params->num_acquisition_trials || trial >= params->num_acquisition_trials + params->num_extinction_trials) {
            update_feedback_contingent(trial, params, network);
        } else {
            params->update_feedback_intervention(trial, params, network);
        }

        update_dopamine_corr(trial, params, network);
        update_pf_tan(trial, params, network);
        update_vis_msn(trial, params, network);

        record_trial(trial, params, network, r_buffer, simulation);
        reset_trial(params, network);
    }
    record_simulation(simulation, params, r_buffer);

    free_spiking_network(network, params);
}

/*
============
 Parameters
============
*/

parameters *init_parameters(int intervention) {
    parameters *params = malloc(sizeof(parameters));
    params->num_acquisition_trials = 300;
    params->num_extinction_trials = 300;
    params->num_reacquisition_trials = 300;
    params->num_trials = params->num_acquisition_trials + params->num_extinction_trials + params->num_reacquisition_trials;
    params->intervention = intervention;

    switch (intervention) {
    	case 0:
    		params->update_feedback_intervention = update_feedback_nc_25;
    		break;
    	case 1:
    		params->update_feedback_intervention = update_feedback_nc_40;
    		break;
    	case 2:
    		params->update_feedback_intervention = update_feedback_nc_63;
    		break;
    	case 3:
    		params->update_feedback_intervention = update_feedback_mixed_7525;
    		break;
    	default:
    		break;
    }

    params->num_simulations = 25;
    params->stim_onset = 1000;
    params->stim_duration = 1000;
    params->T = 3000;
    params->tau = 1;
    params->num_steps = params->T/params->tau;
    params->dim = 200;
    params->num_contexts = 3;
    params->num_pf_cells_per_context = 5;
    params->num_pf_cells = params->num_contexts * params->num_pf_cells_per_context;
    params->num_pf_overlap = 1;
    params->spike_a = 1.0;
    params->spike_b = 100;
    params->spike_length = floor(7.64*params->spike_b);

    params->stim = malloc(3 * sizeof(float *));
    params->stim[0] = malloc(params->num_trials * sizeof(float));
    params->stim[1] = malloc(params->num_trials * sizeof(float));
    params->stim[2] = malloc(params->num_trials * sizeof(float));
    load_stim_param(params);
    return params;
}

void load_stim_param(parameters *params) {
    float** stim = params->stim;
    FILE *stim_fp = fopen("./stimuli_4_cat_200.txt", "r");
    for (int trial = 0; trial < params->num_trials; trial++) {
        fscanf(stim_fp, "%f %f %f\n", &stim[0][trial], &stim[1][trial], &stim[2][trial]);
    }
    fclose(stim_fp);
}

void free_parameters(parameters *params) {
    free(params->stim[0]);
    free(params->stim[1]);
    free(params->stim[2]);
    free(params->stim);
    free(params);
}

/*
=================
 Spiking Network
=================
*/

spiking_network *init_spiking_network(parameters *params, double *vec) {
    int num_trials = params->num_trials;
    int num_contexts = params->num_contexts;
    int num_pf_cells_per_context = params->num_pf_cells_per_context;
    int dim = params->dim;
    int num_steps = params->num_steps;
    int spike_length = params->spike_length;

    spiking_network *network = malloc(sizeof(spiking_network));
    network->current_context = 1;
    network->pf_amp = 1.65;
    network->current_context = -1;

    network->vis_amp = 25.0;
    network->vis_width = 50.0;
    network->vis_dist_x = 0.0;
    network->vis_dist_y = 0.0;

    network->w_noise_tan_L = 0.2;
    network->w_noise_tan_U = 0.2;
    network->w_noise_msn_L = 0.45;
    network->w_noise_msn_U = 0.55;

    network->lateral_inhibition_msn = 100.0;
    network->lateral_inhibition = 0.0;

    network->noise_tan_mu = 0.0;
    network->noise_tan_sigma = 1.0;

    network->noise_msn_mu = 200.0;
    network->noise_msn_sigma = 10.0;

    network->noise_motor_mu = 70.0;
    network->noise_motor_sigma = 1.0;

    network->noise = 0.0;

    network->w_vis_msn = 1.0;
    network->w_msn_motor = 0.1;

    network->w_tan_msn = 1000.0;

    network->w_ltp_vis_msn = 0.075e-8;
    network->w_ltd_vis_msn_1 = 0.05e-8;
    network->w_ltd_vis_msn_2 = 0.05e-11;

    network->w_ltp_pf_tan = 1.5e-5;
    network->w_ltd_pf_tan_1 = 0.9e-5;
    network->w_ltd_pf_tan_2 = 0.5e-6;

    network->nmda = 500.0;
    network->ampa = 100.0;

    network->confidence = 0.0;
    network->response = -1;
    network->response_time = -1;
    network->max_output = 0.0;

    network->resp_thresh = 5.0;

    network->obtained_feedback = 0.0;
    network->predicted_feedback = 0.0;
    network->w_prediction_error = 0.05;
    network->da = 0.0;
    network->da_base = 0.2;
    network->da_alpha = 1.0;
    network->da_beta = 25.0;
    network->r_theta = 0.85;

    network->pause_decay = 0.0018;
    network->pause_mod_amp = 2.7;

    float *w_params = malloc(8 * sizeof(float));
    if (vec) {
    	w_params[0] = vec[0];
	    w_params[1] = vec[1];
	    w_params[2] = vec[2];
	    w_params[3] = vec[3];
	    w_params[4] = vec[4];
	    w_params[5] = vec[5];
	    w_params[6] = vec[6];
	    w_params[7] = vec[7];
    } else {
	    w_params[0] = 9.840816e-02;
	    w_params[1] = 9.458643e-01;
	    w_params[2] = 1.406677e-01;
	    w_params[3] = 2.013654e-01;
	    w_params[4] = 3.489699e-01;
	    w_params[5] = 1.366589e-01;
	    w_params[6] = 8.266335e-01;
	    w_params[7] = 2.283242e-01;
	}

    network->w_tan_msn = w_params[0] * 2000.0 + 500.0; // [500 2000]
    network->w_ltp_vis_msn = w_params[1] * 1e-3; // [0 1e-3]
    network->w_ltd_vis_msn_1 = w_params[2] * 1e-3; // [0 1e-3]
    network->w_ltp_pf_tan = w_params[3] * 1e-3; // [0 1e-3]
    network->w_ltd_pf_tan_1 = w_params[4] * 1e-3; // [0 1e-3]
    network->da_alpha = w_params[5] + 0.2; // [.2 1]
    network->da_beta = w_params[6] * 100.0; // [0 100]
    network->r_theta = w_params[7] + 0.2; // [.2 1]
    free(w_params);

    network->r_p_pos = calloc(num_trials, sizeof(float));
    network->r_p_neg = calloc(num_trials, sizeof(float));
    network->r_I_pos = calloc(num_trials, sizeof(float));
    network->r_I_neg = calloc(num_trials, sizeof(float));
    network->r_omega_pos = calloc(num_trials, sizeof(float));
    network->r_omega_neg = calloc(num_trials, sizeof(float));
    network->r_p_pos_mean = calloc(num_trials, sizeof(float));
    network->r_p_neg_mean = calloc(num_trials, sizeof(float));

    network->pf = malloc(num_contexts * sizeof(float*));
    network->pf_sum = malloc(num_contexts * sizeof(float*));
    network->w_pf_tan = malloc(num_contexts * sizeof(float*));

    for (int context = 0; context < num_contexts; context++) {
        network->pf[context] = calloc(num_pf_cells_per_context, sizeof(float));
        network->pf_sum[context] = calloc(num_pf_cells_per_context, sizeof(float));
        network->w_pf_tan[context] = calloc(num_pf_cells_per_context, sizeof(float));
    }

    network->vis = calloc(dim*dim, sizeof(float));
    network->vis_sum = calloc(dim*dim, sizeof(float));
    network->w_vis_msn_A = calloc(dim*dim, sizeof(float));
    network->w_vis_msn_B = calloc(dim*dim, sizeof(float));
    network->w_vis_msn_C = calloc(dim*dim, sizeof(float));
    network->w_vis_msn_D = calloc(dim*dim, sizeof(float));
    network->vis_msn_act_A = calloc(num_steps, sizeof(float));
    network->vis_msn_act_B = calloc(num_steps, sizeof(float));
    network->vis_msn_act_C = calloc(num_steps, sizeof(float));
    network->vis_msn_act_D = calloc(num_steps, sizeof(float));

    network->spike = malloc(spike_length * sizeof(float));

    network->pf_mod = calloc(num_steps, sizeof(float));
    network->pause_mod = calloc(num_steps, sizeof(float));
    network->pf_tan_act = calloc(num_steps, sizeof(float));

    network->tan_v = calloc(num_steps, sizeof(float));
    network->tan_u = calloc(num_steps, sizeof(float));
    network->tan_spikes = calloc(num_steps, sizeof(int));
    network->tan_output = calloc(num_steps, sizeof(float));

    network->msn_v_A = calloc(num_steps, sizeof(float));
    network->msn_u_A = calloc(num_steps, sizeof(float));
    network->msn_spikes_A = calloc(num_steps, sizeof(int));
    network->msn_output_A = calloc(num_steps, sizeof(float));

    network->msn_v_B = calloc(num_steps, sizeof(float));
    network->msn_u_B = calloc(num_steps, sizeof(float));
    network->msn_spikes_B = calloc(num_steps, sizeof(int));
    network->msn_output_B = calloc(num_steps, sizeof(float));

    network->msn_v_C = calloc(num_steps, sizeof(float));
    network->msn_u_C = calloc(num_steps, sizeof(float));
    network->msn_spikes_C = calloc(num_steps, sizeof(int));
    network->msn_output_C = calloc(num_steps, sizeof(float));

    network->msn_v_D = calloc(num_steps, sizeof(float));
    network->msn_u_D = calloc(num_steps, sizeof(float));
    network->msn_spikes_D = calloc(num_steps, sizeof(int));
    network->msn_output_D = calloc(num_steps, sizeof(float));

    network->motor_v_A = calloc(num_steps, sizeof(float));
    network->motor_spikes_A = calloc(num_steps, sizeof(int));
    network->motor_output_A = calloc(num_steps, sizeof(float));

    network->motor_v_B = calloc(num_steps, sizeof(float));
    network->motor_spikes_B = calloc(num_steps, sizeof(int));
    network->motor_output_B = calloc(num_steps, sizeof(float));

    network->motor_v_C = calloc(num_steps, sizeof(float));
    network->motor_spikes_C = calloc(num_steps, sizeof(int));
    network->motor_output_C = calloc(num_steps, sizeof(float));

    network->motor_v_D = calloc(num_steps, sizeof(float));
    network->motor_spikes_D = calloc(num_steps, sizeof(int));
    network->motor_output_D = calloc(num_steps, sizeof(float));

    network->outputs = (float *) calloc(4, sizeof(float));

    init_network_weights(network, params);
    init_network_buffers(network, params);

    return network;
}

void init_network_weights(spiking_network *network, parameters *params) {
    int num_contexts = params->num_contexts;
    int num_pf_cells_per_context = params->num_pf_cells_per_context;

    for (int context=0; context<num_contexts; context++) {
        for (int pf_cell=0; pf_cell<num_pf_cells_per_context; pf_cell++) {
            network->w_pf_tan[context][pf_cell] = network->w_noise_tan_L + (network->w_noise_tan_U-network->w_noise_tan_L)*rand()/(float)RAND_MAX;
        }
    }

    // Init cortico-striatal weights
    int dim = params->dim;
    for (int d=0; d<dim*dim; d++) {
        network->w_vis_msn_A[d] = network->w_noise_msn_L + (network->w_noise_msn_U-network->w_noise_msn_L)*rand()/(float)RAND_MAX;
        network->w_vis_msn_B[d] = network->w_noise_msn_L + (network->w_noise_msn_U-network->w_noise_msn_L)*rand()/(float)RAND_MAX;
        network->w_vis_msn_C[d] = network->w_noise_msn_L + (network->w_noise_msn_U-network->w_noise_msn_L)*rand()/(float)RAND_MAX;
        network->w_vis_msn_D[d] = network->w_noise_msn_L + (network->w_noise_msn_U-network->w_noise_msn_L)*rand()/(float)RAND_MAX;
    }
}

void init_network_buffers(spiking_network *network, parameters *params) {
    int spike_length = params->spike_length;
    float* spike = network->spike;
    float spike_a = params->spike_a;
    float spike_b = params->spike_b;

    for (int i=0; i<spike_length; i++) {
        spike[i] = spike_a*((float)i/spike_b)*exp(-1.0*(i-spike_b)/spike_b);
    }
}

void free_spiking_network(spiking_network *network, parameters *params) {
    free(network->vis);
    free(network->vis_sum);
    free(network->w_vis_msn_A);
    free(network->w_vis_msn_B);
    free(network->w_vis_msn_C);
    free(network->w_vis_msn_D);
    free(network->vis_msn_act_A);
    free(network->vis_msn_act_B);
    free(network->vis_msn_act_C);
    free(network->vis_msn_act_D);

    free(network->spike);

    free(network->pf_mod);
    free(network->pause_mod);
    free(network->pf_tan_act);

    free(network->tan_v);
    free(network->tan_u);
    free(network->tan_spikes);
    free(network->tan_output);

    free(network->msn_v_A);
    free(network->msn_u_A);
    free(network->msn_spikes_A);
    free(network->msn_output_A);

    free(network->msn_v_B);
    free(network->msn_u_B);
    free(network->msn_spikes_B);
    free(network->msn_output_B);

    free(network->msn_v_C);
    free(network->msn_u_C);
    free(network->msn_spikes_C);
    free(network->msn_output_C);

    free(network->msn_v_D);
    free(network->msn_u_D);
    free(network->msn_spikes_D);
    free(network->msn_output_D);

    free(network->motor_v_A);
    free(network->motor_spikes_A);
    free(network->motor_output_A);

    free(network->motor_v_B);
    free(network->motor_spikes_B);
    free(network->motor_output_B);

    free(network->motor_v_C);
    free(network->motor_spikes_C);
    free(network->motor_output_C);

    free(network->motor_v_D);
    free(network->motor_spikes_D);
    free(network->motor_output_D);

    free(network->outputs);

    for (int context = 0; context < params->num_contexts; context++) {
        free(network->pf[context]);
        free(network->pf_sum[context]);
        free(network->w_pf_tan[context]);
    }

    free(network->r_p_pos);
    free(network->r_p_neg);
    free(network->r_I_pos);
    free(network->r_I_neg);
    free(network->r_omega_pos);
    free(network->r_omega_neg);
    free(network->r_p_pos_mean);
    free(network->r_p_neg_mean);

    free(network->pf);
    free(network->pf_sum);
    free(network->w_pf_tan);

    free(network);
}

/*
=========
 Records
=========
*/

record_buffer *init_record_buffer(parameters *params) {
    record_buffer *r_buffer = malloc(sizeof(record_buffer));

    int num_trials = r_buffer->num_trials = params->num_trials;
    int num_pf_cells = params->num_pf_cells;
    int dim = params->dim;
    int num_steps = params->num_steps;

    r_buffer->tan_v_record = calloc(num_trials, sizeof(float*));
    r_buffer->tan_output_record = calloc(num_trials, sizeof(float*));
    r_buffer->msn_v_A_record = calloc(num_trials, sizeof(float*));
    r_buffer->msn_v_B_record = calloc(num_trials, sizeof(float*));
    r_buffer->msn_v_C_record = calloc(num_trials, sizeof(float*));
    r_buffer->msn_v_D_record = calloc(num_trials, sizeof(float*));
    r_buffer->msn_output_A_record = calloc(num_trials, sizeof(float*));
    r_buffer->msn_output_B_record = calloc(num_trials, sizeof(float*));
    r_buffer->msn_output_C_record = calloc(num_trials, sizeof(float*));
    r_buffer->msn_output_D_record = calloc(num_trials, sizeof(float*));
    r_buffer->motor_v_A_record = calloc(num_trials, sizeof(float*));
    r_buffer->motor_v_B_record = calloc(num_trials, sizeof(float*));
    r_buffer->motor_v_C_record = calloc(num_trials, sizeof(float*));
    r_buffer->motor_v_D_record = calloc(num_trials, sizeof(float*));
    r_buffer->motor_output_A_record = calloc(num_trials, sizeof(float*));
    r_buffer->motor_output_B_record = calloc(num_trials, sizeof(float*));
    r_buffer->motor_output_C_record = calloc(num_trials, sizeof(float*));
    r_buffer->motor_output_D_record = calloc(num_trials, sizeof(float*));

    r_buffer->vis_record = calloc(num_trials, sizeof(float*));
    r_buffer->pf_record = calloc(num_trials, sizeof(float*));
    r_buffer->w_pf_tan_record = calloc(num_trials, sizeof(float*));
    r_buffer->w_vis_msn_A_record = calloc(num_trials, sizeof(float*));
    r_buffer->w_vis_msn_B_record = calloc(num_trials, sizeof(float*));
    r_buffer->w_vis_msn_C_record = calloc(num_trials, sizeof(float*));
    r_buffer->w_vis_msn_D_record = calloc(num_trials, sizeof(float*));

    r_buffer->w_pf_tan_record_ave = calloc(num_trials, sizeof(float*));
    r_buffer->w_vis_msn_A_record_ave = calloc(num_trials, sizeof(float*));
    r_buffer->w_vis_msn_B_record_ave = calloc(num_trials, sizeof(float*));
    r_buffer->w_vis_msn_C_record_ave = calloc(num_trials, sizeof(float*));
    r_buffer->w_vis_msn_D_record_ave = calloc(num_trials, sizeof(float*));

    for (int i=0;i<num_trials; i++) {
        r_buffer->pf_record[i] = calloc(num_pf_cells, sizeof(float));
        r_buffer->w_pf_tan_record[i] = calloc(num_pf_cells, sizeof(float));

        r_buffer->vis_record[i] = calloc(dim*dim, sizeof(float));
        r_buffer->w_vis_msn_A_record[i] = calloc(dim*dim, sizeof(float));
        r_buffer->w_vis_msn_B_record[i] = calloc(dim*dim, sizeof(float));
        r_buffer->w_vis_msn_C_record[i] = calloc(dim*dim, sizeof(float));
        r_buffer->w_vis_msn_D_record[i] = calloc(dim*dim, sizeof(float));

        r_buffer->w_pf_tan_record_ave[i] = calloc(num_pf_cells, sizeof(float));
        r_buffer->w_vis_msn_A_record_ave[i] = calloc(dim*dim, sizeof(float));
        r_buffer->w_vis_msn_B_record_ave[i] = calloc(dim*dim, sizeof(float));
        r_buffer->w_vis_msn_C_record_ave[i] = calloc(dim*dim, sizeof(float));
        r_buffer->w_vis_msn_D_record_ave[i] = calloc(dim*dim, sizeof(float));

        r_buffer->tan_v_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->tan_output_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->msn_v_A_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->msn_v_B_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->msn_v_C_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->msn_v_D_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->msn_output_A_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->msn_output_B_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->msn_output_C_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->msn_output_D_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->motor_v_A_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->motor_v_B_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->motor_v_C_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->motor_v_D_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->motor_output_A_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->motor_output_B_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->motor_output_C_record[i] = calloc(num_steps, sizeof(float));
        r_buffer->motor_output_D_record[i] = calloc(num_steps, sizeof(float));
    }

    r_buffer->response_record = calloc(num_trials, sizeof(float));
    r_buffer->response_time_record = calloc(num_trials, sizeof(float));
    r_buffer->predicted_feedback_record = calloc(num_trials, sizeof(float));
    r_buffer->dopamine_record = calloc(num_trials, sizeof(float));
    r_buffer->correlation_record = calloc(num_trials, sizeof(float));
    r_buffer->confidence_record = calloc(num_trials, sizeof(float));
    r_buffer->accuracy_record = calloc(num_trials, sizeof(float));

    r_buffer->response_record_ave = calloc(num_trials, sizeof(float));
    r_buffer->response_time_record_ave = calloc(num_trials, sizeof(float));
    r_buffer->predicted_feedback_record_ave = calloc(num_trials, sizeof(float));
    r_buffer->dopamine_record_ave = calloc(num_trials, sizeof(float));
    r_buffer->correlation_record_ave = calloc(num_trials, sizeof(float));
    r_buffer->confidence_record_ave = calloc(num_trials, sizeof(float));
    r_buffer->accuracy_record_ave = calloc(num_trials, sizeof(float));

    return r_buffer;
}

void free_record_buffer(record_buffer *r_buffer) {
    for (int i=0;i<r_buffer->num_trials; i++) {
        free(r_buffer->pf_record[i]);
        free(r_buffer->w_pf_tan_record[i]);

        free(r_buffer->vis_record[i]);
        free(r_buffer->w_vis_msn_A_record[i]);
        free(r_buffer->w_vis_msn_B_record[i]);
        free(r_buffer->w_vis_msn_C_record[i]);
        free(r_buffer->w_vis_msn_D_record[i]);

        free(r_buffer->w_pf_tan_record_ave[i]);
        free(r_buffer->w_vis_msn_A_record_ave[i]);
        free(r_buffer->w_vis_msn_B_record_ave[i]);
        free(r_buffer->w_vis_msn_C_record_ave[i]);
        free(r_buffer->w_vis_msn_D_record_ave[i]);

        free(r_buffer->tan_v_record[i]);
        free(r_buffer->tan_output_record[i]);
        free(r_buffer->msn_v_A_record[i]);
        free(r_buffer->msn_v_B_record[i]);
        free(r_buffer->msn_v_C_record[i]);
        free(r_buffer->msn_v_D_record[i]);
        free(r_buffer->msn_output_A_record[i]);
        free(r_buffer->msn_output_B_record[i]);
        free(r_buffer->msn_output_C_record[i]);
        free(r_buffer->msn_output_D_record[i]);
        free(r_buffer->motor_v_A_record[i]);
        free(r_buffer->motor_v_B_record[i]);
        free(r_buffer->motor_v_C_record[i]);
        free(r_buffer->motor_v_D_record[i]);
        free(r_buffer->motor_output_A_record[i]);
        free(r_buffer->motor_output_B_record[i]);
        free(r_buffer->motor_output_C_record[i]);
        free(r_buffer->motor_output_D_record[i]);
    }

    free(r_buffer->tan_v_record);
    free(r_buffer->tan_output_record);
    free(r_buffer->msn_v_A_record);
    free(r_buffer->msn_v_B_record);
    free(r_buffer->msn_v_C_record);
    free(r_buffer->msn_v_D_record);
    free(r_buffer->msn_output_A_record);
    free(r_buffer->msn_output_B_record);
    free(r_buffer->msn_output_C_record);
    free(r_buffer->msn_output_D_record);
    free(r_buffer->motor_v_A_record);
    free(r_buffer->motor_v_B_record);
    free(r_buffer->motor_v_C_record);
    free(r_buffer->motor_v_D_record);
    free(r_buffer->motor_output_A_record);
    free(r_buffer->motor_output_B_record);
    free(r_buffer->motor_output_C_record);
    free(r_buffer->motor_output_D_record);

    free(r_buffer->vis_record);
    free(r_buffer->pf_record);
    free(r_buffer->w_pf_tan_record);
    free(r_buffer->w_vis_msn_A_record);
    free(r_buffer->w_vis_msn_B_record);
    free(r_buffer->w_vis_msn_C_record);
    free(r_buffer->w_vis_msn_D_record);

    free(r_buffer->w_pf_tan_record_ave);
    free(r_buffer->w_vis_msn_A_record_ave);
    free(r_buffer->w_vis_msn_B_record_ave);
    free(r_buffer->w_vis_msn_C_record_ave);
    free(r_buffer->w_vis_msn_D_record_ave);

    free(r_buffer->response_record);
    free(r_buffer->response_time_record);
    free(r_buffer->predicted_feedback_record);
    free(r_buffer->dopamine_record);
    free(r_buffer->correlation_record);
    free(r_buffer->confidence_record);
    free(r_buffer->accuracy_record);

    free(r_buffer->response_record_ave);
    free(r_buffer->response_time_record_ave);
    free(r_buffer->predicted_feedback_record_ave);
    free(r_buffer->dopamine_record_ave);
    free(r_buffer->correlation_record_ave);
    free(r_buffer->confidence_record_ave);
    free(r_buffer->accuracy_record_ave);

    free(r_buffer);
}

void record_trial(int trial, parameters *params, spiking_network *network, record_buffer *r_buffer, int simulation) {
    int dim = params->dim;
    int num_contexts = params->num_contexts;
    int num_steps = params->num_steps;
    int num_pf_cells_per_context = params->num_pf_cells_per_context;

    memcpy(r_buffer->vis_record[trial], network->vis, dim*dim*sizeof(float));

    for (int i=0; i<num_contexts; i++) {
        for (int j=0; j<num_pf_cells_per_context; j++) {
            r_buffer->pf_record[trial][j+i*num_pf_cells_per_context] = network->pf[i][j];
            r_buffer->w_pf_tan_record[trial][j+i*num_pf_cells_per_context] = network->w_pf_tan[i][j];
        }
    }

    memcpy(r_buffer->tan_v_record[trial], network->tan_v, num_steps*sizeof(float));
    memcpy(r_buffer->msn_v_A_record[trial], network->msn_v_A, num_steps*sizeof(float));
    memcpy(r_buffer->msn_v_B_record[trial], network->msn_v_B, num_steps*sizeof(float));
    memcpy(r_buffer->msn_v_C_record[trial], network->msn_v_C, num_steps*sizeof(float));
    memcpy(r_buffer->msn_v_D_record[trial], network->msn_v_D, num_steps*sizeof(float));
    memcpy(r_buffer->motor_v_A_record[trial], network->motor_v_A, num_steps*sizeof(float));
    memcpy(r_buffer->motor_v_B_record[trial], network->motor_v_B, num_steps*sizeof(float));
    memcpy(r_buffer->motor_v_C_record[trial], network->motor_v_C, num_steps*sizeof(float));
    memcpy(r_buffer->motor_v_D_record[trial], network->motor_v_D, num_steps*sizeof(float));

    memcpy(r_buffer->tan_output_record[trial], network->tan_output, num_steps*sizeof(float));
    memcpy(r_buffer->msn_output_A_record[trial], network->msn_output_A, num_steps*sizeof(float));
    memcpy(r_buffer->msn_output_B_record[trial], network->msn_output_B, num_steps*sizeof(float));
    memcpy(r_buffer->msn_output_C_record[trial], network->msn_output_C, num_steps*sizeof(float));
    memcpy(r_buffer->msn_output_D_record[trial], network->msn_output_D, num_steps*sizeof(float));
    memcpy(r_buffer->motor_output_A_record[trial], network->motor_output_A, num_steps*sizeof(float));
    memcpy(r_buffer->motor_output_B_record[trial], network->motor_output_B, num_steps*sizeof(float));
    memcpy(r_buffer->motor_output_C_record[trial], network->motor_output_C, num_steps*sizeof(float));
    memcpy(r_buffer->motor_output_D_record[trial], network->motor_output_D, num_steps*sizeof(float));

    memcpy(r_buffer->w_vis_msn_A_record[trial], network->w_vis_msn_A, dim*dim*sizeof(float));
    memcpy(r_buffer->w_vis_msn_B_record[trial], network->w_vis_msn_B, dim*dim*sizeof(float));
    memcpy(r_buffer->w_vis_msn_C_record[trial], network->w_vis_msn_C, dim*dim*sizeof(float));
    memcpy(r_buffer->w_vis_msn_D_record[trial], network->w_vis_msn_D, dim*dim*sizeof(float));

    r_buffer->response_record[trial] = network->response;
    r_buffer->response_time_record[trial] = network->response_time;
    r_buffer->predicted_feedback_record[trial] = network->predicted_feedback;
    r_buffer->dopamine_record[trial] = network->da;
    r_buffer->correlation_record[trial] = network->correlation;
    r_buffer->confidence_record[trial] = network->confidence;
    r_buffer->accuracy_record[trial] = params->stim[0][trial] == network->response ? 1 : 0;
}

void record_simulation(int simulation, parameters *params, record_buffer *r_buffer) {
    int dim = params->dim;
    for (int i=0; i<params->num_trials; i++) {
        r_buffer->response_record_ave[i] += r_buffer->response_record[i];
        r_buffer->response_time_record_ave[i] += r_buffer->response_time_record[i];
        r_buffer->accuracy_record_ave[i] += r_buffer->accuracy_record_ave[i];
        r_buffer->dopamine_record_ave[i] += r_buffer->dopamine_record[i];
        r_buffer->predicted_feedback_record_ave[i] += r_buffer->predicted_feedback_record[i];
        r_buffer->correlation_record_ave[i] += r_buffer->correlation_record[i];
        r_buffer->confidence_record_ave[i] += r_buffer->confidence_record[i];

        vadd(r_buffer->w_pf_tan_record_ave[i], r_buffer->w_pf_tan_record[i], r_buffer->w_pf_tan_record_ave[i], params->num_pf_cells);
        vadd(r_buffer->w_vis_msn_A_record_ave[i], r_buffer->w_vis_msn_A_record[i], r_buffer->w_vis_msn_A_record_ave[i], dim*dim);
        vadd(r_buffer->w_vis_msn_B_record_ave[i], r_buffer->w_vis_msn_B_record[i], r_buffer->w_vis_msn_B_record_ave[i], dim*dim);
        vadd(r_buffer->w_vis_msn_C_record_ave[i], r_buffer->w_vis_msn_C_record[i], r_buffer->w_vis_msn_C_record_ave[i], dim*dim);
        vadd(r_buffer->w_vis_msn_D_record_ave[i], r_buffer->w_vis_msn_D_record[i], r_buffer->w_vis_msn_D_record_ave[i], dim*dim);
    }
}

void reset_trial(parameters *params, spiking_network *network) {
    int num_steps = params->num_steps;
    int num_contexts = params->num_contexts;
    int num_pf_cells_per_context = params->num_pf_cells_per_context;
    int dim = params->dim;

    network->response = -1;
    network->response_time = -1;
    network->obtained_feedback = 0.0;
    network->confidence = 0.0;

    network->msn_sum_A = 0.0;
    network->msn_sum_B = 0.0;
    network->msn_sum_C = 0.0;
    network->msn_sum_D = 0.0;

    memset(network->vis, 0, dim*dim*sizeof(float));
    memset(network->vis_sum, 0, dim*dim*sizeof(float));

    for (int i=0; i<num_contexts; i++) {
        for (int j=0; j<num_pf_cells_per_context; j++) {
            network->pf[i][j] = 0.0;
            network->pf_sum[i][j] = 0.0;
        }
    }
    network->tan_sum = 0.0;

    memset(network->tan_v, 0, num_steps*sizeof(float));
    memset(network->msn_v_A, 0, num_steps*sizeof(float));
    memset(network->msn_v_B, 0, num_steps*sizeof(float));
    memset(network->msn_v_C, 0, num_steps*sizeof(float));
    memset(network->msn_v_D, 0, num_steps*sizeof(float));
    memset(network->motor_v_A, 0, num_steps*sizeof(float));
    memset(network->motor_v_B, 0, num_steps*sizeof(float));
    memset(network->motor_v_C, 0, num_steps*sizeof(float));
    memset(network->motor_v_D, 0, num_steps*sizeof(float));

    memset(network->tan_output, 0, num_steps*sizeof(float));
    memset(network->msn_output_A, 0, num_steps*sizeof(float));
    memset(network->msn_output_B, 0, num_steps*sizeof(float));
    memset(network->msn_output_C, 0, num_steps*sizeof(float));
    memset(network->msn_output_D, 0, num_steps*sizeof(float));
    memset(network->motor_output_A, 0, num_steps*sizeof(float));
    memset(network->motor_output_B, 0, num_steps*sizeof(float));
    memset(network->motor_output_C, 0, num_steps*sizeof(float));
    memset(network->motor_output_D, 0, num_steps*sizeof(float));
}

void compute_average_results(parameters *params, record_buffer *r_buffer) {
    int num_trials = params->num_trials;
    float num_simulations = params->num_simulations;
    int dim = params->dim;
    int num_pf_cells = params->num_pf_cells;

    vsdiv(r_buffer->response_record_ave, num_simulations, r_buffer->response_record_ave, num_trials);
    vsdiv(r_buffer->accuracy_record_ave, num_simulations, r_buffer->accuracy_record_ave, num_trials);
    vsdiv(r_buffer->dopamine_record_ave, num_simulations, r_buffer->dopamine_record_ave, num_trials);
    vsdiv(r_buffer->predicted_feedback_record_ave, num_simulations, r_buffer->predicted_feedback_record_ave, num_trials);
    vsdiv(r_buffer->correlation_record_ave, num_simulations, r_buffer->correlation_record_ave, num_trials);
    vsdiv(r_buffer->confidence_record_ave, num_simulations, r_buffer->confidence_record_ave, num_trials);

    for (int i=0; i<num_trials; i++) {
        vsdiv(r_buffer->w_pf_tan_record_ave[i], num_simulations, r_buffer->w_pf_tan_record_ave[i], num_pf_cells);
        vsdiv(r_buffer->w_vis_msn_A_record_ave[i], num_simulations, r_buffer->w_vis_msn_A_record_ave[i], dim*dim);
        vsdiv(r_buffer->w_vis_msn_B_record_ave[i], num_simulations, r_buffer->w_vis_msn_B_record_ave[i], dim*dim);
        vsdiv(r_buffer->w_vis_msn_C_record_ave[i], num_simulations, r_buffer->w_vis_msn_C_record_ave[i], dim*dim);
        vsdiv(r_buffer->w_vis_msn_D_record_ave[i], num_simulations, r_buffer->w_vis_msn_D_record_ave[i], dim*dim);
    }
}

void write_data_file(int path, parameters *params, record_buffer *r_buffer) {
    FILE *response_file;
    FILE *response_time_file;
    FILE *acc_file;
    FILE *predicted_feedback_file;
    FILE *dopamine_file;
    FILE *correlation_file;
    FILE *confidence_file;

    FILE *vis_file;
    FILE *w_vis_msn_A_file;
    FILE *w_vis_msn_B_file;
    FILE *w_vis_msn_C_file;
    FILE *w_vis_msn_D_file;

    FILE *w_pf_tan_file;
    FILE *pf_file;

    FILE *tan_output_file;
    FILE *msn_output_A_file;
    FILE *msn_output_B_file;
    FILE *msn_output_C_file;
    FILE *msn_output_D_file;
    FILE *motor_output_A_file;
    FILE *motor_output_B_file;
    FILE *motor_output_C_file;
    FILE *motor_output_D_file;

    FILE *tan_v_file;
    FILE *msn_v_A_file;
    FILE *msn_v_B_file;
    FILE *msn_v_C_file;
    FILE *msn_v_D_file;
    FILE *motor_v_A_file;
    FILE *motor_v_B_file;
    FILE *motor_v_C_file;
    FILE *motor_v_D_file;

    switch (path) {
        case 0:
            response_file = fopen("./unlearning/nc_25/response.txt", "w");
            response_time_file = fopen("./unlearning/nc_25/response_time.txt", "w");
            acc_file = fopen("./unlearning/nc_25/acc.txt", "w");
            predicted_feedback_file = fopen("./unlearning/nc_25/predicted_feedback.txt", "w");
            dopamine_file = fopen("./unlearning/nc_25/dopamine.txt", "w");
            correlation_file = fopen("./unlearning/nc_25/correlation.txt", "w");
            confidence_file = fopen("./unlearning/nc_25/confidence.txt", "w");

            vis_file = fopen("./unlearning/nc_25/vis.txt","w");
            w_vis_msn_A_file = fopen("./unlearning/nc_25/w_vis_msn_A.txt","w");
            w_vis_msn_B_file = fopen("./unlearning/nc_25/w_vis_msn_B.txt","w");
            w_vis_msn_C_file = fopen("./unlearning/nc_25/w_vis_msn_C.txt","w");
            w_vis_msn_D_file = fopen("./unlearning/nc_25/w_vis_msn_D.txt","w");

            w_pf_tan_file = fopen("./unlearning/nc_25/w_pf_tan.txt", "w");
            pf_file = fopen("./unlearning/nc_25/pf.txt","w");

            tan_output_file = fopen("./unlearning/nc_25/tan_output.txt","w");
            msn_output_A_file = fopen("./unlearning/nc_25/msn_output_A.txt","w");
            msn_output_B_file = fopen("./unlearning/nc_25/msn_output_B.txt","w");
            msn_output_C_file = fopen("./unlearning/nc_25/msn_output_C.txt","w");
            msn_output_D_file = fopen("./unlearning/nc_25/msn_output_D.txt","w");
            motor_output_A_file = fopen("./unlearning/nc_25/mot_output_A.txt","w");
            motor_output_B_file = fopen("./unlearning/nc_25/mot_output_B.txt","w");
            motor_output_C_file = fopen("./unlearning/nc_25/mot_output_C.txt","w");
            motor_output_D_file = fopen("./unlearning/nc_25/mot_output_D.txt","w");

            tan_v_file = fopen("./unlearning/nc_25/tan_v.txt","w");
            msn_v_A_file = fopen("./unlearning/nc_25/msn_v_A.txt","w");
            msn_v_B_file = fopen("./unlearning/nc_25/msn_v_B.txt","w");
            msn_v_C_file = fopen("./unlearning/nc_25/msn_v_C.txt","w");
            msn_v_D_file = fopen("./unlearning/nc_25/msn_v_D.txt","w");
            motor_v_A_file = fopen("./unlearning/nc_25/mot_v_A.txt","w");
            motor_v_B_file = fopen("./unlearning/nc_25/mot_v_B.txt","w");
            motor_v_C_file = fopen("./unlearning/nc_25/mot_v_C.txt","w");
            motor_v_D_file = fopen("./unlearning/nc_25/mot_v_D.txt","w");
            break;

        case 1:

            response_file = fopen("./unlearning/nc_40/response.txt", "w");
            response_time_file = fopen("./unlearning/nc_40/response_time.txt", "w");
            acc_file = fopen("./unlearning/nc_40/acc.txt", "w");
            predicted_feedback_file = fopen("./unlearning/nc_40/predicted_feedback.txt", "w");
            dopamine_file = fopen("./unlearning/nc_40/dopamine.txt", "w");
            correlation_file = fopen("./unlearning/nc_40/correlation.txt", "w");
            confidence_file = fopen("./unlearning/nc_40/confidence.txt", "w");

            vis_file = fopen("./unlearning/nc_40/vis.txt","w");
            w_vis_msn_A_file = fopen("./unlearning/nc_40/w_vis_msn_A.txt","w");
            w_vis_msn_B_file = fopen("./unlearning/nc_40/w_vis_msn_B.txt","w");
            w_vis_msn_C_file = fopen("./unlearning/nc_40/w_vis_msn_C.txt","w");
            w_vis_msn_D_file = fopen("./unlearning/nc_40/w_vis_msn_D.txt","w");

            w_pf_tan_file = fopen("./unlearning/nc_40/w_pf_tan.txt", "w");
            pf_file = fopen("./unlearning/nc_40/pf.txt","w");

            tan_output_file = fopen("./unlearning/nc_40/tan_output.txt","w");
            msn_output_A_file = fopen("./unlearning/nc_40/msn_output_A.txt","w");
            msn_output_B_file = fopen("./unlearning/nc_40/msn_output_B.txt","w");
            msn_output_C_file = fopen("./unlearning/nc_40/msn_output_C.txt","w");
            msn_output_D_file = fopen("./unlearning/nc_40/msn_output_D.txt","w");
            motor_output_A_file = fopen("./unlearning/nc_40/mot_output_A.txt","w");
            motor_output_B_file = fopen("./unlearning/nc_40/mot_output_B.txt","w");
            motor_output_C_file = fopen("./unlearning/nc_40/mot_output_C.txt","w");
            motor_output_D_file = fopen("./unlearning/nc_40/mot_output_D.txt","w");

            tan_v_file = fopen("./unlearning/nc_40/tan_v.txt","w");
            msn_v_A_file = fopen("./unlearning/nc_40/msn_v_A.txt","w");
            msn_v_B_file = fopen("./unlearning/nc_40/msn_v_B.txt","w");
            msn_v_C_file = fopen("./unlearning/nc_40/msn_v_C.txt","w");
            msn_v_D_file = fopen("./unlearning/nc_40/msn_v_D.txt","w");
            motor_v_A_file = fopen("./unlearning/nc_40/mot_v_A.txt","w");
            motor_v_B_file = fopen("./unlearning/nc_40/mot_v_B.txt","w");
            motor_v_C_file = fopen("./unlearning/nc_40/mot_v_C.txt","w");
            motor_v_D_file = fopen("./unlearning/nc_40/mot_v_D.txt","w");
            break;

        case 2:

            response_file = fopen("./unlearning/nc_63/response.txt", "w");
            response_time_file = fopen("./unlearning/nc_63/response_time.txt", "w");
            acc_file = fopen("./unlearning/nc_63/acc.txt", "w");
            predicted_feedback_file = fopen("./unlearning/nc_63/predicted_feedback.txt", "w");
            dopamine_file = fopen("./unlearning/nc_63/dopamine.txt", "w");
            correlation_file = fopen("./unlearning/nc_63/correlation.txt", "w");
            confidence_file = fopen("./unlearning/nc_63/confidence.txt", "w");

            vis_file = fopen("./unlearning/nc_63/vis.txt","w");
            w_vis_msn_A_file = fopen("./unlearning/nc_63/w_vis_msn_A.txt","w");
            w_vis_msn_B_file = fopen("./unlearning/nc_63/w_vis_msn_B.txt","w");
            w_vis_msn_C_file = fopen("./unlearning/nc_63/w_vis_msn_C.txt","w");
            w_vis_msn_D_file = fopen("./unlearning/nc_63/w_vis_msn_D.txt","w");

            w_pf_tan_file = fopen("./unlearning/nc_63/w_pf_tan.txt", "w");
            pf_file = fopen("./unlearning/nc_63/pf.txt","w");

            tan_output_file = fopen("./unlearning/nc_63/tan_output.txt","w");
            msn_output_A_file = fopen("./unlearning/nc_63/msn_output_A.txt","w");
            msn_output_B_file = fopen("./unlearning/nc_63/msn_output_B.txt","w");
            msn_output_C_file = fopen("./unlearning/nc_63/msn_output_C.txt","w");
            msn_output_D_file = fopen("./unlearning/nc_63/msn_output_D.txt","w");
            motor_output_A_file = fopen("./unlearning/nc_63/mot_output_A.txt","w");
            motor_output_B_file = fopen("./unlearning/nc_63/mot_output_B.txt","w");
            motor_output_C_file = fopen("./unlearning/nc_63/mot_output_C.txt","w");
            motor_output_D_file = fopen("./unlearning/nc_63/mot_output_D.txt","w");

            tan_v_file = fopen("./unlearning/nc_63/tan_v.txt","w");
            msn_v_A_file = fopen("./unlearning/nc_63/msn_v_A.txt","w");
            msn_v_B_file = fopen("./unlearning/nc_63/msn_v_B.txt","w");
            msn_v_C_file = fopen("./unlearning/nc_63/msn_v_C.txt","w");
            msn_v_D_file = fopen("./unlearning/nc_63/msn_v_D.txt","w");
            motor_v_A_file = fopen("./unlearning/nc_63/mot_v_A.txt","w");
            motor_v_B_file = fopen("./unlearning/nc_63/mot_v_B.txt","w");
            motor_v_C_file = fopen("./unlearning/nc_63/mot_v_C.txt","w");
            motor_v_D_file = fopen("./unlearning/nc_63/mot_v_D.txt","w");
            break;

        case 3:

            response_file = fopen("./unlearning/mixed_7525/response.txt", "w");
            response_time_file = fopen("./unlearning/mixed_7525/response_time.txt", "w");
            acc_file = fopen("./unlearning/mixed_7525/acc.txt", "w");
            predicted_feedback_file = fopen("./unlearning/mixed_7525/predicted_feedback.txt", "w");
            dopamine_file = fopen("./unlearning/mixed_7525/dopamine.txt", "w");
            correlation_file = fopen("./unlearning/mixed_7525/correlation.txt", "w");
            confidence_file = fopen("./unlearning/mixed_7525/confidence.txt", "w");

            vis_file = fopen("./unlearning/mixed_7525/vis.txt","w");
            w_vis_msn_A_file = fopen("./unlearning/mixed_7525/w_vis_msn_A.txt","w");
            w_vis_msn_B_file = fopen("./unlearning/mixed_7525/w_vis_msn_B.txt","w");
            w_vis_msn_C_file = fopen("./unlearning/mixed_7525/w_vis_msn_C.txt","w");
            w_vis_msn_D_file = fopen("./unlearning/mixed_7525/w_vis_msn_D.txt","w");

            w_pf_tan_file = fopen("./unlearning/mixed_7525/w_pf_tan.txt", "w");
            pf_file = fopen("./unlearning/mixed_7525/pf.txt","w");

            tan_output_file = fopen("./unlearning/mixed_7525/tan_output.txt","w");
            msn_output_A_file = fopen("./unlearning/mixed_7525/msn_output_A.txt","w");
            msn_output_B_file = fopen("./unlearning/mixed_7525/msn_output_B.txt","w");
            msn_output_C_file = fopen("./unlearning/mixed_7525/msn_output_C.txt","w");
            msn_output_D_file = fopen("./unlearning/mixed_7525/msn_output_D.txt","w");
            motor_output_A_file = fopen("./unlearning/mixed_7525/mot_output_A.txt","w");
            motor_output_B_file = fopen("./unlearning/mixed_7525/mot_output_B.txt","w");
            motor_output_C_file = fopen("./unlearning/mixed_7525/mot_output_C.txt","w");
            motor_output_D_file = fopen("./unlearning/mixed_7525/mot_output_D.txt","w");

            tan_v_file = fopen("./unlearning/mixed_7525/tan_v.txt","w");
            msn_v_A_file = fopen("./unlearning/mixed_7525/msn_v_A.txt","w");
            msn_v_B_file = fopen("./unlearning/mixed_7525/msn_v_B.txt","w");
            msn_v_C_file = fopen("./unlearning/mixed_7525/msn_v_C.txt","w");
            msn_v_D_file = fopen("./unlearning/mixed_7525/msn_v_D.txt","w");
            motor_v_A_file = fopen("./unlearning/mixed_7525/mot_v_A.txt","w");
            motor_v_B_file = fopen("./unlearning/mixed_7525/mot_v_B.txt","w");
            motor_v_C_file = fopen("./unlearning/mixed_7525/mot_v_C.txt","w");
            motor_v_D_file = fopen("./unlearning/mixed_7525/mot_v_D.txt","w");
            break;

        default:
            break;
    }

    int num_trials = params->num_trials;
    int num_contexts = params->num_contexts;
    int dim = params->dim;
    int num_steps = params->num_steps;
    int num_pf_cells_per_context = params->num_pf_cells_per_context;

    for (int i=0; i<num_trials; i++) {
        fprintf(response_file, "%f\n", r_buffer->response_record_ave[i]);
        fprintf(response_time_file, "%f\n", r_buffer->response_time_record_ave[i]);
        fprintf(acc_file, "%f\n",r_buffer->accuracy_record_ave[i]);
        fprintf(predicted_feedback_file, "%f\n", r_buffer->predicted_feedback_record_ave[i]);
        fprintf(dopamine_file, "%f\n", r_buffer->dopamine_record_ave[i]);
        fprintf(correlation_file, "%f\n", r_buffer->correlation_record_ave[i]);
        fprintf(confidence_file, "%f\n", r_buffer->confidence_record_ave[i]);

        for (int j=0; j<num_contexts; j++) {
            for (int k=0; k<num_pf_cells_per_context; k++)
            {
                fprintf(pf_file, "%f ", r_buffer->w_pf_tan_record[i][k+j*num_pf_cells_per_context]);
                fprintf(w_pf_tan_file, "%f ", r_buffer->w_pf_tan_record[i][k+j*num_pf_cells_per_context]);
            }
        }

        for (int j=0; j<dim*dim; j++) {
            fprintf(vis_file, "%f ", r_buffer->vis_record[i][j]);
            fprintf(w_vis_msn_A_file, "%f ", r_buffer->w_vis_msn_A_record_ave[i][j]);
            fprintf(w_vis_msn_B_file, "%f ", r_buffer->w_vis_msn_B_record_ave[i][j]);
            fprintf(w_vis_msn_C_file, "%f ", r_buffer->w_vis_msn_C_record_ave[i][j]);
            fprintf(w_vis_msn_D_file, "%f ", r_buffer->w_vis_msn_D_record_ave[i][j]);
        }

        for (int j=0; j<num_steps; j++) {
            fprintf(tan_output_file, "%f ", r_buffer->tan_output_record[i][j]);
            fprintf(msn_output_A_file, "%f ", r_buffer->msn_output_A_record[i][j]);
            fprintf(msn_output_B_file, "%f ", r_buffer->msn_output_B_record[i][j]);
            fprintf(msn_output_C_file, "%f ", r_buffer->msn_output_C_record[i][j]);
            fprintf(msn_output_D_file, "%f ", r_buffer->msn_output_D_record[i][j]);
            fprintf(motor_output_A_file, "%f ", r_buffer->motor_output_A_record[i][j]);
            fprintf(motor_output_B_file, "%f ", r_buffer->motor_output_B_record[i][j]);
            fprintf(motor_output_C_file, "%f ", r_buffer->motor_output_C_record[i][j]);
            fprintf(motor_output_D_file, "%f ", r_buffer->motor_output_D_record[i][j]);

            fprintf(tan_v_file, "%f ", r_buffer->tan_v_record[i][j]);
            fprintf(msn_v_A_file, "%f ", r_buffer->msn_v_A_record[i][j]);
            fprintf(msn_v_B_file, "%f ", r_buffer->msn_v_B_record[i][j]);
            fprintf(msn_v_C_file, "%f ", r_buffer->msn_v_C_record[i][j]);
            fprintf(msn_v_D_file, "%f ", r_buffer->msn_v_D_record[i][j]);
            fprintf(motor_v_A_file, "%f ", r_buffer->motor_v_A_record[i][j]);
            fprintf(motor_v_B_file, "%f ", r_buffer->motor_v_B_record[i][j]);
            fprintf(motor_v_C_file, "%f ", r_buffer->motor_v_C_record[i][j]);
            fprintf(motor_v_D_file, "%f ", r_buffer->motor_v_D_record[i][j]);
        }

        fprintf(vis_file, "\n");
        fprintf(w_pf_tan_file, "\n");
        fprintf(w_vis_msn_A_file, "\n");
        fprintf(w_vis_msn_B_file, "\n");
        fprintf(w_vis_msn_C_file, "\n");
        fprintf(w_vis_msn_D_file, "\n");
        fprintf(pf_file, "\n");
        fprintf(tan_output_file, "\n");
        fprintf(msn_output_A_file, "\n");
        fprintf(msn_output_B_file, "\n");
        fprintf(msn_output_C_file, "\n");
        fprintf(msn_output_D_file, "\n");
        fprintf(motor_output_A_file, "\n");
        fprintf(motor_output_B_file, "\n");
        fprintf(motor_output_C_file, "\n");
        fprintf(motor_output_D_file, "\n");
        fprintf(tan_v_file, "\n");
        fprintf(msn_v_A_file, "\n");
        fprintf(msn_v_B_file, "\n");
        fprintf(msn_v_C_file, "\n");
        fprintf(msn_v_D_file, "\n");
        fprintf(motor_v_A_file, "\n");
        fprintf(motor_v_B_file, "\n");
        fprintf(motor_v_C_file, "\n");
        fprintf(motor_v_D_file, "\n");
    }

    fclose(response_file);
    fclose(response_time_file);
    fclose(acc_file);
    fclose(predicted_feedback_file);
    fclose(dopamine_file);
    fclose(correlation_file);
    fclose(confidence_file);
    fclose(w_pf_tan_file);
    fclose(vis_file);
    fclose(w_vis_msn_A_file);
    fclose(w_vis_msn_B_file);
    fclose(w_vis_msn_C_file);
    fclose(w_vis_msn_D_file);
    fclose(pf_file);
    fclose(tan_output_file);
    fclose(msn_output_A_file);
    fclose(msn_output_B_file);
    fclose(msn_output_C_file);
    fclose(msn_output_D_file);
    fclose(motor_output_A_file);
    fclose(motor_output_B_file);
    fclose(motor_output_C_file);
    fclose(motor_output_D_file);
    fclose(tan_v_file);
    fclose(msn_v_A_file);
    fclose(msn_v_B_file);
    fclose(msn_v_C_file);
    fclose(msn_v_D_file);
    fclose(motor_v_A_file);
    fclose(motor_v_B_file);
    fclose(motor_v_C_file);
    fclose(motor_v_D_file);
}

/*
===========
 The Model
===========
*/

void shuffle_stimuli(parameters *params) {
    int temp_0, temp_1, temp_2, i, j;

    float** stim = params->stim;
    int num_trials = params->num_trials;

    for (i=0; i<num_trials-1; i++)
    {
        j = i + rand() / ((float)RAND_MAX / (num_trials-i) + 1);

        temp_0 = stim[0][j];
        temp_1 = stim[1][j];
        temp_2 = stim[2][j];

        stim[0][j] = stim[0][i];
        stim[1][j] = stim[1][i];
        stim[2][j] = stim[2][i];

        stim[0][i] = temp_0;
        stim[1][i] = temp_1;
        stim[2][i] = temp_2;
    }
}

void update_pf(int trial, parameters *params, spiking_network *network) {
	// We assume that there are num_pf_overlap features common to all three contexts
	int num_pf_cells_per_context = params->num_pf_cells_per_context;
    int num_pf_overlap = params->num_pf_overlap;
    float** pf = network->pf;

    switch (network->current_context) {
		case 1: // Model is in context A
			// Turn on every context A Pf cell
			for (int i=0; i<num_pf_cells_per_context; i++) {
				pf[0][i] = 1.0;
			}
			// Turn on context B Pf cells that overlap with context A
			for (int i=0; i<num_pf_overlap; i++) {
				pf[1][i] = 1.0;
			}
			// Turn on context C Pf cells that overlap with context A
			for (int i=0; i<num_pf_overlap; i++) {
				pf[2][i] = 1.0;
			}
			break;
		case 2: // Model is in context B
			for (int i=0; i<num_pf_cells_per_context; i++) {
				pf[1][i] = 1.0;
			}
			for (int i=0; i<num_pf_overlap; i++) {
				pf[2][i] = 1.0;
			}
			for (int i=0; i<num_pf_overlap; i++) {
				pf[0][i] = 1.0;
			}
			break;
		case 3: // Model is in context C

			for (int i=0; i<num_pf_cells_per_context; i++) {
				pf[2][i] = 1.0;
			}
			for (int i=0; i<num_pf_overlap; i++) {
				pf[0][i] = 1.0;
			}
			for (int i=0; i<num_pf_overlap; i++) {
				pf[1][i] = 1.0;
			}
			break;
		default:
			break;
	}

	int stim_onset = params->stim_onset;
    int stim_duration = params->stim_duration;
    int num_steps = params->num_steps;
    float *pf_mod = network->pf_mod;
    float *pause_mod = network->pause_mod;
    float pf_amp = network->pf_amp;

    /* Pf_mod is a decaying exponential with initial height = pf_amp*(num_pf_cells_per_context+num_pf_overlap) */
	memset(pf_mod,0,stim_onset*sizeof(float));
	for (int i=0; i<num_steps; i++) {
		pf_mod[i] = pf_amp*(num_pf_cells_per_context+num_pf_overlap)*exp(-network->pause_decay*i);
	}
	// pause_mod is a square wave with a decaying expoential tail, also with initial height = pf_amp*(num_pf_cells_per_context+num_pf_overlap)
	memset(pause_mod,0,stim_onset*sizeof(float));
	for (int i=stim_onset; i<stim_onset+stim_duration; i++) {
		pause_mod[i] = pf_amp*(num_pf_cells_per_context+num_pf_overlap);
	}

	for (int i=stim_onset+stim_duration; i<num_steps; i++) {
		pause_mod[i] = pf_mod[i-(stim_onset+stim_duration)];
	}

	// Now, we figure out the collective pf-tan synaptic strength to be used in the TAN modulatory equation
	// This should basically be some kind of weighted average so that the Pf Cells in the active context
	// influence it most. With just two contexts, the old version of the model used:
	// Pf_TAN = (Pf_TAN_A*Pf_amp_A+Pf_TAN_B*Pf_amp_B)/(Pf_amp_A+Pf_amp_B);

	int num_contexts = params->num_contexts;
    float** w_pf_tan = network->w_pf_tan;

    network->pf_tan_mod = 0.0;
    for (int i=0; i<num_contexts; i++) {
        for (int j=0; j<num_pf_cells_per_context; j++) {
			network->pf_tan_mod += pf[i][j]*w_pf_tan[i][j]*pf_amp;
		}
	}

	network->pf_tan_mod = network->pf_tan_mod / (float) pf_amp*(num_pf_cells_per_context+(num_contexts-1.0)*num_pf_overlap);

    memset(network->pf_tan_act,0,num_steps*sizeof(float));
    for (int i=0; i<num_contexts; i++) {
		for (int j=0; j<num_pf_cells_per_context; j++) {
            for (int k=stim_onset; k<stim_onset+stim_duration; k++) {
                network->pf_tan_act[k] += w_pf_tan[i][j]*pf[i][j];
            }
		}
	}
}

void update_vis(int trial, parameters *params, spiking_network *network) {
    float** stim = params->stim;
    int dim = params->dim;
    float* vis = network->vis;

    network->vis_dist_x = 0.0;
    network->vis_dist_y = 0.0;

    for (int i=0; i<dim; i++) {
        for (int j=0; j<dim; j++) {
            network->vis_dist_x = stim[1][trial] - j;
            network->vis_dist_y = stim[2][trial] - i;

			vis[j + i*dim] = network->vis_amp*exp(-(network->vis_dist_x*network->vis_dist_x+network->vis_dist_y*network->vis_dist_y)/network->vis_width);
        }
    }

    float* w_vis_msn_A = network->w_vis_msn_A;
    float* w_vis_msn_B = network->w_vis_msn_B;
    float* w_vis_msn_C = network->w_vis_msn_C;
    float* w_vis_msn_D = network->w_vis_msn_D;

    dotpr(vis, w_vis_msn_A, &network->vis_act_A, dim*dim);
    dotpr(vis, w_vis_msn_B, &network->vis_act_B, dim*dim);
    dotpr(vis, w_vis_msn_C, &network->vis_act_C, dim*dim);
    dotpr(vis, w_vis_msn_D, &network->vis_act_D, dim*dim);

    int stim_onset = params->stim_onset;
    int stim_duration = params->stim_duration;

    float* vis_msn_act_A = network->vis_msn_act_A;
    float* vis_msn_act_B = network->vis_msn_act_B;
    float* vis_msn_act_C = network->vis_msn_act_C;
    float* vis_msn_act_D = network->vis_msn_act_D;

    for (int k=stim_onset; k<stim_onset+stim_duration; k++) {
        vis_msn_act_A[k] = network->vis_act_A;
        vis_msn_act_B[k] = network->vis_act_B;
        vis_msn_act_C[k] = network->vis_act_C;
        vis_msn_act_D[k] = network->vis_act_D;
    }
}

void update_tan(int step, parameters *params, spiking_network *network) {
	// IB -- intrinsically bursting
	float C=100.0, vr=-75.0, vt=-45.0, k=1.2;
	float a=0.01, b=5.0, c=-56.0, d=130.0;
	float vpeak=60.0;
	float E=950.0;

    int i = step;
    float* tan_v = network->tan_v;
    float* tan_u = network->tan_u;
    tan_v[0] = vr;

    network->noise = randn(network->noise_tan_mu, network->noise_tan_sigma);
    tan_v[i+1]=tan_v[i]+params->tau*(k*(tan_v[i]-vr)*(tan_v[i]-vt)-tan_u[i]+E+network->pf_tan_act[i]+network->noise)/C;
    tan_u[i+1]=tan_u[i]+params->tau*a*(b*(tan_v[i]-vr)-tan_u[i]+network->pf_tan_mod*network->pause_mod_amp*network->pause_mod[i]);

    int num_steps = params->num_steps;
    int spike_length = params->spike_length;

    if (tan_v[i+1]>=vpeak) {
        tan_v[i]=vpeak;
        tan_v[i+1]=c;
        tan_u[i+1]=tan_u[i+1]+d;
        network->tan_spikes[i+1]=1;

        if (i<num_steps-spike_length) {
            for (int j=0; j<spike_length; j++) {
                network->tan_output[i+j] += network->spike[j];
            }
        } else {
            for (int j=0; j<num_steps-i; j++) {
                network->tan_output[i+j] += network->spike[j];
            }
        }

    } else {
        network->tan_spikes[i+1]=0;
    }
}

void update_msn(int step, parameters *params, spiking_network *network) {
    // Izichevich msn
	float C=50, vr=-80, vt=-25, k=1;
	float a=0.01, b=-20, c=-55, d=150;
	float vpeak=40;

    int i = step;
    float tau = params->tau;
    float noise_msn_mu = network->noise_msn_mu;
    float noise_msn_sigma = network->noise_msn_sigma;
    float lateral_inhibition_msn = network->lateral_inhibition_msn;

    float *msn_v_A = network->msn_v_A;
    float *msn_v_B = network->msn_v_B;
    float *msn_v_C = network->msn_v_C;
    float *msn_v_D = network->msn_v_D;

    msn_v_A[0] = vr;
    msn_v_B[0] = vr;
    msn_v_C[0] = vr;
    msn_v_D[0] = vr;

    float *msn_u_A = network->msn_u_A;
    float *msn_u_B = network->msn_u_B;
    float *msn_u_C = network->msn_u_C;
    float *msn_u_D = network->msn_u_D;

    float *msn_output_A = network->msn_output_A;
    float *msn_output_B = network->msn_output_B;
    float *msn_output_C = network->msn_output_C;
    float *msn_output_D = network->msn_output_D;

    float w_vis_msn = network->w_vis_msn;
    float w_tan_msn = network->w_tan_msn;
    float* tan_output = network->tan_output;

    network->noise = randn(noise_msn_mu, noise_msn_sigma);
    network->lateral_inhibition = lateral_inhibition_msn*(network->msn_output_B[i]+network->msn_output_C[i]+msn_output_D[i]);
    msn_v_A[i+1] = msn_v_A[i] + tau*(k*(msn_v_A[i]-vr)*(msn_v_A[i]-vt)-msn_u_A[i]+ w_vis_msn*pos(network->vis_msn_act_A[i]-w_tan_msn*tan_output[i])-network->lateral_inhibition+network->noise)/C;
    msn_u_A[i+1] = msn_u_A[i]+tau*a*(b*(msn_v_A[i]-vr)-msn_u_A[i]);

    network->noise = randn(noise_msn_mu, noise_msn_sigma);
    network->lateral_inhibition = lateral_inhibition_msn*(network->msn_output_A[i]+network->msn_output_C[i]+msn_output_D[i]);
    msn_v_B[i+1] = msn_v_B[i] + tau*(k*(msn_v_B[i]-vr)*(msn_v_B[i]-vt)-msn_u_B[i]+ w_vis_msn*pos(network->vis_msn_act_B[i]-w_tan_msn*tan_output[i])-network->lateral_inhibition+network->noise)/C;
    msn_u_B[i+1] = msn_u_B[i]+tau*a*(b*(msn_v_B[i]-vr)-msn_u_B[i]);

    network->noise = randn(noise_msn_mu, noise_msn_sigma);
    network->lateral_inhibition = lateral_inhibition_msn*(network->msn_output_A[i]+network->msn_output_B[i]+msn_output_D[i]);
    msn_v_C[i+1] = msn_v_C[i] + tau*(k*(msn_v_C[i]-vr)*(msn_v_C[i]-vt)-msn_u_C[i]+ w_vis_msn*pos(network->vis_msn_act_C[i]-w_tan_msn*tan_output[i])-network->lateral_inhibition+network->noise)/C;
    msn_u_C[i+1] = msn_u_C[i]+tau*a*(b*(msn_v_C[i]-vr)-msn_u_C[i]);

    network->noise = randn(noise_msn_mu, noise_msn_sigma);
    network->lateral_inhibition = lateral_inhibition_msn*(network->msn_output_A[i]+network->msn_output_B[i]+network->msn_output_C[i]);
    msn_v_D[i+1] = msn_v_D[i] + tau*(k*(msn_v_D[i]-vr)*(msn_v_D[i]-vt)-msn_u_D[i]+ w_vis_msn*pos(network->vis_msn_act_D[i]-w_tan_msn*tan_output[i])-network->lateral_inhibition+network->noise)/C;
    msn_u_D[i+1] = msn_u_D[i]+tau*a*(b*(msn_v_D[i]-vr)-msn_u_D[i]);

    int spike_length = params->spike_length;
    int num_steps = params->num_steps;
    float *spike = network->spike;

    if (msn_v_A[i+1]>=vpeak) {
        msn_v_A[i]=vpeak;
        msn_v_A[i+1]=c;
        msn_u_A[i+1]=msn_u_A[i+1]+d;
        network->msn_spikes_A[i+1] = 1;

        if (i<num_steps-spike_length) {
            for (int j=0; j<spike_length; j++) {
                msn_output_A[i+j] += spike[j];
            }
        } else {
            for (int j=0; j<num_steps-i; j++) {
                msn_output_A[i+j] += spike[j];
            }
        }

    } else {
        network->msn_spikes_A[i+1] = 0;
    }

    if (msn_v_B[i+1]>=vpeak) {
        msn_v_B[i]=vpeak;
        msn_v_B[i+1]=c;
        msn_u_B[i+1]=msn_u_B[i+1]+d;
        network->msn_spikes_B[i+1] = 1;

        if (i<num_steps-spike_length) {
            for (int j=0; j<spike_length; j++) {
                msn_output_B[i+j] += spike[j];
            }
        } else {
            for (int j=0; j<num_steps-i; j++) {
                msn_output_B[i+j] += spike[j];
            }
        }

    } else {
        network->msn_spikes_B[i+1] = 0;
    }

    if (msn_v_C[i+1]>=vpeak) {
        msn_v_C[i]=vpeak;
        msn_v_C[i+1]=c;
        msn_u_C[i+1]=msn_u_C[i+1]+d;
        network->msn_spikes_C[i+1] = 1;

        if (i<num_steps-spike_length) {
            for (int j=0; j<spike_length; j++) {
                msn_output_C[i+j] += spike[j];
            }
        } else {
            for (int j=0; j<num_steps-i; j++) {
                msn_output_C[i+j] += spike[j];
            }
        }

    } else {
        network->msn_spikes_C[i+1] = 0;
    }

    if (msn_v_D[i+1]>=vpeak) {
        msn_v_D[i]=vpeak;
        msn_v_D[i+1]=c;
        msn_u_D[i+1]=msn_u_D[i+1]+d;
        network->msn_spikes_D[i+1] = 1;

        if (i<num_steps-spike_length) {
            for (int j=0; j<spike_length; j++) {
                msn_output_D[i+j] += spike[j];
            }
        } else {
            for (int j=0; j<num_steps-i; j++) {
                msn_output_D[i+j] += spike[j];
            }
        }

    } else {
        network->msn_spikes_D[i+1] = 0;
    }
}

void update_motor(int step, parameters *params, spiking_network *network) {
	// motor
	float C=25, vr=-60, vt=-40, k=0.7;
	float c=-50;
	float vpeak=35;

    int i = step;
    float noise_motor_mu = network->noise_motor_mu;
    float noise_motor_sigma = network->noise_motor_sigma;
    float tau = params->tau;

    network->motor_v_A[0] = vr;
    network->motor_v_B[0] = vr;
    network->motor_v_C[0] = vr;
    network->motor_v_D[0] = vr;

    network->noise = randn(noise_motor_mu, noise_motor_sigma);
    network->motor_v_A[i+1] = network->motor_v_A[i] + tau*(k*(network->motor_v_A[i]-vr)*(network->motor_v_A[i]-vt)+network->w_msn_motor*network->msn_output_A[i]+network->noise)/C;

    network->noise = randn(noise_motor_mu, noise_motor_sigma);
    network->motor_v_B[i+1] = network->motor_v_B[i] + tau*(k*(network->motor_v_B[i]-vr)*(network->motor_v_B[i]-vt)+network->w_msn_motor*network->msn_output_B[i]+network->noise)/C;

    network->noise = randn(noise_motor_mu, noise_motor_sigma);
    network->motor_v_C[i+1] = network->motor_v_C[i] + tau*(k*(network->motor_v_C[i]-vr)*(network->motor_v_C[i]-vt)+network->w_msn_motor*network->msn_output_C[i]+network->noise)/C;

    network->noise = randn(noise_motor_mu, noise_motor_sigma);
    network->motor_v_D[i+1] = network->motor_v_D[i] + tau*(k*(network->motor_v_D[i]-vr)*(network->motor_v_D[i]-vt)+network->w_msn_motor*network->msn_output_D[i]+network->noise)/C;

    int spike_length = params->spike_length;
    int num_steps = params->num_steps;

    if (network->motor_v_A[i+1]>=vpeak) {
        network->motor_v_A[i]=vpeak;
        network->motor_v_A[i+1]=c;
        network->motor_spikes_A[i+1] = 1;

        if (i<num_steps-spike_length) {
            for (int j=0; j<spike_length; j++) {
                network->motor_output_A[i+j] += network->spike[j];
            }
        } else {
            for (int j=0; j<num_steps-i; j++) {
                network->motor_output_A[i+j] += network->spike[j];
            }
        }

    } else {
        network->motor_spikes_A[i+1] = 0;
    }

    if (network->motor_v_B[i+1]>=vpeak) {
        network->motor_v_B[i]=vpeak;
        network->motor_v_B[i+1]=c;
        network->motor_spikes_B[i+1] = 1;

        if (i<num_steps-spike_length) {
            for (int j=0; j<spike_length; j++) {
                network->motor_output_B[i+j] += network->spike[j];
            }
        } else {
            for (int j=0; j<num_steps-i; j++) {
                network->motor_output_B[i+j] += network->spike[j];
            }
        }

    } else {
        network->motor_spikes_B[i+1] = 0;
    }

    if (network->motor_v_C[i+1]>=vpeak) {
        network->motor_v_C[i]=vpeak;
        network->motor_v_C[i+1]=c;
        network->motor_spikes_C[i+1] = 1;

        if (i<num_steps-spike_length) {
            for (int j=0; j<spike_length; j++) {
                network->motor_output_C[i+j] += network->spike[j];
            }
        } else {
            for (int j=0; j<num_steps-i; j++) {
                network->motor_output_C[i+j] += network->spike[j];
            }
        }

    } else {
        network->motor_spikes_C[i+1] = 0;
    }

    if (network->motor_v_D[i+1]>=vpeak) {
        network->motor_v_D[i]=vpeak;
        network->motor_v_D[i+1]=c;
        network->motor_spikes_D[i+1] = 1;

        if (i<num_steps-spike_length) {
            for (int j=0; j<spike_length; j++) {
                network->motor_output_D[i+j] += network->spike[j];
            }
        } else {
            for (int j=0; j<num_steps-i; j++) {
                network->motor_output_D[i+j] += network->spike[j];
            }
        }

    } else {
        network->motor_spikes_D[i+1] = 0;
    }
}

void update_response(int step, parameters *params, spiking_network *network) {
    float* outputs = network->outputs;

    outputs[0] = network->motor_output_A[step];
    outputs[1] = network->motor_output_B[step];
    outputs[2] = network->motor_output_C[step];
    outputs[3] = network->motor_output_D[step];

    maxmgvi(outputs, &network->max_output, &network->response, 4);
    vsort_desc(outputs, 4);

    if (outputs[0] > network->resp_thresh) {
        network->response++;
        network->confidence = (outputs[0]-outputs[1])/(float)outputs[0];
    } else {
        network->response = -1;
        network->confidence = -1;
    }
}

void update_feedback_contingent(int trial, parameters *params, spiking_network *network) {
    int num_steps = params->num_steps;
    float* outputs = network->outputs;

    if (network->response == -1) {
        outputs[0] = network->motor_output_A[num_steps-1];
        outputs[1] = network->motor_output_B[num_steps-1];
        outputs[2] = network->motor_output_C[num_steps-1];
        outputs[3] = network->motor_output_D[num_steps-1];

        maxmgvi(outputs, &network->max_output, &network->response, 4);
        vsort_desc(outputs, 4);

        network->response++;
        network->response_time = num_steps;

        network->confidence = (outputs[0]-outputs[1])/(float)outputs[0];
    }

    // Give contingent feedback to both correct and incorrect responses
    network->obtained_feedback = params->stim[0][trial] == (float) network->response ? 1 : -1;
}

void update_feedback_nc_25(int trial, void *p, void *n) {
    parameters *params = p;
    spiking_network *network = n;

    int num_steps = params->num_steps;
    float *outputs = network->outputs;

    if (network->response == -1) {
        outputs[0] = network->motor_output_A[num_steps-1];
        outputs[1] = network->motor_output_B[num_steps-1];
        outputs[2] = network->motor_output_C[num_steps-1];
        outputs[3] = network->motor_output_D[num_steps-1];

        maxmgvi(outputs, &network->max_output, &network->response, 4);
        vsort_desc(outputs, 4);

        network->response++;
        network->response_time = num_steps;

        network->confidence = (outputs[0]-outputs[1])/(float)outputs[0];
    }

    // Give random feedback
    network->obtained_feedback = rand()/(float)RAND_MAX < 0.25 ? 1 : -1;
}

void update_feedback_nc_40(int trial, void *p, void *n) {
    parameters *params = p;
    spiking_network *network = n;

    int num_steps = params->num_steps;
    float* outputs = network->outputs;

    if (network->response == -1) {
        outputs[0] = network->motor_output_A[num_steps-1];
        outputs[1] = network->motor_output_B[num_steps-1];
        outputs[2] = network->motor_output_C[num_steps-1];
        outputs[3] = network->motor_output_D[num_steps-1];

        maxmgvi(outputs, &network->max_output, &network->response, 4);
        vsort_desc(outputs, 4);

        network->response++;
        network->response_time = num_steps;

        network->confidence = (outputs[0]-outputs[1])/(float)outputs[0];
    }

    // Give random feedback
    network->obtained_feedback = rand()/(float)RAND_MAX < 0.40 ? 1 : -1;
}

void update_feedback_nc_63(int trial, void *p, void *n) {
    parameters *params = p;
    spiking_network *network = n;

    int num_steps = params->num_steps;
    float* outputs = network->outputs;

    if (network->response == -1) {
        outputs[0] = network->motor_output_A[num_steps-1];
        outputs[1] = network->motor_output_B[num_steps-1];
        outputs[2] = network->motor_output_C[num_steps-1];
        outputs[3] = network->motor_output_D[num_steps-1];

        maxmgvi(outputs, &network->max_output, &network->response, 4);
        vsort_desc(outputs, 4);

        network->response++;
        network->response_time = num_steps;

        network->confidence = (outputs[0]-outputs[1])/(float)outputs[0];
    }

    // Give random feedback
    network->obtained_feedback = rand()/(float)RAND_MAX < 0.63 ? 1 : -1;
}

void update_feedback_mixed_7525(int trial, void *p, void *n) {
    parameters *params = p;
    spiking_network *network = n;

    int num_steps = params->num_steps;
    float* outputs = network->outputs;

    if (network->response == -1) {
        outputs[0] = network->motor_output_A[num_steps-1];
        outputs[1] = network->motor_output_B[num_steps-1];
        outputs[2] = network->motor_output_C[num_steps-1];
        outputs[3] = network->motor_output_D[num_steps-1];

        maxmgvi(outputs, &network->max_output, &network->response, 4);
        vsort_desc(outputs, 4);

        network->response++;
        network->response_time = num_steps;

        network->confidence = (outputs[0]-outputs[1])/(float)outputs[0];
    }

    if (rand()/(float)RAND_MAX > 0.25) {
        // Give random nc_25 feedback
        network->obtained_feedback = rand()/(float)RAND_MAX > 0.75 ? 1 : -1;
    } else {
        // Give contingent feedback to both correct and incorrect responses
        network->obtained_feedback = params->stim[0][trial] == (float) network->response ? 1 : -1;
    }
}

void update_dopamine_rpe(int trial, parameters *params, spiking_network *network) {
    float obtained_feedback = network->obtained_feedback;
    network->predicted_feedback += network->w_prediction_error*(obtained_feedback-network->predicted_feedback);
    network->da = cap(0.8*(obtained_feedback-network->predicted_feedback) + 0.2);
}

void update_dopamine_corr(int trial, parameters *params, spiking_network *network) {
    float obtained_feedback = network->obtained_feedback;
    float confidence = network->confidence;
    network->predicted_feedback += network->w_prediction_error*(obtained_feedback-network->predicted_feedback);

    float r_theta = network->r_theta;
    float *r_p_pos = network->r_p_pos;
    float *r_p_neg = network->r_p_neg;
    float *r_I_pos = network->r_I_pos;
    float *r_I_neg = network->r_I_neg;
    float *r_omega_pos = network->r_omega_pos;
    float *r_omega_neg = network->r_omega_neg;
    float *r_p_pos_mean = network->r_p_pos_mean;
    float *r_p_neg_mean = network->r_p_neg_mean;

    // update dopamine via interative correlation method
    if (obtained_feedback == 1.0) {
        r_p_pos[trial] = confidence;
        r_p_neg[trial] = 0.0;

        r_I_pos[trial] = 1.0;
        r_I_neg[trial] = 0.0;

    } else if (obtained_feedback == -1.0) {
        r_p_pos[trial] = 0.0;
        r_p_neg[trial] = confidence;

        r_I_pos[trial] = 0.0;
        r_I_neg[trial] = 1.0;
    }

    for (int i=0; i<=trial; i++) {
        r_omega_pos[trial] += pow(r_theta, trial-i) * r_I_pos[i];
        r_omega_neg[trial] += pow(r_theta, trial-i) * r_I_neg[i];
    }

    for (int i=0; i<=trial; i++) {
        r_p_pos_mean[trial] += (1.0/r_omega_pos[trial]) * pow(r_theta, trial-i) * r_p_pos[i];
        r_p_neg_mean[trial] += (1.0/r_omega_neg[trial]) * pow(r_theta, trial-i) * r_p_neg[i];
    }

    if (trial > 0)
    {
        if (isnan(r_p_pos_mean[trial-1]) || r_omega_pos[trial] == 0.0)
        {
            network->correlation = fabs(- r_p_neg[trial] / r_omega_neg[trial] - (r_omega_neg[trial] - 1.0) * r_p_neg_mean[trial-1] / r_omega_neg[trial]);

        }else if (isnan(r_p_neg_mean[trial-1]) || r_omega_neg[trial] == 0.0)
        {

            network->correlation = fabs(+ r_p_pos[trial] / r_omega_pos[trial] + (r_omega_pos[trial] - 1.0) * r_p_pos_mean[trial-1] / r_omega_pos[trial]);

        }else
        {
            network->correlation = fabs(
                               + r_p_pos[trial] / r_omega_pos[trial] + (r_omega_pos[trial] - 1.0) * r_p_pos_mean[trial-1] / r_omega_pos[trial]
                               - r_p_neg[trial] / r_omega_neg[trial] - (r_omega_neg[trial] - 1.0) * r_p_neg_mean[trial-1] / r_omega_neg[trial]);
        }
    }else
    {
        network->correlation = 0.1;
    }

    network->correlation = cap(network->correlation);
    float correlation = network->correlation;

    float da_alpha = network->da_alpha;
    float da_base = network->da_base;
    float da_beta = network->da_beta;

    if (trial > 25)
    {
        network->da = cap(da_alpha*correlation*((obtained_feedback)-(2.0*confidence-1.0)) + da_base*(1.0-exp(-da_beta*correlation)));
    }else
    {
        network->da = cap(da_alpha*0.2*((obtained_feedback)-(2.0*confidence-1.0)) + da_base*(1.0-exp(-da_beta*0.2)));
    }
}

void update_pf_tan(int trial, parameters *params, spiking_network *network) {
	int num_contexts = params->num_contexts;
    int num_pf_cells_per_context = params->num_pf_cells_per_context;
    int stim_onset = params->stim_onset;

    float**pf_sum = network->pf_sum;
    float**pf = network->pf;
    for (int i=0; i<num_contexts; i++) {
		for (int j=0; j<num_pf_cells_per_context; j++) {
            pf_sum[i][j] = 200*pos(pf[i][j]);
		}
	}

    float* tan_v = network->tan_v;
    for (int i=stim_onset; i<stim_onset+200; i++) {
		network->tan_sum += pos(tan_v[i]);
	}

	float** w_pf_tan = network->w_pf_tan;
    float da = network->da;
    float da_base = network->da_base;
    for (int i=0; i<num_contexts; i++) {
		for (int j=0; j<num_pf_cells_per_context; j++) {
			w_pf_tan[i][j] = cap( w_pf_tan[i][j]
                                 + network->w_ltp_pf_tan*pf_sum[i][j]*pos(network->tan_sum-20.0)*pos(da-da_base)*pos(1.0-w_pf_tan[i][j])
                                 - network->w_ltd_pf_tan_1*pf_sum[i][j]*pos(network->tan_sum-20.0)*pos(da_base-da)*pos(w_pf_tan[i][j])
                                 - network->w_ltd_pf_tan_2*pf_sum[i][j]*pos(20.0-network->tan_sum)*pos(network->tan_sum-10.0)*pos(w_pf_tan[i][j]));

            //            w_pf_tan[i][j] = trial > 300 ? 0.2 :  w_pf_tan[i][j];
		}
	}
}

void update_vis_msn(int trial, parameters *params, spiking_network *network) {
    int dim = params->dim;
    int stim_onset = params->stim_onset;
    int stim_duration = params->stim_duration;

    float *vis_sum = network->vis_sum;
    for (int i=0; i<dim*dim; i++) {
        vis_sum[i] = (float)stim_duration*network->vis[i];
    }

    for (int i=stim_onset; i<stim_onset+stim_duration; i++) {
        network->msn_sum_A += pos(network->msn_v_A[i]);
        network->msn_sum_B += pos(network->msn_v_B[i]);
        network->msn_sum_C += pos(network->msn_v_C[i]);
        network->msn_sum_D += pos(network->msn_v_D[i]);
    }

    //    printf("%f %f %f %f\n",msn_sum_A,msn_sum_B,msn_sum_C,msn_sum_D);

    float *w_vis_msn_A = network->w_vis_msn_A;
    float *w_vis_msn_B = network->w_vis_msn_B;
    float *w_vis_msn_C = network->w_vis_msn_C;
    float *w_vis_msn_D = network->w_vis_msn_D;
    float w_ltp_vis_msn = network->w_ltp_vis_msn;
    float w_ltd_vis_msn_1 = network->w_ltd_vis_msn_1;
    float w_ltd_vis_msn_2 = network->w_ltd_vis_msn_2;
    float msn_sum_A = network->msn_sum_A;
    float msn_sum_B = network->msn_sum_B;
    float msn_sum_C = network->msn_sum_C;
    float msn_sum_D = network->msn_sum_D;
    float da = network->da;
    float da_base = network->da_base;
    float nmda = network->nmda;
    float ampa = network->ampa;

    for (int i=0; i<dim*dim; i++) {
        w_vis_msn_A[i] = cap(w_vis_msn_A[i]
                             + w_ltp_vis_msn*vis_sum[i]*pos(msn_sum_A-nmda)*pos(da-da_base)*pos(1.0-w_vis_msn_A[i])
                             - w_ltd_vis_msn_1*vis_sum[i]*pos(msn_sum_A-nmda)*pos(da_base-da)*pos(w_vis_msn_A[i])
                             - w_ltd_vis_msn_2*vis_sum[i]*pos(nmda-msn_sum_A)*pos(msn_sum_A-ampa)*pos(w_vis_msn_A[i]));

        w_vis_msn_B[i] = cap(w_vis_msn_B[i]
                             + w_ltp_vis_msn*vis_sum[i]*pos(msn_sum_B-nmda)*pos(da-da_base)*pos(1.0-w_vis_msn_B[i])
                             - w_ltd_vis_msn_1*vis_sum[i]*pos(msn_sum_B-nmda)*pos(da_base-da)*pos(w_vis_msn_B[i])
                             - w_ltd_vis_msn_2*vis_sum[i]*pos(nmda-msn_sum_B)*pos(msn_sum_B-ampa)*pos(w_vis_msn_B[i]));

        w_vis_msn_C[i] = cap(w_vis_msn_C[i]
                             + w_ltp_vis_msn*vis_sum[i]*pos(msn_sum_C-nmda)*pos(da-da_base)*pos(1.0-w_vis_msn_C[i])
                             - w_ltd_vis_msn_1*vis_sum[i]*pos(msn_sum_C-nmda)*pos(da_base-da)*pos(w_vis_msn_C[i])
                             - w_ltd_vis_msn_2*vis_sum[i]*pos(nmda-msn_sum_C)*pos(msn_sum_C-ampa)*pos(w_vis_msn_C[i]));

        w_vis_msn_D[i] = cap(w_vis_msn_D[i]
                             + w_ltp_vis_msn*vis_sum[i]*pos(msn_sum_D-nmda)*pos(da-da_base)*pos(1.0-w_vis_msn_D[i])
                             - w_ltd_vis_msn_1*vis_sum[i]*pos(msn_sum_D-nmda)*pos(da_base-da)*pos(w_vis_msn_D[i])
                             - w_ltd_vis_msn_2*vis_sum[i]*pos(nmda-msn_sum_D)*pos(msn_sum_D-ampa)*pos(w_vis_msn_D[i]));
    }
}
