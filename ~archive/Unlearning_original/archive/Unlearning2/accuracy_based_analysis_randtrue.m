% close all
% clear all
% clc

% % 1 ? block
% % 
% % 2 ? stimulus length
% % 
% % 3 ? stimulus orientation
% % 
% % 4 ? randomized stimulus category
% % 
% % 5 ? true stimulus category
% % 
% % 6 ? participant response
% % 
% % 7 ? corrective feedback trial (yes=1/no=0)
% % 
% % 8 ? accuracy
% % 
% % 9 ? response time
% % 
% % 10 ? feedback category (1 = 100% random, 2 = 90% rand, 3 = 75% random, 4 = 75% random blocked, 5 = 75% random extended feedback, 6 = 100% corrective)

% % Condition 7: 75% random 25% true randomly intermixed
% % Condition 7b: 15 random ? 10 correct ? 15 random ? 5 correct ? 15 random ? 5 correct ? 15 random ? 5 correct ? 15 random

num_trials = 900;
block_size = 25;
num_blocks = num_trials / block_size;
blocks_per_phase = num_blocks / 3;

%% 75% random 25% true randomly intermixed

sub_num_all = [1 4:23 25:27 29:32];

ac_II = [1 4 5 7 8 10 11 12 13 14 16 17 20 22 23 29 30 31 32];
ac_RB = [6 9 15 18 19 21 25 26 27];

ext_II = [5 7 10 12 23 30 31];
ext_RB = [1 6 8 13 15 16 17 18 21 22 25 26 27];
ext_guess = [4 9 11 14 19 20 29 32];

reac_II = [1 4 7 10 12 13 14 16 20 25 26 30];
reac_RB = [5 6 8 9 15 17 18 21 22 23 27 29 31 32];

II_II_II_subs = intersect(ac_II, ext_II); 
II_II_II_subs = intersect(II_II_II_subs, reac_II);

II_II_RB_subs = intersect(ac_II, ext_II); 
II_II_RB_subs = intersect(II_II_RB_subs, reac_RB);

II_guess_II_subs = intersect(ac_II, ext_guess); 
II_guess_II_subs = intersect(II_guess_II_subs, reac_II);

II_guess_RB_subs = intersect(ac_II, ext_guess); 
II_guess_RB_subs = intersect(II_guess_RB_subs, reac_RB);

II_RB_II_subs = intersect(ac_II, ext_RB);
II_RB_II_subs = intersect(II_RB_II_subs, reac_II);

II_RB_RB_subs = intersect(ac_II, ext_RB);
II_RB_RB_subs = intersect(II_RB_RB_subs, reac_RB);


%% Do the analysis

accuracy_record = [];

% sub_num = [II_II_II_subs II_guess_II_subs II_RB_II_subs];
% sub_num = [II_guess_RB_subs II_RB_RB_subs];
% sub_num = [II_RB_II_subs II_RB_RB_subs];

% sub_num = [II_II_II_subs II_guess_II_subs II_guess_RB_subs II_II_RB_subs II_RB_II_subs II_RB_RB_subs];

% sub_num = sub_num_all;
sub_num = [II_II_II_subs II_II_RB_subs II_guess_II_subs II_guess_RB_subs II_RB_II_subs II_RB_RB_subs];


for i = sub_num
    
   load_cmd = ['load unl7' num2str(i) '.dat;'];
   eval(load_cmd)
   
   def_cmd = ['data = unl7' num2str(i) ';'];
   eval(def_cmd)
   
   cat = data(:,5);
   x = data(:,2);
   y = data(:,3);
   resp = data(:,6);
   
   corr_ind = find(cat == resp);
   feedback = zeros(900,1);
   feedback(corr_ind,1) = 1;
   
   accuracy_record = [accuracy_record; feedback'];
    
end

% Make learning curve

learning_curve = zeros(1,num_blocks);
std_err_curve = zeros(1,num_blocks);

SPSS = [];
sub_accuracy = [];

for i = 1:num_blocks
   
        start = (i-1)*block_size+1;
        stop = start + block_size - 1;
        
        sub_accuracy = [sub_accuracy mean(accuracy_record(:,start:stop),2);];
        
        accuracy = accuracy_record(:,start:stop);
        accuracy = reshape(accuracy, prod(size(accuracy)) ,1);
        
        SPSS = [SPSS mean(accuracy_record(:,start:stop),2)];
        
        mean_accuracy = mean(accuracy);
        std_err = std(accuracy)/sqrt(prod(size(accuracy)));

        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
end

% % num_subs = size(sub_num,2);
% % figure
% % for i = 1:num_subs
% %     subplot(ceil(sqrt(num_subs)),ceil(sqrt(num_subs)),i),hold
% %     plot(sub_accuracy(i,1:12),'-b')
% %     plot(sub_accuracy(i,13:24), '-g')
% %     plot(sub_accuracy(i,25:36),'-r')
% %     axis([0 13 0 1])
% %     
% % end

% % %% figures
% % 
% % figure
% % subplot(1,2,1), hold
% % errorbar(1:36, learning_curve(1:36), std_err_curve(1:36), std_err_curve(1:36), '-k', 'LineWidth', 2)
% % axis([0 36+1 0.0 1])
% % axis square
% % set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % 
% % subplot(1,2,2), hold
% % errorbar(1:12, learning_curve(1:12), std_err_curve(1:12), std_err_curve(1:12), '-b', 'LineWidth', 2)
% % errorbar(1:12, learning_curve(13:24), std_err_curve(13:24), std_err_curve(13:24), '-g', 'LineWidth', 2)
% % errorbar(1:12, learning_curve(25:36), std_err_curve(25:36), std_err_curve(25:36), '-r', 'LineWidth', 2)
% % axis([0 12+1 0.0 1])
% % axis square
% % set(gca,'XTick',2:1:12, 'fontsize', 10, 'fontweight', 'b')
% % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')