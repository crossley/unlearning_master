function [] = cenTex(txt,window,screenRect,txtcolor,bgcolor,txtsize)

% CenTex accepts a cell array containing lines of text and prints
% each line, centered on the screen. CenTex will simply fill the background
% with 'bgcolor' and write text in 'txtcolor' according to the 'screenRect'
% variable, which is found using [window, screenRect] =
% Screen(0,'OpenWindow');
%
% 'txt' MUST be in cell array format -- If only one line of text, define
% 'txt' as 'txt={'YOUR TEXT HERE'};

% Find center of window using 'screenRect'
Xorigin = (screenRect(3)-screenRect(1))/2;
Yorigin = (screenRect(4)-screenRect(2))/2;

Screen(window,'FillRect', bgcolor); % Fill background with backcolor

% Write 'txt'
strLength=length(txt); % Determine length of string for centering purposes
for i = 1:strLength % Cycle through character string
    Screen(window,'TextSize',txtsize);
    TextWidth=Screen(window,'TextWidth',txt{i});
    TextHeight= strLength*(txtsize+5)-5; % Height of text body, giving 5 pixel buffer between each line of text
    Screen(window,'DrawText',txt{i},Xorigin-TextWidth/2,Yorigin-TextHeight/2+(txtsize+5)*(i-1),txtcolor);
end

