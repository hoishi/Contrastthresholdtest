function dataPfc = TESTGetPropFarChoice(rawData)
%% 奥」選択率を計算する関数である
%% 状態情報、視差情報、各位置と視差ごとのトライアル数、「奥」選択率、その標準偏差を出力する
%% dataSetは一列目:状態、二列目：視差、三列目：回答 であること

%データタイプ
dataPfc.id          = rawData(1).exp.expID;
dataPfc.subjectID   = rawData(1).exp.subjectID;
dataPfc.date        = rawData(1).date;
dataPfc.description = 'Far Choice';
dataPfc.type        = 'PFC';
if ~isnan( strfind( dataPfc.id, '4pos') ) 
    dataSet = ExtractPDA( rawData ); 
    %すべての状態
    for n = 1:length(dataSet)
        a(:,n) =  dataSet{n}(:,1);
    end
    conVar = unique(a);
    clear a;
    %状態に名称を付ける
    %状態情報: 位置情報
    for n = 1:length(conVar)
        if conVar(n) == 1 
           dataPfc.condition(n).description = 'Up-Right(1)';%名称
        end
        if conVar(n) == 2 
           dataPfc.condition(n).description = 'Up-Left(2)';%名称
        end
        if conVar(n) == 3 
           dataPfc.condition(n).description = 'Low-Left(3)';%名称
        end
        if conVar(n) == 4 
           dataPfc.condition(n).description = 'Low-Right(4)';%名称
        end    
    end    
end
    
    
if ~isnan( strfind( dataPfc.id, '3freq') )    
    dataSet = ExtractRDA( rawData );
    %すべての状態
    conVar = unique(dataSet{1}(:,1));
    %状態情報: リフレッシュレート
    for n = 1:length(conVar)
        if conVar(n) == 1 
           dataPfc.condition(n).description = '42.5 [Hz](1)';%名称
        end
        if conVar(n) == 2 
           dataPfc.condition(n).description = '21.25 [Hz](2)';%名称
        end
        if conVar(n) == 3 
           dataPfc.condition(n).description = '10.625 [Hz](3)';%名称
        end
    end    
end


%すべての視差
dataPfc.x.value = unique(dataSet{1}(:, 2));
%% 状態と視差ごとに「奥」回答率を計算する    
for n = 1:length(dataSet)
    for c = 1:length(dataPfc.condition) 
        for m = 1:length(dataPfc.x.value)
            dataDispVsConTrialNumMat(m,c,n) = 0; % 実験ごとに各視差状態のトライアル数をカウント
            dataDispVsConFarChoiceMat(m,c,n) = 0; % 実験ごとに「奥」回答数をカウント
            for d = 1:size(dataSet{n},1)
                if dataSet{n}(d,1) == c && dataSet{n}(d,2) == dataPfc.x.value(m) 
                   dataDispVsConTrialNumMat(m,c,n) = dataDispVsConTrialNumMat(m,c,n) + 1;
                   if dataSet{n}(d,3) == 2 % 「奥」回答ならば
                      dataDispVsConFarChoiceMat(m,c,n) = dataDispVsConFarChoiceMat(m,c,n) + 1;
                   end
                end
            end
            dataDispVsConFarChoicePropMat(m,c,n) = dataDispVsConFarChoiceMat(m,c,n) ./ dataDispVsConTrialNumMat(m,c,n); % 実験ごとに「奥」選択率
            if isnan(dataDispVsConFarChoicePropMat(m,c,n))
                dataDispVsConFarChoicePropMat(m,c,n) = 0;   
            end
        end
    end
end

%  dataDispVsConTrialNumMat
%  dataDispVsConFarChoiceMat
%  dataDispVsConFarChoicePropMat


%dataPccで使うので格納する
for n = 1:length(dataSet)
    dataPfc.dataUsedinPcc.dataDispVsConTrialNumMat = dataDispVsConTrialNumMat;
    dataPfc.dataUsedinPcc.dataDispVsConFarChoiceMat = dataDispVsConFarChoiceMat;
    dataPfc.dataUsedinPcc.dataDispVsConFarChoicePropMat = dataDispVsConFarChoicePropMat;
end

%%
% dataAlldpMat = repmat(dataPfc.x.value,1,length(dataPfc.condition)); 
%全実験の各視差状態の・・・
dataTrialMat = sum(dataDispVsConTrialNumMat,3); % トライアル数
dataFarChoicePropMat = 4*mean(dataDispVsConFarChoicePropMat,3); % 平均「奥」選択率
dataFarChoiceSDMat = std(dataDispVsConFarChoicePropMat, [],3); % 標準偏差 
%状態ごとに・・・
for n = 1:length(dataPfc.condition)
    dataPfc.condition(n).rawTrialNum = dataTrialMat(:,n);% トライアル数
    dataPfc.condition(n).rawDataValue = dataFarChoicePropMat(:,n);% 平均「奥」選択率
    dataPfc.condition(n).rawDataEbar = dataFarChoiceSDMat(:,n); % 標準偏差 
end
%実験数(MakePlotで決定係数を求めるときに使用)
dataPfc.ExpNum = length(dataSet);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfunction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataPDA = ExtractPDA( rawData )
%% ExtractPDA データから位置(Position)と視差(Disparity)と回答(Answer)を抽出し各実験ごとに行列を生成
%   一列目:位置(番号)、二列目：視差、三列目：回答

for n = 1:length(rawData)
%位置

    for m = 1:length(rawData(n).data)
        dataPosLR(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimPos(1);
        dataPosUD(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimPos(2);
    end

%視差

    for m = 1:length(rawData(n).data)
        dataDisp(m,1) = rawData(n).data(m).trial.stim(2).parameters.disparity(1);
    end

%回答

    for m = 1:length(rawData(n).data)
        dataAns(m,1) = rawData(n).data(m).response;
    end

%まとめ

    dataSet{n} = horzcat( dataPosLR, dataPosUD, dataDisp, dataAns );
    dataSetTemp = isnan(dataSet{n}(:,4));
    dataPDA{n}= dataSet{n}(dataSetTemp ~= 1,:);%位置(左右)、位置(上下)、視差、回答
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
    dataPDA{n} = horzcat(dataPosName,dataPDA{n}(:,3), dataPDA{n}(:,4));%位置(名前づけ)、視差、回答
   
    clear dataPosName dataPosLR dataPosUD dataDisp dataAns dataSetTemp;
end



function dataRDA = ExtractRDA( rawData )
%% ExtractRDA データから刺激のリフレッシュレート(Refresh Rate)と視差(Disparity)と回答(Answer)を抽出し各実験ごとに行列を生成
%   一列目:位置(番号)、二列目：視差、三列目：回答

for n = 1:length(rawData)
%刺激のリフレッシュレート

    for m = 1:length(rawData(n).data)
        dataRef(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimFreq;
    end

%視差

    for m = 1:length(rawData(n).data)
        dataDisp(m,1) = rawData(n).data(m).trial.stim(2).parameters.disparity(1);
    end

%回答

    for m = 1:length(rawData(n).data)
        dataAns(m,1) = rawData(n).data(m).response; 
    end

%まとめ

    dataSet{n} = horzcat( dataRef, dataDisp, dataAns );
    dataSetTemp = isnan(dataSet{n}(:, 3));
    dataRDA{n}= dataSet{n}(dataSetTemp ~= 1,:);%刺激のリフレッシュレート、視差、回答
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
    dataRDA{n} = horzcat(dataRefName,dataRDA{n}(:,2), dataRDA{n}(:,3));%刺激のリフレッシュレート(名前づけ)、視差、回答
   
    clear dataRefName dataRef dataDisp dataAns dataSetTemp;
end