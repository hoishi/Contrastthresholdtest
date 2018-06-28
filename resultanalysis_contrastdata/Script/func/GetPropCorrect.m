function dataPcc = GetPropCorrect(rawData)
%% 状態情報、視差情報、各位置と視差の絶対値ごとのトライアル数、正答率、その標準偏差を出力する

%dataPfcのデータを使う
dataPfc = GetPropFarChoice(rawData);
%データタイプ
dataPcc.id          = dataPfc.id;
dataPcc.subjectID   = rawData(1).exp.subjectID;
dataPcc.date        = rawData(1).date;
dataPcc.description = 'Correct Choice';
dataPcc.type        = 'PCC';
%すべての状態に名称を付ける
for n = 1:length(dataPfc.condition)
    dataPcc.condition(n).description = dataPfc.condition(n).description; 
end
%すべての視差
dataPcc.x.value = dataPfc.x.value( dataPfc.x.value > 0);
%% 状態と視差強度ごとに正答率を求める
for n = 1:dataPfc.ExpNum
    dataMagDispVsConTrialNumMat(:,:,n) = flipud( dataPfc.dataUsedinPcc.dataDispVsConTrialNumMat(dataPfc.x.value<0,:,n) ) + dataPfc.dataUsedinPcc.dataDispVsConTrialNumMat(dataPfc.x.value>0,:,n); % 実験ごとの各視差状態のトライアル数
    dataMagDispVsConCorrectChoiceMat(:,:,n) = flipud( dataPfc.dataUsedinPcc.dataDispVsConTrialNumMat(dataPfc.x.value<0,:,n) - dataPfc.dataUsedinPcc.dataDispVsConFarChoiceMat(dataPfc.x.value<0,:,n) ) ...
                                              + dataPfc.dataUsedinPcc.dataDispVsConFarChoiceMat(dataPfc.x.value>0,:,n); % 実験ごとの「奥」回答数
    dataMagDispVsConCorrectChoicePropMat(:,:,n) = dataMagDispVsConCorrectChoiceMat(:,:,n) ./ dataMagDispVsConTrialNumMat(:,:,n); % 実験ごとの「奥」選択率

end
%FitDataで使うので格納
dataPcc.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat = dataMagDispVsConCorrectChoicePropMat;
dataPcc.all.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat =  mean(dataPcc.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat,2);
dataPcc.left.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat = ( dataMagDispVsConCorrectChoicePropMat(:,2,:) + dataMagDispVsConCorrectChoicePropMat(:,3,:) ) /2;
dataPcc.right.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat = ( dataMagDispVsConCorrectChoicePropMat(:,1,:) + dataMagDispVsConCorrectChoicePropMat(:,4,:) ) /2;

% datadpMagMat = repmat(dataPfc.x.value(dataPfc.x.value>0),1,length(dataPfc.condition));
%全実験の各視差状態の・・・
dataTrialMagMat = sum( dataMagDispVsConTrialNumMat,3); % トライアル数
dataCorrectChoicePropMat = mean(dataMagDispVsConCorrectChoicePropMat,3); % 平均「奥」選択率
dataCorrectChoiceSDMat = std(dataMagDispVsConCorrectChoicePropMat, [],3); % 標準偏差
%状態ごとに・・・
for n = 1:length(dataPfc.condition)
    dataPcc.condition(n).rawTrialNum = dataTrialMagMat(:,n); % トライアル数
    dataPcc.condition(n).rawDataValue = dataCorrectChoicePropMat(:,n); % 平均「奥」選択率
    dataPcc.condition(n).rawDataEbar = dataCorrectChoiceSDMat(:,n); % 標準偏差    
end
%実験数(MakePlotで決定係数を求めるときに使用)
dataPcc.ExpNum = dataPfc.ExpNum;

%状態を平均して
dataPcc.all.rawTrialNum = mean(dataTrialMagMat,2);
dataPcc.all.rawDataValue = mean(dataCorrectChoicePropMat,2);
dataPcc.all.rawDataEbar = mean(dataCorrectChoiceSDMat,2);

%左右で平均して
dataPcc.left.rawTrialNum = ( dataPcc.condition(2).rawTrialNum + dataPcc.condition(3).rawTrialNum ) / 2;
dataPcc.left.rawDataValue = ( dataPcc.condition(2).rawDataValue + dataPcc.condition(3).rawDataValue ) / 2;
dataPcc.left.rawDataEbar = ( dataPcc.condition(2).rawDataEbar + dataPcc.condition(3).rawDataEbar ) / 2;
dataPcc.right.rawTrialNum = ( dataPcc.condition(1).rawTrialNum + dataPcc.condition(4).rawTrialNum ) / 2;
dataPcc.right.rawDataValue = ( dataPcc.condition(1).rawDataValue + dataPcc.condition(4).rawDataValue ) / 2;
dataPcc.right.rawDataEbar = ( dataPcc.condition(1).rawDataEbar + dataPcc.condition(4).rawDataEbar ) / 2;


%評価
dataPcc.all.correctchoice = mean(dataPcc.all.rawDataValue);


    






