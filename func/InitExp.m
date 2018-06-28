function exp = InitExp(exp_id, subject_id)
% InitExp    ÀŒ±î•ñ\‘¢‘Ì exp ‚ğ‰Šú‰»‚·‚é
%

protocol_dir = './protocol/';

% General Info
exp.date      = datestr(now, 'yyyy-mm-dd');
exp.beginTime = datestr(now, 'HH:MM:SS');

exp.expID     = exp_id;
exp.subjectID = subject_id;

try
    fid = fopen([ protocol_dir exp_id '.prtc' ], 'rt');
    es = '';
    while 1
        l = fgetl(fid);
        if ~ischar(l)
            break;
        end
        es = sprintf('%s\n%s', es, l);
    end
    fclose(fid);

    eval(es);
catch
    error([ 'Error while loading protocol ' exp.expID ]);
end

%% stimPattern ‚Ì‰Šú‰»
for n = 1:length(exp.trial)
for m = 1:length(exp.trial(n).stim)
    exp.trial(n).stim(m).parameters.stimPattern = NaN;
    exp.trial(n).stim(m).parameters.updateStim  = 1;
    if ~isfield(exp.trial(n).stim(m).parameters, 'stimFreq')
        exp.trial(n).stim(m).parameters.stimFreq = exp.trial(n).flipFreq;
    end
end
end

