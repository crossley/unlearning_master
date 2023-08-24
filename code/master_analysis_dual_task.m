close all; clear all; clc;

dt_path = '/Users/mjc/Dropbox/unlearning_master/dualtask_data';

exclusion_criteria_acc = 0.40;
exclusion_criteria_dt = 0.85;
exclusion_criteria = cell(1,2);
exclusion_criteria{1} = exclusion_criteria_acc;
exclusion_criteria{2} = exclusion_criteria_dt;

%% DT1
block_struct = [850 25 34];
sub_num_all = [1 6 11 16 21 26 31 36 41 46 51 55 59 63 67 71 75 79 83 87 91 95 99 103 107 111 115 119 123 127];
sub_num_II = [];

dt_1 = generate_dt_1(dt_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_dt_1 = dt_1{1};
std_err_curve_dt_1 = dt_1{2};
sub_accuracy_dt_1 = dt_1{3};
excluded_subs_dt_1 = dt_1{4};
savings_1 = dt_1{5};
intervention_1 = dt_1{6};
dualtask_1 = dt_1{7};
anova_savings_1 = dt_1{8};

%% DT2
block_struct = [850 25 34];
exclusion_criteria_acc = 0.40;
exclusion_criteria_dt = 0.25;
sub_num_all = [2 7 12 17 22 27 32 37 42 47 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 113 116 120 124 128];
sub_num_II = [];

dt_2 = generate_dt_2(dt_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_dt_2 = dt_2{1};
std_err_curve_dt_2 = dt_2{2};
sub_accuracy_dt_2 = dt_2{3};
excluded_subs_dt_2 = dt_2{4};
savings_2 = dt_2{5};
intervention_2 = dt_2{6};
dualtask_2 = dt_2{7};
anova_savings_2 = dt_2{8};

%% DT3
block_struct = [850 25 34];
exclusion_criteria_acc = 0.40;
exclusion_criteria_dt = 0.25;
sub_num_all = [1 3 8 13 18 23 28 33 38 43 48 53 57 61 65 69 73 77 81 85 93 105 109 113 117 121 125 129];
sub_num_II = [];

dt_3 = generate_dt_3(dt_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_dt_3 = dt_3{1};
std_err_curve_dt_3 = dt_3{2};
sub_accuracy_dt_3 = dt_3{3};
excluded_subs_dt_3 = dt_3{4};
savings_3 = dt_3{5};
intervention_3 = dt_3{6};
dualtask_3 = dt_3{7};
anova_savings_3 = dt_3{8};

%% DT4
block_struct = [850 25 34];
exclusion_criteria_acc = 0.40;
exclusion_criteria_dt = 0.25;
sub_num_all = [4 9 14 19 24 34 39 44 49 58 62 66 70 74 78 82 86 90 94 98 102 106 114 118 122 126 130];
sub_num_II = [];

dt_4 = generate_dt_4(dt_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_dt_4 = dt_4{1};
std_err_curve_dt_4 = dt_4{2};
sub_accuracy_dt_4 = dt_4{3};
excluded_subs_dt_4 = dt_4{4};
savings_4 = dt_4{5};
intervention_4 = dt_4{6};
dualtask_4 = dt_4{7};
anova_savings_4 = dt_4{8};

%%
num_trials = block_struct(1);
block_size = block_struct(2);
num_blocks = block_struct(3);

figure, hold
plot(1:num_blocks, learning_curve_dt_1, '-', 'LineWidth', 2, 'color', rgb('red'))
plot(1:num_blocks, learning_curve_dt_2, '-', 'LineWidth', 2, 'color', rgb('orange'))
plot(1:num_blocks, learning_curve_dt_3, '-', 'LineWidth', 2, 'color', rgb('green'))
plot(1:num_blocks, learning_curve_dt_4, '-', 'LineWidth', 2, 'color', rgb('blue'))
ciplot(learning_curve_dt_1-std_err_curve_dt_1,learning_curve_dt_1+std_err_curve_dt_1,1:num_blocks,rgb('red'))
ciplot(learning_curve_dt_2-std_err_curve_dt_2,learning_curve_dt_2+std_err_curve_dt_2,1:num_blocks,rgb('orange'))
ciplot(learning_curve_dt_3-std_err_curve_dt_3,learning_curve_dt_3+std_err_curve_dt_3,1:num_blocks,rgb('green'))
ciplot(learning_curve_dt_4-std_err_curve_dt_4,learning_curve_dt_4+std_err_curve_dt_4,1:num_blocks,rgb('blue'))
camlight; lighting none; 
alpha(0.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
legend({'DT 1', 'DT 2', 'DT 3', 'DT 4'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--k', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
plot([28,28],[0 1],'--k', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
title('Dual Task Data', 'fontsize', 18)

%% Savings
% Savings - read these out from the MixMod package for R - lsmeansTAB
mean_1 = -0.01696970; lower_1 = -0.1307745; upper_1 = 0.09683512; CI_1 = (upper_1-lower_1)/2;
mean_2 = -0.08756882; lower_2 = -0.2074771; upper_2 = 0.03233946; CI_2 = (upper_2-lower_1)/2;
mean_3 = -0.08471392; lower_3 = -0.1989941; upper_3 = 0.02956631; CI_3 = (upper_3-lower_1)/2;
mean_4 = -0.01037037; lower_4 = -0.1361863; upper_4 = 0.11544559; CI_4 = (upper_4-lower_1)/2;

figure, hold
plot([0 5], [0 0], '--k', 'linewidth', 2)
errorbar([1:4], [mean_1 mean_2 mean_3 mean_4], [CI_1 CI_2 CI_3 CI_4], '*k', 'linewidth',1)
ylabel('Accuracy Difference: Recquisition-Acquisition', 'fontsize', 18, 'fontweight', 'b')
xlabel('Condition', 'fontsize', 18, 'fontweight', 'b')
set(gca,'XTick',[1:4], 'fontsize', 14)
set(gca,'XTickLabel',{'1','2','3','4'},'fontsize', 16, 'fontweight', 'b')
axis square
title('Between-Condition Savings','fontsize', 18, 'fontweight', 'b')

%% Savings vs Intervention correlation
savings_all = [
                savings_1 
                savings_2 
                savings_3 
                savings_4
                ];
 
intervention_all = [
                intervention_1 
                intervention_2 
                intervention_3 
                intervention_4 
                ];

dualtask_all = [
                dualtask_1 
                dualtask_2 
                dualtask_3 
                dualtask_4 
                ];

%             intervention_all(22) = [];
%             savings_all(22) = [];
            
[RHO,PVAL] = corr(intervention_all,savings_all);
figure, hold
plot(intervention_all,savings_all, '*k', 'MarkerSize', 15)
axis square
set(gca,'XTick',-1:0.1:1, 'fontsize', 10, 'fontweight', 'b')
set(gca,'YTick',-1:0.1:1, 'fontsize', 10, 'fontweight', 'b')
xlabel('Mean Intervention Accuracy', 'fontsize', 18, 'fontweight', 'b')
ylabel('Mean Savings', 'fontsize', 18, 'fontweight', 'b')
title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)

[RHO,PVAL] = corr(dualtask_all,savings_all);
figure, hold
plot(dualtask_all,savings_all, '*k', 'MarkerSize', 15)
axis square
set(gca,'XTick',-1:0.1:1, 'fontsize', 10, 'fontweight', 'b')
set(gca,'YTick',-1:0.1:1, 'fontsize', 10, 'fontweight', 'b')
xlabel('Mean DT Accuracy', 'fontsize', 18, 'fontweight', 'b')
ylabel('Mean Savings', 'fontsize', 18, 'fontweight', 'b')
title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)