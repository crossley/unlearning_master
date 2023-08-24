#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include <ctype.h>
#include <omp.h>
#include "renewal_spiking.h"
#include "pso.h"
#include "pso_functions.h"
#include "utils.h"

pso_parameters *init_pso_paramters(int intervention) {
	pso_parameters *pso_params = malloc(sizeof(pso_parameters));
	pso_params->params = init_parameters(intervention);
	pso_params->params->pso_step = 0;
	pso_params->expected_results = init_expected_results(pso_params->params);
	FILE * fid_pso_log = fopen("./pso_vec/pso_log", "w");
	fprintf(fid_pso_log, "Beginning PSO...\n\n");
	fclose(fid_pso_log);
	return pso_params;
}

float *init_expected_results(parameters *params) {
	float *expected_results = malloc(params->num_trials * sizeof(float));
	
	char *goal_path = "";
	switch (params->intervention) {
		case 0:
			goal_path = "./goals/nc_25_mean_results.txt";
			break;
		case 1:
			goal_path = "./goals/nc_40_mean_results.txt";
			break;
		case 2:
			goal_path = "./goals/nc_63_mean_results.txt";
			break;
		case 3:
			goal_path = "./goals/nc_7525_mean_results.txt";
			break;
		default:
			break;
	}
	FILE *fid_expected = fopen(goal_path, "r");

	char line[128];
	fgets(line, 128, fid_expected); // skip first line
	int trial = 0;
	while (fgets(line, 128, fid_expected)) {
		char* val = strtok(line, " ");
		expected_results[trial] = atof(val);
		trial++;
	}
	fclose(fid_expected);

	return expected_results;
}

void free_pso_parameters(pso_parameters *pso_params) {
	free_parameters(pso_params->params);
	free(pso_params->expected_results);
	free(pso_params);
}

pso_result_buffer *init_pso_result_buffer(parameters *params) {
	pso_result_buffer *pso_r_buffer = malloc(sizeof(pso_result_buffer));
	int num_simulations = pso_r_buffer->num_simulations = params->num_simulations;
	int num_trials = pso_r_buffer->num_trials = params->num_trials;
	
	pso_r_buffer->results = malloc(num_simulations * sizeof(float*));
	for (int simulation = 0; simulation < num_simulations; simulation++) {
		pso_r_buffer->results[simulation] = malloc(num_trials * sizeof(float));
	}
	pso_r_buffer->average_results = malloc(num_trials * sizeof(float));

	return pso_r_buffer;
}

void pso_calculate_averages(pso_result_buffer *pso_r_buffer) {
	float** results = pso_r_buffer->results;
	float* average_results = pso_r_buffer->average_results;

	memset(average_results, 0, pso_r_buffer->num_simulations);
	for (int simulation = 0; simulation < pso_r_buffer->num_simulations; simulation++) {
		vadd(average_results, results[simulation], average_results, pso_r_buffer->num_trials);
	}

	vsdiv(average_results, pso_r_buffer->num_simulations, average_results, pso_r_buffer->num_trials);
}

void free_pso_result_buffer(pso_result_buffer *pso_r_buffer) {
	int num_simulations = pso_r_buffer->num_simulations;
	for (int simulation = 0; simulation < num_simulations; simulation++) {
		free(pso_r_buffer->results[simulation]);
	}
	free(pso_r_buffer->results);
	free(pso_r_buffer->average_results);
	free(pso_r_buffer);
}

double pso_cost_func(float *expected_results, float *actual_results, int num_trials) {
	double cost = 0;
	for (int trial = 0; trial < num_trials; trial++) {
		cost += sqrt(pow(expected_results[trial] - actual_results[trial],2));
	}

	return cost;
}

void pso_run_simulation(parameters *params, pso_result_buffer *pso_r_buffer, int simulation, double* vec) {
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
        pso_r_buffer->results[simulation][trial] = network->response;
        
        reset_trial(params, network);
    }

    free_spiking_network(network, params);
}

double pso_obj_func(double *vec, int dim, void *pso_params_arg) {
	pso_parameters *pso_params = pso_params_arg;
	parameters *params = pso_params->params;

	pso_result_buffer *pso_r_buffer = init_pso_result_buffer(params);
	
	int num_simulations = params->num_simulations;
	#pragma omp parallel for
	for (int simulation = 0; simulation < num_simulations; simulation++) {
		pso_run_simulation(params, pso_r_buffer, simulation, vec);
	}
	
	pso_calculate_averages(pso_r_buffer);
	double cost = pso_cost_func(pso_params->expected_results, pso_r_buffer->average_results, params->num_trials);
	free_pso_result_buffer(pso_r_buffer);

	write_to_pso_log(dim, cost, vec, params->pso_step);
	params->pso_step++;

	return cost;
}

void pso_set_simulation_settings(pso_settings_t *settings) {
	settings->dim = 8;
	settings->size = pso_calc_swarm_size(settings->dim);
	settings->x_lo = 0;
	settings->x_hi = 1;
}

void run_pso(pso_parameters *pso_params, pso_obj_fun_t obj_func) {
	pso_settings_t settings;
	pso_set_default_settings(&settings);
	pso_set_simulation_settings(&settings);

	pso_result_t solution;
	solution.gbest = malloc(settings.dim * sizeof(double));
	printf("Optimizing function: fast reacquisition (dim=%d, swarm size=%d)\n", settings.dim, settings.size);
    pso_solve(obj_func, pso_params, &solution, &settings);
    // save_pso_results(pso_params->params->intervention, settings.dim, solution.gbest);
    free(solution.gbest);
}

void begin_pso(int intervention) {
	srand ( (float) time(NULL) );

	printf("Beginning PSO...\n");
	pso_parameters *pso_params = init_pso_paramters(intervention);
	run_pso(pso_params, pso_obj_func);
	free_pso_parameters(pso_params);
	printf("finished\n");
}

void write_to_pso_log(int dim, double cost, double *vec, int pso_step) {
	FILE *fid_pso_log = fopen("./pso_vec/pso_log", "a");
	fprintf(fid_pso_log, "Step: %d\n", pso_step);
	fprintf(fid_pso_log, "Paramters: \n");
	for (int i = 0; i < dim; i++) {
		fprintf(fid_pso_log, "%lf\n", vec[i]);
	}
	fprintf(fid_pso_log, "\nCost: \n");
	fprintf(fid_pso_log, "%lf\n\n\n", cost);
	fclose(fid_pso_log);
}

void save_pso_results(int intervention, int dim, double* vec) {
	char *pso_results_path = "";
	switch (intervention) {
		case 0:
			pso_results_path = "./pso_vec/nc_25";
			break;
		case 1:
			pso_results_path = "./pso_vec/nc_40";
			break;
		case 2:
			pso_results_path = "./pso_vec/nc_63";
			break;
		case 3:
			pso_results_path = "./pso_vec/mixed_7525";
			break;
		default:
			break;
	}
	FILE *fid_pso_results = fopen(pso_results_path, "w");
	for (int i = 0; i < dim; i++) {
		fprintf(fid_pso_results, "%lf\n", vec[i]);
	}

	fclose(fid_pso_results);
}

void parse_log_file() {
	printf("Parsing Log File..\n");

	FILE *fid_pso_log = fopen("./pso_vec/pso_log", "r");
	FILE *fid_parsed_log = fopen("./pso_vec/parsed_pso_log", "w");

	char line[128];
	while (fgets(line, 128, fid_pso_log)) {
		if (strcmp(line, "NaN\n") == 0 || isdigit(line[0])) {
			fprintf(fid_parsed_log, "%s", line);
		}
	}

	fclose(fid_pso_log);
	fclose(fid_parsed_log);

	printf("Results stored at ./pso_vec/parsed_pso_log\n");
}
