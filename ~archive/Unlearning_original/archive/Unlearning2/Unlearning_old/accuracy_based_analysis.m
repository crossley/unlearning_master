close all
clear all
clc

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

%% Random feedback extinction

accuracy_record = [];
sub_num = [1:11 13 14 16 18 19];
sub_num_glc = [1 4 5 7 10 13 14 16 18 19];
sub_num_notglc = setdiff(sub_num,sub_num_glc);

% sub_num = sub_num_glc;

for i = sub_num
    
   load_cmd = ['load ext5_' num2str(i) '.txt;'];
   eval(load_cmd)
   
   def_cmd = ['data = ext5_' num2str(i) ';'];
   eval(def_cmd)
   
   cat = data(:,2);
   x = data(:,3);
   y = data(:,4);
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

        % THE WRONG WAY - BUT NOT REALLY
        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
end

SPSS = [ones(size(SPSS),1) SPSS];

accuracy_record1 = accuracy_record;
learning_curve1 = learning_curve;
std_err_curve1 = std_err_curve;
SPSS1 = SPSS;
sub_accuracy1 = sub_accuracy;

% % % Compare phases
% % % acquisition = SPSS_1(:,2:13);
% % % extinction = SPSS_1(:,14:25);
% % % reacquisition = SPSS_1(:,26:37);
% % % 
% % % acquisition = SPSS_1(:,2:13);        % To only compare early blocks
% % % reacquisition = SPSS_1(:,26:31);
% % % 
% % % acquisition = reshape(acquisition,numel(acquisition),1);
% % % extinction = reshape(extinction,numel(extinction),1);
% % % reacquisition = reshape(reacquisition,numel(reacquisition),1);
% % % 
% % % n_ac = length(acquisition);
% % % n_ext = length(extinction);
% % % n_reac = length(reacquisition);
% % % 
% % % p_hat = mean([acquisition; extinction]);
% % % t1 = (mean(acquisition)-mean(extinction))/sqrt((1/n_ac + 1/n_ext)*p_hat*(1-p_hat))
% % % df1 = n_ac + n_ext - 2
% % % P1 = tcdf(t1,df1)
% % % 
% % % p_hat = mean([extinction; reacquisition]);
% % % t2 = (mean(extinction)-mean(reacquisition))/sqrt((1/n_ext + 1/n_reac)*p_hat*(1-p_hat))
% % % df2 = n_ext + n_reac - 2
% % % P2 = tcdf(t2,df2)
% % % 
% % % p_hat = mean([acquisition; reacquisition]);
% % % t3 = (mean(acquisition)-mean(reacquisition))/sqrt((1/n_ac + 1/n_reac)*p_hat*(1-p_hat))
% % % df3 = n_ac + n_reac - 2
% % % P3 = tcdf(t3,df3)
 
% % % % Compare individual blocks of acquisition and extinction
% % % first_ac = SPSS_1(:,2);
% % % last_ac = SPSS_1(:,13);
% % % last_ext = SPSS_1(:,25);
% % % 
% % % n_first_ac = length(first_ac);
% % % n_last_ac = length(first_ac);
% % % n_last_ext = length(first_ac);
% % % 
% % % p_hat = mean([first_ac; last_ext]);
% % % t1 = (mean(first_ac)-mean(last_ext))/sqrt((1/n_first_ac + 1/n_last_ext)*p_hat*(1-p_hat))
% % % df1 = n_first_ac + n_last_ext - 2
% % % P1 = tcdf(t1,df1)
% % % 
% % % p_hat = mean([last_ac; last_ext]);
% % % t1 = (mean(last_ac)-mean(last_ext))/sqrt((1/n_last_ac + 1/n_last_ext)*p_hat*(1-p_hat))
% % % df1 = n_last_ac + n_last_ext - 2
% % % P1 = tcdf(t1,df1)
% % % 
% % % % Test extinction aginst the null hypothesis that accuracy dropped to 0.25
% % % ext1 = SPSS_1(:,24:25);
% % % ext1 = reshape(ext1, numel(ext1),1);
% % % [H,P,CI,STATS] = ttest(ext1,0.25)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ac = sub_accuracy1(:,1:12);
ext = sub_accuracy1(:,13:24);
reac = sub_accuracy1(:,25:36);

% ac = sub_accuracy1(:,1:4);
% reac = sub_accuracy1(:,25:28);

diff_ac_ext = ac - ext;
diff_reac_ext = reac - ext;
diff_ac_reac = ac - reac;

diff_ac_ext = reshape(diff_ac_ext,numel(diff_ac_ext),1);
diff_reac_ext = reshape(diff_reac_ext,numel(diff_reac_ext),1);
diff_ac_reac = reshape(diff_ac_reac,numel(diff_ac_reac),1);

display('Random: acquisition - reacquisition')

% [H_1,P_1,CI_1,STATS_1] = ttest(diff_ac_ext)
% [H_2,P_2,CI_2,STATS_2] = ttest(diff_reac_ext)
[H_3,P_3,CI_3,STATS_3] = ttest(diff_ac_reac)

% Next set of t-tests

first_ac = sub_accuracy1(:,1);
last_ac = sub_accuracy1(:,12);
last_ext = sub_accuracy1(:,24);

diff_ac1_ext12 = first_ac-last_ext;
diff_ac12_ext12 = last_ac-last_ext;

% [H,P,CI,STATS] = ttest(diff_ac1_ext12)
% [H,P,CI,STATS] = ttest(diff_ac12_ext12)

%% 75% random 25% true randomly intermixed

accuracy_record = [];
sub_num = [71 72 74:79 710:715];

% sub_num = sub_num_glc;

for i = sub_num
    
   load_cmd = ['load unl' num2str(i) '.dat;'];
   eval(load_cmd)
   
   def_cmd = ['data = unl' num2str(i) ';'];
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

        % THE WRONG WAY - BUT NOT REALLY
        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
end

SPSS = [2*ones(size(SPSS),1) SPSS];

accuracy_record2 = accuracy_record;
learning_curve2 = learning_curve;
std_err_curve2 = std_err_curve;
SPSS2 = SPSS;
sub_accuracy2 = sub_accuracy;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ac = sub_accuracy2(:,1:12);
ext = sub_accuracy2(:,13:24);
reac = sub_accuracy2(:,25:36);

% ac = sub_accuracy2(:,1:4);
% reac = sub_accuracy2(:,25:28);

diff_ac_ext = ac - ext;
diff_reac_ext = reac - ext;
diff_ac_reac = ac - reac;

diff_ac_ext = reshape(diff_ac_ext,numel(diff_ac_ext),1);
diff_reac_ext = reshape(diff_reac_ext,numel(diff_reac_ext),1);
diff_ac_reac = reshape(diff_ac_reac,numel(diff_ac_reac),1);

display('Random-True Intermixed: acquisition - reacquisition')

% [H_1,P_1,CI_1,STATS_1] = ttest(diff_ac_ext)
% [H_2,P_2,CI_2,STATS_2] = ttest(diff_reac_ext)
[H_3,P_3,CI_3,STATS_3] = ttest(diff_ac_reac)

% Next set of t-tests

first_ac = sub_accuracy1(:,1);
last_ac = sub_accuracy1(:,12);
last_ext = sub_accuracy1(:,24);

diff_ac1_ext12 = first_ac-last_ext;
diff_ac12_ext12 = last_ac-last_ext;

% [H,P,CI,STATS] = ttest(diff_ac1_ext12)
% [H,P,CI,STATS] = ttest(diff_ac12_ext12)

%% 15 random ? 10 correct ? 15 random ? 5 correct ? 15 random ? 5 correct ? 15 random ? 5 correct ? 15 random

accuracy_record = [];
sub_num = [1 2 4:13];

% sub_num = sub_num_glc;

for i = sub_num
    
   load_cmd = ['load unl7b' num2str(i) '.dat;'];
   eval(load_cmd)
   
   def_cmd = ['data = unl7b' num2str(i) ';'];
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

        % THE WRONG WAY - BUT NOT REALLY
        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
end

SPSS = [3*ones(size(SPSS),1) SPSS];

accuracy_record3 = accuracy_record;
learning_curve3 = learning_curve;
std_err_curve3 = std_err_curve;
SPSS3 = SPSS;
sub_accuracy3 = sub_accuracy;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ac = sub_accuracy3(:,1:12);
ext = sub_accuracy3(:,13:24);
reac = sub_accuracy3(:,25:36);

% ac = sub_accuracy3(:,1:4);
% reac = sub_accuracy3(:,25:28);

diff_ac_ext = ac - ext;
diff_reac_ext = reac - ext;
diff_ac_reac = ac - reac;

diff_ac_ext = reshape(diff_ac_ext,numel(diff_ac_ext),1);
diff_reac_ext = reshape(diff_reac_ext,numel(diff_reac_ext),1);
diff_ac_reac = reshape(diff_ac_reac,numel(diff_ac_reac),1);

display('Random-True Blocked: acquisition - reacquisition')

% [H_1,P_1,CI_1,STATS_1] = ttest(diff_ac_ext)
% [H_2,P_2,CI_2,STATS_2] = ttest(diff_reac_ext)
[H_3,P_3,CI_3,STATS_3] = ttest(diff_ac_reac)

% Next set of t-tests

first_ac = sub_accuracy1(:,1);
last_ac = sub_accuracy1(:,12);
last_ext = sub_accuracy1(:,24);

diff_ac1_ext12 = first_ac-last_ext;
diff_ac12_ext12 = last_ac-last_ext;

% [H,P,CI,STATS] = ttest(diff_ac1_ext12)
% [H,P,CI,STATS] = ttest(diff_ac12_ext12)

%% Noncontingent

% 1 ? block
% 
% 2 ? stimulus length
% 
% 3 ? stimulus orientation
% 
% 4 ? stimulus category
% 
% 5 ? participant response
% 
% 6 ? accuracy
% 
% 7 ? response time
% 
% 8 ? 2 = contingent; 0 = noncontingent correct; 1 = noncontingent error

accuracy_record = [];
sub_num = [1:7 9:11 17];

% sub_num = sub_num_glc;

for i = sub_num
    
   load_cmd = ['load nc40' num2str(i) '.dat;'];
   eval(load_cmd)
   
   def_cmd = ['data = nc40' num2str(i) ';'];
   eval(def_cmd)
   
   cat = data(:,4);
   x = data(:,2);
   y = data(:,3);
   resp = data(:,5);
   
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

        % THE WRONG WAY - BUT NOT REALLY
        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
end

SPSS = [4*ones(size(SPSS),1) SPSS];

accuracy_record4 = accuracy_record;
learning_curve4 = learning_curve;
std_err_curve4 = std_err_curve;
SPSS4 = SPSS;
sub_accuracy4 = sub_accuracy;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ac = sub_accuracy4(:,1:12);
ext = sub_accuracy4(:,13:24);
reac = sub_accuracy4(:,25:36);

% ac = sub_accuracy4(:,1:4);
% reac = sub_accuracy4(:,25:28);

diff_ac_ext = ac - ext;
diff_reac_ext = reac - ext;
diff_ac_reac = ac - reac;

diff_ac_ext = reshape(diff_ac_ext,numel(diff_ac_ext),1);
diff_reac_ext = reshape(diff_reac_ext,numel(diff_reac_ext),1);
diff_ac_reac = reshape(diff_ac_reac,numel(diff_ac_reac),1);

display('Noncontingent: acquisition - reacquisition')

% [H_1,P_1,CI_1,STATS_1] = ttest(diff_ac_ext)
% [H_2,P_2,CI_2,STATS_2] = ttest(diff_reac_ext)
[H_3,P_3,CI_3,STATS_3] = ttest(diff_ac_reac)

% Next set of t-tests

first_ac = sub_accuracy1(:,1);
last_ac = sub_accuracy1(:,12);
last_ext = sub_accuracy1(:,24);

diff_ac1_ext12 = first_ac-last_ext;
diff_ac12_ext12 = last_ac-last_ext;

% [H,P,CI,STATS] = ttest(diff_ac1_ext12)
% [H,P,CI,STATS] = ttest(diff_ac12_ext12)

%% Plot

% % % figure, hold
% % % errorbar(1:36, learning_curve1(1:36), std_err_curve1(1:36), std_err_curve1(1:36), '-b', 'LineWidth', 2)
% % % errorbar(1:36, learning_curve2(1:36), std_err_curve2(1:36), std_err_curve2(1:36), '-g', 'LineWidth', 2)
% % % errorbar(1:36, learning_curve3(1:36), std_err_curve3(1:36), std_err_curve3(1:36), '-r', 'LineWidth', 2)
% % % errorbar(1:36, learning_curve4(1:36), std_err_curve4(1:36), std_err_curve4(1:36), '-c', 'LineWidth', 2)
% % % axis([0 36+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
% % % legend('Random','Random-True Mixed','Random-True Blocked','Noncontingent')
% % % title('All Conditions All Phases','fontsize', 20, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % figure, hold
% % % errorbar(1:36, learning_curve1(1:36), std_err_curve1(1:36), std_err_curve1(1:36), '-b', 'LineWidth', 2)
% % % errorbar(1:36, learning_curve4(1:36), std_err_curve4(1:36), std_err_curve4(1:36), '-c', 'LineWidth', 2)
% % % axis([0 36+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
% % % legend('Random','Noncontingent')
% % % title('Random and Noncontingent','fontsize', 20, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % figure, hold
% % % errorbar(1:36, learning_curve2(1:36), std_err_curve2(1:36), std_err_curve2(1:36), '-g', 'LineWidth', 2)
% % % errorbar(1:36, learning_curve3(1:36), std_err_curve3(1:36), std_err_curve3(1:36), '-r', 'LineWidth', 2)
% % % axis([0 36+1 0.0 1])
% % % axis square
% % % set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
% % % legend('Random-True Mixed','Random-True Blocked')
% % % title('Random-True Mixed and Blocked','fontsize', 20, 'fontweight', 'b')
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % figure, hold
% % % errorbar(1:12, learning_curve1(1:12), std_err_curve1(1:12), std_err_curve1(1:12), '-b', 'LineWidth', 2)
% % % errorbar(1:12, learning_curve1(25:36), std_err_curve1(25:36), std_err_curve1(25:36), '-g', 'LineWidth', 2)
% % % axis([0 12 0.0 1])
% % % axis square
% % % set(gca,'XTick',1:12,'fontsize', 10, 'fontweight', 'b')
% % % legend('Acquisition','Reacquisition')
% % % title('Random','fontsize', 20, 'fontweight', 'b');
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % figure, hold
% % % errorbar(1:12, learning_curve2(1:12), std_err_curve2(1:12), std_err_curve2(1:12), '-b', 'LineWidth', 2)
% % % errorbar(1:12, learning_curve2(25:36), std_err_curve2(25:36), std_err_curve2(25:36), '-g', 'LineWidth', 2)
% % % axis([0 12 0.0 1])
% % % axis square
% % % set(gca,'XTick',1:12,'fontsize', 10, 'fontweight', 'b')
% % % legend('Acquisition','Reacquisition')
% % % title('Random-True Mixed: 75% random 25% true','fontsize', 20, 'fontweight', 'b');
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % figure, hold
% % % errorbar(1:12, learning_curve3(1:12), std_err_curve3(1:12), std_err_curve3(1:12), '-b', 'LineWidth', 2)
% % % errorbar(1:12, learning_curve3(25:36), std_err_curve3(25:36), std_err_curve3(25:36), '-g', 'LineWidth', 2)
% % % axis([0 12 0.0 1])
% % % axis square
% % % set(gca,'XTick',1:12,'fontsize', 10, 'fontweight', 'b')
% % % legend('Acquisition','Reacquisition')
% % % title('Random-True Blocked: 15 random - 10 correct','fontsize', 20, 'fontweight', 'b');
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% % % 
% % % figure, hold
% % % errorbar(1:12, learning_curve4(1:12), std_err_curve4(1:12), std_err_curve4(1:12), '-b', 'LineWidth', 2)
% % % errorbar(1:12, learning_curve4(25:36), std_err_curve4(25:36), std_err_curve4(25:36), '-g', 'LineWidth', 2)
% % % axis([0 12 0.0 1])
% % % axis square
% % % set(gca,'XTick',1:12,'fontsize', 10, 'fontweight', 'b')
% % % legend('Acquisition','Reacquisition')
% % % title('Noncontingent: 40% true','fontsize', 20, 'fontweight', 'b');
% % % xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% % % ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')