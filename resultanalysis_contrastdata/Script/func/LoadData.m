function rawData = LoadData(dataFiles)
% LoadData    ê∂ÉfÅ[É^Çì«Ç›çûÇﬁ

for n = 1:length(dataFiles)
    load(dataFiles{n});

    rawData(n).data = data; 
    rawData(n).env  = env;

    rawData(n).exp.expID      = exp.expID;
    rawData(n).exp.subjectID  = exp.subjectID;
    rawData(n).date           = exp.date;
    rawData(n).beginTime      = exp.beginTime;
end
