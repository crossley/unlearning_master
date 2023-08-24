close all; clear all; clc;

% renewal_path = '/Users/crossley/Documents/projects/research/renewal/data';
renewal_path = '/Users/mjc/Dropbox/unlearning_master/renewal_data';

%% AAA
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [1:9 11:27];
sub_num_glc = [];

AAA = generate_renewal_AAA(renewal_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_AAA = AAA{1};
std_err_curve_AAA = AAA{2};
sub_accuracy_AAA = AAA{3};
excluded_subs_AAA = AAA{4};
savings_AAA = AAA{5};
intervention_AAA = AAA{6};

%% ABA
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [1 3 5 6 7 10 12 14 16 17 19:23 25:27];
sub_num_glc = [];

ABA = generate_renewal_ABA(renewal_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_ABA = ABA{1};
std_err_curve_ABA = ABA{2};
sub_accuracy_ABA = ABA{3};
excluded_subs_ABA = ABA{4};
savings_ABA = ABA{5};
intervention_ABA = ABA{6};

%% AAB
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [1:4 6:26];
sub_num_glc = [];

AAB = generate_renewal_AAB(renewal_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_AAB = AAB{1};
std_err_curve_AAB = AAB{2};
sub_accuracy_AAB = AAB{3};
excluded_subs_AAB = AAB{4};
savings_AAB = AAB{5};
intervention_AAB = AAB{6};

%% ABC
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num_all = [2:18 20:23 25 26];
sub_num_glc = [];

ABC = generate_renewal_ABC(renewal_path,sub_num_all,block_struct,exclusion_criteria);

learning_curve_ABC = ABC{1};
std_err_curve_ABC = ABC{2};
sub_accuracy_ABC = ABC{3};
excluded_subs_ABC = ABC{4};
savings_ABC = ABC{5};
intervention_ABC = ABC{6};

%%
figure, hold
plot(1:36, learning_curve_AAA(1:36), '-', 'LineWidth', 2, 'color', rgb('red'))
plot(1:36, learning_curve_ABA(1:36), '-', 'LineWidth', 2, 'color', rgb('orange'))
plot(1:36, learning_curve_AAB(1:36), '-', 'LineWidth', 2, 'color', rgb('green'))
plot(1:36, learning_curve_ABC(1:36), '-', 'LineWidth', 2, 'color', rgb('blue'))
ciplot(learning_curve_AAA(1:36)-std_err_curve_AAA(1:36),learning_curve_AAA(1:36)+std_err_curve_AAA(1:36),1:36, rgb('red'))
ciplot(learning_curve_ABA(1:36)-std_err_curve_ABA(1:36),learning_curve_ABA(1:36)+std_err_curve_ABA(1:36),1:36, rgb('orange'))
ciplot(learning_curve_AAB(1:36)-std_err_curve_AAB(1:36),learning_curve_AAB(1:36)+std_err_curve_AAB(1:36),1:36, rgb('green'))
ciplot(learning_curve_ABC(1:36)-std_err_curve_ABC(1:36),learning_curve_ABC(1:36)+std_err_curve_ABC(1:36),1:36, rgb('blue'))
camlight; lighting none; 
alpha(.75)
axis([0 36+1 0.0 1])
axis square
set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
legend({'AAA','ABA','AAB','ABC'}, 'fontsize', 18, 'Location', 'SouthEast');
legend boxoff

%%
% All blocks considered
% Savings - read these out from the MixMod package for R - lsmeansTAB
AAA_mean = 0.0155; AAA_lower = -0.0207; AAA_upper = 0.0517; CI_AAA = (AAA_upper-AAA_lower)/2;
ABA_mean = 0.0886; ABA_lower = 0.0483; ABA_upper = 0.1290; CI_ABA = (ABA_upper-ABA_lower)/2;
AAB_mean = -0.0037; AAB_lower = -0.0403; AAB_upper = 0.0329; CI_AAB = (AAB_upper-AAB_lower)/2;
ABC_mean = 0.0197; ABC_lower = -0.0178; ABC_upper = 0.0572; CI_ABC = (ABC_upper-ABC_lower)/2;

figure, hold
plot([0 5], [0 0], '--k', 'linewidth', 2)
errorbar([1:4], [AAA_mean ABA_mean AAB_mean ABC_mean], [CI_AAA CI_ABA CI_AAB CI_ABC], '*k', 'linewidth',1)
ylabel('Accuracy Difference: Recquisition-Acquisition', 'fontsize', 18, 'fontweight', 'b')
set(gca,'XTick',[1:4], 'fontsize', 14)
set(gca,'XTickLabel',{'AAA','ABA','AAB','ABC'},'fontsize', 16, 'fontweight', 'b')
axis square
title('Savings: All Blocks','fontsize', 18, 'fontweight', 'b')

% Partial blocks considered
% Savings - read these out from the MixMod package for R - lsmeansTAB
AAA_mean = 0.0753; AAA_lower = 0.0260; AAA_upper = 0.1245; CI_AAA = (AAA_upper-AAA_lower)/2;
ABA_mean = 0.1442; ABA_lower = 0.0885; ABA_upper =  0.1999; CI_ABA = (ABA_upper-ABA_lower)/2;
AAB_mean = 0.0415; AAB_lower = -0.0084; AAB_upper = 0.0914; CI_AAB = (AAB_upper-AAB_lower)/2;
ABC_mean = 0.0701; ABC_lower = 0.0188; ABC_upper = 0.1214; CI_ABC = (ABC_upper-ABC_lower)/2;

figure, hold
plot([0 5], [0 0], '--k', 'linewidth', 2)
errorbar([1:4], [AAA_mean ABA_mean AAB_mean ABC_mean], [CI_AAA CI_ABA CI_AAB CI_ABC], '*k', 'linewidth',1)
ylabel('Accuracy Difference: Recquisition-Acquisition', 'fontsize', 18, 'fontweight', 'b')
set(gca,'XTick',[1:4], 'fontsize', 14)
set(gca,'XTickLabel',{'AAA','ABA','AAB','ABC'},'fontsize', 16, 'fontweight', 'b')
axis square
title('Savings: Partial Blocks','fontsize', 18, 'fontweight', 'b')

%% Savings vs Intervention correlation
savings_all = [
                savings_AAA 
                savings_ABA 
                savings_AAB 
                savings_ABC 
                ];

intervention_all = [
                intervention_AAA 
                intervention_ABA 
                intervention_AAB 
                intervention_ABC 
                ];

[RHO,PVAL] = corr(intervention_all,savings_all);
figure, hold
plot(intervention_all,savings_all, '*k', 'MarkerSize', 15)
axis square
set(gca,'XTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
set(gca,'YTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
xlabel('Mean Intervention Accuracy', 'fontsize', 18, 'fontweight', 'b')
ylabel('Mean Savings', 'fontsize', 18, 'fontweight', 'b')
title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)