function AnalysisPsychophysicsTest()
% AnalysisStereoTest    Stereo test のデータ解析・可視化スクリプト
%
% Usage:
%
% - 実行すると，ファイル選択ダイアログが表示される．解析対象のファイルを選択する．
% - 中心の絶対視差に対する Prop far choice と，中心の絶対視差強度に対する正答率を計算する．
% - 中心の絶対視差に対する Prop far choice と，中心の絶対視差強度に対する正答率のそれぞれに対して，心理測定関数をフィッティングする．
% - Figure を作成し，中心の絶対視差に対する Prop far choice と，中心の絶対視差強度に対する正答率を，フィットした心理測定関数とともに，表示する．
%

addpath('./lib');

dataFiles = GetFilesUI('data');

%% dataFiles の各ファイルを読み込み、データ行列を作成する　%%ひとつひとつデータ行列をTEXTREADで読み込む　出力各関数の意味？
for n = 1:length(dataFiles)
    dataMatrix{n}  = textread(dataFiles{n}, '', 'commentstyle', 'shell'); %データだけ取り出す
    dataRaw{n}     = dataMatrix{n}(dataMatrix{n}(:,8)~=0, :); %有効回答行列 (未回答の試行以外の行)%8列目が0でない行 列
end

for n = 1:length(dataRaw)
    dpVar = unique(dataRaw{n}(:, 1));%値の小さい順に値を列で返す　もともと列だし

    for m = 1:length(dpVar)
        dataChoiceVsCenterDisp{n}(m, :) = dataRaw{n}(find(dataRaw{n}(:, 1) == dpVar(m)), 8)';%回答行ができる　一列目:視差,二列目以降:回答　にしたい
    end
    
    dataTrialNum{n}    = zeros(length(dpVar),1);
    dataFarNumCount{n} = zeros(length(dpVar),1);
    for m = 1:size(dataChoiceVsCenterDisp{n}, 1)%行数
        for r = 1:size(dataChoiceVsCenterDisp{n}, 2)%列数
            dataTrialNum{n}(m, 1) = dataTrialNum{n}(m, 1) + 1;            
            if dataChoiceVsCenterDisp{n}(m, r) == 2
               dataFarNumCount{n}(m, 1) = dataFarNumCount{n}(m, 1) + 1;
            end
        end
    end
    
    dataFarNum{n} = horzcat(dpVar ,  dataFarNumCount{n}, dataTrialNum{n});%% 各データ行列から、視差 (CENTER_DISPARITY) ごとの Far choice 数と回答を得られた試行数を求める

end

%% 全ブロックのデータを足す %%一列目はそのままで二列目、三列目同士を足し合わせる
dataChoiceRow = zeros(length(dpVar),1);
for n = 1:length(dataFiles)
    dataChoiceRow = dataChoiceRow + dataFarNum{n}(:,2);
end
dataTrialRow = zeros(length(dpVar),1);
for n = 1:length(dataFiles)
    dataTrialRow = dataTrialRow + dataFarNum{n}(:,3);
end
dataAllFarNum = horzcat(dpVar, dataChoiceRow, dataTrialRow);

%% 正当数を計算する
dataNearPartNum = dataAllFarNum(find(dataAllFarNum(:,1)<0), :);
dataNearPartNum(:,2) = dataTrialRow(find(dataAllFarNum(:,1)<0),1) - dataNearPartNum(:,2);%near回答　二列目をいじった
dataNearPartNum = flipud(dataNearPartNum);
dataFarPartNum = dataAllFarNum(find(dataAllFarNum(:,1)>0), :);
dataAllCorrectNum = horzcat(dataAllFarNum(find(dataAllFarNum(:,1)>0),1), dataNearPartNum(:,2)+dataFarPartNum(:,2) ,dataNearPartNum(:,3)+dataFarPartNum(:,3));

%% dataAllFarNum の 2 列目を 3 列目で割る
dataAllFarProp = nan(size(dataAllFarNum, 1), 2); %空の行列の用意？

dataAllFarProp(:, 1) = dataAllFarNum(:, 1);
dataAllFarProp(:, 2) = dataAllFarNum(:, 2) ./ dataAllFarNum(:, 3);%要素ごとの割り算

%% dataAllMagNum の 2 列目を 3 列目で割る
dataAllCorrectProp = nan(size(dataAllCorrectNum, 1), 2); %空の行列の用意？

dataAllCorrectProp(:, 1) = dataAllCorrectNum(:, 1);
dataAllCorrectProp(:, 2) = dataAllCorrectNum(:, 2) ./ dataAllCorrectNum(:, 3);%要素ごとの割り算

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
