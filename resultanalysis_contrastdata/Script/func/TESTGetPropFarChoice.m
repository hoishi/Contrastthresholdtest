function dataPfc = TESTGetPropFarChoice(rawData)
%% ���v�I�𗦂��v�Z����֐��ł���
%% ��ԏ��A�������A�e�ʒu�Ǝ������Ƃ̃g���C�A�����A�u���v�I�𗦁A���̕W���΍����o�͂���
%% dataSet�͈���:��ԁA���ځF�����A�O��ځF�� �ł��邱��

%�f�[�^�^�C�v
dataPfc.id          = rawData(1).exp.expID;
dataPfc.subjectID   = rawData(1).exp.subjectID;
dataPfc.date        = rawData(1).date;
dataPfc.description = 'Far Choice';
dataPfc.type        = 'PFC';
if ~isnan( strfind( dataPfc.id, '4pos') ) 
    dataSet = ExtractPDA( rawData ); 
    %���ׂĂ̏��
    for n = 1:length(dataSet)
        a(:,n) =  dataSet{n}(:,1);
    end
    conVar = unique(a);
    clear a;
    %��Ԃɖ��̂�t����
    %��ԏ��: �ʒu���
    for n = 1:length(conVar)
        if conVar(n) == 1 
           dataPfc.condition(n).description = 'Up-Right(1)';%����
        end
        if conVar(n) == 2 
           dataPfc.condition(n).description = 'Up-Left(2)';%����
        end
        if conVar(n) == 3 
           dataPfc.condition(n).description = 'Low-Left(3)';%����
        end
        if conVar(n) == 4 
           dataPfc.condition(n).description = 'Low-Right(4)';%����
        end    
    end    
end
    
    
if ~isnan( strfind( dataPfc.id, '3freq') )    
    dataSet = ExtractRDA( rawData );
    %���ׂĂ̏��
    conVar = unique(dataSet{1}(:,1));
    %��ԏ��: ���t���b�V�����[�g
    for n = 1:length(conVar)
        if conVar(n) == 1 
           dataPfc.condition(n).description = '42.5 [Hz](1)';%����
        end
        if conVar(n) == 2 
           dataPfc.condition(n).description = '21.25 [Hz](2)';%����
        end
        if conVar(n) == 3 
           dataPfc.condition(n).description = '10.625 [Hz](3)';%����
        end
    end    
end


%���ׂĂ̎���
dataPfc.x.value = unique(dataSet{1}(:, 2));
%% ��ԂƎ������ƂɁu���v�񓚗����v�Z����    
for n = 1:length(dataSet)
    for c = 1:length(dataPfc.condition) 
        for m = 1:length(dataPfc.x.value)
            dataDispVsConTrialNumMat(m,c,n) = 0; % �������ƂɊe������Ԃ̃g���C�A�������J�E���g
            dataDispVsConFarChoiceMat(m,c,n) = 0; % �������ƂɁu���v�񓚐����J�E���g
            for d = 1:size(dataSet{n},1)
                if dataSet{n}(d,1) == c && dataSet{n}(d,2) == dataPfc.x.value(m) 
                   dataDispVsConTrialNumMat(m,c,n) = dataDispVsConTrialNumMat(m,c,n) + 1;
                   if dataSet{n}(d,3) == 2 % �u���v�񓚂Ȃ��
                      dataDispVsConFarChoiceMat(m,c,n) = dataDispVsConFarChoiceMat(m,c,n) + 1;
                   end
                end
            end
            dataDispVsConFarChoicePropMat(m,c,n) = dataDispVsConFarChoiceMat(m,c,n) ./ dataDispVsConTrialNumMat(m,c,n); % �������ƂɁu���v�I��
            if isnan(dataDispVsConFarChoicePropMat(m,c,n))
                dataDispVsConFarChoicePropMat(m,c,n) = 0;   
            end
        end
    end
end

%  dataDispVsConTrialNumMat
%  dataDispVsConFarChoiceMat
%  dataDispVsConFarChoicePropMat


%dataPcc�Ŏg���̂Ŋi�[����
for n = 1:length(dataSet)
    dataPfc.dataUsedinPcc.dataDispVsConTrialNumMat = dataDispVsConTrialNumMat;
    dataPfc.dataUsedinPcc.dataDispVsConFarChoiceMat = dataDispVsConFarChoiceMat;
    dataPfc.dataUsedinPcc.dataDispVsConFarChoicePropMat = dataDispVsConFarChoicePropMat;
end

%%
% dataAlldpMat = repmat(dataPfc.x.value,1,length(dataPfc.condition)); 
%�S�����̊e������Ԃ́E�E�E
dataTrialMat = sum(dataDispVsConTrialNumMat,3); % �g���C�A����
dataFarChoicePropMat = 4*mean(dataDispVsConFarChoicePropMat,3); % ���ρu���v�I��
dataFarChoiceSDMat = std(dataDispVsConFarChoicePropMat, [],3); % �W���΍� 
%��Ԃ��ƂɁE�E�E
for n = 1:length(dataPfc.condition)
    dataPfc.condition(n).rawTrialNum = dataTrialMat(:,n);% �g���C�A����
    dataPfc.condition(n).rawDataValue = dataFarChoicePropMat(:,n);% ���ρu���v�I��
    dataPfc.condition(n).rawDataEbar = dataFarChoiceSDMat(:,n); % �W���΍� 
end
%������(MakePlot�Ō���W�������߂�Ƃ��Ɏg�p)
dataPfc.ExpNum = length(dataSet);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfunction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataPDA = ExtractPDA( rawData )
%% ExtractPDA �f�[�^����ʒu(Position)�Ǝ���(Disparity)�Ɖ�(Answer)�𒊏o���e�������Ƃɍs��𐶐�
%   ����:�ʒu(�ԍ�)�A���ځF�����A�O��ځF��

for n = 1:length(rawData)
%�ʒu

    for m = 1:length(rawData(n).data)
        dataPosLR(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimPos(1);
        dataPosUD(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimPos(2);
    end

%����

    for m = 1:length(rawData(n).data)
        dataDisp(m,1) = rawData(n).data(m).trial.stim(2).parameters.disparity(1);
    end

%��

    for m = 1:length(rawData(n).data)
        dataAns(m,1) = rawData(n).data(m).response;
    end

%�܂Ƃ�

    dataSet{n} = horzcat( dataPosLR, dataPosUD, dataDisp, dataAns );
    dataSetTemp = isnan(dataSet{n}(:,4));
    dataPDA{n}= dataSet{n}(dataSetTemp ~= 1,:);%�ʒu(���E)�A�ʒu(�㉺)�A�����A��
    for m = 1:length(dataPDA{n})
        if dataPDA{n}(m,1) > -2*atan(596.7400/10/2/2/160/2)*180/pi && dataPDA{n}(m,2) < 0
            dataPosName(m,1) = 1;
        end
        if dataPDA{n}(m,1) < -2*atan(596.7400/10/2/2/160/2)*180/pi && dataPDA{n}(m,2) < 0
            dataPosName(m,1) = 2;
        end
        if dataPDA{n}(m,1) < -2*atan(596.7400/10/2/2/160/2)*180/pi && dataPDA{n}(m,2) > 0
            dataPosName(m,1) = 3;
        end
        if dataPDA{n}(m,1) > -2*atan(596.7400/10/2/2/160/2)*180/pi && dataPDA{n}(m,2) > 0
            dataPosName(m,1) = 4;
        end
    end
    dataPDA{n} = horzcat(dataPosName,dataPDA{n}(:,3), dataPDA{n}(:,4));%�ʒu(���O�Â�)�A�����A��
   
    clear dataPosName dataPosLR dataPosUD dataDisp dataAns dataSetTemp;
end



function dataRDA = ExtractRDA( rawData )
%% ExtractRDA �f�[�^����h���̃��t���b�V�����[�g(Refresh Rate)�Ǝ���(Disparity)�Ɖ�(Answer)�𒊏o���e�������Ƃɍs��𐶐�
%   ����:�ʒu(�ԍ�)�A���ځF�����A�O��ځF��

for n = 1:length(rawData)
%�h���̃��t���b�V�����[�g

    for m = 1:length(rawData(n).data)
        dataRef(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimFreq;
    end

%����

    for m = 1:length(rawData(n).data)
        dataDisp(m,1) = rawData(n).data(m).trial.stim(2).parameters.disparity(1);
    end

%��

    for m = 1:length(rawData(n).data)
        dataAns(m,1) = rawData(n).data(m).response; 
    end

%�܂Ƃ�

    dataSet{n} = horzcat( dataRef, dataDisp, dataAns );
    dataSetTemp = isnan(dataSet{n}(:, 3));
    dataRDA{n}= dataSet{n}(dataSetTemp ~= 1,:);%�h���̃��t���b�V�����[�g�A�����A��
    for m = 1:length(dataRDA{n})
        if dataRDA{n}(m,1) == 42.5000
            dataRefName(m,1) = 1;
        end
        if dataRDA{n}(m,1) == 21.2500
            dataRefName(m,1) = 2;
        end
        if dataRDA{n}(m,1) == 10.6250
            dataRefName(m,1) = 3;
        end
    end
    dataRDA{n} = horzcat(dataRefName,dataRDA{n}(:,2), dataRDA{n}(:,3));%�h���̃��t���b�V�����[�g(���O�Â�)�A�����A��
   
    clear dataRefName dataRef dataDisp dataAns dataSetTemp;
end