function [data] = Unlearning4b_5(debug,condNum)

%Debug initialization or not.  Start up code(Unl6.m) decides this already.
if debug==1;speedup=1/100;else speedup=1;end % Speed up delays if in debug mode
% debug=0;
% Specify color values
white = [255 255 255];
% gray = [128 128 128];
black = [0 0 0];
backcolor = black;
textcolor = white;
red = [255 0 0];
green = [0 255 0];


% Open window if window doesn't exist
if ~exist('window','var')
    [window, screenRect] = Screen(0,'OpenWindow');
    HideCursor;
end

% Define center of screen
rect = screenRect;
Xorigin = (rect(3)-rect(1))/2;
Yorigin = (rect(4)-rect(2))/2;
leftTextOrigin = (Xorigin+rect(1))/2;
rightTextOrigin = (Xorigin+rect(3))/2;

%Set up the numbers for the WM task
% bigNum
bigNums=(6:9);
smallNums=(2:5);
sides=[leftTextOrigin,rightTextOrigin];


Screen(window,'TextFont','Verdana'); % Set text font
Screen(window,'FillRect', black); % Fill background with backcolor (black)

% Load stimuli
% stimRaw = dlmread('unlearning2_stims_ii.txt');
stimRaw= xlsread('stims.xlsx');
randStim= xlsread('randStims.xlsx');
randStim=shuffle(randStim);
% wmRandSheet=xlsread('wmRandSheet');

%Generate the amount of WM trials for each condition as well as the
%randomization of the "flip" section.  Also generate the random order of
%value vs size task orders.
wmSpans=100;  %For Condition 5, there are no WM trials => control condition
wmTrial=851; %
for i=1:ceil(wmSpans*.85)
    sizeflip(i,1)=0;
end
for i=ceil(1+wmSpans*.85):wmSpans
    sizeflip(i,1)=1;
end

sizeflip=shuffle(sizeflip);

for i=1:ceil(wmSpans*.5)
    dimOrder(i,1)=1; %WM task is by value
end
for i=ceil(1+wmSpans*.5):wmSpans
    dimOrder(i,1)=2;
end

dimOrder=shuffle(dimOrder);
wmt=1;    
meanWM=0;
    
    

% randStim= xlsread('2catRandstim.xlsx');
% randStim=shuffle(randStim);

%Because the stimuli have 4 columns (cat, x, y, circleCat), we need to randomize
%numbers and then finally have those random numbers be called for making
%the stimuli blocks.
    %This bit separates the stimuli by categories 1=1:225, etc.. AND also
    %shuffles the list, so that we now have a random order of those
    %categories by stimulus.  So in the next step, when we grab the first
    %25 stimuli from l1 (category 1), they arent stim 1, stim 2, etc.. they
    %are randomly drawn from the original list.
    l1=shuffle(1:225);
    l2=shuffle(226:450);
    l3=shuffle(451:675);
    l4=shuffle(676:900);
    
    
    %Rather than adjusting numbers lower down for the 850 stimuli, I just
    %added this bit here so that we have an even mix of the 4 categories in
    %the 50 trial long block 9.
    block91=shuffle(l1(201:225));
    block91=block91(1:13);
    block92=shuffle(l2(201:225));
    practiceblock(1)=block92(14);
    block92=block92(1:13);
    block93=shuffle(l3(201:225));
    block93=block93(1:13);
    block94=shuffle(l4(201:225));
    practiceblock(2)=block94(14);
    block94=block94(1:13);
    
    %Set up practice block
    for i=1:2
        practiceStim(i,1)=stimRaw(practiceblock(i),1);
        practiceStim(i,2)=stimRaw(practiceblock(i),2);
        practiceStim(i,3)=stimRaw(practiceblock(i),3);
    end
    
    %Here, we draw 25 stimuli from each category, so we have a random 25
    %stimuli per category in each block.  The shuffle command then mixes
    %these up so that they will be randomly presented to the participant.
    preArray1=shuffle([l1(1:25), l2(1:25), l3(1:25), l4(1:25)]);
    preArray2=shuffle([l1(26:50), l2(26:50), l3(26:50), l4(26:50)]);
    preArray3=shuffle([l1(51:75), l2(51:75), l3(51:75), l4(51:75)]);
    preArray4=shuffle([l1(76:100), l2(76:100), l3(76:100), l4(76:100)]);
    preArray5=shuffle([l1(101:125), l2(101:125), l3(101:125), l4(101:125)]);
    preArray6=shuffle([l1(126:150), l2(126:150), l3(126:150), l4(126:150)]);
    preArray7=shuffle([l1(151:175), l2(151:175), l3(151:175), l4(151:175)]);
    preArray8=shuffle([l1(176:200), l2(176:200), l3(176:200), l4(176:200)]);
    preArray9=shuffle([block91, block92, block93, block94]);
    
    %Finally, we must turn these numbered lists we generated into the
    %actual stimuli, so the new block(n) lists are created so that column 1
    %is correct category, 2 is length, and 3 is orientation.
    for i=1:100
        %Category Grab
        block1(i,1)=stimRaw(preArray1(i),1);
        block2(i,1)=stimRaw(preArray2(i),1);
        block3(i,1)=stimRaw(preArray3(i),1);
        block4(i,1)=stimRaw(preArray4(i),1);
        block5(i,1)=stimRaw(preArray5(i),1);
        block6(i,1)=stimRaw(preArray6(i),1);
        block7(i,1)=stimRaw(preArray7(i),1);
        block8(i,1)=stimRaw(preArray8(i),1);
        
        %X-values
        block1(i,2)=stimRaw(preArray1(i),2);
        block2(i,2)=stimRaw(preArray2(i),2);
        block3(i,2)=stimRaw(preArray3(i),2);
        block4(i,2)=stimRaw(preArray4(i),2);
        block5(i,2)=stimRaw(preArray5(i),2);
        block6(i,2)=stimRaw(preArray6(i),2);
        block7(i,2)=stimRaw(preArray7(i),2);
        block8(i,2)=stimRaw(preArray8(i),2);
        
        %Y-values
        block1(i,3)=stimRaw(preArray1(i),3);
        block2(i,3)=stimRaw(preArray2(i),3);
        block3(i,3)=stimRaw(preArray3(i),3);
        block4(i,3)=stimRaw(preArray4(i),3);
        block5(i,3)=stimRaw(preArray5(i),3);
        block6(i,3)=stimRaw(preArray6(i),3);
        block7(i,3)=stimRaw(preArray7(i),3);
        block8(i,3)=stimRaw(preArray8(i),3);
        
        %Intervention-Categories
%         block1(i,4)=stimRaw(preArray1(i),4);
%         block2(i,4)=stimRaw(preArray2(i),4);
%         block3(i,4)=stimRaw(preArray3(i),4);
%         block4(i,4)=stimRaw(preArray4(i),4);
%         block5(i,4)=stimRaw(preArray5(i),4);
%         block6(i,4)=stimRaw(preArray6(i),4);
%         block7(i,4)=stimRaw(preArray7(i),4);
%         block8(i,4)=stimRaw(preArray8(i),4);
        
    end
    
    for i=1:50
        block9(i,1)=stimRaw(preArray9(i),1);
        block9(i,2)=stimRaw(preArray9(i),2);
        block9(i,3)=stimRaw(preArray9(i),3);
%         block9(i,4)=stimRaw(preArray9(i),4);
    end
    
    %Finally recombine into one massive stimulus list.
    stim=[block1;block2;block3;block4;block5;block6;block7;block8;block9];
    
        %Begin experiment phase
% blockN=1;
trialNum=1;
blockLength=100;

for blockN=1:9
    if blockN==1
        feedbackType=1;
        instructions = { ...
            '',...
            'Welcome to our categorization experiment. On each trial of the experiment you ',...
            'will be presented with a single line that has some fixed length and orientation.',...
            'You will be asked to categorize that line into either category 1, 2, 3 or 4.',...
            'At first you will just be guessing but the computer will give you feedback telling',...
            'you whether you are correct or wrong. As the task progresses your accuracy will',...
            'likely increase. The response keys for this task are shown below. If you feel',...
            'the line is in category 1 press the “w” key. If you feel the line is in category 2',...
            'press the “z” key. If you feel the line is in category 3 press the “i” key. If you',...
            'feel the line is in category 4 press then “/?” key.',...
            '', ...
            'Press the space bar to continue'};
        
            %display block instructions
            cenTex(instructions,window,screenRect,white,black,18) % Print text centered
            if debug~=1;getResp('space');end; % Wait for user to press 'space bar'; % Wait for user to press 'space bar'    
%             getResp('space');
            cenTex({'+'},window,screenRect,white,black,32) % Display fixation cross
            
            
            
            %Insert working memory instructions here.  Also give an example
            %of a working memory trial.
        instructions = {...
            'At some point during the experiment we will ask you to do something different.',...
            'We will continue to ask you to categorize lines but we will also ask you to',...
            'remember two numbers. On this page, you will notice the two numbers on either',...
            'size of the line. This is the paired numbers task. In this example, one of the',...
            'numbers is larger in "size" and the other is large in "value." After a brief',...
            'moment, the paired numbers will disappear.',...
            '',...
            'Let''s pretend this is a real trial.  Please categorize the line at the top of the screen by',...
            'pressing ''w'',''z'',''?/'', or ''i'''};

%             'For now, press space to continue'};
            %display block instructions
            cenTex(instructions,window,screenRect,white,black,18) % Print text centered
            Screen(window,'TextSize', 64);
            Screen(window,'DrawText', '2',leftTextOrigin-100,Yorigin,textcolor);
            Screen(window,'TextSize', 32);
            Screen(window,'DrawText', '6',rightTextOrigin+100,Yorigin,textcolor);
            
            %Generate the one practice trial.
            pracStimN=preArray9(51);
            % Get stimulus value and category
            stimLength = stimRaw(pracStimN,2);
            stimOrient = stimRaw(pracStimN,3);
            stimCat = stimRaw(pracStimN,1);
            stimTheta = stimOrient * pi / 600;
    %         originalCat= stim(trialNum,5);


            % Draw stimulus
            X1 = Xorigin + (.5 * stimLength * cos(stimTheta));
            Y1 = Yorigin + (.5 * stimLength * sin(stimTheta));
            X2 = Xorigin - (.5 * stimLength * cos(stimTheta));
            Y2 = Yorigin - (.5 * stimLength * sin(stimTheta));
            
            SCREEN(window,'DrawLine',white,X1,Y1/4,X2,Y2/4);
            
            
            if debug~=1;[rawResp, rt] = getResp('z','w','i','/?');else rawResp=randi(2)-1;rt=2*rand(1);end
            
            
            
            
            if rawResp+1==stimCat
                cenTex({'Correct!'}, window,screenRect,white,black,32);
            else
                cenTex({'Incorrect.'}, window,screenRect,white,black,32);
            end
            pause(1*speedup);
%             getResp('space');
%             cenTex({'+'},window,screenRect,white,black,32) % Display fixation cross

            

        instructions = {...
            'After the feedback display for the categorization task, you will be asked to',...
            'respond to either the number that was of a larger "size" or of a larger "value."',...
            'The "F" key corresponds to the number on the left and the "J" key corresponds',...
            'with the number on the right. Go ahead and respond to which number was of the',...
            'larger "size", if you can remember it.  If not, just guess!'};
            cenTex(instructions,window,screenRect,white,black,18) % Print text centered
            if debug~=1;getResp('f','j');end; % Wait for user to press 'space bar'; % Wait for user to press 'space bar'    


        instructions = {...
            'After your response to the paired numbers query, you will be given feedback.',...
            'You will see either "correct" or "wrong" depending on the accuracy of your',...
            'response. Keep in mind the paired numbers task will only be present during one',...
            'specific part of the study. We will tell you before we introduce this second task.',...
            '',...
            'Please remember,',...
            'during the trials where you see both a line and numbers,',...
            'that you respond by selecting a line category first and then will be asked to',...
            'identify which side the larger size/value number was on.',...
            '',...
            'Press spacebar to continue.'};
        
            cenTex(instructions,window,screenRect,white,black,18) % Print text centered
            if debug~=1;getResp('space');end; % Wait for user to press 'space bar'; % Wait for user to press 'space bar'    

%         instructions = {...
%             'You will now do a couple of practice trials for this task. Remember that the response keys for the',...
%             'categorization task are w,z,p and /? and the response keys for the paired numbers',...
%             'task are “f” and “j”. You should try your hardest on both parts of the experiment',...
%             'but the paired number task should take priority. At first your accuracy will be',...
%             'poor but it will improve as you continue the study. If you have any questions',...
%             'please ask the experimenter now.',...
%             '',...
%             'Please press spacebar to continue.'};
%         
%             cenTex(instructions,window,screenRect,white,black,18) % Print text centered
%             if debug~=1;getResp('space');end; % Wait for user to press 'space bar'; % Wait for user to press 'space bar'    
%             
%             for pri=1:2
%             
%                 %Begin practice trial
%                 pause(.5*speedup);
%                 % Get stimulus value and category
%                 stimLength = practiceStim(trialNum,2);
%                 stimOrient = practiceStim(trialNum,3);
%                 stimCat = practiceStim(trialNum,1);
%                 stimTheta = stimOrient * pi / 600;
% %                 originalCat= rpacticeStim(trialNum,5);
% 
%                 %Probably a way over complicated way of randomly grabbing a
%                 %number to use for the WM task on each trial and then
%                 %making sure that the bigger in value is smaller in size
%                 %85% of the time (although that is irrelevant for this
%                 %section (sizeflip=0).  And then we randomize which side
%                 %each number will be presented on by shuffling sides which
%                 %is made of leftorigin and right origin.
%                 num1=randSample(bigNums);
%                 num2=randSample(smallNums);
% %                 sizeflip=0;
%                 if sizeflip==0
%                     bigN=num2;
%                     lilN=num1;
%                 else
%                     bigN=num1;
%                     lilN=num2;
%                 end
%                 side=shuffle(sides);
%                 
%                 % Draw stimulus
%                 X1 = Xorigin + (.5 * stimLength * cos(stimTheta));
%                 Y1 = Yorigin + (.5 * stimLength * sin(stimTheta));
%                 X2 = Xorigin - (.5 * stimLength * cos(stimTheta));
%                 Y2 = Yorigin - (.5 * stimLength * sin(stimTheta));
%                 
%                 Screen(window,'FillRect',black);
%                 Screen(window,'DrawLine',white,X1,Y1,X2,Y2);
% %                 Screen(window,'DrawLine',[0 0 0],1,1,2,2);
%                 
%                 Screen(window,'TextSize', 32);
%                 Screen(window,'DrawText', num2str(lilN),side(1),Yorigin,textcolor);
%                 Screen(window,'TextSize', 64);
%                 Screen(window,'DrawText', num2str(bigN),side(2),Yorigin,textcolor);
%                 
% %                 crLilN=side(1);
% %                 crBigN=side(2);
% %                 valCR=side(1);
%                 
%                 if sizeflip==1
%                     sizeCR=side(1);
%                     valCR=side(2);
%                 else
%                     sizeCR=side(2);
%                     valCR=side(1);
%                 end
%                 
%                 
%                 pause(.2*speedup);
%                 %Technically this clears the whole screen and then draws
%                 %the line again. It is the easiest method and I am lazy
%                 %right now.  Sorry.
%                 Screen(window,'FillRect',backcolor);
%                 Screen(window,'DrawLine',textcolor,X1,Y1,X2,Y2);
% 
%                 %Collect stimulus category (correct response) information based off
%                 %of categories
%                 corrResp=stimCat;
%                 %Collect Subject Response
%             %     [rawResp, rt] = getResp('Z','W','/?','I');
%                 if debug~=1;[rawResp, rt] = getResp('z','w','/?','i');else rawResp=randi(2)-1;rt=2*rand(1);end
%                 resp=rawResp+1;
%                 %Clear screen following response
%                 Screen(window,'FillRect',black);
%                 
%                 if resp==corrResp
% %                 accuracy=1;
% %                 feedgiven=1;
%                     cenTex({'Correct'},window,screenRect,white,black,32)
%                 else
% %                 accuracy=0;
% %                 feedgiven=0;
%                     cenTex({'Incorrect'},window,screenRect,white,black,32)
%                 end
%                 pause(1*speedup);
%                 Screen(window,'FillRect',black);
% %                 pause(.5);
%                 if pri==1
%                     cenTex({'Value?'},window,screenRect,white,black,32)
%                     crWM=2;
%                 else
%                     crWM=1;
%                     cenTex({'Size?'},window,screenRect,white,black,32)
%                 end
% % 
% %                 [stRawResp, stRT] = getResp('f','j');
%                 if debug~=1; [stRawResp, stRT] = getResp('f','j'); else stRawResp=randi(2)-1;stRT=2*rand(1);end
%                 stResp=sides(stRawResp+1);
% 
%                 Screen(window,'FillRect',backcolor);
%                 if crWM==1
%                     if stResp==sizeCR
%                         %Correct
%                         pwmAcc(pri,1)=1;
%                         cenTex({'Correct'},window,screenRect,white,black,32)
%                     else
%                         %Incorrect
%                         pwmAcc(pri,1)=0;
%                         cenTex({'Incorrect'},window,screenRect,white,black,32)
%                     end
%                 else
%                     if stResp==valCR
%                         %Correct
%                         pwmAcc(pri,1)=1;
%                         cenTex({'Correct'},window,screenRect,white,black,32)
%                     else
%                         %Incorrect
%                         pwmAcc(pri,1)=0;
%                         cenTex({'Incorrect'},window,screenRect,white,black,32)
%                     end                   
%                 end
% %                 pause(1);
%                     
%                 pmeanWM=mean(pwmAcc(:,1));
%                 if pmeanWM<.8
%                     pwmMess=red;
%                 else
%                     pwmMess=green;
%                 end
%                 
%                 wmAcctext=['You have answered ' num2str(pmeanWM*100) '% correctly.'];
%                 Screen(window, 'DrawText', wmAcctext, Xorigin-length(wmAcctext)/2.*32/2, 100, pwmMess);
%                 pause(1*speedup);
%                 Screen(window,'FillRect',backcolor);
%             end
%             clear pwmAcc
            instructions = {...
            'Great!  You are now ready to proceed to the experiment.',...
            'Please remember, you categorize the lines into either categories',...
            '',...
            '1 by pressing "w"',...
            '2 by pressing "z"',...
            '3 by pressing "i"',...
            '4 by pressing "/?"',...
            '',...
            'When you are asked to make decisions based on the numbers, please remember',...
            'Press "f" to indicate the number on the left side of the screen',...
            'and press "j" to indicate the number on the right side of the screen',...
            '',...
            'Press space when you are ready to begin the experiment!'
            };
        
            cenTex(instructions,window,screenRect,white,black,18) % Print text centered
            if debug~=1;getResp('space');end; % Wait for user to press 'space bar'; % Wait for user to press 'space bar'    

            pause(2*speedup);
            
    elseif blockN>=4 && blockN<=7
         %Type of feedback (0=random, 1=veridical) Conditions 1 has 400 random
            %trials during intervention
         feedbackType=0;  
%          instructions = { ...
%             '', ...
%             'You are doing great. Please continue with the experiment', ...
%             '', ...
%             '', ...
%             'Press the space bar to continue'};
            instructions = { ...
            ' ', ...
            'You are doing great. Thank you for working so hard at the task.', ...
            'In the next phase of the experiment you will continue to categorize these', ...
            'pictures into categories 1, 2, 3, and 4. Keep trying to', ...
            'do as well as you can. Good luck.', ...
            '', ...
            '', ...
            'Press the space bar to continue'};
        
            %display block instructions
            cenTex(instructions,window,screenRect,white,black,18) % Print text centered
            if debug~=1;getResp('space');end; % Wait for user to press 'space bar'; % Wait for user to press 'space bar'    
%             getResp('space');
            cenTex({'+'},window,screenRect,white,black,32) % Display fixation cross
    elseif blockN>1 && blockN<=3
            feedbackType=1;
            instructions = { ...
            '', ...
            'You are doing great. Please continue with the experiment', ...
            '', ...
            '', ...
            'Press the space bar to continue'};
        
            %display block instructions
            cenTex(instructions,window,screenRect,white,black,18) % Print text centered
            if debug~=1;getResp('space');end; % Wait for user to press 'space bar'; % Wait for user to press 'space bar'    
%             getResp('space');
            cenTex({'+'},window,screenRect,white,black,32) % Display fixation cross
    elseif blockN>7 && blockN<=9
        if blockN==9
            blockLength=50;
        end
            
            feedbackType=1;
            instructions = { ...
            '', ...
            'You are doing great. Please continue with the experiment', ...
            '', ...
            '', ...
            'Press the space bar to continue'};
        
     %display block instructions
            cenTex(instructions,window,screenRect,white,black,18) % Print text centered
            if debug~=1;getResp('space');end; % Wait for user to press 'space bar'; % Wait for user to press 'space bar'    
%             getResp('space');
            cenTex({'+'},window,screenRect,white,black,32) % Display fixation cross
%     elseif blockN==9
%             feedbackType=1;
%             instructions = { ...
%             '', ...
%             'You are doing great. Please continue with the experiment', ...
%             '', ...
%             '', ...
%             'Press the space bar to continue'};
% 
%         %display block instructions
%             cenTex(instructions,window,screenRect,white,black,18) % Print text centered
%             if debug~=1;getResp('space');end; % Wait for user to press 'space bar'; % Wait for user to press 'space bar'    
%         %             getResp('space');
%             cenTex({'+'},window,screenRect,white,black,32) % Display fixation cross   
    end
    for i=1:blockLength
        % Get stimulus value and category
        stimLength = stim(trialNum,2);
        stimOrient = stim(trialNum,3);
        stimCat = stim(trialNum,1);
        stimTheta = stimOrient * pi / 600;
%         originalCat= stim(trialNum,5);


        % Draw stimulus
        X1 = Xorigin + (.5 * stimLength * cos(stimTheta));
        Y1 = Yorigin + (.5 * stimLength * sin(stimTheta));
        X2 = Xorigin - (.5 * stimLength * cos(stimTheta));
        Y2 = Yorigin - (.5 * stimLength * sin(stimTheta));


        if trialNum>=wmTrial && trialNum<(wmTrial+wmSpans) %initiate the WM state for these trials
            num1=randSample(bigNums);
            num2=randSample(smallNums);
%             sizeflip=0;
            if sizeflip(wmt)==0
                bigN=num2;
                lilN=num1;
            else
                bigN=num1;
                lilN=num2;
            end
            side=shuffle(sides);                    
            
            Screen(window,'FillRect',black);
            SCREEN(window,'DrawLine',white,X1,Y1,X2,Y2);
            
            Screen(window,'TextSize', 32);
            Screen(window,'DrawText', num2str(lilN),side(1),Yorigin,textcolor);
            Screen(window,'TextSize', 64);
            Screen(window,'DrawText', num2str(bigN),side(2),Yorigin,textcolor);
            
            
            
                sizeCR=side(2);
              
              if sizeflip(wmt)==1
                  valCR=side(2);
              else
                  valCR=side(1);
              end


            pause(.2*speedup);
                %Technically this clears the whole screen and then draws
                %the line again. It is the easiest method and I am lazy
                %right now.  Sorry.
            Screen(window,'FillRect',backcolor);
            Screen(window,'DrawLine',textcolor,X1,Y1,X2,Y2);

            %Collect stimulus category (correct response) information based off
            %of categories
            corrResp=stimCat;


            %Collect Subject Response
        %     [rawResp, rt] = getResp('Z','W','/?','I');
            if debug~=1;[rawResp, rt] = getResp('z','w','i','/?');else rawResp=randi(2)-1;rt=2*rand(1);end
            resp=rawResp+1;
            %Clear screen following response
            Screen(window,'FillRect',black);
    %         cenTex({'+'},window,screenRect,white,black,32) % Display fixation cross
    %         pause(.5*speedup);

            %Get and display accuracy for either regular or intervention trials
            if feedbackType==1
    %             circCR=stim(trialNum,5);
                randTrial=0;
                if resp==corrResp
                    accuracy=1;
                    feedgiven=1;
                    cenTex({'Correct'},window,screenRect,white,black,32)
                else
                    accuracy=0;
                    feedgiven=0;
                    cenTex({'Incorrect'},window,screenRect,white,black,32)
                end

            elseif feedbackType==0

                rNum=(blockN-4)*100+i;
                corrResp=randStim(rNum);
                randTrial=corrResp;
                %Create intervention feedback and data reporting
                if resp==corrResp
                    feedgiven=1;
                    cenTex({'Correct'},window,screenRect,white,black,32);
                else
                    feedgiven=0;
                    cenTex({'Incorrect'},window,screenRect,white,black,32)
                end


                if resp==stimCat
                    accuracy=1;
                else
                    accuracy=0;
                end
            end     
            pause(1*speedup);
            Screen(window,'FillRect',black);
%                 pause(.5);
                if dimOrder(wmt)==1
                    cenTex({'Value?'},window,screenRect,white,black,32)
                    crWM=2;
                else
                    crWM=1;
                    cenTex({'Size?'},window,screenRect,white,black,32)
                end

%                 [stRawResp, stRT] = getResp('f','j');
                if debug~=1; [stRawResp, stRT] = getResp('f','j'); else stRawResp=randi(2)-1;stRT=2*rand(1);end
                stResp=sides(stRawResp+1);
                data{trialNum,12}=stRT;

                Screen(window,'FillRect',backcolor);
                if crWM==1
                    if stResp==sizeCR
                        %Correct
                        data{trialNum,11}=1;
                        wmAcc(wmt,1)=1;
                        cenTex({'Correct'},window,screenRect,white,black,32)
                    else
                        %Incorrect
                        wmAcc(wmt,1)=0;
                        data{trialNum,11}=0;
                        cenTex({'Incorrect'},window,screenRect,white,black,32)
                    end
                else
                    if stResp==valCR
                        %Correct
                        wmAcc(wmt,1)=1;
                        data{trialNum,11}=1;
                        cenTex({'Correct'},window,screenRect,white,black,32)
                    else
                        %Incorrect
                        wmAcc(wmt,1)=0;
                        data{trialNum,11}=0;
                        cenTex({'Incorrect'},window,screenRect,white,black,32)
                    end                   
                end
                
%                 pause(1);
                    
                meanWM=mean(wmAcc(:,1));
                if meanWM<.8
                    wmMess=red;
                else
                    wmMess=green;
                end
                
                wmAcctext=['You have answered ' num2str(meanWM*100) '% correctly.'];
                Screen(window, 'DrawText', wmAcctext, Xorigin-length(wmAcctext)/2.*32/2, 100, wmMess);
                pause(1*speedup);
                Screen(window,'FillRect',backcolor);
                
                wmt=wmt+1;
            
            
            
            
        else
        
            Screen(window,'FillRect',black);
            SCREEN(window,'DrawLine',white,X1,Y1,X2,Y2);
            screen(window,'DrawLine',[0 0 0],1,1,2,2);

            %Collect stimulus category (correct response) information based off
            %of categories
            corrResp=stimCat;


            %Collect Subject Response
        %     [rawResp, rt] = getResp('Z','W','/?','I');
            if debug~=1;[rawResp, rt] = getResp('z','w','i','/?');else rawResp=randi(2)-1;rt=2*rand(1);end
            resp=rawResp+1;
            %Clear screen following response
            Screen(window,'FillRect',black);
    %         cenTex({'+'},window,screenRect,white,black,32) % Display fixation cross
    %         pause(.5*speedup);

            %Get and display accuracy for either regular or intervention trials
            if feedbackType==1
    %             circCR=stim(trialNum,5);
                randTrial=0;
                if resp==corrResp
                    accuracy=1;
                    feedgiven=1;
                    cenTex({'Correct'},window,screenRect,white,black,32)
                else
                    accuracy=0;
                    feedgiven=0;
                    cenTex({'Incorrect'},window,screenRect,white,black,32)
                end

            elseif feedbackType==0

                rNum=(blockN-4)*100+i;
                corrResp=randStim(rNum);
                randTrial=corrResp;
                %Create intervention feedback and data reporting
                if resp==corrResp
                    feedgiven=1;
                    cenTex({'Correct'},window,screenRect,white,black,32);
                else
                    feedgiven=0;
                    cenTex({'Incorrect'},window,screenRect,white,black,32)
                end


                if resp==stimCat
                    accuracy=1;
                else
                    accuracy=0;
                end
            end
            pause(1*speedup);
            data{trialNum,12}=0;
            data{trialNum,11}=0;
            


        end
        

        %Clear Screen and Collect data for the trial
        cenTex({'+'},window,screenRect,white,black,32) % Display fixation cross
        data{trialNum,1}=blockN; % Block Number
        data{trialNum,2}=stimLength; % Stimulus Length
        data{trialNum,3}=stimOrient; % Stimulus Orientation
%         data{trialNum,4}=randN; %What the random Correct Response was/would have been
        data{trialNum,4}=stimCat; %Correct Stimulus Category, regardless of feedback
        data{trialNum,5}=resp; %Subject Response
        data{trialNum,6}=randTrial; %Correct response for random trials
        data{trialNum,7}=accuracy; %Accuracy on original category structure
        data{trialNum,8}=rt; % Response Time
        data{trialNum,9}=feedgiven; %Circle Accuracy
        data{trialNum,10}=feedbackType; %What condition at start of experiment
        data{trialNum,13}=meanWM;
        pause(1*speedup); %ITI
        
        %Next trial
        trialNum=trialNum+1; 
        
%         After 100 trials, advance the block
%         if trialNum==100||trialNum==200||trialNum==300||trialNum==400||trialNum==500||trialNum==600||trialNum==700||trialNum==800
%             blockN=blockN+1;
%         end
%         elseif trialNum==850;
%             break
%         end
    end
end

    
    
    
    
end
    