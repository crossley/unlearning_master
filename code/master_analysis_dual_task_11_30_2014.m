close all; clear all; clc;

dt_path = '/Users/mjc/Dropbox/unlearning_master/dual_task_data_11_30_2014';

exclusion_criteria_acc = 0.40;
exclusion_criteria_dt = 0.8;
exclusion_criteria = cell(1,2);
exclusion_criteria{1} = exclusion_criteria_acc;
exclusion_criteria{2} = exclusion_criteria_dt;

block_struct = [850 25 34];


%% DT1
sub_num_all = [16 21 26 31 36 45];
sub_num_II = [];

dt_1 = generate_dt_1_20141130(dt_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_dt_1 = dt_1{1};
std_err_curve_dt_1 = dt_1{2};
sub_accuracy_dt_1 = dt_1{3};
excluded_subs_dt_1 = dt_1{4};
savings_1 = dt_1{5};
intervention_1 = dt_1{6};
dualtask_1 = dt_1{7};
anova_savings_1 = dt_1{8};

%% DT2
sub_num_all = [12 17 22 27 32 42];
sub_num_II = [];

dt_2 = generate_dt_2_20141130(dt_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_dt_2 = dt_2{1};
std_err_curve_dt_2 = dt_2{2};
sub_accuracy_dt_2 = dt_2{3};
excluded_subs_dt_2 = dt_2{4};
savings_2 = dt_2{5};
intervention_2 = dt_2{6};
dualtask_2 = dt_2{7};
anova_savings_2 = dt_2{8};

%% DT3
sub_num_all = [13 18 23 28 33 38 48];
sub_num_II = [];

dt_3 = generate_dt_3_20141130(dt_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_dt_3 = dt_3{1};
std_err_curve_dt_3 = dt_3{2};
sub_accuracy_dt_3 = dt_3{3};
excluded_subs_dt_3 = dt_3{4};
savings_3 = dt_3{5};
intervention_3 = dt_3{6};
dualtask_3 = dt_3{7};
anova_savings_3 = dt_3{8};

%% DT4
sub_num_all = [14 19 24 34 39 44 49];
sub_num_II = [];

dt_4 = generate_dt_4_20141130(dt_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_dt_4 = dt_4{1};
std_err_curve_dt_4 = dt_4{2};
sub_accuracy_dt_4 = dt_4{3};
excluded_subs_dt_4 = dt_4{4};
savings_4 = dt_4{5};
intervention_4 = dt_4{6};
dualtask_4 = dt_4{7};
anova_savings_4 = dt_4{8};

%% DT5
block_struct = [850 25 34];
sub_num_all = [10 15 20 25 30 35 40 45 50];
sub_num_II = [];

dt_bc = generate_dt_5_20141130(dt_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_dt_bc = dt_bc{1};
std_err_curve_dt_bc = dt_bc{2};
sub_accuracy_dt_bc = dt_bc{3};
excluded_subs_dt_bc = dt_bc{4};
savings_2 = dt_bc{5};
intervention_bc = dt_bc{6};
dualtask_bc = dt_bc{7};
anova_savings_bc = dt_bc{8};

%%
num_trials = block_struct(1);
block_size = block_struct(2);
num_blocks = block_struct(3);

color = lines(5);

figure
% figure, hold
subplot(2,2,1), hold
ciplot(learning_curve_dt_1-std_err_curve_dt_1,learning_curve_dt_1+std_err_curve_dt_1,1:num_blocks,color(1,:))
ciplot(learning_curve_dt_bc-std_err_curve_dt_bc,learning_curve_dt_bc+std_err_curve_dt_bc,1:num_blocks,color(3,:))
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:4:num_blocks, 'fontsize', 12, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% legend({'DT 1','DT bc'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--k', 'LineWidth', 1, 'color', 'k')
plot([28,28],[0 1],'--k', 'LineWidth', 1, 'color', 'k')

% figure, hold
subplot(2,2,2), hold
ciplot(learning_curve_dt_2-std_err_curve_dt_2,learning_curve_dt_2+std_err_curve_dt_2,1:num_blocks,color(1,:))
ciplot(learning_curve_dt_bc-std_err_curve_dt_bc,learning_curve_dt_bc+std_err_curve_dt_bc,1:num_blocks,color(3,:))
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:4:num_blocks, 'fontsize', 12, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% legend({'DT 2','DT bc'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--k', 'LineWidth', 1, 'color', 'k')
plot([28,28],[0 1],'--k', 'LineWidth', 1, 'color', 'k')

% figure, hold
subplot(2,2,3), hold
ciplot(learning_curve_dt_3-std_err_curve_dt_3,learning_curve_dt_3+std_err_curve_dt_3,1:num_blocks,color(1,:))
ciplot(learning_curve_dt_bc-std_err_curve_dt_bc,learning_curve_dt_bc+std_err_curve_dt_bc,1:num_blocks,color(3,:))
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:4:num_blocks, 'fontsize', 12, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% legend({'DT 3','DT bc'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--k', 'LineWidth', 1, 'color', 'k')
plot([28,28],[0 1],'--k', 'LineWidth', 1, 'color', 'k')

% figure, hold
subplot(2,2,4), hold
ciplot(learning_curve_dt_4-std_err_curve_dt_4,learning_curve_dt_4+std_err_curve_dt_4,1:num_blocks,color(1,:))
ciplot(learning_curve_dt_bc-std_err_curve_dt_bc,learning_curve_dt_bc+std_err_curve_dt_bc,1:num_blocks,color(3,:))
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:4:num_blocks, 'fontsize', 12, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% legend({'DT 4','DT bc'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--k', 'LineWidth', 1, 'color', 'k')
plot([28,28],[0 1],'--k', 'LineWidth', 1, 'color', 'k')

