clear

expDirectory = pwd;
dataDirectory = [expDirectory '\Data'];

cd(expDirectory);

%New MATLAB2013 compatable create randomization code.
matlabversion  = version;
matlabversion = str2num(matlabversion(1:3));
if matlabversion >= 7.7
    rand('twister',sum(100*clock));
else
    rand('twister',sum(100*clock));
%     s = RandStream('swb2712','Seed',sum(100*clock));
%     RandStream.setGlobalStream(s);
% else
%     rand('state',sum(100*clock))
end

% Enter subject data
datainputflag = 0;
while datainputflag ~= 1
    initflag = 0;
    while initflag ~= 1
        prompt = {'WalkinID', 'Subject Number', 'Subject Initials', 'Condition Number'};
        name = ['Welcome to ' mfilename];
        defAns = {'9999','1001','debug','1-5'};
        options.Resize = 'on';
        options.WindowStyle = 'normal';
        options.Interpreter = 'tex';
        info = inputdlg(prompt,name,1,defAns,options);
        if isempty(info)
            return
        end
        pid = info{2};
        pinitT = info{3};
        condNum = info{4};
        walkinID= info{1};

        pinitT = str2double(pinitT);
        if isnan(pinitT)
            pinit = info{3};
            initCH = 1;
            initCHerr = '';
        else
            initCH = 0;
            initCHerr = 'Subject Initials needs to be entered as letters';
        end

        pid = str2double(pid);
        if isnan(pid)
            subCH = 0;
            subCHerr = 'Subject Number needs to be entered as (a) number(s)';
        else
            subCHerr = '';
            subCH = 1;
        end
        
        walkinID = str2double(walkinID);
        if isnan(walkinID)
            walkCH = 0;
            walkCHerr = 'WalkinID needs to be entered as (a) number(s)';
        else
            walkCHerr = '';
            walkCH = 1;
        end
        
        condNum = str2double(condNum);
        if rem(condNum,1) ~= 0 || condNum>6 || condNum<=0
            condCH = 0;
            condCHerr = 'Condition Number needs to be an integer 1-5';
        else
            condCHerr = '';
            condCH = 1;
        end

        if initCH + subCH + condCH + walkCH == 4
            if strcmpi(pinit,'debug')
                options.Default='No';
                debugquest = 'You have initialized debug mode, do you want to continue in debug mode?';
                orlydebug = questdlg(debugquest,'Debug Mode?','Yes','No',options);
                if strcmpi(orlydebug,'Yes')
                    initflag = 1;
                end
                debug = 1;
                randresp = 1;
                speedup = 100;
            else
                debug = 0;
                randresp = 0;
                speedup = 1;
                initflag = 1;
            end
        else
            errorText = {walkCHerr, initCHerr, subCHerr, condCHerr};
            uiwait(errordlg(errorText, 'Error!'));
        end
    end


    options.Default='No';
    checkinfo = {'Is the follow ing information correct',...
        '',...
        [pinit ' = Subject`s Initials'],...
        [num2str(pid)  ' = Subject Number'],...
        [num2str(condNum) ' = Condition Number'],...
        [num2str(walkinID) ' = WalkinID'],...
        };
    check = questdlg(checkinfo,'Is this info correct?','Yes','No',options);
    if strcmpi(check,'Yes')
        datainputflag = 1;
    end
end


switch condNum
    case 1
        data = Unlearning4b_1(debug,condNum); % 100 WM trials, 250-350
    case 2
        data = Unlearning4b_2(debug,condNum); % 200 WM trials, 250-450
    case 3
        data = Unlearning4b_3(debug,condNum); % 300 WM trials, 250-550
    case 4
        data = Unlearning4b_4(debug,condNum); % 250 WM trials, 400-650
    case 5
        data = Unlearning4b_5(debug,condNum); % Control
    case 6
        data = UnlearningDebug(debug,condNum); %Quick Version to debug with
    otherwise
    % Just in case there is some error with the condition number
    disp('There has been an error. Please restart the experiment and specify information correctly.')
end

filename = ['Unl4b_' num2str(walkinID) '_' num2str(pid) '_' pinit '_' num2str(condNum) '.mat'];

cd Data

% Write data (.mat format)
% Note: data can later be written to .xls if so desired, but limited
% excel capability in some computer stations makes .mat the most consistent
% method of data storage
save(filename,'data');

cd ..

%save as .txt file
cd txtData

if condNum==5
    condNum='c';
    filename=['un4b' condNum num2str(pid) '.txt'];
else
    filename=['un4b' num2str(condNum) num2str(pid) '.txt'];
end


fid=fopen(filename,'wt');
for row=1:length(data)
    fprintf(fid, '%d %.4f %.4f %d %d %d %d %.4f %d %d %d %.4f %.4f\n', data{row,:});
end
fclose(fid)
cd ..
%save as .dat file
cd datData
filename=filename(1:end-4);
dlmwrite([filename '.dat'],data,' ');
cd ..

cd(expDirectory)

Screen('CloseAll') % Close all