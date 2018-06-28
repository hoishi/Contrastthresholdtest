function st = InitSt(env)
% InitSt    st 構造体を初期化する

st.initExp        = false;                 % 実験開始フラグ
st.trialCount     = 1;                     % 試行カウンタ
st.dataCount      = 1;                     % データカウンタ
st.initTrial      = true;                  % 試行初期化フラグ
st.terminateTrial = false;                 % 試行終了フラグ
st.showStim       = zeros(env.stimNum, 1); % 刺激提示フラグ
st.acceptResp     = false;                 % 反応受け付けフラグ
st.currentResp    = NaN;                   % 現在の試行における被験者の反応を格納するバッファ
st.doFlipForced   = false;                 % 強制フリップのフラグ
