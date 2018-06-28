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



