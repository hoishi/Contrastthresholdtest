function AnalysisContrastTest_pre(pre)
% AnalysisStereoTest    心理実験データの解析プログラム
%
% Usage:
%
% - 実行すると，ファイル選択ダイアログが表示される．解析対象のファイルを選択する．
% - コントラスト強度に対する正答率を計算する．
% - コントラスト強度に対する Prop far choice と，コントラスト強度に対する正答率のそれぞれに対して，心理測定関数をフィッティングする．
% - Figure を作成し，コントラスト強度に対する Prop far choice と，コントラスト強度に対する正答率を，フィットした心理測定関数とともに，表示する．
%
%4posのデータをまとめて解析し、Pfc( Propotion of far choice ), Pcc( Proportion of coorect choice )の結果を描画する
addpath('./resultanalysis_contrastdata/Script');
addpath('./resultanalysis_contrastdata/Script/lib');
addpath('./resultanalysis_contrastdata/Script/func');
addpath('./lib');
addpath('./func');
%% データの読み込み
%% データの読み込み
dataFiles = GetFilesUI('mat');
rawData = LoadData(dataFiles);

%% 「奥」選択率と正答率の計算
dataCon = GetPropRightChoice(rawData);
if pre == 1
%% データ保存
    save(['pre1_' dataCon.subjectID '_' dataCon.id '_' dataCon.date '.mat' ], 'dataCon');
end

if pre == 2
%% データ保存
    save(['pre2_' dataCon.subjectID '_' dataCon.id '_' dataCon.date '.mat' ], 'dataCon');
end