close all
clear all
clc

% load PR_model_ReacCond.dat
% learning = PR_model_ReacCond;

% load Reac_learning.dat
% learning = Reac_learning;

load learning_100_rand.dat
load learning_7525.dat

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

%%

dopamine = learning_100_rand(1:7:end);
pf_tan = learning_100_rand(2:7:end);
ctx_msn_A = learning_100_rand(3:7:end);
ctx_msn_B = learning_100_rand(4:7:end);
ctx_msn_C = learning_100_rand(5:7:end);
ctx_msn_D = learning_100_rand(6:7:end);
resp = learning_100_rand(7:7:end);

ctx_msn_mean = mean([ctx_msn_A'; ctx_msn_B'; ctx_msn_C'; ctx_msn_D';]);

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

%%

dopamine = learning_7525(1:7:end);
pf_tan = learning_7525(2:7:end);
ctx_msn_A = learning_7525(3:7:end);
ctx_msn_B = learning_7525(4:7:end);
ctx_msn_C = learning_7525(5:7:end);
ctx_msn_D = learning_7525(6:7:end);
resp = learning_7525(7:7:end);

ctx_msn_mean = mean([ctx_msn_A'; ctx_msn_B'; ctx_msn_C'; ctx_msn_D';]);

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

%%

figure, hold
% plot(resp_mean_1, '-b', 'Linewidth', 2)
% plot(resp_mean_2, '-g', 'Linewidth', 2)
errorbar([1:num_blocks], resp_mean_1, resp_err_1, resp_err_1, '-k', 'LineWidth', 2)
errorbar([1:num_blocks], resp_mean_2, resp_err_2, resp_err_2, '--k', 'LineWidth', 2)
axis([0 num_blocks+1 0 1])
set(gca,'XTick',2:2:num_blocks)
axis square
xlabel('Block')
ylabel('Proportion Correct')

figure, hold
% plot(resp_mean_1(1:12), '-k', 'Linewidth', 2)
% plot(resp_mean_1(25:36), '--k', 'Linewidth', 2)
errorbar([0:12], [0.25 resp_mean_1(1:12)], [0 resp_err_1(1:12)], [0 resp_err_1(1:12)], '-k', 'LineWidth', 2)
errorbar([0:12], [resp_mean_1(24) resp_mean_1(25:36)], [resp_err_1(24) resp_err_1(25:36)], [resp_err_1(24) resp_err_1(25:36)], '--k', 'LineWidth', 2)
axis([-0.25 12+1 0 1])
set(gca,'XTick',0:1:12)
axis square
legend('Acquisition', 'Reacquisition')
xlabel('Block')
ylabel('Proportion Correct')

figure, hold
% plot(resp_mean_1(1:12), '-k', 'Linewidth', 2)
% plot(resp_mean_1(25:36), '--k', 'Linewidth', 2)
errorbar([0:12], [0.25 resp_mean_2(1:12)], [0 resp_err_2(1:12)], [0 resp_err_2(1:12)], '-k', 'LineWidth', 2)
errorbar([0:12], [resp_mean_2(24) resp_mean_2(25:36)], [resp_err_2(24) resp_err_2(25:36)], [resp_err_2(24) resp_err_2(25:36)], '--k', 'LineWidth', 2)
axis([-0.25 12+1 0 1])
set(gca,'XTick',0:1:12)
axis square
legend('Acquisition', 'Reacquisition')
xlabel('Block')
ylabel('Proportion Correct')

% 
% figure, hold
% plot([1:36], pf_tan_mean, '-k', 'LineWidth', 2)
% plot([1:36], ctx_msn_mean, '--k', 'LineWidth', 2)
% axis([0 num_blocks+1 0 1])
% set(gca,'XTick',2:2:num_blocks)
% axis square
% 
% figure, hold
% plot([1:36], dopamine_mean, '-k', 'LineWidth', 2)
% axis([0 num_blocks+1 0 1.0])
% set(gca,'XTick',2:2:num_blocks)
% axis square