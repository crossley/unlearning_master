function [dt_1_vars] = generate_dt_1(path, sub_num, block_struct, exclusion_criteria)

num_trials = block_struct(1);
block_size = block_struct(2);
num_blocks = block_struct(3);

accuracy_record = [];
savings_record = [];
intervention_record = [];
dual_task_record = [];
learning_curve = zeros(1,num_blocks);
std_err_curve = zeros(1,num_blocks);
excluded_subs = [];
sub_accuracy = [];
SPSS = [];

exclusion_criteria_acc = exclusion_criteria{1};
exclusion_criteria_dt = exclusion_criteria{2};

for i = sub_num
    
    data = dlmread([path '/unl41' num2str(i) '.dat']);
    
    cat = data(:,4);
    x = data(:,2);
    y = data(:,3);
    resp = data(:,5);

    corr_ind = find(cat == resp);
    feedback = zeros(900,1);
    feedback(corr_ind,1) = 1;
    
    dt_feedback = data(:,16);

    if mean(feedback(201:250)) < exclusion_criteria_acc || mean(dt_feedback(251:350)) < exclusion_criteria_dt
        excluded_subs = [excluded_subs i];
    else
        accuracy_record = [accuracy_record; feedback'];
        savings_record = [savings_record; mean(feedback(601:900))-mean(feedback(1:300))];
        intervention_record = [intervention_record; mean(feedback(301:600))];
        dual_task_record = [dual_task_record; mean(dt_feedback(251:350))];
    end
    
end

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

sub_num = setdiff(sub_num,excluded_subs);

num_subs = size(accuracy_record,1);
condition = ones(num_subs*num_blocks,1);
phase = repmat([ones(12,1); 2*ones(16,1); 3*ones(6,1);],num_subs,1);
block = repmat([1:num_blocks]',num_subs,1);
subject = reshape(repmat(sub_num,num_blocks,1),num_subs*num_blocks,1);
accuracy = reshape(SPSS',num_subs*num_blocks,1);
anova = [condition phase block subject accuracy];

ac_ind = find(phase == 1);
ext_ind = find(phase == 2);
reac_ind = find(phase == 3);

anova_ac = anova(ac_ind,:);
anova_ext = anova(ext_ind,:);
anova_reac = anova(reac_ind,:);

condition = 1*ones(num_subs,1);
anova_savings = [condition sub_num' dual_task_record savings_record intervention_record];

dt_1_vars = cell(1,4);
dt_1_vars{1} = learning_curve;
dt_1_vars{2} = std_err_curve;
dt_1_vars{3} = sub_accuracy;
dt_1_vars{4} = excluded_subs;
dt_1_vars{5} = savings_record;
dt_1_vars{6} = intervention_record;
dt_1_vars{7} = dual_task_record;
dt_1_vars{8} = anova_savings;