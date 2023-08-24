/*
 main.c
 renewal_spiking

 Created by Matthew Crossley on 11/1/12.
 Copyright (c) 2012 Matthew Crossley. All rights reserved.
*/

#include <stdio.h>
#include <string.h>
#include "pso.h"
#include "renewal_spiking.h"
#include "pso_functions.h"

int main(int argc, const char * argv[]) {
    if (argc < 2) {
        printf("Please enter a command");
        return 0;
    }
    if (strcmp(argv[1], "nc_25") == 0) {
        printf("Simulating nc_25 Intervention\n\n");
        begin_simulation(0, NULL);
    } else if (strcmp(argv[1], "nc_40") == 0) {
        printf("Simulating nc_40 Intervention\n\n");
        begin_simulation(1, NULL);
    } else if (strcmp(argv[1], "nc_63") == 0) {
        printf("Simulating nc_63 Intervention\n\n");
        begin_simulation(2, NULL);
    } else if (strcmp(argv[1], "mixed_7525") == 0) {
        printf("Simulating mixed_7525 Intervention\n\n");
        begin_simulation(3, NULL);
    } else if (strcmp(argv[1], "pso_nc_25") == 0) {
        printf("Running PSO with nc_25 Intervention\n\n");
        begin_pso(0);
    } else if (strcmp(argv[1], "pso_nc_40") == 0) {
        printf("Running PSO with nc_40 Intervention\n\n");
        begin_pso(1);
    } else if (strcmp(argv[1], "pso_nc_63") == 0) {
        printf("Running PSO with nc_63 Intervention\n\n");
        begin_pso(2);
    } else if (strcmp(argv[1], "pso_mixed_7525") == 0) {
        printf("Running PSO with mixed_7525 Intervention\n\n");
        begin_pso(3);
    } else if (strcmp(argv[1], "parse_log_file") == 0) {
    	parse_log_file();
	}
    return 0;
}
