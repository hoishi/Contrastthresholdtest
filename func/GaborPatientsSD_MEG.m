function GaborPatientsSD_MEG(folder_name,nTrials,subj_ID,SessionNumber,block)
% MEG対応
% 画面トリガーシグナルの設定(signal_area)
% キー入力の追加（MEGキー用）
% スクリーンメッセージの抑止(f_disp)
% MEGに合わせてppdの値を再計算

if exist( 'Interface','var' )
    close Interface;
end

%% TO DO
% folder_name = '/Users/WhitneyLab/Dropbox/experiments/Schizophrenia & SD/';
% subj_ID = 'ccc';
% SessionNumber = '1';
% nTrials = 10;
% block = '1';
% pic_num = 1;

% UP
SessionNumber =  datestr(now,30) % add date infomation
subj_ID
nTrials
block
MAC = ismac

% Reset random kernel
rng('shuffle')
KbName('UnifyKeyNames');

f_disp = 0; % メッセージ抑止フラグ
f_sig = true; % シグナル抑止フラグ

%% Timing parameters %%
dispTime0 = 0.5;  % Time between bar pressing and Gabor presentation
dispTime1 = 0.5;  % Gabor duration
dispTime2 = 1;  % Mask duration
dispTime3 = 0.25;  % ISI between mask and response bar
dispTime4 = 2;  % Waiting Time No Bar condition

%% Main parameters %%
responseBar_dim= [0.5 4];  % bar width (0.5) and length (4)
% pixelsPerDeg = 38;         % pixels per degree of visual angle for 1920 x 1080 res
pixelsPerDeg = 42;         % pixels per degree of visual angle for 1280 x 800 res in MEG room 20161031 UP
EccTarget = 5; % in deg of visual angle
EccFixDot = 5; % in deg of visual angle - NB it must be added!!
fixation_dot = 0.2; % fixation dot diameter - 0.2 degrees

%% Gabor Parameters
gabor_size = 6; % Gabor size in degrees of visual angle
l_mean = round(255/2);%mean luminance/intensity (halfway through the 0-255 intensity range)
contrast = .25; %added contrast parameter
gaborPhase = 180; %phase in degrees
numCycles = 0.50; %cpd cycle per degree
aperture = .90; %aperture gaussian window
noiseGabor = 50; % noise IN gabor. set at 1 to see the normal Gabor

%% Some quick calculations on the parameters we set
parmss.gabor_dim = [round(pixelsPerDeg*gabor_size) round(pixelsPerDeg*gabor_size)]; % gabor dimension
responseBar_dim = pixelsPerDeg * responseBar_dim % bar width and length
EccFixDot = pixelsPerDeg * EccFixDot; %eccentricity fixation dot AND bar
fixation_dot = pixelsPerDeg * fixation_dot; % fixation dot diameter - 0.2 degrees
BlockRep = 1:str2double(block); %4 blocks,50 trials each. 4 sessions of 800 (50*4*4) in total.
gaussSD = pixelsPerDeg * aperture; %SD gaussian


%% Creates Folder and Saves Data
folder_subj = strcat(folder_name,'/',subj_ID); % Puts together path and new folder

if exist(folder_subj,'dir')==0
    mkdir(folder_subj); % Creates folder in Data with subject name
end

if ispc
    save_path=folder_subj; % MM: add data here
else
    save_path=folder_subj;
end



%handle duplicate filename
fn = [save_path '/' subj_ID '_session' SessionNumber '_block' num2str(1) '_Exp_parameters.mat'];
if exist(fn,'file')
    fn = strrep(fn, '\','/');
    fprintf('File name: "%s".\n', fn);
    overwrite = input('The file is already saved with this name. Overwrite? (y/n): ','s');
    if overwrite == 'y' % do nothing
    else %anything besides 'y', input new name
        fprintf('###### Please run Interface.m again.\n');
        return
    end
    clear overwrite
end



%% ------ Screen and Color Setup ------ %%

%Choose a screen
AssertOpenGL;
screens = Screen('Screens');
screenNumber = max(screens);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebuglevel', 0); % removes screen for donations
%  HideCursor();

%Get colors this just gets the numbers that represent black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
gray = round((white+black)/2);

%Open a window and paint the background gray, [w1 h1 w2 h2]
[w, screenRect] = Screen('OpenWindow',screenNumber, gray);
screenRect % UP
third_scrn_horiz = floor(screenRect(3)/3);
half_scrn_horiz = floor(screenRect(3)/2);
half_scrn_vert = floor(screenRect(4)/2);

% signal Area % UP 
% Signal_area = [screenRect(3)-50, screenRect(4)-50, screenRect(3), screenRect(4)];
Signal_area = [screenRect(3)-30, 0, screenRect(3), 70];

Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

[T, ~, ~]=Screen('GetFlipInterval', w );
refreshRate = round(1/T) % UP

%% Make response bar texture %%
responsePic=ones(responseBar_dim); %create matrix for response bar
responsePic=responsePic*((white+black)/3); % bar color
responseTex=Screen('MakeTexture', w, responsePic);

resp_tex_rect=[0-EccFixDot 0-EccFixDot responseBar_dim-EccFixDot];
resp_center_rect=CenterRect(resp_tex_rect, screenRect);
resp_center_rect(1)=resp_center_rect(1)-EccFixDot; % moves bar to fixation point eccentricity
resp_center_rect(3)=resp_center_rect(3)-EccFixDot; % moves bar to fixation point eccentricity

%% Bar Mask Texture
% bar_tex_rect=[0 0 parmss.gabor_dim];
% bar_center_rect = CenterRect(bar_tex_rect, screenRect);
% bar_rect = bar_center_rect+[-EccFixDot,0,-EccFixDot,0];

%% Gabor Location
gabor_tex_rect=[0 0 parmss.gabor_dim];
gabor_center_rect = CenterRect(gabor_tex_rect, screenRect);
gabor_rect=gabor_center_rect+[pixelsPerDeg*EccTarget,0,pixelsPerDeg*EccTarget,0];

Snd('Play',[sin(1:20000) zeros(1,10000) sin(1:20000)]);

for ii=BlockRep
    if f_sig == true % UP
       Screen('FillRect', w ,black ,Signal_area );
       Screen('Flip',w);
    end

    %% Set up response arrays
    GabOrSpec=nan(nTrials, 1);
    TimeArray=nan(nTrials, 5);
    
    %% Design of Target Gabor Orientation structure
    TargetGabor = randi([-90 90],1,nTrials); % take random orientation for number of Trials
    
    %% Bar response randomization
    StartBarOrientation=randi([0 360],1,nTrials);
    
    %% Design of Stimulus Sequence
    % Design of Target-Flankers Structure for 200
    a=repmat([0 0],(nTrials/10),1); % 20%
    b=repmat([0 0],(nTrials/10),1); % 20%
    c=repmat([1 0],(nTrials/10),1); % 20%
    d=repmat([1 0],(nTrials/10),1); % 20%
    e=repmat([1 0],(nTrials/10),1); % 20%
    
    abcd = vertcat(a,b,c,d,e); % concatenate all three couples
    CouplesOrderStruct = abcd(randperm(size(abcd,1)),:); % couples in columns
    CouplesOrder = CouplesOrderStruct';
    CouplesOrder = CouplesOrder(:);
    CouplesOrder = CouplesOrder';
    
    while ~(CouplesOrder(1)==0 && CouplesOrder(end)==0) %&& ~(strfind(CouplesOrder,[1 1])==[])) % what I want
        CouplesOrderStruct = abcd(randperm(size(abcd,1)),:); % couples in columns
        CouplesOrder = CouplesOrderStruct';
        CouplesOrder = CouplesOrder(:);
        CouplesOrder = CouplesOrder';
    end
    
    %saves files
    if str2double(block)==1
        % Init save file names
        save_mfileAll = [save_path '/' subj_ID '_session_' SessionNumber '_block' num2str(BlockRep(ii)) '_Exp_parametersPRACTICE.mat']; % saves all the parameters
        save_mfile =  [save_path '/' subj_ID '_session_' SessionNumber '_block' num2str(BlockRep(ii)) '_dataPRACTICE.mat']; % saves subject data
    elseif str2double(block)>1
        % Init save file names
        save_mfileAll = [save_path '/' subj_ID '_session_' SessionNumber '_block' num2str(BlockRep(ii)) '_Exp_parameters.mat']; % saves all the parameters
        save_mfile =  [save_path '/' subj_ID '_session_' SessionNumber '_block' num2str(BlockRep(ii)) '_data.mat']; % saves subject data
    end
    
    %% Fixation dot location
    fix_rect = [third_scrn_horiz-(fixation_dot/2)-(EccFixDot) half_scrn_vert-(fixation_dot/2) third_scrn_horiz+(fixation_dot/2)-(EccFixDot) half_scrn_vert+(fixation_dot/2)] + [half_scrn_horiz-third_scrn_horiz 0 half_scrn_horiz-third_scrn_horiz 0];
    
    % Makes Gabor
    noise_size = 10;
    myImgMat = GaborMeshgrid (gabor_size, noise_size, numCycles, gaborPhase, l_mean, contrast, pixelsPerDeg,noiseGabor);
    gabor_tex=Screen('MakeTexture', w, myImgMat); %this is the Gabor texture, gabor_tex, which we use anytime we draw a Gabor
    
    % Creates gaussian mask
    mask = ones(parmss.gabor_dim(1)+1, parmss.gabor_dim(1)+1, 2) * gray;
    [x,y] = meshgrid(-parmss.gabor_dim(1)/2:parmss.gabor_dim(1)/2,-parmss.gabor_dim(1)/2:parmss.gabor_dim(1)/2);
    mask(:, :, 2) = white * (1 - exp(-((x/gaussSD).^2)-((y/gaussSD).^2))); % 10 can see it
    masktex = Screen('MakeTexture', w, mask);
    
    % Creates random noise textures
    blur_filter = fspecial('gaussian', 35, 10);
    noise_size = 10;
    for e=1:nTrials
        noise = (resizem(rand(noise_size,noise_size),[parmss.gabor_dim(1)+1 parmss.gabor_dim(1)+1]) - .5)*75 + gray;
        noisetex(e,:,:) = Screen('MakeTexture', w, imfilter(noise,blur_filter,'replicate'));
    end
    %%
    
    % Set keyboard mappings % UP
    spacebar = KbName('space');
    spacebar_num = KbName('1!');
    spacebar_num_ten = KbName('1');
    
    esckey = KbName('ESCAPE');
    
    left_response = KbName('LeftArrow');
    left_num_response = KbName('2@');
    left_num_ten_response = KbName('2');
    
    right_response = KbName('RightArrow');
    right_num_response = KbName('3#');
    right_num_ten_response = KbName('3');
    
    enter = KbName('Return');
    
    % Display fixation point & instructions
%     instruct='Determine each central gabor''s orientation.\n Respond with left or right arrow key.\n Press space bar to begin.';
    instruct='Determine each central gabor''s orientation.\n Respond with left or right arrow and space key.\n Press enter bar to begin.';
%     disp(instruct);
    disp('Press enter bar to begin.');
    if f_disp == 1 % スクリーンへのメッセージ表示 % UP
        Screen(w, 'TextSize',25);
        DrawFormattedText(w, instruct, 'center', 384-pixelsPerDeg*7, 0);
    end
    Screen('FillOval', w, black, fix_rect); %fixation dot
    if f_sig == true % UP
       Screen('FillRect', w ,black ,Signal_area );
    end

    Screen('Flip',w);
    
    %% Start experiment
    priorityLevel = MaxPriority(w);
    Priority(priorityLevel);
    
    % wait for spacebar
    [keyIsDown,~,keyCode] = KbCheck(-1);
%     while ~keyCode(spacebar)
    while ~keyCode(enter)
        [keyIsDown,seconds,keyCode] = KbCheck(-1);
    end
    disp('Start !!.');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        LOOP       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for kk=1:nTrials
        
        %% Display Gabor %%
        starTime=GetSecs();
        
        Screen('FillOval', w, black, fix_rect); %fixation dot
        Screen('DrawTexture', w, gabor_tex, gabor_tex_rect, gabor_rect, TargetGabor(kk)); % targetGabor(kk) is about orient
        Screen('DrawTexture', w, masktex, gabor_tex_rect, gabor_rect,TargetGabor(kk));
        
       if f_sig == true % UP
            Screen('FillRect', w ,white ,Signal_area );
       end
%             Screen('FillRect', w ,black ,Signal_area );
%         end
        
        ISI=Screen('Flip', w, starTime + dispTime0); % from key press to Gabor
        
        %% Display Mask %%
        Screen('FillOval', w, black, fix_rect); %fixation dot
        if f_sig == true
            Screen('FillRect', w ,black ,Signal_area );
        end
        
        % Draw noise
        Screen('DrawTexture', w, noisetex(kk,:,:), gabor_tex_rect, gabor_rect, 0);
        Screen('DrawTexture', w, masktex, gabor_tex_rect, gabor_rect,0);
        
        GaborDur=Screen('Flip', w, ISI + dispTime1); % Gabor duration
        
        %% ISI between Mask and Adjustment %%
        Screen('FillOval', w, black, fix_rect); %fixation dot
        if f_sig == true
            Screen('FillRect', w ,black ,Signal_area );
        end
        MaskDur=Screen('Flip', w, GaborDur + dispTime2); % Mask duration
        
        %% ADJUSTMENT TASK ORIENTATION %%
        
        if CouplesOrder(kk)==0
            
            % Do MOA task
            gabor_orient=StartBarOrientation(kk); %bar orientation is always zero
            
            %draw - BAR
            Screen('DrawTexture', w, responseTex, resp_tex_rect, resp_center_rect, StartBarOrientation(kk)); %last argument is angle in degrees (0)
            %Screen('DrawTexture', w, masktex, bar_tex_rect, bar_rect,0);
            
            Screen('FillOval', w, black, fix_rect); %fixation dot
            if f_sig == true
                Screen('FillRect', w ,black ,Signal_area );
            end
            ISIMaskBar=Screen('Flip', w, MaskDur + dispTime3); % ISI between Mask and Bar
            
            
            % loop for adjustement response % UP
            rot_delta = 0.5;    % This determines the speed of rotation.
            while 1
                [keyIsDown,seconds,keyCode] = KbCheck(-1);
                if keyIsDown
                    if keyCode(spacebar) || keyCode(spacebar_num) || keyCode(spacebar_num_ten) %press space to submit response
                        break
                    elseif keyCode(left_response) || keyCode(left_num_response) || keyCode(left_num_ten_response)
                        gabor_orient = gabor_orient - rot_delta;
                    elseif keyCode(right_response) || keyCode(right_num_response) ||keyCode(right_num_ten_response)
                        gabor_orient = gabor_orient + rot_delta;
                    end
                    gabor_orient = mod(gabor_orient-1,360)+1;
                    
                    %draw gabor in new orientation
                    Screen('DrawTexture', w, responseTex, resp_tex_rect, resp_center_rect, gabor_orient); %last argument is angle in degrees
                    %Screen('DrawTexture', w, masktex, bar_tex_rect, bar_rect,0);
                    
                    
                    Screen('FillOval', w, black, fix_rect); %fixation dot
                    if f_sig == true
                        Screen('FillRect', w ,black ,Signal_area );
                    end
        Screen('Flip', w); %it draws the rotating bar
                end
            end
            %% NO ADJUSTMENT %%
            
        elseif CouplesOrder(kk)==1
            
            Screen('FillOval', w, black, fix_rect); %fixation dot
            if f_sig == true
                Screen('FillRect', w ,black ,Signal_area );
            end
            ISIMaskBar=Screen('Flip', w, MaskDur + dispTime3); % ISI between Mask and Bar
            
            Screen('FillOval', w, black, fix_rect); %fixation dot
            if f_sig == true
                Screen('FillRect', w ,black ,Signal_area );
            end
            gabor_orient = nan;
            AdjBarDur=Screen('Flip', w, ISIMaskBar + dispTime4); % Waiting Time No Bar condition
            
        end
        
        % Saves Times
        TimeArray((kk),:)=[(ISI-starTime), (GaborDur-ISI),...
            (MaskDur-GaborDur),(ISIMaskBar-MaskDur),(GetSecs-ISIMaskBar)];
        
        GabOrSpec(kk) = gabor_orient; %bar orientation;
        
        % It converts to circle with maximum at 180
        if GabOrSpec(kk)>180;
            GabOrSpec(kk)=wrapTo180(GabOrSpec(kk));
        end
        
        % converts lower-right quadrants into upper left one
        if GabOrSpec(kk)>=91 && GabOrSpec(kk)<=179;
            GabOrSpec(kk)=GabOrSpec(kk)-180;
            % converts lower-left quadrants into upper right one
        elseif GabOrSpec(kk)<=-91 && GabOrSpec(kk)>=-179;
            GabOrSpec(kk)=GabOrSpec(kk)+180;
        end
        
        %Abort if escape is pressed
        [keyIsDown,seconds,keyCode] = KbCheck(-1);
        if keyCode(esckey)
            break;
        end;
        
        esc=KbName('ESCAPE');
        if keyCode(esc)
            Screen('CloseAll');
        end;
        
        Screen('FillOval', w, black, fix_rect); %fixation dot
        if f_sig == true
            Screen('FillRect', w ,black ,Signal_area );
        end
        Screen('Flip', w);
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        END LOOP       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % save workspace to mat file
    save(save_mfileAll);
    save(save_mfile, 'TimeArray','EccFixDot', 'EccTarget','CouplesOrder','StartBarOrientation' ,'GabOrSpec',...
        'folder_subj','nTrials','subj_ID','SessionNumber','block','TargetGabor');
    
    % display for interblocks
    if num2str(BlockRep(ii)) < num2str(BlockRep(end))
        
        % Display fixation point & instructions
        Snd('Play',sin(0:10000));
        InterBlockInstr=['Block ' num2str(BlockRep(ii)) 'out of ' num2str(BlockRep(end)) '\n \n Take a break \n or \n press Enter to continue'];
        disp(['Block ' num2str(BlockRep(ii)) ' out of ' num2str(BlockRep(end)) ' Take a break or press Enter to continue']);
        if f_disp == 1 % スクリーンへのメッセージ表示 % UP
            DrawFormattedText(w, InterBlockInstr, 'center', 384-pixelsPerDeg*7, 0);
            Screen(w, 'TextSize',40);
        end
        Screen('FillOval', w, black, fix_rect); %fixation dot
        if f_sig == true
            Screen('FillRect', w ,black ,Signal_area );
        end
        Screen('Flip',w);
        WaitSecs(.16);
        
        % wait for spacebar
        [keyIsDown,seconds,keyCode] = KbCheck(-1);
        while ~keyCode(enter)
            [keyIsDown,seconds,keyCode] = KbCheck(-1);
        end
        
    end
        if f_sig == true
            Screen('FillRect', w ,black ,Signal_area );
        end

    Screen('Flip',w);
    
end

% FlushEvents;

%% Goodbye message
goodbye='Thank you!\n Press Enter to close the program';
aaa=Screen('TextSize', w, 28);
DrawFormattedText(w, goodbye, 'center', 384-pixelsPerDeg*7, 0);
        if f_sig == true
            Screen('FillRect', w ,black ,Signal_area );
        end

Screen('Flip',w);
Snd('Play',[sin(1:20000) zeros(1,10000) sin(1:20000) zeros(1,10000) sin(1:20000)]);
disp('Thank you!  Press Enter to close the program')
priorityLevel = MaxPriority(w);
Priority(priorityLevel);

% wait for enter
[keyIsDown,seconds,keyCode] = KbCheck(-1);
while ~keyCode(enter)
    [keyIsDown,seconds,keyCode] = KbCheck(-1);
end

%% Close
Priority(0);
ShowCursor();
% Screen('CloseAll');
sca;

end
