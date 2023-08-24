close all
clear all
clc

%% Behavioral Data

% Get 100 rand data
accuracy_based_analysis_100_rand
learning_curve_100_rand = learning_curve;
std_err_curve_100_rand = std_err_curve;

SPSS_100_rand = [ones(size(SPSS,1),1) SPSS];

% Get 100 rand meta data
accuracy_based_analysis_100_rand_meta
learning_curve_100_rand_meta = learning_curve;
std_err_curve_100_rand_meta = std_err_curve;

SPSS_100_rand_meta = [2*ones(size(SPSS,1),1) SPSS];

% Get 75/25 data
accuracy_based_analysis_randtrue
learning_curve_75_25 = learning_curve;
std_err_curve_75_25 = std_err_curve;

SPSS_75_25 = [ones(size(SPSS,1),1) SPSS];

% Get 75/25 meta data
accuracy_based_analysis_randtrue_meta
learning_curve_75_25_meta = learning_curve;
std_err_curve_75_25_meta = std_err_curve;

SPSS_75_25_meta = [2*ones(size(SPSS,1),1) SPSS];

mean_all = mean([learning_curve_100_rand(1:12); learning_curve_75_25(1:12); resp_mean_3(1:12)]);
resp_err_all = mean([resp_err_1(1:12); resp_err_2(1:12); resp_err_3(1:12)]);

%% Modeling Analysis

load learning_100_rand.dat
load learning_7525.dat
load learning_40_rand.dat

% 	ABA_AveData[0] = ABA_aveDopamine;
% 	ABA_AveData[1] = ABA_avePf_TAN;
% 	ABA_AveData[2] = ABA_aveVIS_MSN_A;
% 	ABA_AveData[3] = ABA_aveVIS_MSN_B;
% 	ABA_AveData[4] = ABA_aveVIS_MSN_C;
% 	ABA_AveData[5] = ABA_aveVIS_MSN_D;
% 	ABA_AveData[6] = ABA_aveResponse;

num_trials = 900;
block_size = 25;
num_blocks = num_trials / block_size;

% Do 100% Rand condition

dopamine = learning_100_rand(1:7:end);
pf_tan = learning_100_rand(2:7:end);
ctx_msn_A = learning_100_rand(3:7:end);
ctx_msn_B = learning_100_rand(4:7:end);
ctx_msn_C = learning_100_rand(5:7:end);
ctx_msn_D = learning_100_rand(6:7:end);
resp = learning_100_rand(7:7:end);

ctx_msn_mean = mean([ctx_msn_A'; ctx_msn_B'; ctx_msn_C'; ctx_msn_D';]);

dopamine_100 = dopamine;
pf_tan_100 = pf_tan;
ctx_msn_100 = ctx_msn_mean;
resp_100 = resp;

dopamine_blocked = reshape(dopamine, block_size, num_blocks);
dopamine_mean_1 = mean(dopamine_blocked);
dopamine_err_1 = std(dopamine_blocked)/sqrt(25);

pf_tan_blocked = reshape(pf_tan, block_size, num_blocks);
pf_tan_mean_1 = mean(pf_tan_blocked);
pf_tan_std_1 = std(pf_tan_blocked)/sqrt(25);

ctx_msn_blocked = reshape(ctx_msn_mean, block_size, num_blocks);
ctx_msn_mean_1 = mean(ctx_msn_blocked);
ctx_msn_err_1 = std(ctx_msn_blocked)/sqrt(25);

resp_blocked = reshape(resp, block_size, num_blocks);
resp_mean_1 = mean(resp_blocked);
resp_err_1 = std(resp_blocked)/sqrt(25);

% Do semi-random condition: 75-25

dopamine = learning_7525(1:7:end);
pf_tan = learning_7525(2:7:end);
ctx_msn_A = learning_7525(3:7:end);
ctx_msn_B = learning_7525(4:7:end);
ctx_msn_C = learning_7525(5:7:end);
ctx_msn_D = learning_7525(6:7:end);
resp = learning_7525(7:7:end);

ctx_msn_mean = mean([ctx_msn_A'; ctx_msn_B'; ctx_msn_C'; ctx_msn_D';]);

dopamine_75_25 = dopamine;
pf_tan_75_25 = pf_tan;
ctx_msn_75_25 = ctx_msn_mean;
resp_75_25 = resp;

dopamine_blocked = reshape(dopamine, block_size, num_blocks);
dopamine_mean_2 = mean(dopamine_blocked);
dopamine_err_2 = std(dopamine_blocked)/sqrt(25);

pf_tan_blocked = reshape(pf_tan, block_size, num_blocks);
pf_tan_mean_2 = mean(pf_tan_blocked);
pf_tan_std_2 = std(pf_tan_blocked)/sqrt(25);

ctx_msn_blocked = reshape(ctx_msn_mean, block_size, num_blocks);
ctx_msn_mean_2 = mean(ctx_msn_blocked);
ctx_msn_err_2 = std(ctx_msn_blocked)/sqrt(25);

resp_blocked = reshape(resp, block_size, num_blocks);
resp_mean_2 = mean(resp_blocked);
resp_err_2 = std(resp_blocked)/sqrt(25);

% Do Rand condition - 40% positive feedback

dopamine = learning_40_rand(1:7:end);
pf_tan = learning_40_rand(2:7:end);
ctx_msn_A = learning_40_rand(3:7:end);
ctx_msn_B = learning_40_rand(4:7:end);
ctx_msn_C = learning_40_rand(5:7:end);
ctx_msn_D = learning_40_rand(6:7:end);
resp = learning_40_rand(7:7:end);

ctx_msn_mean = mean([ctx_msn_A'; ctx_msn_B'; ctx_msn_C'; ctx_msn_D';]);

dopamine_40 = dopamine;
pf_tan_40 = pf_tan;
ctx_msn_40 = ctx_msn_mean;
resp_40 = resp;

dopamine_blocked = reshape(dopamine, block_size, num_blocks);
dopamine_mean_3 = mean(dopamine_blocked);
dopamine_err_3 = std(dopamine_blocked)/sqrt(25);

pf_tan_blocked = reshape(pf_tan, block_size, num_blocks);
pf_tan_mean_3 = mean(pf_tan_blocked);
pf_tan_std_3 = std(pf_tan_blocked)/sqrt(25);

ctx_msn_blocked = reshape(ctx_msn_mean, block_size, num_blocks);
ctx_msn_mean_3 = mean(ctx_msn_blocked);
ctx_msn_err_3 = std(ctx_msn_blocked)/sqrt(25);

resp_blocked = reshape(resp, block_size, num_blocks);
resp_mean_3 = mean(resp_blocked);
resp_err_3 = std(resp_blocked)/sqrt(25);


%% Figures

% % % % Model Mechanics
% % % figure, hold
% % % plot(dopamine_100, '-', 'LineWidth', 2, 'color', [0.75 0.75 0.75])
% % % plot(dopamine_75_25, '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % % plot(dopamine_40, '-', 'LineWidth', 2, 'color', [0.25 0.25 0.25])
% % % axis([0 900+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',100:100:900, 'fontsize', 10, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('DA Release', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % figure, hold
% % % plot(pf_tan_100, '-', 'LineWidth', 2, 'color', [0.75 0.75 0.75])
% % % plot(pf_tan_75_25, '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % % plot(pf_tan_40, '-', 'LineWidth', 2, 'color', [0.25 0.25 0.25])
% % % axis([0 900+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',100:100:900, 'fontsize', 10, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Pf-TAN Synaptic Strength', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % figure, hold
% % % plot(ctx_msn_100, '-', 'LineWidth', 2, 'color', [0.75 0.75 0.75])
% % % plot(ctx_msn_75_25, '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % % plot(ctx_msn_40, '-', 'LineWidth', 2, 'color', [0.25 0.25 0.25])
% % % axis([0 900+1 0.45 0.75])
% % % axis square
% % % set(gca,'XTick',100:100:900, 'fontsize', 10, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('CTX-MSN Synaptic Strength', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % figure, hold
% % % plot(resp_100, '-', 'LineWidth', 2, 'color', [0.75 0.75 0.75])
% % % plot(resp_75_25, '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % % plot(resp_40, '-', 'LineWidth', 2, 'color', [0.25 0.25 0.25])
% % % axis([0 900+1 0 1])
% % % axis square
% % % set(gca,'XTick',100:100:900, 'fontsize', 10, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')

% % % % 100 rand - Overlay Model
% % % figure, hold
% % % errorbar(1:12, resp_mean_1(1:12), resp_err_1(1:12), resp_err_1(1:12), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % % errorbar(1:12, resp_mean_1(13:24), resp_err_1(13:24), resp_err_1(13:24), '-', 'LineWidth', 2, 'color', [0.75 0.75 0.75])
% % % errorbar(1:12, resp_mean_1(25:36), resp_err_1(25:36), resp_err_1(25:36), '-', 'LineWidth', 2, 'color', [0.25 0.25 0.25])
% % % axis([0 12+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % % 75-25 rand - Overlay Model
% % % figure, hold
% % % errorbar(1:12, resp_mean_2(1:12), resp_err_2(1:12), resp_err_2(1:12), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % % errorbar(1:12, resp_mean_2(13:24), resp_err_2(13:24), resp_err_2(13:24), '-', 'LineWidth', 2, 'color', [0.75 0.75 0.75])
% % % errorbar(1:12, resp_mean_2(25:36), resp_err_2(25:36), resp_err_2(25:36), '-', 'LineWidth', 2, 'color', [0.25 0.25 0.25])
% % % axis([0 12+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % % 100 rand / 40 pos - Overlay Model
% % % figure, hold
% % % errorbar(1:12, resp_mean_3(1:12), resp_err_3(1:12), resp_err_3(1:12), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % % errorbar(1:12, resp_mean_3(13:24), resp_err_3(13:24), resp_err_3(13:24), '-', 'LineWidth', 2, 'color', [0.75 0.75 0.75])
% % % errorbar(1:12, resp_mean_3(25:36), resp_err_3(25:36), resp_err_3(25:36), '-', 'LineWidth', 2, 'color', [0.25 0.25 0.25])
% % % axis([0 12+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')

% 100 rand - Overlay Human
% % % figure, hold
% % % errorbar(1:12, learning_curve_100_rand(1:12), std_err_curve_100_rand(1:12), std_err_curve_100_rand(1:12), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % % errorbar(1:12, learning_curve_100_rand(13:24), std_err_curve_100_rand(13:24), std_err_curve_100_rand(13:24), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % % errorbar(1:12, learning_curve_100_rand(25:36), std_err_curve_100_rand(25:36), std_err_curve_100_rand(25:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % % axis([0 12+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % % 75-25 rand - Overlay Human
% % % figure, hold
% % % errorbar(1:12, learning_curve_75_25(1:12), std_err_curve_75_25(1:12), std_err_curve_75_25(1:12), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % % errorbar(1:12, learning_curve_75_25(13:24), std_err_curve_75_25(13:24), std_err_curve_75_25(13:24), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % % errorbar(1:12, learning_curve_75_25(25:36), std_err_curve_75_25(25:36), std_err_curve_75_25(25:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % % axis([0 12+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')

% % % 100 rand - Overlay Model
% % figure, hold
% % errorbar(1:12, resp_mean_1(1:12), resp_err_1(1:12), resp_err_1(1:12), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % errorbar(1:12, resp_mean_1(13:24), resp_err_1(13:24), resp_err_1(13:24), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % errorbar(1:12, resp_mean_1(25:36), resp_err_1(25:36), resp_err_1(25:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % axis([0 12+1 0.0 1])
% % axis square
% % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % 
% % % 75-25 rand - Overlay Model
% % figure, hold
% % errorbar(1:12, resp_mean_2(1:12), resp_err_2(1:12), resp_err_2(1:12), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % errorbar(1:12, resp_mean_2(13:24), resp_err_2(13:24), resp_err_2(13:24), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % errorbar(1:12, resp_mean_2(25:36), resp_err_2(25:36), resp_err_2(25:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % axis([0 12+1 0.0 1])
% % axis square
% % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')

% % % 100 rand
% % figure, hold
% % errorbar(1:36, learning_curve_100_rand(1:36), std_err_curve_100_rand(1:36), std_err_curve_100_rand(1:36), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % errorbar(1:36, learning_curve_100_rand_meta(1:36), std_err_curve_100_rand_meta(1:36), std_err_curve_100_rand_meta(1:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % axis([0 36+1 0.0 1])
% % axis square
% % set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % 
% % % 100 rand - Overlay
% % figure, hold
% % errorbar(1:12, learning_curve_100_rand(1:12), std_err_curve_100_rand(1:12), std_err_curve_100_rand(1:12), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % errorbar(1:12, learning_curve_100_rand(13:24), std_err_curve_100_rand(13:24), std_err_curve_100_rand(13:24), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % errorbar(1:12, learning_curve_100_rand(25:36), std_err_curve_100_rand(25:36), std_err_curve_100_rand(25:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % axis([0 12+1 0.0 1])
% % axis square
% % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % 
% % figure, hold
% % errorbar(1:12, learning_curve_100_rand_meta(1:12), std_err_curve_100_rand_meta(1:12), std_err_curve_100_rand_meta(1:12), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % errorbar(1:12, learning_curve_100_rand_meta(13:24), std_err_curve_100_rand_meta(13:24), std_err_curve_100_rand_meta(13:24), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % errorbar(1:12, learning_curve_100_rand_meta(25:36), std_err_curve_100_rand_meta(25:36), std_err_curve_100_rand_meta(25:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % axis([0 12+1 0.0 1])
% % axis square
% % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')

% 75-25
% % figure, hold
% % errorbar(1:36, learning_curve_75_25(1:36), std_err_curve_75_25(1:36), std_err_curve_75_25(1:36), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % errorbar(1:36, learning_curve_75_25_meta(1:36), std_err_curve_75_25_meta(1:36), std_err_curve_75_25_meta(1:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % axis([0 36+1 0.0 1])
% % axis square
% % set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % 
% % % 75-25 rand - Overlay
% % figure, hold
% % errorbar(1:12, learning_curve_75_25(1:12), std_err_curve_75_25(1:12), std_err_curve_75_25(1:12), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % errorbar(1:12, learning_curve_75_25(13:24), std_err_curve_75_25(13:24), std_err_curve_75_25(13:24), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % errorbar(1:12, learning_curve_75_25(25:36), std_err_curve_75_25(25:36), std_err_curve_75_25(25:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % axis([0 12+1 0.0 1])
% % axis square
% % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % 
% % figure, hold
% % errorbar(1:12, learning_curve_75_25_meta(1:12), std_err_curve_75_25_meta(1:12), std_err_curve_75_25_meta(1:12), '-', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % errorbar(1:12, learning_curve_75_25_meta(13:24), std_err_curve_75_25_meta(13:24), std_err_curve_75_25_meta(13:24), '-', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
% % errorbar(1:12, learning_curve_75_25_meta(25:36), std_err_curve_75_25_meta(25:36), std_err_curve_75_25_meta(25:36), '--', 'LineWidth', 2, 'color', [0.0 0.0 0.0])
% % axis([0 12+1 0.0 1])
% % axis square
% % set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')