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

figures = 0;
files = 1;

num_trials = 850;
block_size = 25;
num_blocks = num_trials/block_size;

exclusion_criteria_acc = 0.0;
exclusion_criteria_dt = 0.0;


sub_num_1 = [1 6 11 16 21 26 31 36 41 46 51 55 59 63 67 71 75 79 83 87 91 95 99 103 107 111 115 119 123 127];
sub_num_2 = [2 7 12 17 22 27 32 37 42 47 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 113 116 120 124 128];
sub_num_3 = [1 3 8 13 18 23 28 33 38 43 48 53 57 61 65 69 73 77 81 85 93 105 109 113 117 121 125 129];
sub_num_4 = [4 9 14 19 24 34 39 44 49 58 62 66 70 74 78 82 86 90 94 98 102 106 114 118 122 126 130];
sub_num_5 = [5 10 20 25 30 35 40 45 50];

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

dual_task_record_1 = [];
dual_task_record_2 = [];
dual_task_record_3 = [];
dual_task_record_4 = [];
dual_task_record_5 = [];

%%

for i = sub_num_1
    
    data = dlmread(['unl41' num2str(i) '.dat']);
    
    acc_cat = data(:,6);
    acc_dt = data(:,16);
    
    accuracy_record_1 = [accuracy_record_1; acc_cat'];
    dual_task_record_1 = [dual_task_record_1; acc_dt'];
    
end

for i = sub_num_2
    
    data = dlmread(['unl42' num2str(i) '.dat']);
    
    acc_cat = data(:,6);
    acc_dt = data(:,16);
    
    accuracy_record_2 = [accuracy_record_2; acc_cat'];
    dual_task_record_2 = [dual_task_record_2; acc_dt'];
    
end

for i = sub_num_3
    
    data = dlmread(['unl43' num2str(i) '.dat']);
    
    acc_cat = data(:,6);
    acc_dt = data(:,16);
    
    accuracy_record_3 = [accuracy_record_3; acc_cat'];
    dual_task_record_3 = [dual_task_record_3; acc_dt'];
    
end

for i = sub_num_4
    
    data = dlmread(['unl44' num2str(i) '.dat']);
    
    acc_cat = data(:,6);
    acc_dt = data(:,16);
    
    accuracy_record_4 = [accuracy_record_4; acc_cat'];
    dual_task_record_4 = [dual_task_record_4; acc_dt'];
    
end

for i = sub_num_5
    
    data = dlmread(['unl45' num2str(i) '.dat']);
    
    acc_cat = data(:,6);
    acc_dt = data(:,16);
    
    accuracy_record_5 = [accuracy_record_5; acc_cat'];
    dual_task_record_5 = [dual_task_record_5; acc_dt'];
    
end

% cond 1
mean_late_ac_1 = mean(accuracy_record_1(:,201:300),2);
exlcude_rows_1 = find(mean_late_ac_1<exclusion_criteria_acc);
mean_dt_ac_1 = mean(dual_task_record_1(:,251:350),2);
exlcude_rows_1 = [exlcude_rows_1; find(mean_dt_ac_1<exclusion_criteria_dt)];
accuracy_record_1(exlcude_rows_1,:) = [];
dual_task_record_1(exlcude_rows_1,:) = [];
num_subs_1 = size(accuracy_record_1,1);

accuracy_record_1 = reshape(accuracy_record_1,num_subs_1*block_size,num_blocks);
acc_cat_mean_1 = mean(accuracy_record_1);
stdderr_cat_mean_1 = std(accuracy_record_1)/sqrt(num_subs_1);

dual_task_record_1(find(dual_task_record_1==999)) = 0;
dual_task_record_1 = reshape(dual_task_record_1,num_subs_1*block_size,num_blocks);
acc_dt_mean_1 = mean(dual_task_record_1);
stdderr_dt_mean_1 = std(dual_task_record_1)/sqrt(num_subs_1);

% cond 2
mean_late_ac_2 = mean(accuracy_record_2(:,201:300),2);
exlcude_rows_2 = find(mean_late_ac_2<exclusion_criteria_acc);
mean_dt_ac_2 = mean(dual_task_record_2(:,251:450),2);
exlcude_rows_2 = [exlcude_rows_2; find(mean_dt_ac_2<exclusion_criteria_dt)];
accuracy_record_2(exlcude_rows_2,:) = [];
dual_task_record_2(exlcude_rows_2,:) = [];
num_subs_2 = size(accuracy_record_2,1);

accuracy_record_2 = reshape(accuracy_record_2,num_subs_2*block_size,num_blocks);
acc_cat_mean_2 = mean(accuracy_record_2);
stdderr_cat_mean_2 = std(accuracy_record_2)/sqrt(num_subs_2);

dual_task_record_2(find(dual_task_record_2==999)) = 0;
dual_task_record_2 = reshape(dual_task_record_2,num_subs_2*block_size,num_blocks);
acc_dt_mean_2 = mean(dual_task_record_2);
stdderr_dt_mean_2 = std(dual_task_record_2)/sqrt(num_subs_2);

% cond 3
mean_late_ac_3 = mean(accuracy_record_3(:,201:300),2);
exlcude_rows_3 = find(mean_late_ac_3<exclusion_criteria_acc);
mean_dt_ac_3 = mean(dual_task_record_3(:,251:550),2);
exlcude_rows_3 = [exlcude_rows_3; find(mean_dt_ac_3<exclusion_criteria_dt)];
accuracy_record_3(exlcude_rows_3,:) = [];
dual_task_record_3(exlcude_rows_3,:) = [];
num_subs_3 = size(accuracy_record_3,1);

accuracy_record_3 = reshape(accuracy_record_3,num_subs_3*block_size,num_blocks);
acc_cat_mean_3 = mean(accuracy_record_3);
stdderr_cat_mean_3 = std(accuracy_record_3)/sqrt(num_subs_3);

dual_task_record_3(find(dual_task_record_3==999)) = 0;
dual_task_record_3 = reshape(dual_task_record_3,num_subs_3*block_size,num_blocks);
acc_dt_mean_3 = mean(dual_task_record_3);
stdderr_dt_mean_3 = std(dual_task_record_3)/sqrt(num_subs_3);

% cond 4
mean_late_ac_4 = mean(accuracy_record_4(:,201:300),2);
exlcude_rows_4 = find(mean_late_ac_4<exclusion_criteria_acc);
mean_dt_ac_4 = mean(dual_task_record_4(:,401:650),2);
exlcude_rows_4 = [exlcude_rows_4; find(mean_dt_ac_4<exclusion_criteria_dt)];
accuracy_record_4(exlcude_rows_4,:) = [];
dual_task_record_4(exlcude_rows_4,:) = [];
num_subs_4 = size(accuracy_record_4,1);

accuracy_record_4 = reshape(accuracy_record_4,num_subs_4*block_size,num_blocks);
acc_cat_mean_4 = mean(accuracy_record_4);
stdderr_cat_mean_4 = std(accuracy_record_4)/sqrt(num_subs_4);

dual_task_record_4(find(dual_task_record_4==999)) = 0;
dual_task_record_4 = reshape(dual_task_record_4,num_subs_4*block_size,num_blocks);
acc_dt_mean_4 = mean(dual_task_record_4);
stdderr_dt_mean_4 = std(dual_task_record_4)/sqrt(num_subs_4);

% cond 5
mean_late_ac_5 = mean(accuracy_record_5(:,201:300),2);
exlcude_rows_5 = find(mean_late_ac_5<exclusion_criteria_acc);
% mean_dt_ac_5 = mean(dual_task_record_5(:,251:351),2);
% exlcude_rows_5 = [exlcude_rows_5; find(mean_dt_ac_5<exclusion_criteria_dt)];
accuracy_record_5(exlcude_rows_5,:) = [];
dual_task_record_5(exlcude_rows_5,:) = [];
num_subs_5 = size(accuracy_record_5,1);

accuracy_record_5 = reshape(accuracy_record_5,num_subs_5*block_size,num_blocks);
acc_cat_mean_5 = mean(accuracy_record_5);
stdderr_cat_mean_5 = std(accuracy_record_5)/sqrt(num_subs_5);

dual_task_record_5(find(dual_task_record_5==999)) = 0;
dual_task_record_5 = reshape(dual_task_record_5,num_subs_5*block_size,num_blocks);
acc_dt_mean_5 = mean(dual_task_record_5);
stdderr_dt_mean_5 = std(dual_task_record_5)/sqrt(num_subs_1);

size(exlcude_rows_1)
size(exlcude_rows_2)
size(exlcude_rows_3)
size(exlcude_rows_4)
size(exlcude_rows_5)

if figures

    %% Overall phases and conditions

    figure, hold
    plot(1:num_blocks, acc_cat_mean_1, '-', 'LineWidth', 2, 'color', rgb('red'))
    plot(1:num_blocks, acc_cat_mean_2, '-', 'LineWidth', 2, 'color', rgb('orange'))
    plot(1:num_blocks, acc_cat_mean_3, '-', 'LineWidth', 2, 'color', rgb('green'))
    plot(1:num_blocks, acc_cat_mean_4, '-', 'LineWidth', 2, 'color', rgb('blue'))
    ciplot(acc_cat_mean_1-stdderr_cat_mean_1,acc_cat_mean_1+stdderr_cat_mean_1,1:num_blocks,rgb('red'))
    ciplot(acc_cat_mean_2-stdderr_cat_mean_2,acc_cat_mean_2+stdderr_cat_mean_2,1:num_blocks,rgb('orange'))
    ciplot(acc_cat_mean_3-stdderr_cat_mean_3,acc_cat_mean_3+stdderr_cat_mean_3,1:num_blocks,rgb('green'))
    ciplot(acc_cat_mean_4-stdderr_cat_mean_4,acc_cat_mean_4+stdderr_cat_mean_4,1:num_blocks,rgb('blue'))
    camlight; lighting none; 
    alpha(.5)
    axis([0 num_blocks+1 0.0 1])
    axis square
    set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
    legend({'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4'}, 'fontsize', 18, 'Location', 'North');
    legend boxoff
    plot([12,12],[0 1],'--k', 'LineWidth', 2)
    plot([28,28],[0 1],'--k', 'LineWidth', 2)
    
    figure, hold
    plot(1:num_blocks, acc_dt_mean_1, '-', 'LineWidth', 2, 'color', rgb('red'))
    plot(1:num_blocks, acc_dt_mean_2, '-', 'LineWidth', 2, 'color', rgb('orange'))
    plot(1:num_blocks, acc_dt_mean_3, '-', 'LineWidth', 2, 'color', rgb('green'))
    plot(1:num_blocks, acc_dt_mean_4, '-', 'LineWidth', 2, 'color', rgb('blue'))
    ciplot(acc_dt_mean_1-stdderr_dt_mean_1,acc_dt_mean_1+stdderr_dt_mean_1,1:num_blocks,rgb('red'))
    ciplot(acc_dt_mean_2-stdderr_dt_mean_2,acc_dt_mean_2+stdderr_dt_mean_2,1:num_blocks,rgb('orange'))
    ciplot(acc_dt_mean_3-stdderr_dt_mean_3,acc_dt_mean_3+stdderr_dt_mean_3,1:num_blocks,rgb('green'))
    ciplot(acc_dt_mean_4-stdderr_dt_mean_4,acc_dt_mean_4+stdderr_dt_mean_4,1:num_blocks,rgb('blue'))
    camlight; lighting none; 
    alpha(.5)
    axis([0 num_blocks+1 0.0 1])
    axis square
    set(gca,'XTick',2:2:num_blocks, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
    legend({'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4'}, 'fontsize', 18, 'Location', 'South');
    legend boxoff
    plot([12,12],[0 1],'--k', 'LineWidth', 2)
    plot([28,28],[0 1],'--k', 'LineWidth', 2)

    %% Between Condition

    % Acquisition
    figure, hold
    plot(1:12, acc_cat_mean_1(1:12), '-', 'LineWidth', 2, 'color', rgb('red'))
    plot(1:12, acc_cat_mean_2(1:12), '-', 'LineWidth', 2, 'color', rgb('orange'))
    plot(1:12, acc_cat_mean_3(1:12), '-', 'LineWidth', 2, 'color', rgb('green'))
    plot(1:12, acc_cat_mean_4(1:12), '-', 'LineWidth', 2, 'color', rgb('blue'))
    ciplot(acc_cat_mean_1(1:12)-stdderr_cat_mean_1(1:12),acc_cat_mean_1(1:12)+stdderr_cat_mean_1(1:12),1:12,rgb('red'))
    ciplot(acc_cat_mean_2(1:12)-stdderr_cat_mean_2(1:12),acc_cat_mean_2(1:12)+stdderr_cat_mean_2(1:12),1:12,rgb('orange'))
    ciplot(acc_cat_mean_3(1:12)-stdderr_cat_mean_3(1:12),acc_cat_mean_3(1:12)+stdderr_cat_mean_3(1:12),1:12,rgb('green'))
    ciplot(acc_cat_mean_4(1:12)-stdderr_cat_mean_4(1:12),acc_cat_mean_4(1:12)+stdderr_cat_mean_4(1:12),1:12,rgb('blue'))
    camlight; lighting none; 
    alpha(.5)
    axis([0 12+1 0.0 1])
    axis square
    set(gca,'XTick',1:1:12, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
    legend({'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4'}, 'fontsize', 18, 'Location', 'North');
    legend boxoff
    title('Acquisition', 'fontsize', 18)

    % Extinction 
    figure, hold
    plot(1:16, acc_cat_mean_1(13:28), '-', 'LineWidth', 2, 'color', rgb('red'))
    plot(1:16, acc_cat_mean_2(13:28), '-', 'LineWidth', 2, 'color', rgb('orange'))
    plot(1:16, acc_cat_mean_3(13:28), '-', 'LineWidth', 2, 'color', rgb('green'))
    plot(1:16, acc_cat_mean_4(13:28), '-', 'LineWidth', 2, 'color', rgb('blue'))
    ciplot(acc_cat_mean_1(13:28)-stdderr_cat_mean_1(13:28),acc_cat_mean_1(13:28)+stdderr_cat_mean_1(13:28),1:16,rgb('red'))
    ciplot(acc_cat_mean_2(13:28)-stdderr_cat_mean_2(13:28),acc_cat_mean_2(13:28)+stdderr_cat_mean_2(13:28),1:16,rgb('orange'))
    ciplot(acc_cat_mean_3(13:28)-stdderr_cat_mean_3(13:28),acc_cat_mean_3(13:28)+stdderr_cat_mean_3(13:28),1:16,rgb('green'))
    ciplot(acc_cat_mean_4(13:28)-stdderr_cat_mean_4(13:28),acc_cat_mean_4(13:28)+stdderr_cat_mean_4(13:28),1:16,rgb('blue'))
    camlight; lighting none; 
    alpha(.5)
    axis([0 16+1 0.0 1])
    axis square
    set(gca,'XTick',1:1:16, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
    legend({'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4'}, 'fontsize', 18, 'Location', 'North');
    legend boxoff
    title('Extinction', 'fontsize', 18)

    % Reacquisition 
    figure, hold
    plot(1:6, acc_cat_mean_1(29:34), '-', 'LineWidth', 2, 'color', rgb('red'))
    plot(1:6, acc_cat_mean_2(29:34), '-', 'LineWidth', 2, 'color', rgb('orange'))
    plot(1:6, acc_cat_mean_3(29:34), '-', 'LineWidth', 2, 'color', rgb('green'))
    plot(1:6, acc_cat_mean_4(29:34), '-', 'LineWidth', 2, 'color', rgb('blue'))
    ciplot(acc_cat_mean_1(29:34)-stdderr_cat_mean_1(29:34),acc_cat_mean_1(29:34)+stdderr_cat_mean_1(29:34),1:6,rgb('red'))
    ciplot(acc_cat_mean_2(29:34)-stdderr_cat_mean_2(29:34),acc_cat_mean_2(29:34)+stdderr_cat_mean_2(29:34),1:6,rgb('orange'))
    ciplot(acc_cat_mean_3(29:34)-stdderr_cat_mean_3(29:34),acc_cat_mean_3(29:34)+stdderr_cat_mean_3(29:34),1:6,rgb('green'))
    ciplot(acc_cat_mean_4(29:34)-stdderr_cat_mean_4(29:34),acc_cat_mean_4(29:34)+stdderr_cat_mean_4(29:34),1:6,rgb('blue'))
    camlight; lighting none; 
    alpha(.5)
    axis([0 6+1 0.0 1])
    axis square
    set(gca,'XTick',1:1:6, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
    legend({'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4'}, 'fontsize', 18, 'Location', 'North');
    legend boxoff
    title('Reacquisition', 'fontsize', 18)

    %% Within condition

    % Condition 1
    figure, hold
    plot(1:6, acc_cat_mean_1(1:6), '-', 'LineWidth', 2, 'color', rgb('red'))
    plot(1:6, acc_cat_mean_1(29:34), '-', 'LineWidth', 2, 'color', rgb('blue'))
    ciplot(acc_cat_mean_1(1:6)-stdderr_cat_mean_1(1:6),acc_cat_mean_1(1:6)+stdderr_cat_mean_1(1:6),1:6,rgb('red'))
    ciplot(acc_cat_mean_1(29:34)-stdderr_cat_mean_1(29:34),acc_cat_mean_1(29:34)+stdderr_cat_mean_1(29:34),1:6,rgb('blue'))
    camlight; lighting none; 
    alpha(.5)
    axis([0 6+1 0.0 1])
    axis square
    set(gca,'XTick',1:1:6, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
    legend({'Early Acquisition', 'Reacquisition'}, 'fontsize', 18, 'Location', 'North');
    legend boxoff
    title('Savings: Condition 1', 'fontsize', 18)

    % Condition 2
    figure, hold
    plot(1:6, acc_cat_mean_2(1:6), '-', 'LineWidth', 2, 'color', rgb('red'))
    plot(1:6, acc_cat_mean_2(29:34), '-', 'LineWidth', 2, 'color', rgb('blue'))
    ciplot(acc_cat_mean_2(1:6)-stdderr_cat_mean_2(1:6),acc_cat_mean_2(1:6)+stdderr_cat_mean_2(1:6),1:6,rgb('red'))
    ciplot(acc_cat_mean_2(29:34)-stdderr_cat_mean_2(29:34),acc_cat_mean_2(29:34)+stdderr_cat_mean_2(29:34),1:6,rgb('blue'))
    camlight; lighting none; 
    alpha(.5)
    axis([0 6+1 0.0 1])
    axis square
    set(gca,'XTick',1:1:6, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
    legend({'Early Acquisition', 'Reacquisition'}, 'fontsize', 18, 'Location', 'North');
    legend boxoff
    title('Savings: Condition 2', 'fontsize', 18)

    % Condition 3
    figure, hold
    plot(1:6, acc_cat_mean_3(1:6), '-', 'LineWidth', 2, 'color', rgb('red'))
    plot(1:6, acc_cat_mean_3(29:34), '-', 'LineWidth', 2, 'color', rgb('blue'))
    ciplot(acc_cat_mean_3(1:6)-stdderr_cat_mean_3(1:6),acc_cat_mean_3(1:6)+stdderr_cat_mean_3(1:6),1:6,rgb('red'))
    ciplot(acc_cat_mean_3(29:34)-stdderr_cat_mean_3(29:34),acc_cat_mean_3(29:34)+stdderr_cat_mean_3(29:34),1:6,rgb('blue'))
    camlight; lighting none; 
    alpha(.5)
    axis([0 6+1 0.0 1])
    axis square
    set(gca,'XTick',1:1:6, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
    legend({'Early Acquisition', 'Reacquisition'}, 'fontsize', 18, 'Location', 'North');
    legend boxoff
    title('Savings: Condition 3', 'fontsize', 18)

    % Condition 4
    figure, hold
    plot(1:6, acc_cat_mean_4(1:6), '-', 'LineWidth', 2, 'color', rgb('red'))
    plot(1:6, acc_cat_mean_4(29:34), '-', 'LineWidth', 2, 'color', rgb('blue'))
    ciplot(acc_cat_mean_4(1:6)-stdderr_cat_mean_4(1:6),acc_cat_mean_4(1:6)+stdderr_cat_mean_4(1:6),1:6,rgb('red'))
    ciplot(acc_cat_mean_4(29:34)-stdderr_cat_mean_4(29:34),acc_cat_mean_4(29:34)+stdderr_cat_mean_4(29:34),1:6,rgb('blue'))
    camlight; lighting none; 
    alpha(.5)
    axis([0 6+1 0.0 1])
    axis square
    set(gca,'XTick',1:1:6, 'fontsize', 10, 'fontweight', 'b')
    xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
    ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
    legend({'Early Acquisition', 'Reacquisition'}, 'fontsize', 18, 'Location', 'North');
    legend boxoff
    title('Savings: Condition 4', 'fontsize', 18)

end

%%
if files
    
    fid_all = fopen('anova_all','w');
    fprintf(fid_all, 'condition phase block subject accuracy\n');
    fprintf(fid_all,'%f %f %f %f %f\n',[anova_AAA; anova_ABA; anova_AAB; anova_ABC;]');
    fclose(fid_all)
    
    fid_all = fopen('anova_ac','w');
    fprintf(fid_all, 'condition phase block subject accuracy\n');
    fprintf(fid_all,'%f %f %f %f %f\n',[anova_AAA_ac; anova_ABA_ac; anova_AAB_ac; anova_ABC_ac;]');
    fclose(fid_all)
    
    fid_all = fopen('anova_ext','w');
    fprintf(fid_all, 'condition phase block subject accuracy\n');
    fprintf(fid_all,'%f %f %f %f %f\n',[anova_AAA_ext; anova_ABA_ext; anova_AAB_ext; anova_ABC_ext;]');
    fclose(fid_all)
    
    fid_all = fopen('anova_reac','w');
    fprintf(fid_all, 'condition phase block subject accuracy\n');
    fprintf(fid_all,'%f %f %f %f %f\n',[anova_AAA_reac; anova_ABA_reac; anova_AAB_reac; anova_ABC_reac;]');
    fclose(fid_all)

    fid_AAA = fopen('AAA_anova','w');
    fid_ABA = fopen('ABA_anova','w');
    fid_AAB = fopen('AAB_anova','w');
    fid_ABC = fopen('ABC_anova','w');
    fprintf(fid_AAA, 'condition phase block subject accuracy\n');
    fprintf(fid_ABA, 'condition phase block subject accuracy\n');
    fprintf(fid_AAB, 'condition phase block subject accuracy\n');
    fprintf(fid_ABC, 'condition phase block subject accuracy\n');
    fprintf(fid_AAA,'%f %f %f %f %f\n',anova_AAA');
    fprintf(fid_ABA,'%f %f %f %f %f\n',anova_ABA');
    fprintf(fid_AAB,'%f %f %f %f %f\n',anova_AAB');
    fprintf(fid_ABC,'%f %f %f %f %f\n',anova_ABC');
    fclose(fid_AAA)
    fclose(fid_ABA)
    fclose(fid_AAB)
    fclose(fid_ABC)

    anova_savings_AAA = [anova_AAA_ac(:,1:end-1) anova_AAA_reac(:,end)-anova_AAA_ac(:,end)];
    anova_savings_ABA = [anova_ABA_ac(:,1:end-1) anova_ABA_reac(:,end)-anova_ABA_ac(:,end)];
    anova_savings_AAB = [anova_AAB_ac(:,1:end-1) anova_AAB_reac(:,end)-anova_AAB_ac(:,end)];
    anova_savings_ABC = [anova_ABC_ac(:,1:end-1) anova_ABC_reac(:,end)-anova_ABC_ac(:,end)];

    fid_all = fopen('anova_savings_all_blocks','w');
    fprintf(fid_all, 'condition phase block subject accuracy\n');
    fprintf(fid_all,'%f %f %f %f %f\n',[anova_savings_AAA; anova_savings_ABA; anova_savings_AAB; anova_savings_ABC;]');
    fclose(fid_all);

    block_ac = anova_AAA_ac(:,3);
    block_reac = anova_AAA_reac(:,3);
    ac_ind = find(block_ac < 7);
    reac_ind = find(block_reac > 24 & block_reac < 31);
    anova_savings_AAA = [anova_AAA_ac(ac_ind,1:end-1) anova_AAA_reac(reac_ind,end)-anova_AAA_ac(ac_ind,end)];

    block_ac = anova_ABA_ac(:,3);
    block_reac = anova_ABA_reac(:,3);
    ac_ind = find(block_ac < 7);
    reac_ind = find(block_reac > 24 & block_reac < 31);
    anova_savings_ABA = [anova_ABA_ac(ac_ind,1:end-1) anova_ABA_reac(reac_ind,end)-anova_ABA_ac(ac_ind,end)];

    block_ac = anova_AAB_ac(:,3);
    block_reac = anova_AAB_reac(:,3);
    ac_ind = find(block_ac < 7);
    reac_ind = find(block_reac > 24 & block_reac < 31);
    anova_savings_AAB = [anova_AAB_ac(ac_ind,1:end-1) anova_AAB_reac(reac_ind,end)-anova_AAB_ac(ac_ind,end)];

    block_ac = anova_ABC_ac(:,3);
    block_reac = anova_ABC_reac(:,3);
    ac_ind = find(block_ac < 7);
    reac_ind = find(block_reac > 24 & block_reac < 31);
    anova_savings_ABC = [anova_ABC_ac(ac_ind,1:end-1) anova_ABC_reac(reac_ind,end)-anova_ABC_ac(ac_ind,end)];

    fid_all = fopen('anova_savings_partial_blocks','w');
    fprintf(fid_all, 'condition phase block subject accuracy\n');
    fprintf(fid_all,'%f %f %f %f %f\n',[anova_savings_AAA; anova_savings_ABA; anova_savings_AAB; anova_savings_ABC;]');
    fclose(fid_all);

end