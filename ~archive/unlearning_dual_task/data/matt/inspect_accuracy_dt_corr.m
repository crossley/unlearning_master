close all; clear all; clc;

% unl411.dat      unl422.dat      unl431.dat      unl444.dat      unl455.dat
% unl416.dat      unl427.dat      unl433.dat      unl449.dat      unl4510.dat
% unl4111.dat     unl4212.dat     unl438.dat      unl4414.dat     unl4520.dat
% unl4116.dat     unl4217.dat     unl4313.dat     unl4419.dat     unl4525.dat
% unl4121.dat     unl4222.dat     unl4318.dat     unl4424.dat     unl4530.dat
% unl4126.dat     unl4227.dat     unl4323.dat     unl4434.dat     unl4535.dat
% unl4131.dat     unl4232.dat     unl4328.dat     unl4439.dat     unl4540.dat
% unl4136.dat     unl4237.dat     unl4333.dat     unl4444.dat     unl4545.dat
% unl4141.dat     unl4242.dat     unl4338.dat     unl4449.dat     unl4550.dat
% unl4146.dat     unl4247.dat     unl4343.dat     unl4458.dat	
% unl4151.dat     unl4252.dat     unl4348.dat     unl4462.dat	
% unl4155.dat     unl4256.dat     unl4353.dat     unl4466.dat	
% unl4159.dat     unl4260.dat     unl4357.dat     unl4470.dat	
% unl4163.dat     unl4264.dat     unl4361.dat     unl4474.dat	
% unl4167.dat     unl4268.dat     unl4365.dat     unl4478.dat	
% unl4171.dat     unl4272.dat     unl4369.dat     unl4482.dat	
% unl4175.dat     unl4276.dat     unl4373.dat     unl4486.dat	
% unl4179.dat     unl4280.dat     unl4377.dat     unl4490.dat	
% unl4183.dat     unl4284.dat     unl4381.dat     unl4494.dat	
% unl4187.dat     unl4288.dat     unl4385.dat     unl4498.dat	
% unl4191.dat     unl4292.dat     unl4393.dat     unl44102.dat	
% unl4195.dat     unl4296.dat     unl43105.dat	unl44106.dat	
% unl4199.dat     unl42100.dat	unl43109.dat	unl44114.dat	
% unl41103.dat	unl42104.dat	unl43113.dat	unl44118.dat	
% unl41107.dat	unl42108.dat	unl43117.dat	unl44122.dat	
% unl41111.dat	unl42113.dat	unl43121.dat	unl44126.dat	
% unl41115.dat	unl42116.dat	unl43125.dat	unl44130.dat	
% unl41119.dat	unl42120.dat	unl43129.dat		
% unl41123.dat	unl42124.dat			
% unl41127.dat	unl42128.dat	

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

exclusion_criteria_acc = 0.4;
exclusion_criteria_dt = 0.0; % don't exlude based on dt performance for the correlation analysis


sub_num_1 = [1 6 11 16 21 26 31 36 41 46 51 55 59 63 67 71 75 79 83 87 91 95 99 103 107 111 115 119 123 127];
sub_num_2 = [2 7 12 17 22 27 32 37 42 47 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 113 116 120 124 128];
sub_num_3 = [1 3 8 13 18 23 28 33 38 43 48 53 57 61 65 69 73 77 81 85 93 105 109 113 117 121 125 129];
sub_num_4 = [4 9 14 19 24 34 39 44 49 58 62 66 70 74 78 82 86 90 94 98 102 106 114 118 122 126 130];

num_subs_1 = length(sub_num_1)
num_subs_2 = length(sub_num_2)
num_subs_3 = length(sub_num_3)
num_subs_4 = length(sub_num_4)

dual_task_record_1 = [];
dual_task_record_2 = [];
dual_task_record_3 = [];
dual_task_record_4 = [];

savings_record_1 = [];
savings_record_2 = [];
savings_record_3 = [];
savings_record_4 = [];

intervention_record_1 = [];
intervention_record_2 = [];
intervention_record_3 = [];
intervention_record_4 = [];

excluded_subs_1 = [];
excluded_subs_2 = [];
excluded_subs_3 = [];
excluded_subs_4 = [];

%% Condition 1

savings_record = [];
dual_task_record = [];
intervention_record = [];
excluded_subs = [];

sub_num = sub_num_1;

for i = sub_num
    
    data = dlmread(['unl41' num2str(i) '.dat']);
    
    acc_cat = data(:,6);
    acc_dt = data(:,16);
    
    if mean(acc_cat(201:251)) < exclusion_criteria_acc || mean(acc_dt(251:350)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        dual_task_record = [dual_task_record; mean(acc_dt(251:350))];
        savings_record = [savings_record; mean(acc_cat(701:850))-mean(acc_cat(1:150))];
        intervention_record = [intervention_record; mean(acc_cat(301:700))];
    end
    
end

dual_task_record_1 = dual_task_record;
savings_record_1 = savings_record;
intervention_record_1 = intervention_record;

sub_num = setdiff(sub_num,excluded_subs);
num_subs = length(sub_num);
condition = ones(num_subs,1);
anova_savings_1 = [condition sub_num' dual_task_record savings_record intervention_record];

%% Condition 2

savings_record = [];
dual_task_record = [];
intervention_record = [];
excluded_subs = [];

sub_num = sub_num_2;

for i = sub_num
    
    data = dlmread(['unl42' num2str(i) '.dat']);
    
    acc_cat = data(:,6);
    acc_dt = data(:,16);
    
    if mean(acc_cat(201:251)) < exclusion_criteria_acc || mean(acc_dt(251:450)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        dual_task_record = [dual_task_record; mean(acc_dt(251:450))];
        savings_record = [savings_record; mean(acc_cat(701:850))-mean(acc_cat(1:150))];
        intervention_record = [intervention_record; mean(acc_cat(301:700))];
    end
    
end

dual_task_record_2 = dual_task_record;
savings_record_2 = savings_record;
intervention_record_2 = intervention_record;

sub_num = setdiff(sub_num,excluded_subs);
num_subs = length(sub_num);
condition = 2*ones(num_subs,1);
anova_savings_2 = [condition sub_num' dual_task_record savings_record intervention_record];

%% Condition 3

savings_record = [];
dual_task_record = [];
intervention_record = [];
excluded_subs = [];

sub_num = sub_num_3;

for i = sub_num
    
    data = dlmread(['unl43' num2str(i) '.dat']);
    
    acc_cat = data(:,6);
    acc_dt = data(:,16);
    
    if mean(acc_cat(201:251)) < exclusion_criteria_acc || mean(acc_dt(251:550)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        dual_task_record = [dual_task_record; mean(acc_dt(251:550))];
        savings_record = [savings_record; mean(acc_cat(701:850))-mean(acc_cat(1:150))];
        intervention_record = [intervention_record; mean(acc_cat(301:700))];
    end
    
end

dual_task_record_3 = dual_task_record;
savings_record_3 = savings_record;
intervention_record_3 = intervention_record;

sub_num = setdiff(sub_num,excluded_subs);
num_subs = length(sub_num);
condition = 3*ones(num_subs,1);
anova_savings_3 = [condition sub_num' dual_task_record savings_record intervention_record];

%% Condition 4

savings_record = [];
dual_task_record = [];
intervention_record = [];
excluded_subs = [];

sub_num = sub_num_4;

for i = sub_num
    
    data = dlmread(['unl44' num2str(i) '.dat']);
    
    acc_cat = data(:,6);
    acc_dt = data(:,16);
    
    if mean(acc_cat(201:251)) < exclusion_criteria_acc || mean(acc_dt(401:650)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        dual_task_record = [dual_task_record; mean(acc_dt(401:650))];
        savings_record = [savings_record; mean(acc_cat(701:850))-mean(acc_cat(1:150))];
        intervention_record = [intervention_record; mean(acc_cat(301:700))];
    end
    
end

dual_task_record_4 = dual_task_record;
savings_record_4 = savings_record;
intervention_record_4 = intervention_record;

sub_num = setdiff(sub_num,excluded_subs);
num_subs = length(sub_num);
condition = 4*ones(num_subs,1);
anova_savings_4 = [condition sub_num' dual_task_record savings_record intervention_record];

%%

size(excluded_subs_1)
size(excluded_subs_2)
size(excluded_subs_3)
size(excluded_subs_4)

dual_task_record = [dual_task_record_1; dual_task_record_2; dual_task_record_3; dual_task_record_4];
savings_record = [savings_record_1; savings_record_2; savings_record_3; savings_record_4];
intervention_record = [intervention_record_1; intervention_record_2; intervention_record_3; intervention_record_4];

if figures

    [RHO,PVAL] = corr(dual_task_record,savings_record);
    figure, hold
    plot(dual_task_record,savings_record, '*k', 'MarkerSize', 15)
    axis([0 1 0 1])
    axis square
    set(gca,'XTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
    set(gca,'YTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Mean Dual-Task Accuracy', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Mean Savings', 'fontsize', 18, 'fontweight', 'b')
    title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)
    
    [RHO,PVAL] = corr(intervention_record,savings_record);
    figure
    plot(intervention_record,savings_record, '*k', 'MarkerSize', 15)
    axis([0 1 0 1])
    axis square
    set(gca,'XTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
    set(gca,'YTick',0:0.1:1, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Mean Intervention Accuracy', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Mean Savings', 'fontsize', 18, 'fontweight', 'b')
    title(['r = ' num2str(RHO) '     ' 'p = ' num2str(PVAL)], 'fontsize', 18)

end

%%

if files

    fid_all = fopen('anova_savings_corr','w');
    fprintf(fid_all, 'condition subject dt_accuracy savings intervention\n');
    fprintf(fid_all,'%f %f %f %f %f\n',[anova_savings_1; anova_savings_2; anova_savings_3; anova_savings_4;]');
    fclose(fid_all);
    
end