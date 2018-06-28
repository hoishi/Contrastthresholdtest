function PsyExp(exp_id, subject_id, isDebug)
% PsyExp    視覚心理実験用プログラム

%% 引数処理
if ~exist('exp_id'),     exp_id     = 'DEMO';    end
if ~exist('subject_id'), subject_id = 'TESTSUB'; end
if ~exist('isDebug'),    isDebug    = true;      end

%% 初期化
addpath './func';
% reset display gamma-function
ResetDisplayGammaPTB();
% force to 10-bit display output
AssertOpenGL;
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','FloatingPoint32BitIfPossible'); % try to get 32 bpc fload precision if the hardware supports
PsychImaging('AddTask','General','EnableNative10BitFramebuffer'); % enable 10-bit color depth (generally for ATI graphic cards, but also effective for some nVidia cards)

KbName('UnifyKeyNames');
HideCursor;

env = InitEnv();
tm  = InitTm(env);
st  = InitSt(env);
exp = InitExp(exp_id, subject_id);



currentTimeString = datestr(now, 'yyyymmddTHHMMSS');

%% Create PTB window
Screen('Preference', 'SkipSyncTests', 0); % for Win10 function

[ env.scrnNum, env.wndPtr ] = CreateMONOWindow(env.stereoMode, env.lut);

% BackupCluts(max(Screen('Screens')));%元のガンマを保存する
% %ガンマ補正
% load('gammatablePTB.mat','gammatable');
% Screen('LoadNormalizedGammaTable', env.wndPtr, gammatable)

if ~isfield(env, 'scrnWidth'), env.scrnRect = Screen('Rect', env.scrnNum);                                end
if ~isfield(env, 'wndRect'),   env.wndRect  = Screen('Rect', env.wndPtr);                                 end
if ~isfield(env, 'scrnSize'),  [ env.scrnSize(1), env.scrnSize(2) ] = Screen('DisplaySize', env.scrnNum); end
if ~isfield(env, 'wndSize'),   [ env.wndSize(1),  env.wndSize(2)  ]  = Screen('WindowSize', env.wndPtr);  end
if ~isfield(env, 'scrnhz'),    env.scrnHz   = Screen('FrameRate', env.scrnNum);                           end

if env.scrnHz <= 0, env.scrnHz = 60; end % In some systems, PTB fails to get FrameRate %%%%%%

env.wndCenter = [ env.wndSize(1) / 2, env.wndSize(2) / 2 ];

% previous setting
% env.whiteIndex = WhiteIndex(env.scrnNum);
% env.blackIndex = BlackIndex(env.scrnNum);

% 10bit setting
env.whiteIndex = env.lut(1024);
env.blackIndex = env.lut(1);

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    while 1

        % 実験終了判定
        if st.trialCount > length(exp.trial)
            break;
        end
        
        % tm 構造体の更新
        tm.timeCurrent = GetSecs;
        tm.timePrevFlip = tm.timeFlip;

        st.stimUpdated = zeros(size(exp.trial(st.trialCount).stim));

        % Key check
        [ keyIsDown, secs, keyCode, deltaSecs ] = KbCheck;
        if keyIsDown
            if keyCode(KbName('ESCAPE')), break, end
            if keyCode(KbName('SPACE'))
                st.initExp = true;
            end
        end

        % 実験開始キーが押されるまで待機
        if ~st.initExp
            continue;
        end

        % Trial 初期化処理
        if st.initTrial
            st.initTrial = false;
            tm.timeInitTrial = tm.timeCurrent;

            % 刺激パターン更新時刻の初期化
            for n = 1:length(exp.trial(st.trialCount).stim)
                st.prevStimUpdateTime(n) = -Inf;
            end

            disp('--------------------------------------------------------------------------------');
            disp(['Trial count: ' num2str(st.trialCount)]);
        end

        %% 現在時刻に応じたフラグ設定
        timeElapsed = tm.timeCurrent - tm.timeInitTrial;
        st.doFlipForced = false;

        % 試行終了の判定
        if timeElapsed > GetEventTime(exp.trialTimeTable, 'END_TRIAL');
            st.terminateTrial = true;
        end

        % 刺激描画の判定
        for n = 1:length(exp.trial(st.trialCount).stim)
            if timeElapsed >= GetEventTime(exp.trialTimeTable, sprintf('STIM%02d_ONSET', n)) && timeElapsed <= GetEventTime(exp.trialTimeTable, sprintf('STIM%02d_OFFSET', n))
                if st.showStim(n) == 0;
                    st.doFlipForced = true;
                end
                st.showStim(n) = 1;
            else
                if st.showStim(n) == 1;
                    st.doFlipForced = true;
                end
                st.showStim(n) = 0;
            end
        end

        % 反応受け付けの判定
        if timeElapsed >= GetEventTime(exp.trialTimeTable, 'RESPONSE_ONSET') && timeElapsed <= GetEventTime(exp.trialTimeTable, 'RESPONSE_OFFSET')
            st.acceptResp = true;
        else
            st.acceptResp = false;
        end

        %% フラグに応じた各種処理
        % 刺激提示
        for n = 1:length(exp.trial(st.trialCount).stim)
            if st.showStim(n)
                % 刺激パターンの更新判定
                if tm.timeCurrent - st.prevStimUpdateTime(n) > 1 / exp.trial(st.trialCount).stim(n).parameters.stimFreq
                    exp.trial(st.trialCount).stim(n).parameters.updateStim = 1;

                    st.prevPrevStimUpdateTime(n) = st.prevStimUpdateTime(n);
                    st.prevStimUpdateTime(n)     = tm.timeCurrent;

                    st.stimUpdated(n) = 1;
                else
                    exp.trial(st.trialCount).stim(n).parameters.updateStim = 0;
                    st.stimUpdated(n) = 0;
                end

                % 刺激の描画
                exp.trial(st.trialCount).stim(n).parameters.stimPattern = ...
                    exp.trial(st.trialCount).stim(n).drawFunc(env, tm, exp.trial(st.trialCount).stim(n).parameters);
                tm.timeUpdateStim(n) = tm.timeCurrent;
            end
        end

        % 反応処理
        if   ~isnan( strfind(exp_id,'UR') )
            if st.acceptResp
                if keyIsDown
                    % 無効なキーが押されたとき，前回押された有効なキー入力を保持する
                    tmpResp = GetResp(exp.response, keyCode);
                    if ~isnan(tmpResp)
                        st.currentResp = tmpResp;
                    end
                end
                if exp.showFeedback && ~isnan(st.currentResp)
                    for s = [ 0, 1 ]
                        fbStr = exp.feedbackTxt{st.currentResp};
                        Screen('TextSize', env.wndPtr, 30);
                        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', env.wndPtr, fbStr);
%                         Screen('SelectStereoDrawBuffer', env.wndPtr, s);
                        DrawFormattedText(env.wndPtr, fbStr, ...
                                          env.wndCenter(1) - normBoundsRect(RectRight) / 2, ...
                                          env.wndCenter(2) - normBoundsRect(RectBottom) / 2 , ...
                                          [env.lut(1024),env.lut(1024),env.lut(1024)]);
                    end
                end
            end
        end
        if  ~isnan( strfind(exp_id,'UL') )
            if st.acceptResp
                if keyIsDown
                    % 無効なキーが押されたとき，前回押された有効なキー入力を保持する
                    tmpResp = GetResp(exp.response, keyCode);
                    if ~isnan(tmpResp)
                        st.currentResp = tmpResp;
                    end
                end
                if exp.showFeedback && ~isnan(st.currentResp)
                    for s = [ 0, 1 ]
                        fbStr = exp.feedbackTxt{st.currentResp};
                        Screen('TextSize', env.wndPtr, 30);
                        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', env.wndPtr, fbStr);
%                         Screen('SelectStereoDrawBuffer', env.wndPtr, s);
                        DrawFormattedText(env.wndPtr, fbStr, ...
                                          env.wndCenter(1) - normBoundsRect(RectRight) / 2, ...
                                          env.wndCenter(2) - normBoundsRect(RectBottom) / 2 , ...
                                          [env.lut(1024),env.lut(1024),env.lut(1024)]);
                    end
                end
            end
        end
        if  ~isnan( strfind(exp_id,'DL') )
            if st.acceptResp
                if keyIsDown
                    % 無効なキーが押されたとき，前回押された有効なキー入力を保持する
                    tmpResp = GetResp(exp.response, keyCode);
                    if ~isnan(tmpResp)
                        st.currentResp = tmpResp;
                    end
                end
                if exp.showFeedback && ~isnan(st.currentResp)
                    for s = [ 0, 1 ]
                        fbStr = exp.feedbackTxt{st.currentResp};
                        Screen('TextSize', env.wndPtr, 30);
                        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', env.wndPtr, fbStr);
%                         Screen('SelectStereoDrawBuffer', env.wndPtr, s);
                        DrawFormattedText(env.wndPtr, fbStr, ...
                                          env.wndCenter(1) - normBoundsRect(RectRight) / 2, ...
                                          env.wndCenter(2) - normBoundsRect(RectBottom) / 2 , ...
                                          [env.lut(1024),env.lut(1024),env.lut(1024)]);
                    end
                end
            end
        end
        if  ~isnan( strfind(exp_id,'DR') )
            if st.acceptResp
                if keyIsDown
                    % 無効なキーが押されたとき，前回押された有効なキー入力を保持する
                    tmpResp = GetResp(exp.response, keyCode);
                    if ~isnan(tmpResp)
                        st.currentResp = tmpResp;
                    end
                end
                if exp.showFeedback && ~isnan(st.currentResp)
                    for s = [ 0, 1 ]
                        fbStr = exp.feedbackTxt{st.currentResp};
                        Screen('TextSize', env.wndPtr, 30);
                        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', env.wndPtr, fbStr);
%                         Screen('SelectStereoDrawBuffer', env.wndPtr, s);
                        DrawFormattedText(env.wndPtr, fbStr, ...
                                          env.wndCenter(1) - normBoundsRect(RectRight) / 2, ...
                                          env.wndCenter(2) - normBoundsRect(RectBottom) / 2 , ...
                                          [env.lut(1024),env.lut(1024),env.lut(1024)]);
                    end
                end
            end
        end        
            
        tm.timeFlip = Screen('Flip', env.wndPtr, 0);

        % Trial 終了処理
        if st.terminateTrial
            st.initTrial = true;
            st.terminateTrial = false;

            data(st.dataCount).trial    = exp.trial(st.trialCount);
            data(st.dataCount).response = st.currentResp;
            st.dataCount = st.dataCount + 1;

            % 被験者の反応に応じた処理
            if ~isnan(st.currentResp)
                disp([ 'Choice: ' num2str(st.currentResp) ]);
                st.currentResp = NaN;
                st.trialCount = st.trialCount + 1;
            else
                exp.trial(st.trialCount:end) = Shuffle(exp.trial(st.trialCount:end));
            end
        end

        %% Main loop 終了処理
        % キークリア
        clear keyIsDown secs keyCode deltaSecs;

        % デバッグ情報の出力
        if isDebug, DebugLog(fid, env, st, tm); end

        % 描画時刻の出力
        if ~isDebug, DispFrameRate(tm); end

    end
catch
    %% エラー処理
    if isDebug, fclose(fid); end
    Screen('CloseAll');
    ShowCursor;
    psychrethrow(psychlasterror);
end

%% 実験終了の表示

for s = [ 0, 1 ]
    endStr = sprintf('The experiment has been completed!\nThank you!');
    Screen('TextSize', env.wndPtr, 30);
    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', env.wndPtr, endStr);

%     Screen('SelectStereoDrawBuffer', env.wndPtr, s);
    DrawFormattedText(env.wndPtr, endStr, ...
                      env.wndCenter(1)  - normBoundsRect(RectRight) / 2, ...
                      env.wndCenter(2) - normBoundsRect(RectBottom) / 2, ...
                      [env.lut(1024),env.lut(1024),env.lut(1024)]);
end
tm.timeFlip = Screen('Flip', env.wndPtr, 0); % 

%% データ保存
if exist('data')
    save([ exp.expID '_' exp.subjectID '_' currentTimeString '.mat' ], 'env', 'exp', 'data');
else
    save([ exp.expID '_' exp.subjectID '_' currentTimeString '.mat' ], 'env', 'exp');
end

% input('Press any key to exit');

sca;%CLUTSを戻す
%% Terminate program
if isDebug, fclose(fid); end
Screen('CloseAll')
ShowCursor;

