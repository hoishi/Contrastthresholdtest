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



