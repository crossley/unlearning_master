close all; clear all; clc;

% % % Format of output file???
% % % 
% % % 1 - block(1-17)

% % % [Line Categorization]
% % % 2 - Stimulus Length
% % % 3 - Stimulus Orientation
% % % 4 - Stimulus Category(1-4)
% % % 5 - Participant Response(1-4)
% % % 6 - Accuracy(0=incorrect, 1=correct)
% % % 7 - Reponse Time
% % % 8 - Feedback type (0=corrective, 1=random)

% % % [Numerical Stroop]
% % % 9 - Left Value(2-9)
% % % 10 - Right Value(2-9)
% % % 11 - Left Size(1=smaller, 2=larger)
% % % 12 - Right Size(1=smaller, 2=larger)
% % % 13 - Query(0=Value, 1=Size)
% % % 14 - Category(0=left, 1=right)
% % % 15 - Participant response(0=left, 1=right)
% % % 16 - Accuracy(0=incorrect, 1=correct)
% 17 - Response time

figures = 1;
files = 1;

num_trials = 850;
block_size = 25;
num_blocks = num_trials/block_size;

exclusion_criteria_acc = 0*0.4;
exclusion_criteria_dt = 0.85;


sub_num_1 = [];
sub_num_2 = [];
sub_num_3 = [];
sub_num_4 = [131:137 139:142 144:148 150 152:157 159 160];
sub_num_5 = [101 103 104 106 107 108 110 111 112 113 114 115 116 117 118 119 120 121 122 124 125 126 127 129 130]; % new control 3/28/2014


num_subs_1 = length(sub_num_1)
num_subs_2 = length(sub_num_2)
num_subs_3 = length(sub_num_3)
num_subs_4 = length(sub_num_4)
num_subs_5 = length(sub_num_5)

accuracy_record_1 = [];
accuracy_record_2 = [];
accuracy_record_3 = [];
accuracy_record_4 = [];
accuracy_record_5 = [];

learning_curve_1 = [];
learning_curve_2 = [];
learning_curve_3 = [];
learning_curve_4 = [];
learning_curve_5 = [];

std_err_curve_1 = [];
std_err_curve_2 = [];
std_err_curve_3 = [];
std_err_curve_4 = [];
std_err_curve_5 = [];

dt_learning_curve_1 = [];
dt_learning_curve_2 = [];
dt_learning_curve_3 = [];
dt_learning_curve_4 = [];
dt_learning_curve_5 = [];

dt_std_err_curve_1 = [];
dt_std_err_curve_2 = [];
dt_std_err_curve_3 = [];
dt_std_err_curve_4 = [];
dt_std_err_curve_5 = [];

dual_task_record_1 = [];
dual_task_record_2 = [];
dual_task_record_3 = [];
dual_task_record_4 = [];
dual_task_record_5 = [];

excluded_subs_1 = [];
excluded_subs_2 = [];
excluded_subs_3 = [];
excluded_subs_4 = [];
excluded_subs_5 = [];

%% Condition 1

accuracy_record = [];
dual_task_record = [];
learning_curve = [];
std_err_curve = [];
excluded_subs = [];

sub_num = sub_num_1;

for i = sub_num
    
    data = dlmread(['unl41' num2str(i) '.dat']);
        
    acc_cat = data(:,4) == data(:,5);
    acc_dt = data(:,16);
    
%     acc_cat = data(:,8);
    
    if mean(acc_cat(201:251)) < exclusion_criteria_acc || mean(acc_dt(251:350)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        accuracy_record = [accuracy_record; acc_cat'];
        dual_task_record = [dual_task_record; acc_dt'];
    end
    
end

learning_curve = zeros(1,num_blocks);
std_err_curve = zeros(1,num_blocks);
dt_learning_curve = zeros(1,num_blocks);
dt_std_err_curve = zeros(1,num_blocks);
SPSS = [];
sub_accuracy = [];

for i = 1:num_blocks
   
        start = (i-1)*block_size+1;
        stop = start + block_size - 1;
        
        sub_accuracy = [sub_accuracy mean(accuracy_record(:,start:stop),2);];
        
        accuracy = accuracy_record(:,start:stop);
        accuracy = reshape(accuracy, prod(size(accuracy)) ,1);
        
        dt_accuracy = dual_task_record(:,start:stop);
        dt_accuracy = reshape(dt_accuracy, prod(size(dt_accuracy)) ,1);
        
        SPSS = [SPSS mean(accuracy_record(:,start:stop),2)];
                
        mean_accuracy = mean(accuracy);
        std_err = std(accuracy)/sqrt(prod(size(accuracy)));

        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
        dt_mean_accuracy = mean(dt_accuracy);
        dt_std_err = std(dt_accuracy)/sqrt(prod(size(dt_accuracy)));

        dt_learning_curve(i) = mean(mean(dual_task_record(:,start:stop),2));
        dt_std_err_curve(i) = std(mean(dual_task_record(:,start:stop),2))/sqrt(prod(size(mean(dual_task_record(:,start:stop),2))));
        
end

accuracy_record_1 = accuracy_record;
dual_task_record_1 = dual_task_record;
learning_curve_1 = learning_curve;
std_err_curve_1 = std_err_curve;
dt_learning_curve_1 = dt_learning_curve;
dt_std_err_curve_1 = dt_std_err_curve;
excluded_subs_1 = excluded_subs;
sub_num = setdiff(sub_num,excluded_subs);

num_blocks = num_blocks - 2;
SPSS = SPSS(:,1:end-2);
num_subs = size(accuracy_record_1,1)
condition = ones(num_subs*num_blocks,1);
% phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(6,1);],num_subs,1);
% phase_s = repmat([ones(6,1); 2*ones(6,1); 3*ones(16,1); 4*ones(6,1);],num_subs,1);
phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(4,1);],num_subs,1);
phase_s = repmat([ones(4,1); 2*ones(8,1); 3*ones(16,1); 4*ones(4,1);],num_subs,1);
block = repmat([1:num_blocks]',num_subs,1);
subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
accuracy = reshape(SPSS',num_subs*num_blocks,1);
anova_1 = [condition phase phase_s block subject accuracy];
num_blocks = num_blocks + 2;


ac_ind = find(phase == 1);
ext_ind = find(phase == 2);
reac_ind = find(phase == 3);

anova_ac_1 = anova_1(ac_ind,:);
anova_ext_1 = anova_1(ext_ind,:);
anova_reac_1 = anova_1(reac_ind,:);

sub_accuracy_1 = sub_accuracy;

% num_blocks = 12; % first 150 trials of acquisition / all 150 reacquisition
% num_subs = size(accuracy_record_1,1);
% condition = ones(num_subs*num_blocks,1);
% phase = repmat([ones(6,1); 2*ones(6,1);],num_subs,1);
% block = repmat([1:num_blocks]',num_subs,1);
% subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
% accuracy = reshape([SPSS(:,1:6); SPSS(:,29:34)]',num_subs*num_blocks,1);
% anova_savings_1 = [condition phase block subject accuracy];
% num_blocks = 34;

%% Condition 2

accuracy_record = [];
dual_task_record = [];
learning_curve = [];
std_err_curve = [];
excluded_subs = [];

sub_num = sub_num_2;

for i = sub_num
    
    data = dlmread(['unl42' num2str(i) '.dat']);
    
    acc_cat = data(:,4) == data(:,5);
    acc_dt = data(:,16);
    
%     acc_cat = data(:,8);
    
    if mean(acc_cat(201:251)) < exclusion_criteria_acc || mean(acc_dt(251:450)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        accuracy_record = [accuracy_record; acc_cat'];
        dual_task_record = [dual_task_record; acc_dt'];
    end
    
end

learning_curve = zeros(1,num_blocks);
std_err_curve = zeros(1,num_blocks);
dt_learning_curve = zeros(1,num_blocks);
dt_std_err_curve = zeros(1,num_blocks);
SPSS = [];
sub_accuracy = [];

for i = 1:num_blocks
   
        start = (i-1)*block_size+1;
        stop = start + block_size - 1;
        
        sub_accuracy = [sub_accuracy mean(accuracy_record(:,start:stop),2);];
        
        accuracy = accuracy_record(:,start:stop);
        accuracy = reshape(accuracy, prod(size(accuracy)) ,1);
        
        dt_accuracy = dual_task_record(:,start:stop);
        dt_accuracy = reshape(dt_accuracy, prod(size(dt_accuracy)) ,1);
        
        SPSS = [SPSS mean(accuracy_record(:,start:stop),2)];
                
        mean_accuracy = mean(accuracy);
        std_err = std(accuracy)/sqrt(prod(size(accuracy)));

        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
        dt_mean_accuracy = mean(dt_accuracy);
        dt_std_err = std(dt_accuracy)/sqrt(prod(size(dt_accuracy)));

        dt_learning_curve(i) = mean(mean(dual_task_record(:,start:stop),2));
        dt_std_err_curve(i) = std(mean(dual_task_record(:,start:stop),2))/sqrt(prod(size(mean(dual_task_record(:,start:stop),2))));
        
end

accuracy_record_2 = accuracy_record;
dual_task_record_2 = dual_task_record;
learning_curve_2 = learning_curve;
std_err_curve_2 = std_err_curve;
dt_learning_curve_2 = dt_learning_curve;
dt_std_err_curve_2 = dt_std_err_curve;
excluded_subs_2 = excluded_subs;
sub_num = setdiff(sub_num,excluded_subs);

num_blocks = num_blocks - 2;
SPSS = SPSS(:,1:end-2);
num_subs = size(accuracy_record_2,1)
condition = 2*ones(num_subs*num_blocks,1);
% phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(6,1);],num_subs,1);
% phase_s = repmat([ones(6,1); 2*ones(6,1); 3*ones(16,1); 4*ones(6,1);],num_subs,1);
phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(4,1);],num_subs,1);
phase_s = repmat([ones(4,1); 2*ones(8,1); 3*ones(16,1); 4*ones(4,1);],num_subs,1);
block = repmat([1:num_blocks]',num_subs,1);
subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
accuracy = reshape(SPSS',num_subs*num_blocks,1);
anova_2 = [condition phase phase_s block subject accuracy];
num_blocks = num_blocks + 2;


ac_ind = find(phase == 1);
ext_ind = find(phase == 2);
reac_ind = find(phase == 3);

anova_ac_2 = anova_2(ac_ind,:);
anova_ext_2 = anova_2(ext_ind,:);
anova_reac_2 = anova_2(reac_ind,:);

sub_accuracy_2 = sub_accuracy;

% num_blocks = 12; % first 150 trials of acquisition / all 150 reacquisition
% num_subs = size(accuracy_record_2,1);
% condition = 2*ones(num_subs*num_blocks,1);
% phase = repmat([ones(6,1); 2*ones(6,1);],num_subs,1);
% block = repmat([1:num_blocks]',num_subs,1);
% subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
% accuracy = reshape([SPSS(:,1:6); SPSS(:,29:34)]',num_subs*num_blocks,1);
% anova_savings_2 = [condition phase block subject accuracy];
% num_blocks = 34;

%% Condition 3

accuracy_record = [];
dual_task_record = [];
learning_curve = [];
std_err_curve = [];
excluded_subs = [];

sub_num = sub_num_3;

for i = sub_num
    
    data = dlmread(['unl43' num2str(i) '.dat']);
    
    acc_cat = data(:,4) == data(:,5);
    acc_dt = data(:,16);
    
%     acc_cat = data(:,8);
    
    if mean(acc_cat(201:251)) < exclusion_criteria_acc || mean(acc_dt(251:550)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        accuracy_record = [accuracy_record; acc_cat'];
        dual_task_record = [dual_task_record; acc_dt'];
    end
    
end

learning_curve = zeros(1,num_blocks);
std_err_curve = zeros(1,num_blocks);
dt_learning_curve = zeros(1,num_blocks);
dt_std_err_curve = zeros(1,num_blocks);
SPSS = [];
sub_accuracy = [];

for i = 1:num_blocks
   
        start = (i-1)*block_size+1;
        stop = start + block_size - 1;
        
        sub_accuracy = [sub_accuracy mean(accuracy_record(:,start:stop),2);];
        
        accuracy = accuracy_record(:,start:stop);
        accuracy = reshape(accuracy, prod(size(accuracy)) ,1);
        
        dt_accuracy = dual_task_record(:,start:stop);
        dt_accuracy = reshape(dt_accuracy, prod(size(dt_accuracy)) ,1);
        
        SPSS = [SPSS mean(accuracy_record(:,start:stop),2)];
                
        mean_accuracy = mean(accuracy);
        std_err = std(accuracy)/sqrt(prod(size(accuracy)));

        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
        dt_mean_accuracy = mean(dt_accuracy);
        dt_std_err = std(dt_accuracy)/sqrt(prod(size(dt_accuracy)));

        dt_learning_curve(i) = mean(mean(dual_task_record(:,start:stop),2));
        dt_std_err_curve(i) = std(mean(dual_task_record(:,start:stop),2))/sqrt(prod(size(mean(dual_task_record(:,start:stop),2))));
        
end

accuracy_record_3 = accuracy_record;
dual_task_record_3 = dual_task_record;
learning_curve_3 = learning_curve;
std_err_curve_3 = std_err_curve;
dt_learning_curve_3 = dt_learning_curve;
dt_std_err_curve_3 = dt_std_err_curve;
excluded_subs_3 = excluded_subs;
sub_num = setdiff(sub_num,excluded_subs);

num_blocks = num_blocks - 2;
SPSS = SPSS(:,1:end-2);
num_subs = size(accuracy_record_3,1)
condition = 3*ones(num_subs*num_blocks,1);
% phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(6,1);],num_subs,1);
% phase_s = repmat([ones(6,1); 2*ones(6,1); 3*ones(16,1); 4*ones(6,1);],num_subs,1);
phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(4,1);],num_subs,1);
phase_s = repmat([ones(4,1); 2*ones(8,1); 3*ones(16,1); 4*ones(4,1);],num_subs,1);
block = repmat([1:num_blocks]',num_subs,1);
subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
accuracy = reshape(SPSS',num_subs*num_blocks,1);
anova_3 = [condition phase phase_s block subject accuracy];
num_blocks = num_blocks + 2;


ac_ind = find(phase == 1);
ext_ind = find(phase == 2);
reac_ind = find(phase == 3);

anova_ac_3 = anova_3(ac_ind,:);
anova_ext_3 = anova_3(ext_ind,:);
anova_reac_3 = anova_3(reac_ind,:);

sub_accuracy_3 = sub_accuracy;

% num_blocks = 12; % first 150 trials of acquisition / all 150 reacquisition
% num_subs = size(accuracy_record_3,1);
% condition = 3*ones(num_subs*num_blocks,1);
% phase = repmat([ones(6,1); 2*ones(6,1);],num_subs,1);
% block = repmat([1:num_blocks]',num_subs,1);
% subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
% accuracy = reshape([SPSS(:,1:6); SPSS(:,29:34)]',num_subs*num_blocks,1);
% anova_savings_3 = [condition phase block subject accuracy];
% num_blocks = 34;

%% Condition 4

accuracy_record = [];
dual_task_record = [];
learning_curve = [];
std_err_curve = [];
excluded_subs = [];

sub_num = sub_num_4;

for i = sub_num
    
    data = dlmread(['unl44' num2str(i) '.dat']);
    
    acc_cat = data(:,4) == data(:,5);
    acc_dt = data(:,16);
    
%     acc_cat = data(:,8);
    
    if mean(acc_cat(201:251)) < exclusion_criteria_acc || mean(acc_dt(401:650)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        accuracy_record = [accuracy_record; acc_cat'];
        dual_task_record = [dual_task_record; acc_dt'];
    end
    
end

learning_curve = zeros(1,num_blocks);
std_err_curve = zeros(1,num_blocks);
dt_learning_curve = zeros(1,num_blocks);
dt_std_err_curve = zeros(1,num_blocks);
SPSS = [];
sub_accuracy = [];

for i = 1:num_blocks
   
        start = (i-1)*block_size+1;
        stop = start + block_size - 1;
        
        sub_accuracy = [sub_accuracy mean(accuracy_record(:,start:stop),2);];
        
        accuracy = accuracy_record(:,start:stop);
        accuracy = reshape(accuracy, prod(size(accuracy)) ,1);
        
        dt_accuracy = dual_task_record(:,start:stop);
        dt_accuracy = reshape(dt_accuracy, prod(size(dt_accuracy)) ,1);
        
        SPSS = [SPSS mean(accuracy_record(:,start:stop),2)];
                
        mean_accuracy = mean(accuracy);
        std_err = std(accuracy)/sqrt(prod(size(accuracy)));

        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
        dt_mean_accuracy = mean(dt_accuracy);
        dt_std_err = std(dt_accuracy)/sqrt(prod(size(dt_accuracy)));

        dt_learning_curve(i) = mean(mean(dual_task_record(:,start:stop),2));
        dt_std_err_curve(i) = std(mean(dual_task_record(:,start:stop),2))/sqrt(prod(size(mean(dual_task_record(:,start:stop),2))));
        
end

accuracy_record_4 = accuracy_record;
dual_task_record_4 = dual_task_record;
learning_curve_4 = learning_curve;
std_err_curve_4 = std_err_curve;
dt_learning_curve_4 = dt_learning_curve;
dt_std_err_curve_4 = dt_std_err_curve;
excluded_subs_4 = excluded_subs;
sub_num = setdiff(sub_num,excluded_subs);

num_blocks = num_blocks - 2;
SPSS = SPSS(:,1:end-2);
num_subs = size(accuracy_record_4,1)
condition = 4*ones(num_subs*num_blocks,1);
% phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(6,1);],num_subs,1);
% phase_s = repmat([ones(6,1); 2*ones(6,1); 3*ones(16,1); 4*ones(6,1);],num_subs,1);
phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(4,1);],num_subs,1);
phase_s = repmat([ones(4,1); 2*ones(8,1); 3*ones(16,1); 4*ones(4,1);],num_subs,1);
block = repmat([1:num_blocks]',num_subs,1);
subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
accuracy = reshape(SPSS',num_subs*num_blocks,1);
anova_4 = [condition phase phase_s block subject accuracy];
num_blocks = num_blocks + 2;


ac_ind = find(phase == 1);
ext_ind = find(phase == 2);
reac_ind = find(phase == 3);

anova_ac_4 = anova_4(ac_ind,:);
anova_ext_4 = anova_4(ext_ind,:);
anova_reac_4 = anova_4(reac_ind,:);

sub_accuracy_4 = sub_accuracy;

% num_blocks = 12; % first 150 trials of acquisition / all 150 reacquisition
% num_subs = size(accuracy_record_4,1);
% condition = 4*ones(num_subs*num_blocks,1);
% phase = repmat([ones(6,1); 2*ones(6,1);],num_subs,1);
% block = repmat([1:num_blocks]',num_subs,1);
% subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
% accuracy = reshape([SPSS(:,1:6); SPSS(:,29:34)]',num_subs*num_blocks,1);
% anova_savings_4 = [condition phase block subject accuracy];
% num_blocks = 34;

%%
% condition 5 (unused control from the first batch)
% new condition 5 (no dual-task + extended extinction) 3/28/2014

accuracy_record = [];
dual_task_record = [];
learning_curve = [];
std_err_curve = [];
excluded_subs = [];

sub_num = sub_num_5;

for i = sub_num
    
    data = dlmread(['Unl5_' num2str(i) '.txt']);

    acc_cat = data(:,5) == data(:,6);
%     acc_cat = data(:,8);
    
    if mean(acc_cat(201:251)) < exclusion_criteria_acc || mean(acc_dt(251:350)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        accuracy_record = [accuracy_record; acc_cat'];
    end
    
end

learning_curve = zeros(1,num_blocks);
std_err_curve = zeros(1,num_blocks);
dt_learning_curve = zeros(1,num_blocks);
dt_std_err_curve = zeros(1,num_blocks);
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

accuracy_record_5 = accuracy_record;
dual_task_record_5 = dual_task_record;
learning_curve_5 = learning_curve;
std_err_curve_5 = std_err_curve;
excluded_subs_5 = excluded_subs;
sub_num = setdiff(sub_num,excluded_subs);

% Last 50 trials in this condition got whacked (change phase too)
num_blocks = num_blocks - 2;
SPSS = SPSS(:,1:end-2);
num_subs = size(accuracy_record_5,1)
condition = 5*ones(num_subs*num_blocks,1);
phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(4,1);],num_subs,1);
phase_s = repmat([ones(4,1); 2*ones(8,1); 3*ones(16,1); 4*ones(4,1);],num_subs,1);
block = repmat([1:num_blocks]',num_subs,1);
subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
accuracy = reshape(SPSS',num_subs*num_blocks,1);
anova_5 = [condition phase phase_s block subject accuracy];
num_blocks = num_blocks + 2;

ac_ind = find(phase == 1);
ext_ind = find(phase == 2);
reac_ind = find(phase == 3);

anova_ac_5 = anova_5(ac_ind,:);
anova_ext_5 = anova_5(ext_ind,:);
anova_reac_5 = anova_5(reac_ind,:);

sub_accuracy_5 = sub_accuracy;

% num_blocks = 8; % first 150 trials of acquisition / all 150 reacquisition
% num_subs = size(accuracy_record_5,1);
% condition = 5*ones(num_subs*num_blocks,1);
% phase = repmat([ones(4,1); 2*ones(4,1);],num_subs,1);
% block = repmat([1:num_blocks]',num_subs,1);
% subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
% accuracy = reshape([SPSS(:,1:4); SPSS(:,29:32)]',num_subs*num_blocks,1);
% anova_savings_5 = [condition phase block subject accuracy];
% num_blocks = 34;

%%

size(excluded_subs_1)
size(excluded_subs_2)
size(excluded_subs_3)
size(excluded_subs_4)
size(excluded_subs_5)

acc_cat_mean_1 = learning_curve_1; mean(learning_curve_1(13:29))
acc_cat_mean_2 = learning_curve_2; mean(learning_curve_2(13:29))
acc_cat_mean_3 = learning_curve_3; mean(learning_curve_3(13:29))
acc_cat_mean_4 = learning_curve_4; mean(learning_curve_4(13:29))
acc_cat_mean_5 = learning_curve_5; mean(learning_curve_5(13:29))

stdderr_cat_mean_1 = std_err_curve_1;
stdderr_cat_mean_2 = std_err_curve_2;
stdderr_cat_mean_3 = std_err_curve_3;
stdderr_cat_mean_4 = std_err_curve_4;
stdderr_cat_mean_5 = std_err_curve_5;

acc_dt_mean_1 = dt_learning_curve_1;
acc_dt_mean_2 = dt_learning_curve_2;
acc_dt_mean_3 = dt_learning_curve_3;
acc_dt_mean_4 = dt_learning_curve_4;

stdderr_dt_mean_1 = dt_std_err_curve_1;
stdderr_dt_mean_2 = dt_std_err_curve_2;
stdderr_dt_mean_3 = dt_std_err_curve_3;
stdderr_dt_mean_4 = dt_std_err_curve_4;

acc_cat_mean_5(end-1:end) = [];
stdderr_cat_mean_5(end-1:end) = [];

if figures

    color = lines(5);
    a = .75;
    
    figure, hold
%     subplot(2,2,1), hold
    ciplot(acc_cat_mean_1-stdderr_cat_mean_1,acc_cat_mean_1+stdderr_cat_mean_1,1:num_blocks,color(1,:))
    ciplot(acc_cat_mean_5-stdderr_cat_mean_5,acc_cat_mean_5+stdderr_cat_mean_5,1:num_blocks-2,color(3,:))
    camlight; lighting none; 
    alpha(a)
    axis([0 num_blocks+1 0.0 1])
    axis square
    ylabel('Accuracy', 'fontsize', 18, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    set(gca,'XTick',2:2:num_blocks, 'fontsize', 12, 'fontweight', 'b')
%     legend({'Condition 1', 'Condition 5'}, 'fontsize', 18, 'Location', 'North');
%     legend boxoff
    plot([12,12],[0 1],'--k', 'LineWidth', 2)
    plot([28,28],[0 1],'--k', 'LineWidth', 2)
    
    figure, hold
%     subplot(2,2,2), hold
    ciplot(acc_cat_mean_2-stdderr_cat_mean_2,acc_cat_mean_2+stdderr_cat_mean_2,1:num_blocks,color(1,:))
    ciplot(acc_cat_mean_5-stdderr_cat_mean_5,acc_cat_mean_5+stdderr_cat_mean_5,1:num_blocks-2,color(3,:))
    camlight; lighting none; 
    alpha(a)
    axis([0 num_blocks+1 0.0 1])
    axis square
    ylabel('Accuracy', 'fontsize', 18, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    set(gca,'XTick',2:2:num_blocks, 'fontsize', 12, 'fontweight', 'b')
%     legend({'Condition 2', 'Condition 5'}, 'fontsize', 18, 'Location', 'North');
%     legend boxoff
    plot([12,12],[0 1],'--k', 'LineWidth', 2)
    plot([28,28],[0 1],'--k', 'LineWidth', 2)
    
    figure, hold
%     subplot(2,2,3), hold
    ciplot(acc_cat_mean_3-stdderr_cat_mean_3,acc_cat_mean_3+stdderr_cat_mean_3,1:num_blocks,color(1,:))
    ciplot(acc_cat_mean_5-stdderr_cat_mean_5,acc_cat_mean_5+stdderr_cat_mean_5,1:num_blocks-2,color(3,:))
    camlight; lighting none; 
    alpha(a)
    axis([0 num_blocks+1 0.0 1])
    axis square
    ylabel('Accuracy', 'fontsize', 18, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    set(gca,'XTick',2:2:num_blocks, 'fontsize', 12, 'fontweight', 'b')
%     legend({'Condition 3', 'Condition 5'}, 'fontsize', 18, 'Location', 'North');
%     legend boxoff
    plot([12,12],[0 1],'--k', 'LineWidth', 2)
    plot([28,28],[0 1],'--k', 'LineWidth', 2)
    
    figure, hold
%     subplot(2,2,4), hold
    ciplot(acc_cat_mean_4-stdderr_cat_mean_4,acc_cat_mean_4+stdderr_cat_mean_4,1:num_blocks,color(1,:))   
    ciplot(acc_cat_mean_5-stdderr_cat_mean_5,acc_cat_mean_5+stdderr_cat_mean_5,1:num_blocks-2,color(3,:))
    camlight; lighting none; 
    alpha(a)
    axis([0 num_blocks+1 0.0 1])
    axis square
    ylabel('Accuracy', 'fontsize', 18, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    set(gca,'XTick',2:2:num_blocks, 'fontsize', 12, 'fontweight', 'b')
%     legend({'Condition 4', 'Condition 5'}, 'fontsize', 18, 'Location', 'North');
%     legend boxoff
    plot([12,12],[0 1],'--k', 'LineWidth', 2)
    plot([28,28],[0 1],'--k', 'LineWidth', 2)
    
%     figure, hold
%     plot(1:num_blocks, acc_dt_mean_1, '-', 'LineWidth', 2, 'color', color(1,:))
%     plot(1:num_blocks, acc_dt_mean_2, '-', 'LineWidth', 2, 'color', color(2,:))
%     plot(1:num_blocks, acc_dt_mean_3, '-', 'LineWidth', 2, 'color', color(3,:))
%     plot(1:num_blocks, acc_dt_mean_4, '-', 'LineWidth', 2, 'color', color(4,:))
%     ciplot(acc_dt_mean_1-stdderr_dt_mean_1,acc_dt_mean_1+stdderr_dt_mean_1,1:num_blocks,color(1,:))
%     ciplot(acc_dt_mean_2-stdderr_dt_mean_2,acc_dt_mean_2+stdderr_dt_mean_2,1:num_blocks,color(2,:))
%     ciplot(acc_dt_mean_3-stdderr_dt_mean_3,acc_dt_mean_3+stdderr_dt_mean_3,1:num_blocks,color(3,:))
%     ciplot(acc_dt_mean_4-stdderr_dt_mean_4,acc_dt_mean_4+stdderr_dt_mean_4,1:num_blocks,color(4,:))
%     camlight; lighting none; 
%     alpha(a)
%     axis([0 num_blocks+1 0.0 1])
%     axis square
%     set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
%     xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
%     ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
%     legend({'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4'}, 'fontsize', 18, 'Location', 'South');
%     legend boxoff
%     plot([12,12],[0 1],'--k', 'LineWidth', 2)
%     plot([28,28],[0 1],'--k', 'LineWidth', 2)

%%
    figure, hold
    ciplot(acc_cat_mean_4-stdderr_cat_mean_4,acc_cat_mean_4+stdderr_cat_mean_4,1:num_blocks,color(1,:))   
    ciplot(acc_cat_mean_3-stdderr_cat_mean_3,acc_cat_mean_3+stdderr_cat_mean_3,1:num_blocks,color(3,:))
    camlight; lighting none; 
    alpha(a)
    axis([0 num_blocks+1 0.0 1])
    axis square
    ylabel('Accuracy', 'fontsize', 18, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    set(gca,'XTick',2:2:num_blocks, 'fontsize', 12, 'fontweight', 'b')
    plot([12,12],[0 1],'--k', 'LineWidth', 2)
    plot([28,28],[0 1],'--k', 'LineWidth', 2)
    
    %% savings matlab style    
%     cond_1_savings = mean(sub_accuracy_1(:,29:32),2) - mean(sub_accuracy_1(:,1:4),2);
%     cond_2_savings = mean(sub_accuracy_2(:,29:32),2) - mean(sub_accuracy_2(:,1:4),2);
%     cond_3_savings = mean(sub_accuracy_3(:,29:32),2) - mean(sub_accuracy_3(:,1:4),2);
%     cond_4_savings = mean(sub_accuracy_4(:,29:32),2) - mean(sub_accuracy_4(:,1:4),2);
%     cond_5_savings = mean(sub_accuracy_5(:,29:32),2) - mean(sub_accuracy_5(:,1:4),2);
    
    cond_1_savings = mean(sub_accuracy_1(:,29:34),2) - mean(sub_accuracy_1(:,1:6),2);
    cond_2_savings = mean(sub_accuracy_2(:,29:34),2) - mean(sub_accuracy_2(:,1:6),2);
    cond_3_savings = mean(sub_accuracy_3(:,29:34),2) - mean(sub_accuracy_3(:,1:6),2);
    cond_4_savings = mean(sub_accuracy_4(:,29:34),2) - mean(sub_accuracy_4(:,1:6),2);
    cond_5_savings = mean(sub_accuracy_5(:,29:32),2) - mean(sub_accuracy_5(:,1:4),2);
    
%     cond_1_savings = (mean(sub_accuracy_1(:,32),2)-mean(sub_accuracy_1(:,29),2)) - (mean(sub_accuracy_1(:,4),2)-mean(sub_accuracy_1(:,1),2));
%     cond_2_savings = (mean(sub_accuracy_2(:,32),2)-mean(sub_accuracy_2(:,29),2)) - (mean(sub_accuracy_2(:,4),2)-mean(sub_accuracy_2(:,1),2));
%     cond_3_savings = (mean(sub_accuracy_3(:,32),2)-mean(sub_accuracy_3(:,29),2)) - (mean(sub_accuracy_3(:,4),2)-mean(sub_accuracy_3(:,1),2));
%     cond_4_savings = (mean(sub_accuracy_4(:,32),2)-mean(sub_accuracy_4(:,29),2)) - (mean(sub_accuracy_4(:,4),2)-mean(sub_accuracy_4(:,1),2));
%     cond_5_savings = (mean(sub_accuracy_5(:,32),2)-mean(sub_accuracy_5(:,29),2)) - (mean(sub_accuracy_5(:,4),2)-mean(sub_accuracy_5(:,1),2));

%     cond_1_savings = sub_accuracy_1(:,29:34) - sub_accuracy_1(:,1:6);
%     cond_2_savings = sub_accuracy_2(:,29:34) - sub_accuracy_2(:,1:6);
%     cond_3_savings = sub_accuracy_3(:,29:34) - sub_accuracy_3(:,1:6);
%     cond_4_savings = sub_accuracy_4(:,29:34) - sub_accuracy_4(:,1:6);
%     cond_5_savings = sub_accuracy_5(:,29:34) - sub_accuracy_5(:,1:6);
    
    % pairwise differences
%     [H,P,CI] = ttest2(cond_3_savings,cond_4_savings)
    
    mean_1 = mean(cond_1_savings);
    mean_2 = mean(cond_2_savings);
    mean_3 = mean(cond_3_savings);
    mean_4 = mean(cond_4_savings);
    mean_5 = mean(cond_5_savings);
    
    [H,P,CI_1] = ttest(cond_1_savings); CI_1 = (CI_1(2) - CI_1(1))/2;
    [H,P,CI_2] = ttest(cond_2_savings); CI_2 = (CI_2(2) - CI_2(1))/2;
    [H,P,CI_3] = ttest(cond_3_savings); CI_3 = (CI_3(2) - CI_3(1))/2;
    [H,P,CI_4] = ttest(cond_4_savings); CI_4 = (CI_4(2) - CI_4(1))/2;
    [H,P,CI_5] = ttest(cond_5_savings); CI_5 = (CI_5(2) - CI_5(1))/2;
    
%     [H,P,CI_1] = ttest(cond_1_savings); CI_1 = (CI_1(2,:) - CI_1(1,:))/2;
%     [H,P,CI_2] = ttest(cond_2_savings); CI_2 = (CI_2(2,:) - CI_2(1,:))/2;
%     [H,P,CI_3] = ttest(cond_3_savings); CI_3 = (CI_3(2,:) - CI_3(1,:))/2;
%     [H,P,CI_4] = ttest(cond_4_savings); CI_4 = (CI_4(2,:) - CI_4(1,:))/2;
%     [H,P,CI_5] = ttest(cond_5_savings); CI_5 = (CI_5(2,:) - CI_5(1,:))/2;
    
    figure, hold
    plot([0 6], [0 0], '--k', 'linewidth', 2)
    errorbar(1, mean_1, CI_1, '*k', 'linewidth',1)
    errorbar(2, mean_2, CI_2, '*k', 'linewidth',1)
    errorbar(3, mean_3, CI_3, '*k', 'linewidth',1)
    errorbar(4, mean_4, CI_4, '*k', 'linewidth',1)
    errorbar(5, mean_5, CI_5, '*k', 'linewidth',1)
    ylabel('Savings', 'fontsize', 18, 'fontweight', 'b')
    xlabel('Condition', 'fontsize', 18, 'fontweight', 'b')
    set(gca,'XTick',[1:5], 'fontsize', 14)
    set(gca,'XTickLabel',{'1','2','3','4','5'},'fontsize', 16, 'fontweight', 'b')
    axis square
    
%     mean_1 = mean_1(1:4);
%     mean_2 = mean_2(1:4);
%     mean_3 = mean_3(1:4);
%     mean_4 = mean_4(1:4);
%     mean_5 = mean_5(1:4);
%     
%     CI_1 = CI_1(1:4);
%     CI_2 = CI_2(1:4);
%     CI_3 = CI_3(1:4);
%     CI_4 = CI_4(1:4);
%     CI_5 = CI_5(1:4);
% 
%     x_1 = 1:4;
%     x_2 = x_1 + 8;
%     x_3 = x_2 + 8;
%     x_4 = x_3 + 8;
%     x_5 = x_4 + 8;
%     
%     figure, hold
%     plot([0 37], [0 0], '--k', 'linewidth', 1)
%     errorbar(x_1, mean_1, CI_1, '*k', 'linewidth',2)
%     errorbar(x_2, mean_2, CI_2, '*k', 'linewidth',2)
%     errorbar(x_3, mean_3, CI_3, '*k', 'linewidth',2)
%     errorbar(x_4, mean_4, CI_4, '*k', 'linewidth',2)
%     errorbar(x_5, mean_5, CI_5, '*k', 'linewidth',2)
%     ylabel('Savings', 'fontsize', 18, 'fontweight', 'b')
%     xlabel('Condition', 'fontsize', 18, 'fontweight', 'b')
%     set(gca,'XTick',[mean(x_1) mean(x_2) mean(x_3) mean(x_4) mean(x_5)], 'fontsize', 14)
%     set(gca,'XTickLabel',{'1','2','3','4','5'},'fontsize', 16, 'fontweight', 'b')
%     axis square
%     ymin = min([mean_1-CI_1 mean_2-CI_2 mean_3-CI_3 mean_4-CI_4 mean_5-CI_5]);
%     ymax = max([mean_1+CI_1 mean_2+CI_2 mean_3+CI_3 mean_4+CI_4 mean_5+CI_5]);
%     xmin = 0;
%     xmax = x_5(end)+1;
%     axis([xmin xmax ymin ymax])
    
    %% savings new R style 3/28/2014
    lower_1 = -0.0401; upper_1 = 0.0358; CI_1 = (upper_1-lower_1)/2; mean_1 = upper_1 - (upper_1 - lower_1)/2;
    lower_2 = -0.0563; upper_2 = 0.0254; CI_2 = (upper_2-lower_2)/2; mean_2 = upper_2 - (upper_2 - lower_2)/2;
    lower_3 = 0.0075; upper_3 = 0.0852; CI_3 = (upper_3-lower_3)/2; mean_3 = upper_3 - (upper_3 - lower_3)/2;
    lower_4 = -0.0808; upper_4 = 0.0031; CI_4 = (upper_4-lower_4)/2; mean_4 = upper_4 - (upper_4 - lower_4)/2;
    lower_5 = -0.0883; upper_5 = 0.0093; CI_5 = (upper_5-lower_5)/2; mean_5 = upper_5 - (upper_5 - lower_5)/2;
    
%     lower_1 = -0.0432; upper_1 = 0.0477; CI_1 = (upper_1-lower_1)/2; mean_1 = upper_1 - (upper_1 - lower_1)/2;
%     lower_2 = -0.0747; upper_2 = 0.0231; CI_2 = (upper_2-lower_2)/2; mean_2 = upper_2 - (upper_2 - lower_2)/2;
%     lower_3 = -0.0194; upper_3 = 0.0737; CI_3 = (upper_3-lower_3)/2; mean_3 = upper_3 - (upper_3 - lower_3)/2;
%     lower_4 = -0.1164; upper_4 = -0.0158; CI_4 = (upper_4-lower_4)/2; mean_4 = upper_4 - (upper_4 - lower_4)/2;
%     lower_5 = -0.0872; upper_5 = 0.0082; CI_5 = (upper_5-lower_5)/2; mean_5 = upper_5 - (upper_5 - lower_5)/2;

    mean_1 = -mean_1;
    mean_2 = -mean_2;
    mean_3 = -mean_3;
    mean_4 = -mean_4;
    mean_5 = -mean_5;
    
    figure, hold
    plot([0 6], [0 0], '--k', 'linewidth', 2)
    errorbar(1, mean_1, CI_1, '*k', 'linewidth',1)
    errorbar(2, mean_2, CI_2, '*k', 'linewidth',1)
    errorbar(3, mean_3, CI_3, '*k', 'linewidth',1)
    errorbar(4, mean_4, CI_4, '*k', 'linewidth',1)
    errorbar(5, mean_5, CI_5, '*k', 'linewidth',1)
    ylabel('Savings', 'fontsize', 18, 'fontweight', 'b')
    xlabel('Condition', 'fontsize', 18, 'fontweight', 'b')
    set(gca,'XTick',[1:5], 'fontsize', 14)
    set(gca,'XTickLabel',{'1','2','3','4','5'},'fontsize', 16, 'fontweight', 'b')
    axis square
%     title('Savings','fontsize', 18, 'fontweight', 'b')
    
end

%%
if files
    
    fid_all = fopen('anova_all','w');
    fprintf(fid_all, 'condition phase phase_s block subject accuracy\n');
    fprintf(fid_all,'%f %f %f %f %f %f\n',[anova_1; anova_2; anova_3; anova_4; anova_5;]');
    fclose(fid_all);
end