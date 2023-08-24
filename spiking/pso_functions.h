typedef struct {
	parameters *params;
	float* expected_results;
} pso_parameters;

pso_parameters *init_pso_paramters(int intervention);
float *init_expected_results(parameters *params);
void free_pso_parameters(pso_parameters *pso_params);

typedef struct {
	int num_simulations;
	int num_trials;
	float** results;
	float* average_results;
} pso_result_buffer;

pso_result_buffer *init_pso_result_buffer(parameters *params);
void free_pso_result_buffer(pso_result_buffer *pso_r_buffer);
void pso_calculate_averages(pso_result_buffer *pso_r_buffer);

double pso_cost_func(float *expected_results, float *actual_results, int num_trials);
void pso_run_simulation(parameters *params, pso_result_buffer *pso_r_buffer, int simulation, double* vec);
double pso_obj_func(double *vec, int dim, void *pso_params_arg);
void pso_set_simulation_settings(pso_settings_t *settings);
void run_pso(pso_parameters *pso_params, pso_obj_fun_t obj_func);
void begin_pso(int intervention);
void write_to_pso_log(int dim, double cost, double *vec, int pso_step);
void save_pso_results(int intervention, int dim, double* vec);
void parse_log_file();