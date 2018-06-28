function AnalysisContrastTest()
% AnalysisStereoTest    �S�������f�[�^�̉�̓v���O����
%
% Usage:
%
% - ���s����ƁC�t�@�C���I���_�C�A���O���\�������D��͑Ώۂ̃t�@�C����I������D
% - �R���g���X�g���x�ɑ΂��鐳�������v�Z����D
% - �R���g���X�g���x�ɑ΂��� Prop far choice �ƁC�R���g���X�g���x�ɑ΂��鐳�����̂��ꂼ��ɑ΂��āC�S������֐����t�B�b�e�B���O����D
% - Figure ���쐬���C�R���g���X�g���x�ɑ΂��� Prop far choice �ƁC�R���g���X�g���x�ɑ΂��鐳�������C�t�B�b�g�����S������֐��ƂƂ��ɁC�\������D
%
%4pos�̃f�[�^���܂Ƃ߂ĉ�͂��APfc( Propotion of far choice ), Pcc( Proportion of coorect choice )�̌��ʂ�`�悷��
addpath('./resultanalysis_contrastdata/Script');
addpath('./resultanalysis_contrastdata/Script/lib');
addpath('./resultanalysis_contrastdata/Script/func');
addpath('./lib');
addpath('./func');
%% �f�[�^�̓ǂݍ���
dataFiles = GetFilesUI('mat');
rawData = LoadData(dataFiles);

%% �u���v�I�𗦂Ɛ������̌v�Z
dataCon = GetPropRightChoice(rawData);
% dataPcc = GetPropCorrect(rawData);

%% �t�B�b�e�B���O
dataCon = FitDataCon(dataCon);
h1 = figure;
Copy_of_MakePlot(dataCon,h1)
h2 = figure;
MakeCONPFPlot(dataCon,h2)

%% �f�[�^�ۑ�
save(['Original_' dataCon.subjectID '_' dataCon.id '_' dataCon.date '.mat' ], 'dataCon');