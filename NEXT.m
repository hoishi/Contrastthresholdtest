function NEXT(exp_id, subject_id, isDebug)
% PsyExp    視覚心理実験用プログラム

%% 引数処理
if ~exist('exp_id'),     exp_id     = 'DEMO';    end
if ~exist('subject_id'), subject_id = 'TESTSUB'; end
if ~exist('isDebug'),    isDebug    = true;      end

%% 初期化
addpath './func';

AssertOpenGL;
KbName('UnifyKeyNames');
HideCursor;

env = InitEnv();
tm  = InitTm(env);
st  = InitSt(env);
exp = InitExp(exp_id, subject_id);

currentTimeString = datestr(now, 'yyyymmddTHHMMSS');

%% Create PTB window
[ env.scrnNum, env.wndPtr ] = CreateMONOWindow(env.stereoMode, env.bgColor);

if ~isfield(env, 'scrnWidth'), env.scrnRect = Screen('Rect', env.scrnNum);                                end
if ~isfield(env, 'wndRect'),   env.wndRect  = Screen('Rect', env.wndPtr);                                 end
if ~isfield(env, 'scrnSize'),  [ env.scrnSize(1), env.scrnSize(2) ] = Screen('DisplaySize', env.scrnNum); end
if ~isfield(env, 'wndSize'),   [ env.wndSize(1),  env.wndSize(2)  ]  = Screen('WindowSize', env.wndPtr);  end
if ~isfield(env, 'scrnhz'),    env.scrnHz   = Screen('FrameRate', env.scrnNum);                           end

if env.scrnHz <= 0, env.scrnHz = 60; end % In some systems, PTB fails to get FrameRate

env.wndCenter = [ env.wndSize(1) / 2, env.wndSize(2) / 2 ];

env.whiteIndex = WhiteIndex(env.scrnNum);
env.blackIndex = BlackIndex(env.scrnNum);

% 視野角をピクセルに変換する関数の設定
env.deg2px_hrz = @(x) 2 * env.viewDistance * env.wndSize(1) / ( env.scrnSize(1) * 0.1 ) * tan( (x / 180) * pi / 2 );
env.deg2px_vrt = @(x) 2 * env.viewDistance * env.wndSize(2) / ( env.scrnSize(2) * 0.1 ) * tan( (x / 180) * pi / 2 );

% 情報表示
fprintf('================================================================================\n');
fprintf('\tScreen Info\n');
fprintf('\tScreen Num:\t\t\t%d\n', env.scrnNum);
fprintf('\tScreen Size (mm):\t%f x %f\n', env.scrnSize(1), env.scrnSize(2));
fprintf('\tScreen Frame Rate:\t%f\n', env.scrnHz);
fprintf('\tWindow Ptr:\t\t\t%d\n', env.wndPtr);
fprintf('\tWindow Size (px):\t%d x %d\n', env.wndSize(1), env.wndSize(2));
fprintf('\n');
fprintf('\tExperiment info\n');
fprintf('\tEXP ID:\t\t%s\n', exp.expID);
fprintf('\tSubject ID:\t%s\n', exp.subjectID);
fprintf('\tTotal trial num:\t%d\n', length(exp.trial));
fprintf('================================================================================\n');

%% Open debug log file
if isDebug
    dlfname = [ exp.expID '_' exp.subjectID '_' currentTimeString '.log' ];
    fid = fopen(dlfname, 'w');
end

%% 実験終了の表示

for s = [ 0, 1 ]
    if strfind(exp_id,'UR') 
        message = 'The next experiment stimulus \nposition is Up-Right';
    end
    if strfind(exp_id,'UL') 
        message = 'The next experiment stimulus \nposition is Up-Left';
    end
    if strfind(exp_id,'DL') 
        message = 'The next experiment stimulus \nposition is Down-Left';
    end
    if strfind(exp_id,'DR') 
        message = 'The next experiment stimulus \nposition is Down-Right';
    end    
    endStr = sprintf(message);
    Screen('TextSize', env.wndPtr, 30);
    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', env.wndPtr, endStr);

    Screen('SelectStereoDrawBuffer', env.wndPtr, s);
    DrawFormattedText(env.wndPtr, endStr, ...
                      env.wndCenter(1) - normBoundsRect(RectRight) / 2, ...
                      env.wndCenter(2) - normBoundsRect(RectBottom) / 2, ...
                      [255 255 255]);
end
tm.timeFlip = Screen('Flip', env.wndPtr, 0); % 

input('Press any key to exit');

%% Terminate program
if isDebug, fclose(fid); end
Screen('CloseAll')
ShowCursor;

