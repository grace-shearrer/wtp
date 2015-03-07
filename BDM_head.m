%=========================================================================
% BDM task code in progress
%=========================================================================
%function BDM(sinit, runNum, scanflag)
%just added to try to push through synching
Screen('Preference', 'SkipSyncTests', 1);

c=clock;
hr=num2str(c(4));
min=num2str(c(5));
timestamp=[date,'_',hr,'h',min,'m'];
rand('state',sum(100*clock));       % resets 'randomization'

%---------------------------------------------------------------
%% 'GET user input' DISABLED TO USE WRAPPER
%---------------------------------------------------------------

 % input checkers
% oktype=[0 1 2];
 okscan=[0 1];
 okrun=[1 2];
% 
 % get subject code
 sinit=input('Subject code (no quotes):','s');
 while isempty(sinit)
     disp('ERROR: no value entered. Please try again.');
     sinit=input('Subject code:','s');
 end
% 
 % get run number
 runNum=input('First(1) or Second(2) run?: ');
 while isempty(runNum) || sum(okrun==runNum)~=1
     disp('ERROR: input must be 1 or 2. Please try again.');
     runNum=input('First(1) or Second(2) run?: ');
 end
% 
% % get run type
% runType=input('Demo(0), self-run(2) or Study(1) ?');
% while isempty(runType) || sum(oktype==runType)~=1
%     disp('ERROR: input must be 0, 1, or 2. Please try again.');
%     runType=input('Demo(0), self-run(2) or Study(1) ?');
% end
% 
 % is this a scan?
 scanflag=input('Are you scanning? yes(1) or no(0): ');
 while isempty(scanflag) || sum(okscan==scanflag)~=1
     disp('ERROR: input must be 0 or 1. Please try again.');
     scanflag=input('Are you scanning? yes(1) or no(0)');
 end

tic

%---------------------------------------------------------------
%% 'INITIALIZE Screen variables'
%---------------------------------------------------------------

pixelSize=32;
[w, ScreenRect] = Screen('OpenWindow',0,[],[],pixelSize);

% Here Be Colors
black=BlackIndex(w); % Should equal 0.
white=WhiteIndex(w); % Should equal 255.
yellow=[0 255 0];


% set up Screen positions for stimuli
[wWidth, wHeight]=Screen('WindowSize', w);
xcenter=wWidth/2;
ycenter=wHeight/2;

Screen('FillRect', w, black);  % NB: only need to do this once!
Screen('Flip', w);

% text stuffs
theFont='Arial';
Screen('TextFont',w,theFont);

instrSZ=40;
betsz=60;
Screen('TextSize',w, instrSZ);

%---------------------------------------------------------------
%% 'ASSIGN response keys'
%---------------------------------------------------------------

if scanflag==0
    leftstack='u';
    midleftstack= 'i';
    midrightstack='o';
    rightstack='p';
else
    leftstack='b';
    midleftstack= 'y';
    midrightstack='g';
    rightstack='r';
end

%change to 1234
%-----------------------------------------------------------------
% set phase times

maxtime=4;      % 4 second limit on each selection


%-----------------------------------------------------------------
% stack locations


leftRect=[xcenter-(xcenter*3/8)-20 ycenter+300 xcenter-(xcenter*3/8)+20 ycenter+340];
midleftRect=[xcenter-(xcenter*1/8)-20 ycenter+300 xcenter-(xcenter*1/8)+20 ycenter+340];
midrightRect=[xcenter+(xcenter*1/8)-20 ycenter+300 xcenter+(xcenter*1/8)+20 ycenter+340];
rightRect=[xcenter+(xcenter*3/8)-20 ycenter+300 xcenter+(xcenter*3/8)+20 ycenter+340];




%---------------------------------------------------------------
%% 'LOAD image arrays'
%---------------------------------------------------------------


food_images=dir('~/Documents/MATLAB/sugar_brain/stim/*.bmp');
food_images=vertcat(food_images,dir('~/Documents/MATLAB/sugar_brain/stim/*.bmp'));

shuffledlist=Shuffle(1:length(food_images));

imgArrays = cell(length(shuffledlist), 1);

for i=1:length(shuffledlist)
    
    imgArrays{i,1}=imread(['~/Documents/MATLAB/sugar_brain/stim/' food_images(shuffledlist(i)).name]);
end

r=Shuffle(1:4);
onsetlist=load(['Onset_files/BDM_onset_' num2str(r(1)) '.mat']);
onsetlist=onsetlist.onsetlist;


%ListenChar(2); %suppresses terminal ouput

%---------------------------------------------------------------
%% 'Write output file header'
%---------------------------------------------------------------

fid1=fopen(['Onset' sinit '_BDM' num2str(runNum) '_' timestamp '.txt'], 'a');
fprintf(fid1,'sinit scanner runtrial onsettime Name Bid RT \n'); %write the header line

%---------------------------------------------------------------
%% 'Display Main Instructions'
%---------------------------------------------------------------

Screen('TextSize',w, instrSZ);
CenterText(w,'As explained, please bid on each of the following items', white,0,-100);
CenterText(w,'by selecting one of $0 $1 $2 or $3 using', white,0,-20);
CenterText(w,'button 1, 2, 3 or 4 respectively.', white,0,60);
CenterText(w,'When you are ready, press any button to continue.', yellow,0,120);
HideCursor;
Screen('Flip', w);
WaitSecs(0.05); % prevent key spillover
noresp=1;
while noresp
    [keyIsDown,secs,keyCode] = KbCheck(-1);
    if keyIsDown && noresp
        noresp = 0;
    end
end

if scanflag==1
    
    CenterText(w,'Get ready!', white,0,0);
    Screen('Flip', w);
    
    noresp=1;
    while noresp
        [keyIsDown,secs,keyCode] = KbCheck(-1);
        if find(keyCode)==23 & keyIsDown & noresp
            noresp = 0;
        end
    end
end

Screen('TextSize', w, betsz);
Screen('DrawText', w, '+', xcenter, ycenter, white);
Screen(w,'Flip');


%---------------------------------------------------------------
%% 'Run Trials'
%---------------------------------------------------------------
runStart=GetSecs;

for trial=1:length(onsetlist)
    %stim=uint8(imgArrays{trial,1}
    colorright=white;
    colormidright=white;
    colormidleft=white;
    colorleft=white;
    %-----------------------------------------------------------------
    % set image
    Screen('TextSize', w, betsz);
    Screen('DrawText', w, '$0', leftRect(1), leftRect(2), white);
    Screen('DrawText', w, '$1', midleftRect(1), midleftRect(2), white);
    Screen('DrawText', w, '$2', midrightRect(1), midrightRect(2), white);
    Screen('DrawText', w, '$3', rightRect(1), rightRect(2), white);
    
    %-----------------------------------------------------------------
    % display stacks
    % FOR using large pictures as features:
    %swapped trial and 1
    Screen('PutImage',w,imgArrays{trial, 1});
    Screen(w,'Flip', runStart+onsetlist(trial));
    
    eventTime=GetSecs-runStart;
    %-----------------------------------------------------------------
    % get response
    
    
    noresp=1;
    goodresp=0;
    while noresp
        % check for response
        [keyIsDown,secs,keyCode] = KbCheck(-1);
        if keyIsDown && noresp
            tmp=KbName(keyCode);
            keyPressed = tmp(1);
            if ischar(keyPressed)==0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed to be a char, so this converts it and takes the first key pressed
                keyPressed=char(keyPressed);
                keyPressed=keyPressed(1);
            end
            if keyPressed==leftstack || keyPressed==midleftstack || keyPressed==midrightstack || keyPressed==rightstack
                respTime = GetSecs-runStart-eventTime;
                noresp=0;
                goodresp=1;
            end
        end
        
        
        % check for reaching time limit
        if noresp && GetSecs-runStart >= onsetlist(trial)+maxtime
            noresp=0;
            keyPressed=999;
            respTime=4;
        end
    end

    
    %-----------------------------------------------------------------

    
    % determine what bid to highlight
    
    switch keyPressed
        case leftstack
            colorleft=yellow;
            bid=0;
            
        case midleftstack
            colormidleft=yellow;
            bid=1;
            
        case midrightstack
            colormidright=yellow;
            bid=2;
            
        case rightstack
            colorright=yellow;
            bid=3;
    end
%removed the 1 from {1, trial}
    if goodresp==1
        Screen('PutImage',w,imgArrays{trial, 1});
        Screen('DrawText', w, '$0', leftRect(1), leftRect(2), colorleft);
        Screen('DrawText', w, '$1', midleftRect(1), midleftRect(2), colormidleft);
        Screen('DrawText', w, '$2', midrightRect(1), midrightRect(2), colormidright);
        Screen('DrawText', w, '$3', rightRect(1), rightRect(2), colorright);
        Screen(w,'Flip',runStart+onsetlist(trial)+respTime);
        extra=0;
    else
        Screen('DrawText', w, 'Please respond faster!', xcenter-300, ycenter, white);
        Screen(w,'Flip',runStart+onsetlist(trial)+respTime);
        extra=0.5;
    end
 
    
    
    %-----------------------------------------------------------------
    % show fixation ITI
    Screen('TextSize',w, betsz);
    Screen('DrawText', w, '+', xcenter, ycenter, white);
    Screen(w,'Flip',runStart+onsetlist(trial)+maxtime+extra);
    
    if goodresp ~= 1
        bid=999;
        respTime=999;
    end
    
    %-----------------------------------------------------------------
    % write to output file
    
    fprintf(fid1,'%s %d %d %d %s %d %d \n', sinit, scanflag, trial, eventTime, food_images(shuffledlist(trial)).name, bid, respTime); 
end





Screen('TextSize',w, instrSZ);
CenterText(w,'Thank you!', yellow,0,100);
Screen('Flip', w, runStart+onsetlist(trial)+maxtime+4);
WaitSecs(5); % prevent key spillover

% noresp=1;
% while noresp
%     [keyIsDown,secs,keyCode] = KbCheck;
%     if find(keyCode)==44 & keyIsDown & noresp
%         noresp = 0;
%     end
% end

toc
ShowCursor;
Screen('closeall');
BDM_resolve(sinit);



