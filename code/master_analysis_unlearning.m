close all; clear all; clc;

nc_25_path = '/Users/mjc/Dropbox/unlearning_master/nc_25_data';
nc_40_path = '/Users/mjc/Dropbox/unlearning_master/nc_40_data';
nc_63_path = '/Users/mjc/Dropbox/unlearning_master/nc_63_data';
nc_63_path_new = '/Users/mjc/Dropbox/unlearning_master/nc_63_data_new_batch';
mixed_7525_path = '/Users/mjc/Dropbox/unlearning_master/mix_2575_data';
dt_path = '/Users/mjc/Dropbox/unlearning_master/dualtask_data';
renewal_path = '/Users/mjc/Dropbox/unlearning_master/renewal_data';

%% NC25
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all_1 = [1:3 5:7 9:11 13 15:18];
sub_num_II_1 = [3 5 7 10 11 15 16 18];
sub_num_all_2 = [1:11 13 14 16 18 19];
sub_num_glc_2 = [1 4 5 7 10 13 14 16 18 19];
sub_num_all = cell(1,2);
sub_num_all{1} = sub_num_all_1;
sub_num_all{2} = sub_num_all_2;

nc_25 = generate_nc_25(nc_25_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_nc_25 = nc_25{1};
std_err_curve_nc_25 = nc_25{2};
sub_accuracy_nc_25 = nc_25{3};
excluded_subs_nc_25 = nc_25{4};
savings_nc_25 = nc_25{5};
intervention_nc_25 = nc_25{6};
mean_acc_nc_25 = nc_25{7};

%% NC25m
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [1:5 7:11 13:20];
sub_num_glc = [1 3 4 5 7 8 10 11 13 14 18];

nc_25m = generate_nc_25m(nc_25_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_nc_25m = nc_25m{1};
std_err_curve_nc_25m = nc_25m{2};
sub_accuracy_nc_25m = nc_25m{3};
excluded_subs_nc_25m = nc_25m{4};
savings_nc_25m = nc_25m{5};
intervention_nc_25m = nc_25m{6};
an_acc_nc_25m = nc_25m{7};

%% NC40
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [1:15 17:24];
sub_num_II = [1:11 13 14 15 17 18 22 23];

nc_40 = generate_nc_40(nc_40_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_nc_40 = nc_40{1};
std_err_curve_nc_40 = nc_40{2};
sub_accuracy_nc_40 = nc_40{3};
excluded_subs_nc_40 = nc_40{4};
savings_nc_40 = nc_40{5};
intervention_nc_40 = nc_40{6};
mean_acc_nc_40 = nc_40{7};

%% NC40m
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [1:4 6:9 11:15 17:22 25:30];
sub_num_II = [1 2 3 6 8 9 12 15 17 18 19 22 25 26 28 29];

nc_40m = generate_nc_40m(nc_40_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_nc_40m = nc_40m{1};
std_err_curve_nc_40m = nc_40m{2};
sub_accuracy_nc_40m = nc_40m{3};
excluded_subs_nc_40m = nc_40m{4};
savings_nc_40m = nc_40m{5};
intervention_nc_40m = nc_40m{6};
mean_acc_nc_40m = nc_40m{7};

%% Mixed7525
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [1 4:23 25:27 29:32];
sub_num_II = [1 4 5 7 8 10 11 12 13 14 16 17 20 22 23 29 30 31 32];

mixed_7525 = generate_mixed_7525(mixed_7525_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_mixed_7525 = mixed_7525{1};
std_err_curve_mixed_7525 = mixed_7525{2};
sub_accuracy_mixed_7525 = mixed_7525{3};
excluded_subs_mixed_7525 = mixed_7525{4};
savings_mixed_7525 = mixed_7525{5};
intervention_mixed_7525 = mixed_7525{6};
mean_acc_7525 = mixed_7525{7};

%% Mixed7525m
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [1:11 13 14 16 18:20 23 25:30];
sub_num_II = [1:10 16 25:30];

mixed_7525m = generate_mixed_7525m(mixed_7525_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_mixed_7525m = mixed_7525m{1};
std_err_curve_mixed_7525m = mixed_7525m{2};
sub_accuracy_mixed_7525m = mixed_7525m{3};
excluded_subs_mixed_7525m = mixed_7525m{4};
savings_mixed_7525m = mixed_7525m{5};
intervention_mixed_7525m = mixed_7525m{6};
mean_acc_7525m = mixed_7525m{7};

%% NC63
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39];
sub_num_II = [];

nc_63 = generate_nc_63(nc_63_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_nc_63 = nc_63{1};
std_err_curve_nc_63 = nc_63{2};
sub_accuracy_nc_63 = nc_63{3};
excluded_subs_nc_63 = nc_63{4};
savings_nc_63 = nc_63{5};
intervention_nc_63 = nc_63{6};
savings_nc_63 = nc_63{5};
intervention_nc_63 = nc_63{6};
mean_acc_nc_63 = nc_63{7};

%% NC63m
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 38 40];
sub_num_II = [];

nc_63m = generate_nc_63m(nc_63_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_nc_63m = nc_63m{1};
std_err_curve_nc_63m = nc_63m{2};
sub_accuracy_nc_63m = nc_63m{3};
excluded_subs_nc_63m = nc_63m{4};
savings_nc_63m = nc_63m{5};
intervention_nc_63m = nc_63m{6};
mean_acc_nc_63m = nc_63m{7};

%% NC63 - new batch
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [3 4 5 7 9 11 13 15 17 19 21 22 25 27 29 31 33 35 37 39 41 45 47 49 51 53 56];
sub_num_II = [];

nc_63_new = generate_nc_63(nc_63_path_new,sub_num_all,block_struct,exclusion_criteria);

learning_curve_nc_63_new = nc_63_new{1};
std_err_curve_nc_63_new = nc_63_new{2};
sub_accuracy_nc_63_new = nc_63_new{3};
excluded_subs_nc_63_new = nc_63_new{4};
savings_nc_63_new = nc_63_new{5};
intervention_nc_63_new = nc_63_new{6};
savings_nc_63_new = nc_63_new{5};
intervention_nc_63_new = nc_63_new{6};
mean_acc_nc_63_new = nc_63_new{7};

%% NC63m - new batch
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [6 8 10 12 14 18 20 22 24 26 28 30 32 36 38 40 42 44  46 48 50 52 54 55 ];
sub_num_II = [];

nc_63m_new = generate_nc_63m(nc_63_path_new,sub_num_all,block_struct,exclusion_criteria);

learning_curve_nc_63m_new = nc_63m_new{1};
std_err_curve_nc_63m_new = nc_63m_new{2};
sub_accuracy_nc_63m_new = nc_63m_new{3};
excluded_subs_nc_63m_new = nc_63m_new{4};
savings_nc_63m_new = nc_63m_new{5};
intervention_nc_63m_new = nc_63m_new{6};
mean_acc_nc_63m_new = nc_63m_new{7};

%%
num_trials = block_struct(1);
block_size = block_struct(2);
num_blocks = block_struct(3);
num_blocks_per_phase = block_struct(4);

figure, hold
plot(1:num_blocks, learning_curve_nc_25, '-', 'LineWidth', 2, 'color', rgb('red'))
plot(1:num_blocks, learning_curve_nc_25m, '-', 'LineWidth', 2, 'color', rgb('blue'))
ciplot(learning_curve_nc_25-std_err_curve_nc_25,learning_curve_nc_25+std_err_curve_nc_25,1:num_blocks,rgb('red'))
ciplot(learning_curve_nc_25m-std_err_curve_nc_25m,learning_curve_nc_25m+std_err_curve_nc_25m,1:num_blocks,rgb('blue'))
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
legend({'Relearning NC25', 'Meta-Learning NC25'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
plot([24,24],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
title('NC 25', 'fontsize', 18)

figure, hold
plot(1:num_blocks, learning_curve_nc_40, '-', 'LineWidth', 2, 'color', rgb('red'))
plot(1:num_blocks, learning_curve_nc_40m, '-', 'LineWidth', 2, 'color', rgb('blue'))
ciplot(learning_curve_nc_40-std_err_curve_nc_40,learning_curve_nc_40+std_err_curve_nc_40,1:num_blocks,rgb('red'))
ciplot(learning_curve_nc_40m-std_err_curve_nc_40m,learning_curve_nc_40m+std_err_curve_nc_40m,1:num_blocks,rgb('blue'))
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
legend({'Relearning NC40', 'Meta-Learning NC40'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
plot([24,24],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
title('NC 40', 'fontsize', 18)

figure, hold
plot(1:num_blocks, learning_curve_mixed_7525, '-', 'LineWidth', 2, 'color', rgb('red'))
plot(1:num_blocks, learning_curve_mixed_7525m, '-', 'LineWidth', 2, 'color', rgb('blue'))
ciplot(learning_curve_mixed_7525-std_err_curve_mixed_7525,learning_curve_mixed_7525+std_err_curve_mixed_7525,1:num_blocks,rgb('red'))
ciplot(learning_curve_mixed_7525m-std_err_curve_mixed_7525m,learning_curve_mixed_7525m+std_err_curve_mixed_7525m,1:num_blocks,rgb('blue'))
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
legend({'Relearning Mixed7525', 'Meta-Learning Mixed7525'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
plot([24,24],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
title('Mixed 7525', 'fontsize', 18)

figure, hold
plot(1:num_blocks, learning_curve_nc_63, '-', 'LineWidth', 2, 'color', rgb('red'))
plot(1:num_blocks, learning_curve_nc_63m, '-', 'LineWidth', 2, 'color', rgb('blue'))
ciplot(learning_curve_nc_63-std_err_curve_nc_63,learning_curve_nc_63+std_err_curve_nc_63,1:num_blocks,rgb('red'))
ciplot(learning_curve_nc_63m-std_err_curve_nc_63m,learning_curve_nc_63m+std_err_curve_nc_63m,1:num_blocks,rgb('blue'))
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
legend({'Relearning NC63', 'Meta-Learning NC463'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
plot([24,24],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
title('NC 63', 'fontsize', 18)

figure, hold
plot(1:num_blocks, learning_curve_nc_63_new, '-', 'LineWidth', 2, 'color', rgb('red'))
plot(1:num_blocks, learning_curve_nc_63m_new, '-', 'LineWidth', 2, 'color', rgb('blue'))
ciplot(learning_curve_nc_63_new-std_err_curve_nc_63_new,learning_curve_nc_63_new+std_err_curve_nc_63_new,1:num_blocks,rgb('red'))
ciplot(learning_curve_nc_63m_new-std_err_curve_nc_63m_new,learning_curve_nc_63m_new+std_err_curve_nc_63m_new,1:num_blocks,rgb('blue'))
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
legend({'Relearning NC63', 'Meta-Learning NC463'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
plot([24,24],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
title('NC 63 New', 'fontsize', 18)

%% Savings vs Intervention correlation
% savings_all = [
%                 savings_nc_25 
%                 savings_nc_25m 
%                 savings_nc_40 
%                 savings_nc_40m 
%                 savings_mixed_7525 
%                 savings_mixed_7525m 
%                 savings_nc_63 
%                 savings_nc_63m
%                 ];
% 
% intervention_all = [
%                 intervention_nc_25 
%                 intervention_nc_25m 
%                 intervention_nc_40 
%                 intervention_nc_40m 
%                 intervention_mixed_7525 
%                 intervention_mixed_7525m 
%                 intervention_nc_63 
%                 intervention_nc_63m
%                 ];
% 
% [RHO,PVAL] = corr(intervention_all,savings_all);
% figure, hold
% plot(intervention_all,savings_all, '*k', 'MarkerSize', 15)
% axis square
% set(gca,'XTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% set(gca,'YTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% xlabel('Mean Intervention Accuracy', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Mean Savings', 'fontsize', 18, 'fontweight', 'b')
% title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)
% 
% [RHO,PVAL] = corr(intervention_nc_25,savings_nc_25);
% figure, hold
% plot(intervention_nc_25,savings_nc_25, '*k', 'MarkerSize', 15)
% axis square
% set(gca,'XTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% set(gca,'YTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% xlabel('NC25 Mean Intervention Accuracy', 'fontsize', 18, 'fontweight', 'b')
% ylabel('NC25 Mean Savings', 'fontsize', 18, 'fontweight', 'b')
% title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)
% 
% [RHO,PVAL] = corr(intervention_nc_40,savings_nc_40);
% figure, hold
% plot(intervention_nc_40,savings_nc_40, '*k', 'MarkerSize', 15)
% axis square
% set(gca,'XTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% set(gca,'YTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% xlabel('NC40 Mean Intervention Accuracy', 'fontsize', 18, 'fontweight', 'b')
% ylabel('NC40 Mean Savings', 'fontsize', 18, 'fontweight', 'b')
% title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)
% 
% [RHO,PVAL] = corr(intervention_nc_63,savings_nc_63);
% figure, hold
% plot(intervention_nc_63,savings_nc_63, '*k', 'MarkerSize', 15)
% axis square
% set(gca,'XTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% set(gca,'YTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% xlabel('NC63 Mean Intervention Accuracy', 'fontsize', 18, 'fontweight', 'b')
% ylabel('NC63 Mean Savings', 'fontsize', 18, 'fontweight', 'b')
% title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)
% 
% [RHO,PVAL] = corr(intervention_mixed_7525,savings_mixed_7525);
% figure, hold
% plot(intervention_mixed_7525,savings_mixed_7525, '*k', 'MarkerSize', 15)
% axis square
% set(gca,'XTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% set(gca,'YTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
% xlabel('Mixed7525 Mean Intervention Accuracy', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Mixed7525 Mean Savings', 'fontsize', 18, 'fontweight', 'b')
% title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)

%%
fid = fopen('nc_25_results.txt','w');
fprintf(fid,'%f\n',mean_acc_nc_25');
fclose(fid);

fid = fopen('nc_40_results.txt','w');
fprintf(fid,'%f\n',mean_acc_nc_40');
fclose(fid);

fid = fopen('nc_63_results.txt','w');
fprintf(fid,'%f\n',mean_acc_nc_63');
fclose(fid);

fid = fopen('nc_7525_results.txt','w');
fprintf(fid,'%f\n',mean_acc_7525');
fclose(fid);