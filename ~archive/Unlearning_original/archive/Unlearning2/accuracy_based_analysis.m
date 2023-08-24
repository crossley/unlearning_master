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

        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
end

% num_subs = size(sub_num,2);
% figure
% for i = 1:num_subs
%     subplot(ceil(sqrt(num_subs)),ceil(sqrt(num_subs)),i)
%     plot(sub_accuracy(i,:))
%     axis([0 37 0 1])
%     
% end

num_subs = size(sub_num,2);
figure
for i = 1:num_subs
    subplot(ceil(sqrt(num_subs)),ceil(sqrt(num_subs)),i),hold
    plot(sub_accuracy(i,1:12),'-b')
    plot(sub_accuracy(i,25:36), '-g')
    axis([0 13 0 1])
    
end

SPSS = [ones(size(SPSS),1) SPSS];

accuracy_record1 = accuracy_record;
learning_curve1 = learning_curve;
std_err_curve1 = std_err_curve;
SPSS1 = SPSS;
sub_accuracy1 = sub_accuracy;

%% Random feedback extinction - Meta-Learning Control

accuracy_record = [];
sub_num = [1:5 7:11 13:20];
sub_num_glc = [];
sub_num_notglc = setdiff(sub_num,sub_num_glc);

% sub_num = sub_num_glc;

for i = sub_num
    
   load_cmd = ['load ext6_' num2str(i) '.txt;'];
   eval(load_cmd)
   
   def_cmd = ['data = ext6_' num2str(i) ';'];
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

        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
end

SPSS = [ones(size(SPSS),1) SPSS];

accuracy_record2 = accuracy_record;
learning_curve2 = learning_curve;
std_err_curve2 = std_err_curve;
SPSS2 = SPSS;
sub_accuracy2 = sub_accuracy;

%% Unlearning 75 rand 25 true blocked

accuracy_record = [];
sub_num = [1 2 4:18 20 21 23 25:30];

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

        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
end

% num_subs = size(sub_num,2);
% figure
% for i = 1:num_subs
%     subplot(ceil(sqrt(num_subs)),ceil(sqrt(num_subs)),i)
%     plot(sub_accuracy(i,:))
%     axis([0 37 0 1])
%     
% end

% num_subs = size(sub_num,2);
% figure
% for i = 1:num_subs
%     subplot(ceil(sqrt(num_subs)),ceil(sqrt(num_subs)),i),hold
%     plot(sub_accuracy(i,1:12),'-b')
%     plot(sub_accuracy(i,25:36), '-g')
%     axis([0 13 0 1])
%     
% end

SPSS = [3*ones(size(SPSS),1) SPSS];

accuracy_record3 = accuracy_record;
learning_curve3 = learning_curve;
std_err_curve3 = std_err_curve;
SPSS3 = SPSS;
sub_accuracy3 = sub_accuracy;

%% Unlearning 75 random 25 true blocked meta-learning control

accuracy_record = [];
sub_num = [1:11 13 14 16 18 19 20 23 25 26:30];

% sub_num = sub_num_glc;

for i = sub_num
    
   load_cmd = ['load unl7m' num2str(i) '.dat;'];
   eval(load_cmd)
   
   def_cmd = ['data = unl7m' num2str(i) ';'];
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

SPSS = [4*ones(size(SPSS),1) SPSS];

accuracy_record4 = accuracy_record;
learning_curve4 = learning_curve;
std_err_curve4 = std_err_curve;
SPSS4 = SPSS;
sub_accuracy4 = sub_accuracy;

%% 25% Random

accuracy_record = [];
sub_num = [11:13 15:17 19 110 111 113 115:118];

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

        learning_curve(i) = mean(mean(accuracy_record(:,start:stop),2));
        std_err_curve(i) = std(mean(accuracy_record(:,start:stop),2))/sqrt(prod(size(mean(accuracy_record(:,start:stop),2))));
        
end

SPSS = [5*ones(size(SPSS),1) SPSS];

accuracy_record5 = accuracy_record;
learning_curve5 = learning_curve;
std_err_curve5 = std_err_curve;
SPSS5 = SPSS;
sub_accuracy5 = sub_accuracy;

%% 75% random 25% true randomly intermixed

accuracy_record = [];
sub_num = [1 4:23 25:27 29:32];

% sub_num = sub_num_glc;

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

% num_subs = size(sub_num,2);
% figure
% for i = 1:num_subs
%     subplot(ceil(sqrt(num_subs)),ceil(sqrt(num_subs)),i),hold
%     plot(sub_accuracy(i,1:12),'-b')
%     plot(sub_accuracy(i,25:36), '-g')
%     axis([0 13 0 1])
%     
% end

SPSS = [6*ones(size(SPSS),1) SPSS];

accuracy_record6 = accuracy_record;
learning_curve6 = learning_curve;
std_err_curve6 = std_err_curve;
SPSS6 = SPSS;
sub_accuracy6 = sub_accuracy;

%%

% % % Random Feedback Extinction = 1
% % % Random Feedback Extinction Meta Learning Control = 2
% % % 75 random 25 true blocked = 3
% % % 75 random 25 true blocked Meta Learning Control = 4
% % % 25 Random = 5
% % % 75 random 25 true random intermixed = 6

% figure
% 
% subplot(1,3,1),hold
% errorbar(1:36, learning_curve1(1:36), std_err_curve1(1:36), std_err_curve1(1:36), '-b', 'LineWidth', 2)
% errorbar(1:36, learning_curve2(1:36), std_err_curve2(1:36), std_err_curve2(1:36), '-g', 'LineWidth', 2)
% axis([0 36+1 0.0 1])
% axis square
% set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
% legend('Random','Random Meta')
% xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% 
% subplot(1,3,2),hold
% errorbar(1:12, learning_curve1(1:12), std_err_curve1(1:12), std_err_curve1(1:12), '-b', 'LineWidth', 2)
% errorbar(1:12, learning_curve1(25:36), std_err_curve1(25:36), std_err_curve1(25:36), '-g', 'LineWidth', 2)
% axis([0 12+1 0.0 1])
% axis square
% set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% legend('Random Acquisition','Random Reacquisition')
% xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% 
% subplot(1,3,3),hold
% errorbar(1:12, learning_curve2(1:12), std_err_curve2(1:12), std_err_curve2(1:12), '-b', 'LineWidth', 2)
% errorbar(1:12, learning_curve2(25:36), std_err_curve2(25:36), std_err_curve2(25:36), '-g', 'LineWidth', 2)
% axis([0 12+1 0.0 1])
% axis square
% set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% legend('Meta Acquisition','Meta Reacquisition')
% xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')

%%

% % % Random Feedback Extinction = 1
% % % Random Feedback Extinction Meta Learning Control = 2
% % % 75 random 25 true blocked = 3
% % % 75 random 25 true blocked Meta Learning Control = 4
% % % 25 Random = 5
% % % 75 random 25 true random intermixed = 6

% figure
% 
% subplot(1,3,1),hold
% errorbar(1:36, learning_curve3(1:36), std_err_curve3(1:36), std_err_curve3(1:36), '-b', 'LineWidth', 2)
% errorbar(1:36, learning_curve4(1:36), std_err_curve4(1:36), std_err_curve4(1:36), '-g', 'LineWidth', 2)
% axis([0 36+1 0.0 1])
% axis square
% set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
% legend('75 Random 25 True Blocked','75 Random 25 True Blocked Meta')
% xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% 
% subplot(1,3,2),hold
% errorbar(1:12, learning_curve3(1:12), std_err_curve3(1:12), std_err_curve3(1:12), '-b', 'LineWidth', 2)
% errorbar(1:12, learning_curve3(25:36), std_err_curve3(25:36), std_err_curve3(25:36), '-g', 'LineWidth', 2)
% axis([0 12+1 0.0 1])
% axis square
% set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% legend('Random Acquisition','Random Reacquisition')
% xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% 
% subplot(1,3,3),hold
% errorbar(1:12, learning_curve4(1:12), std_err_curve4(1:12), std_err_curve4(1:12), '-b', 'LineWidth', 2)
% errorbar(1:12, learning_curve4(25:36), std_err_curve4(25:36), std_err_curve4(25:36), '-g', 'LineWidth', 2)
% axis([0 12+1 0.0 1])
% axis square
% set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% legend('Meta Acquisition','Meta Reacquisition')
% xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')

%%

% figure

% % % Random Feedback Extinction = 1
% % % Random Feedback Extinction Meta Learning Control = 2
% % % 75 random 25 true blocked = 3
% % % 75 random 25 true blocked Meta Learning Control = 4
% % % 25 Random = 5
% % % 75 random 25 true random intermixed = 6

% subplot(1,3,1),hold
% errorbar(1:36, learning_curve6(1:36), std_err_curve6(1:36), std_err_curve6(1:36), '-b', 'LineWidth', 2)
% errorbar(1:36, learning_curve5(1:36), std_err_curve5(1:36), std_err_curve5(1:36), '-g', 'LineWidth', 2)
% axis([0 36+1 0.0 1])
% axis square
% set(gca,'XTick',2:2:36, 'fontsize', 10, 'fontweight', 'b')
% legend('75 Random 25 True Intermixed','25 Random???')
% xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% 
% subplot(1,3,2),hold
% errorbar(1:12, learning_curve6(1:12), std_err_curve6(1:12), std_err_curve6(1:12), '-b', 'LineWidth', 2)
% errorbar(1:12, learning_curve6(25:36), std_err_curve6(25:36), std_err_curve6(25:36), '-g', 'LineWidth', 2)
% axis([0 12+1 0.0 1])
% axis square
% set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% legend('Random Acquisition','Random Reacquisition')
% xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')
% 
% subplot(1,3,3),hold
% errorbar(1:12, learning_curve5(1:12), std_err_curve5(1:12), std_err_curve5(1:12), '-b', 'LineWidth', 2)
% errorbar(1:12, learning_curve5(25:36), std_err_curve5(25:36), std_err_curve5(25:36), '-g', 'LineWidth', 2)
% axis([0 12+1 0.0 1])
% axis square
% set(gca,'XTick',1:12, 'fontsize', 10, 'fontweight', 'b')
% legend('?? Acquisition','?? Reacquisition')
% xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
% ylabel('Proportion Correct', 'fontsize', 18, 'fontweight', 'b')