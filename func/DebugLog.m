function DebugLog(fid, env, st, tm)
% DebugLog    デバッグログを出力する

logstr = sprintf('%f:', tm.timeCurrent);

for n = 1:env.stimNum
    if st.showStim(n)
        logstr = sprintf('%s STIM_%02d_ON', logstr, n);
    end
end

for n = 1:length(st.stimUpdated)
    if st.stimUpdated(n)
        elapsedTimeStimUpdate = st.prevStimUpdateTime(n) - st.prevPrevStimUpdateTime(n);
        logstr = sprintf('%s STIM_%02d_UPDATED (interval %f; refresh rate %f)', ...
                         logstr, n, elapsedTimeStimUpdate, 1/elapsedTimeStimUpdate);
    end
end

if st.acceptResp
    logstr = sprintf('%s ACCEPT_RESP', logstr);
end
if ~isnan(st.currentResp)
    logstr = sprintf('%s RESP: %d', logstr, st.currentResp);
end

fprintf(1,   '%s\n', logstr);
fprintf(fid, '%s\n', logstr);

if tm.timeFlip ~= tm.timePrevFlip
    elapsedTime = tm.timeFlip - tm.timePrevFlip;

    if st.doFlipForced
        logstr = sprintf('%f: FLIP_FORCED (flip interval %f; fps %f)', tm.timeFlip, elapsedTime, 1/elapsedTime);
    else
        logstr = sprintf('%f: FLIP (flip interval %f; fps %f)', tm.timeFlip, elapsedTime, 1/elapsedTime);
    end

    fprintf(1,   '%s\n', logstr);
    fprintf(fid, '%s\n', logstr);
end

