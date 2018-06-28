function dataPcc = GetPropRightChoice(rawData)
%% 右選択率を計算する関数である
%% 状態情報、輝度情報、各位置と輝度ごとのトライアル数、正答率、その標準偏差を出力する
%% dataSetは一列目:状態、二列目：輝度、三列目：回答 であること

%データタイプ
dataPcc.id          = rawData(1).exp.expID;
dataPcc.subjectID   = rawData(1).exp.subjectID;
dataPcc.date        = rawData(1).date;
dataPcc.description = 'Right Choice';
dataPcc.type        = 'CON';
if ~isnan( strfind( dataPcc.id, '4pos') ) 
    exp_id_initnamenum = strfind(dataPcc.id,'4pos') + length('4pos') -1 ;
    dataPcc.id = dataPcc.id(1:exp_id_initnamenum);
    dataSet = ExtractPLOA( rawData ); 
     
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
           dataPcc.condition(1).description = 'Up-Right(1)';%名称
        end
        if conVar(n) == 2 
           dataPcc.condition(2).description = 'Up-Left(2)';%名称
        end
        if conVar(n) == 3 
           dataPcc.condition(3).description = 'Low-Left(3)';%名称
        end
        if conVar(n) == 4 
           dataPcc.condition(4).description = 'Low-Right(4)';%名称
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

%すべての輝度
dataPcc.x.value = unique(dataSet{1}(:, 2));
%% 状態と輝度ごとに「右」回答率を計算する 
if isfield(dataPcc.condition(1),'data') && isfield(dataPcc.condition(2),'data') && isfield(dataPcc.condition(3),'data') && isfield(dataPcc.condition(4),'data')
for c = 1:length(dataPcc.condition) 
    for n = 1:length(dataPcc.condition(c).data)
        for m = 1:length(dataPcc.x.value)
            dataPcc.condition(c).block{n}.dataLumVsConTrialNumMat(m) = 0; % 実験ごとに各輝度状態のトライアル数をカウント
            dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat(m) = 0; % 実験ごとに正答数をカウント
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
            dataPcc.condition(c).block{n}.dataLumVsConCorrectChoicePropMat(m) = dataPcc.condition(c).block{n}.dataLumVsConCorrectChoiceMat(m) ./ dataPcc.condition(c).block{n}.dataLumVsConTrialNumMat(m); % 実験ごとの 正答率
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
            dataLumVsConTrialNumMat(m,c,n) = 0; % 実験ごとに各視差状態のトライアル数をカウント
            dataLumVsConCorrectChoiceMat(m,c,n) = 0; % 実験ごとに「奥」回答数をカウント
            for d = 1:size(dataSet{n},1)
                if dataSet{n}(d,1) == c && dataSet{n}(d,2) == dataPcc.x.value(m) 
                   dataLumVsConTrialNumMat(m,c,n) = dataLumVsConTrialNumMat(m,c,n) + 1;
                   if dataSet{n}(d,3) == 2 % 「奥」回答ならば
                      dataLumVsConCorrectChoiceMat(m,c,n) = dataLumVsConCorrectChoiceMat(m,c,n) + 1;
                   end
                end
            end
            dataLumVsConCorrectChoicePropMat(m,c,n) = dataLumVsConCorrectChoiceMat(m,c,n) ./ dataLumVsConTrialNumMat(m,c,n); % 実験ごとに「奥」選択率
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




%dataPccで使うので格納する

dataPcc.dataUsedinPcc.dataLumVsConTrialNumMat = dataLumVsConTrialNumMat;
dataPcc.dataUsedinPcc.dataLumVsConCorrectChoiceMat = dataLumVsConCorrectChoiceMat;
dataPcc.dataUsedinPcc.dataLumVsConCorrectChoicePropMat = dataLumVsConCorrectChoicePropMat;

dataPcc.all.dataUsedinPcc.dataLumVsConCorrectChoicePropMat = mean(dataPcc.dataUsedinPcc.dataLumVsConCorrectChoicePropMat,2);

%%
% dataAlldpMat = repmat(dataPcc.x.value,1,length(dataPcc.condition)); 
%全実験の各視差状態の・・・平均
dataTrialMat = sum(dataLumVsConTrialNumMat,3); % トライアル数
dataCorrectChoicePropMat = mean(dataLumVsConCorrectChoicePropMat,3); % 平均正答率
dataCorrectChoiceSDMat = std(dataLumVsConCorrectChoicePropMat, [],3); % 標準偏差 
%状態ごとに・・・格納
for n = 1:length(dataPcc.condition)
    dataPcc.condition(n).rawTrialNum = dataTrialMat(:,n);% トライアル数
    dataPcc.condition(n).rawDataValue = dataCorrectChoicePropMat(:,n);% 平均「奥」選択率
    dataPcc.condition(n).rawDataEbar = dataCorrectChoiceSDMat(:,n); % 標準偏差 
end
%状態を平均して %ココガアウト！！！！！！！！！！！！平均の平均はだめ
dataPcc.all.rawTrialNum = sum(dataTrialMat,2);
dataPcc.all.rawDataValue = mean(dataCorrectChoicePropMat,2);
dataPcc.all.rawDataEbar = mean(dataCorrectChoiceSDMat,2);
%実験数(MakePlotで決定係数を求めるときに使用)
dataPcc.ExpNum = size(dataPcc.dataUsedinPcc.dataLumVsConCorrectChoicePropMat,3);

%左右で平均して
dataPcc.left.rawTrialNum = ( dataPcc.condition(2).rawTrialNum + dataPcc.condition(3).rawTrialNum ) / 2;
dataPcc.left.rawDataValue = ( dataPcc.condition(2).rawDataValue + dataPcc.condition(3).rawDataValue ) / 2;
dataPcc.left.rawDataEbar = ( dataPcc.condition(2).rawDataEbar + dataPcc.condition(3).rawDataEbar ) / 2;
dataPcc.right.rawTrialNum = ( dataPcc.condition(1).rawTrialNum + dataPcc.condition(4).rawTrialNum ) / 2;
dataPcc.right.rawDataValue = ( dataPcc.condition(1).rawDataValue + dataPcc.condition(4).rawDataValue ) / 2;
dataPcc.right.rawDataEbar = ( dataPcc.condition(1).rawDataEbar + dataPcc.condition(4).rawDataEbar ) / 2;


%評価
dataPcc.all.correctchoice = mean(dataPcc.all.rawDataValue);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfunction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataPLOA = ExtractPLOA( rawData )
%% ExtractPLA データから位置(Position)と輝度(Luminance)と方位(orientation)と回答(Answer)を抽出し各実験ごとに行列を生成
%   一列目:位置(番号)、二列目：視差、三列目：回答

for n = 1:length(rawData)
%位置

    for m = 1:length(rawData(n).data)
        dataPosLR(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimPos(1);
        dataPosUD(m,1) = rawData(n).data(m).trial.stim(2).parameters.stimPos(2);
    end

%輝度

    for m = 1:length(rawData(n).data)
        dataLum(m,1) = rawData(n).data(m).trial.stim(2).parameters.contrast;
    end
    
%方位

    for m = 1:length(rawData(n).data)
        dataOri(m,1) = rawData(n).data(m).trial.stim(2).parameters.orientation;
    end    

%回答

    for m = 1:length(rawData(n).data)
        dataAns(m,1) = rawData(n).data(m).response;
    end

%まとめ

    dataSet{n} = horzcat( dataPosLR, dataPosUD, dataLum, dataOri, dataAns );
    dataSetTemp = isnan(dataSet{n}(:,5));
    dataPLOA{n}= dataSet{n}(dataSetTemp ~= 1,:);%位置(左右)、位置(上下)、輝度、方位、回答
 
    
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

    
    dataPLOA{n} = horzcat(dataPosName,dataPLOA{n}(:,3), dataPLOA{n}(:,4), dataPLOA{n}(:,5));%位置(名前づけ)、輝度、方位、回答
   
    clear dataPosName dataPosLR dataPosUD dataLum dataOri dataAns dataSetTemp;
end
clear dataSet



