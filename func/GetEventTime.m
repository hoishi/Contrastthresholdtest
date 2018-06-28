function rt = GetEventTime(tt, event)
% GetEventTime    tt (timetable \‘¢‘Ì) ‚©‚ç event ‚É‘Î‰‚µ‚½ŠÔ‚ğ•Ô‚·D

rt = NaN;

for n = 1:length(tt)
    if strcmp(tt(n).event, event)
        rt = tt(n).trialTime;
    end
end

