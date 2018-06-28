function dataPcc = GetPropRightChoice(rawData)
%% �E�I�𗦂��v�Z����֐��ł���
%% ��ԏ��A�P�x���A�e�ʒu�ƋP�x���Ƃ̃g���C�A�����A�������A���̕W���΍����o�͂���
%% dataSet�͈���:��ԁA���ځF�P�x�A�O��ځF�� �ł��邱��

%�f�[�^�^�C�v
dataPcc.id          = rawData(1).exp.expID;
dataPcc.subjectID   = rawData(1).exp.subjectID;
dataPcc.date        = rawData(1).date;
dataPcc.description = 'Right Choice';
dataPcc.type        = 'CON';
if ~isnan( strfind( dataPcc.id, '4pos') ) 
    exp_id_initnamenum = strfind(dataPcc.id,'4pos') + length('4pos') -1 ;
    dataPcc.id = dataPcc.id(1:exp_id_initnamenum);
    dataSet = ExtractPLOA( rawData ); 
     
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
           dataPcc.condition(1).description = 'Up-Right(1)';%����
        end
        if conVar(n) == 2 
           dataPcc.condition(2).description = 'Up-Left(2)';%����
        end
        if conVar(n) == 3 
           dataPcc.condition(3).description = 'Low-Left(3)';%����
        end
        if conVar(n) == 4 
           dataPcc.condition(4).description = 'Low-Right(4)';%����
        end    
    end
    p =0; q=0; r=0; s=0;
    for n = 1:length(dataSet)
        if dataSet{n}(:,1) == 1
            p = p + 1;
            dataPcc.condition(1).data{p} = dataSet{n};            
        end
        if dataSet{n}(:,1) == 2
            q = q + 1;
            dataPcc.condition(2).data{q} = dataSet{n};            
        end        
        if dataSet{n}(:,1) == 3
            r = r + 1;
            dataPcc.condition(3).data{r} = dataSet{n};
        end
        if dataSet{n}(:,1) == 4
            s = s + 1;
            dataPcc.condition(4).data{s} = dataSet{n}; 
        end        
    end

end

%���ׂĂ̋P�x
dataPcc.x.value = unique(dataSet{1}(:, 2));
%% ��ԂƋP�x���ƂɁu�E�v�񓚗����v�Z���� 
if isfield(dataPcc.condition(1),'data') && isfield(dataPcc.condition(2),'data') && isfield(dataPcc.condition(3),'data') && isfield(dataPcc.condition(4),'data')
for c = 1:length(dataPcc.condition) 
    for n = 1:length(dataPcc.condition(c).data)
        for m = 1:length(dataPcc.x.value)
            dataPcc.condition(c).block{n}.dataLumVsConTrialNumMat(m) = 0; % �������ƂɊe�P�x��Ԃ̃g���C�A�������J�E���g
            dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat(m) = 0; % �������Ƃɐ��������J�E���g
            for d = 1:size(dataPcc.condition(c).data{n},1)
                if dataPcc.condition(c).data{n}(d,1) == c && dataPcc.condition(c).data{n}(d,2) == dataPcc.x.value(m) %condition, luminance 
                   dataPcc.condition(c).block{n}.dataLumVsConTrialNumMat(m) = dataPcc.condition(c).block{n}.dataLumVsConTrialNumMat(m) + 1;%count up
                   if dataPcc.condition(c).data{n}(d,3) == 45 && dataPcc.condition(c).data{n}(d,4) == 2 % right orientation, answer right,i.e. correct answer 
                      dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat(m) = dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat(m) + 1;
                   elseif dataPcc.condition(c).data{n}(d,3) == -45 && dataPcc.condition(c).data{n}(d,4) == 1 % Left orientation, answer left,i.e. correct answer 
                      dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat(m) = dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat(m) + 1; 
                   end
                end
            end
            dataPcc.condition(c).block{n}.dataLumVsConCorrectChoicePropMat(m) = dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat(m) ./ dataPcc.condition(c).block{n}.dataLumVsConTrialNumMat(m); % �������Ƃ� ������
            if isnan(dataPcc.condition(c).block{n}.dataLumVsConCorrectChoicePropMat(m))
                dataPcc.condition(c).block{n}.dataLumVsConCorrectChoicePropMat(m) = 0;   
            end
        end
        dataLumVsConTrialNumMat(:,c,n) = dataPcc.condition(c).block{n}.dataLumVsConTrialNumMat;
        dataLumVsConCorrectChoiceMat(:,c,n) = dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat;
        dataLumVsConCorrectChoicePropMat(:,c,n) = dataPcc.condition(c).block{n}.dataLumVsConCorrectChoicePropMat;
    end    
end
dataPcc.condition = rmfield( dataPcc.condition,'data' );
dataPcc.condition = rmfield( dataPcc.condition,'block' );

else
for n = 1:length(dataSet)
    for c = 1:length(dataPcc.condition) 
        for m = 1:length(dataPcc.x.value)
            dataLumVsConTrialNumMat(m,c,n) = 0; % �������ƂɊe������Ԃ̃g���C�A�������J�E���g
            dataLumVsConCorrectChoiceMat(m,c,n) = 0; % �������ƂɁu���v�񓚐����J�E���g
            for d = 1:size(dataSet{n},1)
                if dataSet{n}(d,1) == c && dataSet{n}(d,2) == dataPcc.x.value(m) 
                   dataLumVsConTrialNumMat(m,c,n) = dataLumVsConTrialNumMat(m,c,n) + 1;
                   if dataSet{n}(d,3) == 2 % �u���v�񓚂Ȃ��
                      dataLumVsConCorrectChoiceMat(m,c,n) = dataLumVsConCorrectChoiceMat(m,c,n) + 1;
                   end
                end
            end
            dataLumVsConCorrectChoicePropMat(m,c,n) = dataLumVsConCorrectChoiceMat(m,c,n) ./ dataLumVsConTrialNumMat(m,c,n); % �������ƂɁu���v�I��
        end
    end
end
end
%  dataLumVsConTrialNumMat
%  dataLumVsConCorrectChoiceMat
%  dataLumVsConCorrectChoicePropMat
% for c = 1:length(dataPcc.condition)
%     for n = 1:length(dataPcc.condition(c).data)
%         dataLumVsConTrialNumMat(:,c,n) = dataPcc.condition(c).block{n}.dataLumVsConTrialNumMat;
%         dataLumVsConCorrectChoiceMat(:,c,n) = dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat;
%         dataLumVsConCorrectChoicePropMat(:,c,n) = dataPcc.condition(c).block{n}.dataLumVsConCorrectChoicePropMat;
%     end    
% end




%dataPcc�Ŏg���̂Ŋi�[����

dataPcc.dataUsedinPcc.dataLumVsConTrialNumMat = dataLumVsConTrialNumMat;
dataPcc.dataUsedinPcc.dataLumVsConCorrectChoiceMat = dataLumVsConCorrectChoiceMat;
dataPcc.dataUsedinPcc.dataLumVsConCorrectChoicePropMat = dataLumVsConCorrectChoicePropMat;

dataPcc.all.dataUsedinPcc.dataLumVsConCorrectChoicePropMat = mean(dataPcc.dataUsedinPcc.dataLumVsConCorrectChoicePropMat,2);

%%
% dataAlldpMat = repmat(dataPcc.x.value,1,length(dataPcc.condition)); 
%�S�����̊e������Ԃ́E�E�E����
dataTrialMat = sum(dataLumVsConTrialNumMat,3); % �g���C�A����
dataCorrectChoicePropMat = mean(dataLumVsConCorrectChoicePropMat,3); % ���ϐ�����
dataCorrectChoiceSDMat = std(dataLumVsConCorrectChoicePropMat, [],3); % �W���΍� 
%��Ԃ��ƂɁE�E�E�i�[
for n = 1:length(dataPcc.condition)
    dataPcc.condition(n).rawTrialNum = dataTrialMat(:,n);% �g���C�A����
    dataPcc.condition(n).rawDataValue = dataCorrectChoicePropMat(:,n);% ���ρu���v�I��
    dataPcc.condition(n).rawDataEbar = dataCorrectChoiceSDMat(:,n); % �W���΍� 
end
%��Ԃ𕽋ς��� %�R�R�K�A�E�g�I�I�I�I�I�I�I�I�I�I�I�I���ς̕��ς͂���
dataPcc.all.rawTrialNum = sum(dataTrialMat,2);
dataPcc.all.rawDataValue = mean(dataCorrectChoicePropMat,2);
dataPcc.all.rawDataEbar = mean(dataCorrectChoiceSDMat,2);
%������(MakePlot�Ō���W�������߂�Ƃ��Ɏg�p)
dataPcc.ExpNum = size(dataPcc.dataUsedinPcc.dataLumVsConCorrectChoicePropMat,3);

%���E�ŕ��ς���
dataPcc.left.rawTrialNum = ( dataPcc.condition(2).rawTrialNum + dataPcc.condition(3).rawTrialNum ) / 2;
dataPcc.left.rawDataValue = ( dataPcc.condition(2).rawDataValue + dataPcc.condition(3).rawDataValue ) / 2;
dataPcc.left.rawDataEbar = ( dataPcc.condition(2).rawDataEbar + dataPcc.condition(3).rawDataEbar ) / 2;
dataPcc.right.rawTrialNum = ( dataPcc.condition(1).rawTrialNum + dataPcc.condition(4).rawTrialNum ) / 2;
dataPcc.right.rawDataValue = ( dataPcc.condition(1).rawDataValue + dataPcc.condition(4).rawDataValue ) / 2;
dataPcc.right.rawDataEbar = ( dataPcc.condition(1).rawDataEbar + dataPcc.condition(4).rawDataEbar ) / 2;


%�]��
dataPcc.all.correctchoice = mean(dataPcc.all.rawDataValue);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfunction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataPLOA = ExtractPLOA( rawData )
%% ExtractPLA �f�[�^����ʒu(Position)�ƋP�x(Luminance)�ƕ���(orientation)�Ɖ�(Answer)�𒊏o���e�������Ƃɍs��𐶐�
%   ����:�ʒu(�ԍ�)�A���ځF�����A�O��ځF��

for n = 1:length(rawData)
%�ʒu

    for m = 1:length(rawData(n).data)
        dataPosLR(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimPos(1);
        dataPosUD(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimPos(2);
    end

%�P�x

    for m = 1:length(rawData(n).data)
        dataLum(m,1) = rawData(n).data(m).trial.stim(2).parameters.contrast;
    end
    
%����

    for m = 1:length(rawData(n).data)
        dataOri(m,1) = rawData(n).data(m).trial.stim(2).parameters.orientation;
    end    

%��

    for m = 1:length(rawData(n).data)
        dataAns(m,1) = rawData(n).data(m).response;
    end

%�܂Ƃ�

    dataSet{n} = horzcat( dataPosLR, dataPosUD, dataLum, dataOri, dataAns );
    dataSetTemp = isnan(dataSet{n}(:,5));
    dataPLOA{n}= dataSet{n}(dataSetTemp ~= 1,:);%�ʒu(���E)�A�ʒu(�㉺)�A�P�x�A���ʁA��
 
    
        for m = 1:size(dataPLOA{n},1)
            if dataPLOA{n}(m,1) > 0 && dataPLOA{n}(m,2) < 0
                dataPosName(m,1) = 1;
            end
            if dataPLOA{n}(m,1) < 0 && dataPLOA{n}(m,2) < 0
                dataPosName(m,1) = 2;
            end
            if dataPLOA{n}(m,1) < 0 && dataPLOA{n}(m,2) > 0
                dataPosName(m,1) = 3;
            end
            if dataPLOA{n}(m,1) > 0 && dataPLOA{n}(m,2) > 0
                dataPosName(m,1) = 4;
            end
        end

    
    dataPLOA{n} = horzcat(dataPosName,dataPLOA{n}(:,3), dataPLOA{n}(:,4), dataPLOA{n}(:,5));%�ʒu(���O�Â�)�A�P�x�A���ʁA��
   
    clear dataPosName dataPosLR dataPosUD dataLum dataOri dataAns dataSetTemp;
end
clear dataSet



