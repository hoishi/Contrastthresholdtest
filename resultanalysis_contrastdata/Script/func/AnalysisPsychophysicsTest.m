function AnalysisPsychophysicsTest()
% AnalysisStereoTest    Stereo test �̃f�[�^��́E�����X�N���v�g
%
% Usage:
%
% - ���s����ƁC�t�@�C���I���_�C�A���O���\�������D��͑Ώۂ̃t�@�C����I������D
% - ���S�̐�Ύ����ɑ΂��� Prop far choice �ƁC���S�̐�Ύ������x�ɑ΂��鐳�������v�Z����D
% - ���S�̐�Ύ����ɑ΂��� Prop far choice �ƁC���S�̐�Ύ������x�ɑ΂��鐳�����̂��ꂼ��ɑ΂��āC�S������֐����t�B�b�e�B���O����D
% - Figure ���쐬���C���S�̐�Ύ����ɑ΂��� Prop far choice �ƁC���S�̐�Ύ������x�ɑ΂��鐳�������C�t�B�b�g�����S������֐��ƂƂ��ɁC�\������D
%

addpath('./lib');

dataFiles = GetFilesUI('data');

%% dataFiles �̊e�t�@�C����ǂݍ��݁A�f�[�^�s����쐬����@%%�ЂƂЂƂf�[�^�s���TEXTREAD�œǂݍ��ށ@�o�͊e�֐��̈Ӗ��H
for n = 1:length(dataFiles)
    dataMatrix{n}  = textread(dataFiles{n}, '', 'commentstyle', 'shell'); %�f�[�^�������o��
    dataRaw{n}     = dataMatrix{n}(dataMatrix{n}(:,8)~=0, :); %�L���񓚍s�� (���񓚂̎��s�ȊO�̍s)%8��ڂ�0�łȂ��s ��
end

for n = 1:length(dataRaw)
    dpVar = unique(dataRaw{n}(:, 1));%�l�̏��������ɒl���ŕԂ��@���Ƃ��Ɨ񂾂�

    for m = 1:length(dpVar)
        dataChoiceVsCenterDisp{n}(m, :) = dataRaw{n}(find(dataRaw{n}(:, 1) == dpVar(m)), 8)';%�񓚍s���ł���@����:����,���ڈȍ~:�񓚁@�ɂ�����
    end
    
    dataTrialNum{n}    = zeros(length(dpVar),1);
    dataFarNumCount{n} = zeros(length(dpVar),1);
    for m = 1:size(dataChoiceVsCenterDisp{n}, 1)%�s��
        for r = 1:size(dataChoiceVsCenterDisp{n}, 2)%��
            dataTrialNum{n}(m, 1) = dataTrialNum{n}(m, 1) + 1;            
            if dataChoiceVsCenterDisp{n}(m, r) == 2
               dataFarNumCount{n}(m, 1) = dataFarNumCount{n}(m, 1) + 1;
            end
        end
    end
    
    dataFarNum{n} = horzcat(dpVar ,  dataFarNumCount{n}, dataTrialNum{n});%% �e�f�[�^�s�񂩂�A���� (CENTER_DISPARITY) ���Ƃ� Far choice ���Ɖ񓚂𓾂�ꂽ���s�������߂�

end

%% �S�u���b�N�̃f�[�^�𑫂� %%���ڂ͂��̂܂܂œ��ځA�O��ړ��m�𑫂����킹��
dataChoiceRow = zeros(length(dpVar),1);
for n = 1:length(dataFiles)
    dataChoiceRow = dataChoiceRow + dataFarNum{n}(:,2);
end
dataTrialRow = zeros(length(dpVar),1);
for n = 1:length(dataFiles)
    dataTrialRow = dataTrialRow + dataFarNum{n}(:,3);
end
dataAllFarNum = horzcat(dpVar, dataChoiceRow, dataTrialRow);

%% ���������v�Z����
dataNearPartNum = dataAllFarNum(find(dataAllFarNum(:,1)<0), :);
dataNearPartNum(:,2) = dataTrialRow(find(dataAllFarNum(:,1)<0),1) - dataNearPartNum(:,2);%near�񓚁@���ڂ���������
dataNearPartNum = flipud(dataNearPartNum);
dataFarPartNum = dataAllFarNum(find(dataAllFarNum(:,1)>0), :);
dataAllCorrectNum = horzcat(dataAllFarNum(find(dataAllFarNum(:,1)>0),1), dataNearPartNum(:,2)+dataFarPartNum(:,2) ,dataNearPartNum(:,3)+dataFarPartNum(:,3));

%% dataAllFarNum �� 2 ��ڂ� 3 ��ڂŊ���
dataAllFarProp = nan(size(dataAllFarNum, 1), 2); %��̍s��̗p�ӁH

dataAllFarProp(:, 1) = dataAllFarNum(:, 1);
dataAllFarProp(:, 2) = dataAllFarNum(:, 2) ./ dataAllFarNum(:, 3);%�v�f���Ƃ̊���Z

%% dataAllMagNum �� 2 ��ڂ� 3 ��ڂŊ���
dataAllCorrectProp = nan(size(dataAllCorrectNum, 1), 2); %��̍s��̗p�ӁH

dataAllCorrectProp(:, 1) = dataAllCorrectNum(:, 1);
dataAllCorrectProp(:, 2) = dataAllCorrectNum(:, 2) ./ dataAllCorrectNum(:, 3);%�v�f���Ƃ̊���Z

%% Plot
hf = figure;

subplot(1,2,1);
plot(dataAllFarProp(:, 1), dataAllFarProp(:, 2),'o');
xlabel('Center Disparity');
ylabel('Prop Far Choice');
subplot(1,2,2);
plot(dataAllCorrectProp(:, 1),dataAllCorrectProp(:, 2),'o');
xlabel('Center Disparity Mag');
ylabel('Prop Correct Choice');
% Prop Far Choice (dataAllFarProp(:, 2) vs dataAllFarProp(:, 1))
