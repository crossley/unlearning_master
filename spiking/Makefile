CC = gcc
CFLAGS = -Wall -g -fopenmp -std=c99 -march=corei7 -pthread -O3 -Wno-unused-result
LDFLAGS = -lgsl -lgslcblas -lm -lpthread
DEPENDENCIES = main.c utils.c pso.c renewal_spiking.c pso_functions.c

main: $(DEPENDENCIES)
	$(CC) $(DEPENDENCIES) $(CFLAGS) $(LDFLAGS) -o main

# Run Simulations with default settings
nc_25: main
	@mkdir -p unlearning
	@mkdir -p unlearning/nc_25
	@./main nc_25

nc_40: main
	@mkdir -p unlearning
	@mkdir -p unlearning/nc_40
	@./main nc_40

nc_63: main
	@mkdir -p unlearning
	@mkdir -p unlearning/nc_63
	@./main nc_63

mixed_7525: main
	@mkdir -p unlearning
	@mkdir -p unlearning/mixed_7525
	@./main mixed_7525

# PSO Commands, Check ./pso_vec/pso_log to see progress
pso_nc_25: main
	@mkdir -p pso_vec
	@./main pso_nc_25

pso_nc_40: main
	@mkdir -p pso_vec
	@./main pso_nc_40

pso_nc_63: main
	@mkdir -p pso_vec
	@./main pso_nc_63

pso_mixed_7525: main
	@mkdir -p pso_vec
	@./main pso_mixed_7525

# Parse the log file
parse_log_file: pso_vec/pso_log main
	@./main parse_log_file	

# Remove desired aspects
clean: main
	@rm -rf main

clean_default_results: unlearning
	@rm -rf unlearning

clean_pso_vec: pso_vec
	@rm -rf pso_vec