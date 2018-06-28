function data = FitData(data)
%% プロットに心理測定関数を当てはめ、弁別閾値を求める

if strcmp(data.type ,'PFC')
    for n =1:length(data.condition)
        %フィッティングする
        data.condition(n).fitdata.isFit = true;
        % 心理測定関数の定義
        data.condition(n).fitdata.func  = @(t, p) p(4) + (1 - p(4) - p(3)) .* normcdf( t, p(1), p(2) ); 
    end
    
    LoopNum_Far = 0;
    for n =1:length(data.condition)
        % 目的関数の定義
        objfunc = @(p) -mlefunc(p, data.x.value, data.condition(n).rawDataValue, data.condition(n).rawTrialNum, data.condition(n).fitdata.func);

        % 探索の初期値
        c = 1;
        for P = 0:0.015:0.03
        for Q = 0:0.015:0.03   
        for R = 0:0.25:0.50
        for S = 0:0.25:0.50    
            initVal{c} = [ P, Q, R, S]; %平均,分散,α,βの探索初期値
            c = c + 1;
        end
        end
        end
        end

        % 制約の定義
        lb = [ 0, 1e-6,   0,  0 ];
        ub = [  Inf,  Inf,  1,  1 ];
        fvalPFMin = Inf;
        for c = 1:length(initVal)
            [ prmPF, fvalPF, exitflagPF ] = fmincon( objfunc, initVal{c}, [], [], [], [], lb, ub, [], optimset('Display', 'notify' ) );

            if fvalPF < fvalPFMin
                fvalMinNum = c; 
                fvalPFMin = fvalPF;
                prmPFMin = prmPF;
                initValPFMinMat = initVal{c};
            end
            LoopNum_Far = LoopNum_Far +1

        end
        %最適な探索の初期値
        data.condition(n).fitdata.initVal = initValPFMinMat;
        %平均,分散,α,β
        data.condition(n).fitdata.prm = prmPFMin;
        %定義したマイナス尤度関数の最小値
        data.condition(n).fitdata.fval = fvalPFMin;
        %主観的等価点
        data.condition(n).sppData(1).description = 'PSE';
        data.condition(n).sppData(1).value = GetThreshold(0.5, data.condition(n).fitdata.func, data.condition(n).fitdata.prm);
        %「奥」選択率が 25 %の視差の値
        data.condition(n).sppData(2).description = '25% far choice';
        data.condition(n).sppData(2).value = GetThreshold(0.25, data.condition(n).fitdata.func, data.condition(n).fitdata.prm);
        %「奥」選択率が 75 %の視差の値
        data.condition(n).sppData(3).description = '75% far choice';
        data.condition(n).sppData(3).value = GetThreshold(0.75, data.condition(n).fitdata.func, data.condition(n).fitdata.prm);
        %Near 閾値
        data.condition(n).sppData(4).description = 'Near threshold';
        data.condition(n).sppData(4).value = data.condition(n).sppData(1).value - data.condition(n).sppData(2).value;
        %Far 閾値
        data.condition(n).sppData(5).description = 'Far threshold';
        data.condition(n).sppData(5).value = data.condition(n).sppData(3).value - data.condition(n).sppData(1).value;
        
        clear objfunc initVal;
        clear fvalMinNum fvalPFMin prmPFMin initValPFMin;

    disp('AllFarOK');
    end


    % 決定係数(心理物理関数の当てはまりのよさ) を求める SSE:残差平方和 SST:全分散の和 CoD:決定係数

    for n = 1:length(data.condition)
        for m = 1:data.ExpNum
            dataDispVsConFarChoicePropMatTemp(:,m,n) = data.dataUsedinPcc.dataDispVsConFarChoicePropMat(:,n,m);
        end
        Ytemp(:,:,n) = repmat(data.condition(n).rawDataValue,1, data.ExpNum);
        SSE_Far(n) = sum(( data.condition(n).rawDataValue - data.condition(n).fitdata.func( data.x.value, data.condition(n).fitdata.prm) ).^2);
        SST_Far(n) = sum(sum((dataDispVsConFarChoicePropMatTemp(:,:,n) - Ytemp(:,:,n)).^2));
        data.condition(n).fitdata.r_sq = 1 - SSE_Far(n)/SST_Far(n);

    %     rsq_pf(n) = GetRsq( dataAllDispVsPosFarChoicePropMat(:,n,:),pmf(X(:,n), prmPFMat(n,:)) );
    
    end
%     clear Ytemp;
end




if strcmp(data.type , 'PCC')
   
    for n =1:length(data.condition)
        %フィッティングする
        data.condition(n).fitdata.isFit = true;
        % 心理測定関数の定義
        data.condition(n).fitdata.func  = @(t, p) p(4) + (1 - p(4) - p(3)) .* normcdf( t, p(1), p(2) ); 
    end
    
    LoopNum_Correct = 0;
    for n =1:length(data.condition)
        % 目的関数の定義
        objfunc = @(p) -mlefunc(p, data.x.value, data.condition(n).rawDataValue, data.condition(n).rawTrialNum, data.condition(n).fitdata.func);

        % 探索の初期値
        c = 1;
        for P = 0:0.015:0.045
        for Q = 0:0.015:0.03   
        for R = 0:0.25:0.50
        for S = 0.25:0.25:0.75    
            initVal{c} = [ P, Q, R, S]; %平均,分散,α,βの探索初期値
            c = c + 1;
        end
        end
        end
        end

        % 制約の定義
        lb = [ 0, 1e-6,   0,  0 ];
        ub = [  Inf,  Inf,  1,  1 ];
        fvalMin = Inf;
        for c = 1:length(initVal)
            [ prm, fval, exitflag ] = fmincon( objfunc, initVal{c}, [], [], [], [], lb, ub, [], optimset('Display', 'notify' ) );

            if fval < fvalMin
                fvalMinNum = c; 
                fvalMin = fval;
                prmMin = prm;
                initValMinMat = initVal{c};
            end
            LoopNum_Correct = LoopNum_Correct +1

        end
        %最適な探索の初期値
        data.condition(n).fitdata.initVal = initValMinMat;
        %平均,分散,α,β
%         prmMin(1) = 0; 
        data.condition(n).fitdata.prm = prmMin;
        %定義したマイナス尤度関数の最小値
        data.condition(n).fitdata.fval = fvalMin;
        % 弁別閾値 (正答率 75% にあたる視差強度) を求める
        data.condition(n).sppData(1).description = 'Threshold';
        data.condition(n).sppData(1).value = GetThreshold(0.75, data.condition(n).fitdata.func, data.condition(n).fitdata.prm);
        % 正答率 60 %にあたる視差強度 を求める
        data.condition(n).sppData(2).description = '60% correct choice';
        data.condition(n).sppData(2).value = GetThreshold(0.60, data.condition(n).fitdata.func, data.condition(n).fitdata.prm);
        % 正答率 90 %にあたる視差強度 を求める
        data.condition(n).sppData(3).description = '90% correct choice';
        data.condition(n).sppData(3).value = GetThreshold(0.90, data.condition(n).fitdata.func, data.condition(n).fitdata.prm); 
  
        clear objfunc initVal;
        clear fvalMinNum fvalMin prmMin initValMin;

  
    end

    % 決定係数(心理物理関数の当てはまりのよさ) を求める SSE:残差平方和 SST:全分散の和 CoD:決定係数

    for n = 1:length(data.condition)
        for m = 1:data.ExpNum
            dataMagDispVsConCorrectChoicePropMatTemp(:,m,n) = data.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat(:,n,m);
        end
        Ytemp(:,:,n) = repmat( data.condition(n).rawDataValue,1,data.ExpNum);
        SSE_Correct(n) = sum(( data.condition(n).rawDataValue - data.condition(n).fitdata.func( data.x.value, data.condition(n).fitdata.prm) ).^2);
        SST_Correct(n) = sum(sum((dataMagDispVsConCorrectChoicePropMatTemp(:,:,n) - Ytemp(:,:,n)).^2));
        data.condition(n).fitdata.r_sq = 1 - SSE_Correct(n)/SST_Correct(n);
    end
end


if strcmp(data.type ,'PFC')
    for n =1:length(data.all)
        %フィッティングする
        data.all.fitdata.isFit = true;
        % 心理測定関数の定義
        data.all.fitdata.func  = @(t, p) p(4) + (1 - p(4) - p(3)) .* normcdf( t, p(1), p(2) ); 
    end
    
    LoopNum_Far = 0;
    for n =1:length(data.all)
        % 目的関数の定義
        objfunc = @(p) -mlefunc(p, data.x.value, data.all.rawDataValue, data.all.rawTrialNum, data.all.fitdata.func);

        % 探索の初期値
        c = 1;
        for P = 0:0.015:0.03
        for Q = 0:0.015:0.03   
        for R = 0:0.25:0.50
        for S = 0:0.25:0.50    
            initVal{c} = [ P, Q, R, S]; %平均,分散,α,βの探索初期値
            c = c + 1;
        end
        end
        end
        end

        % 制約の定義
        lb = [ 0, 1e-6,   0,  0 ];
        ub = [  Inf,  Inf,  1,  1 ];
        fvalPFMin = Inf;
        for c = 1:length(initVal)
            [ prmPF, fvalPF, exitflagPF ] = fmincon( objfunc, initVal{c}, [], [], [], [], lb, ub, [], optimset('Display', 'notify' ) );

            if fvalPF < fvalPFMin
                fvalMinNum = c; 
                fvalPFMin = fvalPF;
                prmPFMin = prmPF;
                initValPFMinMat = initVal{c};
            end
            LoopNum_Far = LoopNum_Far +1

        end
        %最適な探索の初期値
        data.all.fitdata.initVal = initValPFMinMat;
        %平均,分散,α,β
        data.all.fitdata.prm = prmPFMin;
        %定義したマイナス尤度関数の最小値
        data.all.fitdata.fval = fvalPFMin;
        %主観的等価点
        data.all.sppData(1).description = 'PSE';
        data.all.sppData(1).value = GetThreshold(0.5, data.all.fitdata.func, data.all.fitdata.prm);
        %「奥」選択率が 25 %の視差の値
        data.all.sppData(2).description = '25% far choice';
        data.all.sppData(2).value = GetThreshold(0.25, data.all.fitdata.func, data.all.fitdata.prm);
        %「奥」選択率が 75 %の視差の値
        data.all.sppData(3).description = '75% far choice';
        data.all.sppData(3).value = GetThreshold(0.75, data.all.fitdata.func, data.all.fitdata.prm);
        %Near 閾値
        data.all.sppData(4).description = 'Near threshold';
        data.all.sppData(4).value = data.all.sppData(1).value - data.all.sppData(2).value;
        %Far 閾値
        data.all.sppData(5).description = 'Far threshold';
        data.all.sppData(5).value = data.all.sppData(3).value - data.all.sppData(1).value;
        
        clear objfunc initVal;
        clear fvalMinNum fvalPFMin prmPFMin initValPFMin;

    disp('AllFarOK');
    end


    % 決定係数(心理物理関数の当てはまりのよさ) を求める SSE:残差平方和 SST:全分散の和 CoD:決定係数

    for n = 1:length(data.all)
        for m = 1:data.ExpNum
            dataAllDispVsConFarChoicePropMatTemp(:,m,n) = data.all.dataUsedinPcc.dataDispVsConFarChoicePropMat(:,n,m);
        end
        Ytemp(:,:,n) = repmat(data.all.rawDataValue,1, data.ExpNum);
        SSE_Far(n) = sum(( data.all.rawDataValue - data.all.fitdata.func( data.x.value, data.all.fitdata.prm) ).^2);
        SST_Far(n) = sum(sum((dataAllDispVsConFarChoicePropMatTemp(:,:,n) - Ytemp(:,:,n)).^2));
        data.all.fitdata.r_sq = 1 - SSE_Far(n)/SST_Far(n);

    %     rsq_pf(n) = GetRsq( dataAllDispVsPosFarChoicePropMat(:,n,:),pmf(X(:,n), prmPFMat(n,:)) );
    
    end
%     clear Ytemp;
end


if strcmp(data.type , 'PCC')
   
    for n =1:length(data.all)
        %フィッティングする
        data.all(n).fitdata.isFit = true;
        % 心理測定関数の定義
        data.all(n).fitdata.func  = @(t, p) p(4) + (1 - p(4) - p(3)) .* normcdf( t, p(1), p(2) ); 
    end
    
    LoopNum_Correct = 0;
    for n =1:length(data.all)
        % 目的関数の定義
        objfunc = @(p) -mlefunc(p, data.x.value, data.all(n).rawDataValue, data.all(n).rawTrialNum, data.all(n).fitdata.func);

        % 探索の初期値
        c = 1;
        for P = 0:0.015:0.045
        for Q = 0:0.015:0.03   
        for R = 0:0.25:0.50
        for S = 0.25:0.25:0.75    
            initVal{c} = [ P, Q, R, S]; %平均,分散,α,βの探索初期値
            c = c + 1;
        end
        end
        end
        end

        % 制約の定義
        lb = [ 0, 1e-6,   0,  0 ];
        ub = [  Inf,  Inf,  1,  1 ];
        fvalMin = Inf;
        for c = 1:length(initVal)
            [ prm, fval, exitflag ] = fmincon( objfunc, initVal{c}, [], [], [], [], lb, ub, [], optimset('Display', 'notify' ) );

            if fval < fvalMin
                fvalMinNum = c; 
                fvalMin = fval;
                prmMin = prm;
                initValMinMat = initVal{c};
            end
            LoopNum_Correct = LoopNum_Correct +1

        end
        %最適な探索の初期値
        data.all(n).fitdata.initVal = initValMinMat;
        %平均,分散,α,β
%         prmMin(1) = 0;
        data.all(n).fitdata.prm = prmMin;
        %定義したマイナス尤度関数の最小値
        data.all(n).fitdata.fval = fvalMin;
        % 弁別閾値 (正答率 75% にあたる視差強度) を求める
        data.all(n).sppData(1).description = 'Threshold';
        data.all(n).sppData(1).value = GetThreshold(0.75, data.all(n).fitdata.func, data.all(n).fitdata.prm);
        % 正答率 60 %にあたる視差強度 を求める
        data.all(n).sppData(2).description = '60% correct choice';
        data.all(n).sppData(2).value = GetThreshold(0.60, data.all(n).fitdata.func, data.all(n).fitdata.prm);
        % 正答率 90 %にあたる視差強度 を求める
        data.all(n).sppData(3).description = '90% correct choice';
        data.all(n).sppData(3).value = GetThreshold(0.90, data.all(n).fitdata.func, data.all(n).fitdata.prm); 
  
        clear objfunc initVal;
        clear fvalMinNum fvalMin prmMin initValMin;

  
    end

    % 決定係数(心理物理関数の当てはまりのよさ) を求める SSE:残差平方和 SST:全分散の和 CoD:決定係数

    for n = 1:length(data.all)
        for m = 1:data.ExpNum
            dataAllMagDispVsConCorrectChoicePropMatTemp(:,m,n) = data.all.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat(:,n,m);
        end
        Ytemp(:,:,n) = repmat( data.all(n).rawDataValue,1,data.ExpNum);
        SSE_Correct(n) = sum(( data.all(n).rawDataValue - data.all(n).fitdata.func( data.x.value, data.all(n).fitdata.prm) ).^2);
        SST_Correct(n) = sum(sum((dataAllMagDispVsConCorrectChoicePropMatTemp(:,:,n) - Ytemp(:,:,n)).^2));
        data.all(n).fitdata.r_sq = 1 - SSE_Correct(n)/SST_Correct(n);
    end
%     for 
%     data.all(n).fitdata.func(t,data.all(n).fitdata.prm)
end

if strcmp(data.type , 'PCC')
   
    for n =1:length(data.left)
        %フィッティングする
        data.left.fitdata.isFit = true;
        % 心理測定関数の定義
        data.left.fitdata.func  = @(t, p) p(4) + (1 - p(4) - p(3)) .* normcdf( t, p(1), p(2) ); 
    end
    
    LoopNum_Correct = 0;
    for n =1:length(data.left)
        % 目的関数の定義
        objfunc = @(p) -mlefunc(p, data.x.value, data.left.rawDataValue, data.left.rawTrialNum, data.left.fitdata.func);

        % 探索の初期値
        c = 1;
        for P = 0:0.015:0.045
        for Q = 0:0.015:0.03   
        for R = 0:0.25:0.50
        for S = 0.25:0.25:0.75    
            initVal{c} = [ P, Q, R, S]; %平均,分散,α,βの探索初期値
            c = c + 1;
        end
        end
        end
        end

        % 制約の定義
        lb = [ 0, 1e-6,   0,  0 ];
        ub = [  Inf,  Inf,  1,  1 ];
        fvalMin = Inf;
        for c = 1:length(initVal)
            [ prm, fval, exitflag ] = fmincon( objfunc, initVal{c}, [], [], [], [], lb, ub, [], optimset('Display', 'notify' ) );

            if fval < fvalMin
                fvalMinNum = c; 
                fvalMin = fval;
                prmMin = prm;
                initValMinMat = initVal{c};
            end
            LoopNum_Correct = LoopNum_Correct +1

        end
        %最適な探索の初期値
        data.left.fitdata.initVal = initValMinMat;
        %平均,分散,α,β
%         prmMin(1) = 0;
        data.left.fitdata.prm = prmMin;
        %定義したマイナス尤度関数の最小値
        data.left.fitdata.fval = fvalMin;
        % 弁別閾値 (正答率 75% にあたる視差強度) を求める
        data.left.sppData(1).description = 'Threshold';
        data.left.sppData(1).value = GetThreshold(0.75, data.left.fitdata.func, data.left.fitdata.prm);
        % 正答率 60 %にあたる視差強度 を求める
        data.left.sppData(2).description = '60% correct choice';
        data.left.sppData(2).value = GetThreshold(0.60, data.left.fitdata.func, data.left.fitdata.prm);
        % 正答率 90 %にあたる視差強度 を求める
        data.left.sppData(3).description = '90% correct choice';
        data.left.sppData(3).value = GetThreshold(0.90, data.left.fitdata.func, data.left.fitdata.prm); 
  
        clear objfunc initVal;
        clear fvalMinNum fvalMin prmMin initValMin;

  
    end

    % 決定係数(心理物理関数の当てはまりのよさ) を求める SSE:残差平方和 SST:全分散の和 CoD:決定係数

    for n = 1:length(data.left)
        for m = 1:data.ExpNum
            dataleftMagDispVsConCorrectChoicePropMatTemp(:,m,n) = data.left.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat(:,n,m);
        end
        Ytemp(:,:,n) = repmat( data.left.rawDataValue,1,data.ExpNum);
        SSE_Correct(n) = sum(( data.left.rawDataValue - data.left.fitdata.func( data.x.value, data.left.fitdata.prm) ).^2);
        SST_Correct(n) = sum(sum((dataleftMagDispVsConCorrectChoicePropMatTemp(:,:,n) - Ytemp(:,:,n)).^2));
        data.left.fitdata.r_sq = 1 - SSE_Correct(n)/SST_Correct(n);
    end
%     for 
%     data.all(n).fitdata.func(t,data.all(n).fitdata.prm)
end

if strcmp(data.type , 'PCC')
   
    for n =1:length(data.right)
        %フィッティングする
        data.right.fitdata.isFit = true;
        % 心理測定関数の定義
        data.right.fitdata.func  = @(t, p) p(4) + (1 - p(4) - p(3)) .* normcdf( t, p(1), p(2) ); 
    end
    
    LoopNum_Correct = 0;
    for n =1:length(data.right)
        % 目的関数の定義
        objfunc = @(p) -mlefunc(p, data.x.value, data.right.rawDataValue, data.right.rawTrialNum, data.right.fitdata.func);

        % 探索の初期値
        c = 1;
        for P = 0:0.015:0.045
        for Q = 0:0.015:0.03   
        for R = 0:0.25:0.50
        for S = 0.25:0.25:0.75    
            initVal{c} = [ P, Q, R, S]; %平均,分散,α,βの探索初期値
            c = c + 1;
        end
        end
        end
        end

        % 制約の定義
        lb = [ 0, 1e-6,   0,  0 ];
        ub = [  Inf,  Inf,  1,  1 ];
        fvalMin = Inf;
        for c = 1:length(initVal)
            [ prm, fval, exitflag ] = fmincon( objfunc, initVal{c}, [], [], [], [], lb, ub, [], optimset('Display', 'notify' ) );

            if fval < fvalMin
                fvalMinNum = c; 
                fvalMin = fval;
                prmMin = prm;
                initValMinMat = initVal{c};
            end
            LoopNum_Correct = LoopNum_Correct +1

        end
        %最適な探索の初期値
        data.right.fitdata.initVal = initValMinMat;
        %平均,分散,α,β
%         prmMin(1) = 0;
        data.right.fitdata.prm = prmMin;
        %定義したマイナス尤度関数の最小値
        data.right.fitdata.fval = fvalMin;
        % 弁別閾値 (正答率 75% にあたる視差強度) を求める
        data.right.sppData(1).description = 'Threshold';
        data.right.sppData(1).value = GetThreshold(0.75, data.right.fitdata.func, data.right.fitdata.prm);
        % 正答率 60 %にあたる視差強度 を求める
        data.right.sppData(2).description = '60% correct choice';
        data.right.sppData(2).value = GetThreshold(0.60, data.right.fitdata.func, data.right.fitdata.prm);
        % 正答率 90 %にあたる視差強度 を求める
        data.right.sppData(3).description = '90% correct choice';
        data.right.sppData(3).value = GetThreshold(0.90, data.right.fitdata.func, data.right.fitdata.prm); 
  
        clear objfunc initVal;
        clear fvalMinNum fvalMin prmMin initValMin;

  
    end

    % 決定係数(心理物理関数の当てはまりのよさ) を求める SSE:残差平方和 SST:全分散の和 CoD:決定係数

    for n = 1:length(data.right)
        for m = 1:data.ExpNum
            datarightMagDispVsConCorrectChoicePropMatTemp(:,m,n) = data.right.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat(:,n,m);
        end
        Ytemp(:,:,n) = repmat( data.right.rawDataValue,1,data.ExpNum);
        SSE_Correct(n) = sum(( data.right.rawDataValue - data.right.fitdata.func( data.x.value, data.right.fitdata.prm) ).^2);
        SST_Correct(n) = sum(sum((datarightMagDispVsConCorrectChoicePropMatTemp(:,:,n) - Ytemp(:,:,n)).^2));
        data.right.fitdata.r_sq = 1 - SSE_Correct(n)/SST_Correct(n);
    end
%     for 
%     data.all(n).fitdata.func(t,data.all(n).fitdata.prm)
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfunctions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%尤度関数
function out = mlefunc(p, x, y, n, f)
CNDF = f(x, p);

CNDF( CNDF <= 0 ) = 1e-6;
CNDF( CNDF >= 1 ) = 1 - 1e-6;

out = sum ( log ( factorial(n) ./ ( factorial( round(y .* n) ) .* factorial( round(n - y .* n) ) ) ) ...
                       + y .* n .* ( log( CNDF ) ) ...
                       + ( 1 - y ) .* n .* ( log( 1 - CNDF ) ) );
%逆関数
function x = GetThreshold(y, f, p)
objectFunc = @(t) (f(t, p) - y) ^ 2;
x = fminsearch(objectFunc, p(1),[]);%p(1)急峻なところを初期値にする

% %決定係数
% function r_sq = GetRsq(ExpNum,datacon,ChoicePropMat,x,y,p,f)
%     for n = 1:length(datacon)
%         for m = 1:ExpNum
%             RevChoicePropMat(:,m,n) = ChoicePropMat(:,n,m);
%         end
%         Ytemp(:,:,n) = repmat(y(n),1,length(dataFiles));
%         SSE(n) = sum(( y(n) - f( x, p(n) ) ).^2);
%         SST(n) = sum(sum((RevChoicePropMat(:,:,n) - Ytemp(:,:,n)).^2));
%         r_sq(n) = 1 - SSE(n)/SST(n);
%     end
% r = 1 - sum( (y - fx) .^ 2 ) / sum( (y - mean(y,1)) .^ 2 );%mean(y,1) 列平均
% 
% data.all.fitdata.r_sq = GetRsq( data.ExpNum,data.all,data.dataUsedinPcc.dataAllDispVsPosFarChoicePropMat, data.x.value,data.all.rawDataValue, data.all(n).fitdata.prm,data.all(n).fitdata.func)
    
    
    
    
    
    
    
