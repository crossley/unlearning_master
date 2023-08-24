/* 
===========
 Paramters
===========
*/

typedef void (*feedback_func)(int, void *, void *);

typedef struct {
	int num_acquisition_trials;
	int num_extinction_trials;
	int num_reacquisition_trials;
	int num_trials;
	float num_simulations;
	int T;
	int tau;
	int num_steps;
	int pso_step;
	
	int stim_onset;
	int stim_duration;
	float **stim;
	int intervention;
	feedback_func update_feedback_intervention;
	
	/* 
	   Case 0: nc_25
	   Case 1: nc_40
	   Case 2: nc_63
	   Case 3: mixed_7525
	*/
	 
	int dim;
	int num_pf_cells;
	int num_pf_cells_per_context;
	int num_contexts;
	int num_pf_overlap;
	
	float spike_a;
	float spike_b;
	float spike_length;
} parameters;

parameters *init_parameters(int intervention);
void load_stim_param(parameters *params);
void free_parameters(parameters *params);

/*
=================
 Spiking Network
=================
*/

typedef struct {
	int current_context;
	float vis_amp;
	float vis_width;
	float vis_dist_x;
	float vis_dist_y;

	float lateral_inhibition_msn;
	float lateral_inhibition;

	float w_noise_tan_L;
	float w_noise_msn_L;
	float w_noise_tan_U;
	float w_noise_msn_U;
	float noise_tan_mu;
	float noise_tan_sigma;
	float noise_msn_mu;
	float noise_msn_sigma;
	float noise_motor_mu;
	float noise_motor_sigma;
	float noise;
	float resp_thresh;

	float w_ltp_vis_msn;
	float w_ltd_vis_msn_1;
	float w_ltd_vis_msn_2;
	float w_ltp_pf_tan;
	float w_ltd_pf_tan_1;
	float w_ltd_pf_tan_2;
	float nmda;
	float ampa;

	float confidence;
	int response;
	int response_time;
	float *outputs;
	float max_output;

	float obtained_feedback;
	float predicted_feedback;
	float w_prediction_error;
	float da;
	float da_base;
	float da_alpha;
	float da_beta;

	float r_theta;
	float *r_p_pos;
	float *r_p_neg;
	float *r_I_pos;
	float *r_I_neg;
	float *r_omega_pos;
	float *r_omega_neg;
	float *r_p_pos_mean;
	float *r_p_neg_mean;
	float correlation;

	float **pf_sum;
	float tan_sum;
	float *vis_sum;
	float msn_sum_A;
	float msn_sum_B;
	float msn_sum_C;
	float msn_sum_D;

	float pause_decay;
	float pf_amp;
	float pause_mod_amp;
	float pf_tan_mod;

	float w_vis_msn;
	float w_msn_motor;
	float w_tan_msn;
	float **w_pf_tan;

	float *w_vis_msn_A;
	float *w_vis_msn_B;
	float *w_vis_msn_C;
	float *w_vis_msn_D;

	float vis_act_A;
	float vis_act_B;
	float vis_act_C;
	float vis_act_D;

	float *vis_msn_act_A;
	float *vis_msn_act_B;
	float *vis_msn_act_C;
	float *vis_msn_act_D;

	float *spike;
	float *vis;
	float **pf;
	float *pf_mod;
	float *pause_mod;
	float *pf_tan_act;

	float *tan_v;
	float *tan_u;
	int *tan_spikes;
	float *tan_output;

	float *msn_v_A;
	float *msn_u_A;
	int *msn_spikes_A;
	float *msn_output_A;

	float *msn_v_B;
	float *msn_u_B;
	int *msn_spikes_B;
	float *msn_output_B;

	float *msn_v_C;
	float *msn_u_C;
	int *msn_spikes_C;
	float *msn_output_C;

	float *msn_v_D;
	float *msn_u_D;
	int *msn_spikes_D;
	float *msn_output_D;

	float *motor_v_A;
	int *motor_spikes_A;
	float *motor_output_A;

	float *motor_v_B;
	int *motor_spikes_B;
	float *motor_output_B;

	float *motor_v_C;
	int *motor_spikes_C;
	float *motor_output_C;

	float *motor_v_D;
	int *motor_spikes_D;
	float *motor_output_D;
} spiking_network;

spiking_network *init_spiking_network(parameters *params, double* vec);
void free_spiking_network(spiking_network *network, parameters *params);
void init_network_weights(spiking_network *network, parameters *params);
void init_network_buffers(spiking_network *network, parameters *params);

/*
=========
 Records
=========
*/

typedef struct {
	int num_trials;
	float **vis_record;
	float **pf_record;
	float **tan_v_record;
	float **tan_output_record;
	float **msn_v_A_record;
	float **msn_v_B_record;
	float **msn_v_C_record;
	float **msn_v_D_record;
	float **msn_output_A_record;
	float **msn_output_B_record;
	float **msn_output_C_record;
	float **msn_output_D_record;
	float **motor_v_A_record;
	float **motor_v_B_record;
	float **motor_v_C_record;
	float **motor_v_D_record;
	float **motor_output_A_record;
	float **motor_output_B_record;
	float **motor_output_C_record;
	float **motor_output_D_record;

	float **w_pf_tan_record;
	float **w_vis_msn_A_record;
	float **w_vis_msn_B_record;
	float **w_vis_msn_C_record;
	float **w_vis_msn_D_record;

	float *response_record;
	float *response_time_record;
	float *predicted_feedback_record;
	float *dopamine_record;
	float *correlation_record;
	float *confidence_record;
	float *accuracy_record;

	// average records
	float **w_pf_tan_record_ave;
	float **w_vis_msn_A_record_ave;
	float **w_vis_msn_B_record_ave;
	float **w_vis_msn_C_record_ave;
	float **w_vis_msn_D_record_ave;

	float *response_record_ave;
	float *response_time_record_ave;
	float *predicted_feedback_record_ave;
	float *dopamine_record_ave;
	float *correlation_record_ave;
	float *confidence_record_ave;
	float *accuracy_record_ave;
} record_buffer;

record_buffer *init_record_buffer(parameters *params);
void free_record_buffer(record_buffer *r_buffer);
void record_trial(int trial, parameters *params, spiking_network *network, record_buffer *r_buffer, int simulation);
void reset_trial(parameters *params, spiking_network *network);
void record_simulation(int simulation, parameters *params, record_buffer *r_buffer);
void compute_average_results(parameters *params, record_buffer *r_buffer);
void write_data_file(int path, parameters *params, record_buffer *r_buffer);

/* 
=============
 Simulations
=============
*/

void begin_simulation(int intervention, double *vec);
void run_simulation(parameters *params, record_buffer *r_buffer, int simulation, double *vec);

/* 
===========
 The Model
===========
*/

void update_pf(int trial, parameters *params, spiking_network *network);
void update_vis(int trial, parameters *params, spiking_network *network);
void update_tan(int step, parameters *params, spiking_network *network);
void update_msn(int step, parameters *params, spiking_network *network);
void update_motor(int step, parameters *params, spiking_network *network);
void update_response(int step, parameters *params, spiking_network *network);
void update_feedback_contingent(int trial, parameters *params, spiking_network *network);
void update_feedback_nc_25(int trial, void *params, void *network);
void update_feedback_nc_40(int trial, void *params, void *network);
void update_feedback_nc_63(int trial, void *params, void *network);
void update_feedback_mixed_7525(int trial, void *params, void *network);
void update_dopamine_rpe(int trial, parameters *params, spiking_network *network);
void update_dopamine_corr(int trial, parameters *params, spiking_network *network);
void update_pf_tan(int trial, parameters *params, spiking_network *network);
void update_vis_msn(int trial, parameters *params, spiking_network *network);
void shuffle_stimuli(parameters *params);
