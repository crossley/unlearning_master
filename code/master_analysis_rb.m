close all; clear all; clc;

rb_path = '/Users/mjc/Dropbox/unlearning_master/rb_data/data';

%% rb
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num = [11:2:23 26 27 29 31 32 33 39 41 43 52 72];

rb = generate_rb(rb_path,sub_num,block_struct,exclusion_criteria);

learning_curve_rb = rb{1};
std_err_curve_rb = rb{2};
sub_accuracy_rb = rb{3};
excluded_subs_rb = rb{4};
savings_rb = rb{5};
intervention_rb = rb{6};
mean_acc_rb = rb{7};

%% rbm
block_struct = [900 25 36 12];
exclusion_criteria = 0.40;
sub_num = [10:2:24 28 30 32 36 38 40 42 11 13 15]; % out of laziness excluded 4 6 8 (fixed by renaming to 11 13 15)

rbm = generate_rbm(rb_path,sub_num,block_struct,exclusion_criteria);

learning_curve_rbm = rbm{1};
std_err_curve_rbm = rbm{2};
sub_accuracy_rbm = rbm{3};
excluded_subs_rbm = rbm{4};
savings_rbm = rbm{5};
intervention_rbm = rbm{6};
mean_acc_rbm = rbm{7};

%%

num_trials = block_struct(1);
block_size = block_struct(2);
num_blocks = block_struct(3);
num_blocks_per_phase = block_struct(4);

figure, hold
% plot(1:num_blocks, learning_curve_rb, '-', 'LineWidth', 2, 'color', 'r')
% plot(1:num_blocks, learning_curve_rbm, '-', 'LineWidth', 2, 'color', 'b')
ciplot(learning_curve_rb-std_err_curve_rb,learning_curve_rb+std_err_curve_rb,1:num_blocks,'r')
ciplot(learning_curve_rbm-std_err_curve_rbm,learning_curve_rbm+std_err_curve_rbm,1:num_blocks,'b')
camlight; lighting none; 
alpha(.75)
axis([0 num_blocks+1 0.0 1])
axis square
set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
legend({'Random Intervention', 'Mixed Intervention'}, 'fontsize', 18, 'Location', 'North');
legend boxoff
plot([12,12],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
plot([24,24],[0 1],'--', 'LineWidth', 2, 'color', [0.5 0.5 0.5])
title('RB Data', 'fontsize', 18)