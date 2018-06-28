function tm = InitTm(env)
% InitTm    tm 構造体を初期化する

tm.timeCurrent    = GetSecs;               % 現在時刻
tm.timeStart      = tm.timeCurrent;        % 実験開始時刻
tm.timeInitTrial  = tm.timeCurrent;        % 試行開始時刻
tm.timeFlip       = 0;                     % 画面をフリップした時刻
tm.timePrevFlip   = 0;                     % 前回画面をフリップした時刻
tm.timeUpdateStim = zeros(env.stimNum, 1); % 刺激更新時刻

