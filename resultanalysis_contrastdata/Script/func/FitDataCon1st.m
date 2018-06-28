function data = FitDataCon1st(data)
%% プロットに心理測定関数を当てはめ、弁別閾値を求める
% if strcmp(data.type , 'CON')
%    
%     for n =1:length(data.condition)
%         %フィッティングする
%         data.condition(n).fitdata.isFit = true;
%         % 心理測定関数の定義
%         data.condition(n).fitdata.func  = @(t, p) p(4) + (1 - p(4) - p(3)) .* normcdf( t, p(1), p(2) ); 
%     end
%     
%     LoopNum_Correct = 0;
%     for n =1:length(data.condition)
%         % 目的関数の定義
%         objfunc = @(p) -mlefunc(p, data.x.value, data.condition(n).rawDataValue, data.condition(n).rawTrialNum, data.condition(n).fitdata.func);
% 
%         % 探索の初期値
%         c = 1;
%         for P = 0:0.015:0.045
%         for Q = 0:0.015:0.03   
%         for R = 0:0.25:0.50
%         for S = 0.25:0.25:0.75    
%             initVal{c} = [ P, Q, R, S]; %平均,分散,α,βの探索初期値
%             c = c + 1;
%         end
%         end
%         end
%         end
% 
%         % 制約の定義
%         lb = [ 0, 1e-6,   0,  0 ];
%         ub = [  Inf,  Inf,  1,  1 ];
%         fvalMin = Inf;
%         for c = 1:length(initVal)
%             [ prm, fval, exitflag ] = fmincon( objfunc, initVal{c}, [], [], [], [], lb, ub, [], optimset('Display', 'notify' ) );
% 
%             if fval < fvalMin
%                 fvalMinNum = c; 
%                 fvalMin = fval;
%                 prmMin = prm;
%                 initValMinMat = initVal{c};
%             end
%             LoopNum_Correct = LoopNum_Correct +1
% 
%         end
%         %最適な探索の初期値
%         data.condition(n).fitdata.initVal = initValMinMat;
%         %平均,分散,α,β
% %         prmMin(1) = 0; 
%         data.condition(n).fitdata.prm = prmMin;
%         %定義したマイナス尤度関数の最小値
%         data.condition(n).fitdata.fval = fvalMin;
%         % 弁別閾値 (正答率 75% にあたる視差強度) を求める
%         data.condition(n).sppData(1).description = 'Threshold';
%         data.condition(n).sppData(1).value = GetThreshold(0.75, data.condition(n).fitdata.func, data.condition(n).fitdata.prm);
%         % 正答率 60 %にあたる視差強度 を求める
%         data.condition(n).sppData(2).description = '60% correct choice';
%         data.condition(n).sppData(2).value = GetThreshold(0.60, data.condition(n).fitdata.func, data.condition(n).fitdata.prm);
%         % 正答率 90 %にあたる視差強度 を求める
%         data.condition(n).sppData(3).description = '90% correct choice';
%         data.condition(n).sppData(3).value = GetThreshold(0.90, data.condition(n).fitdata.func, data.condition(n).fitdata.prm); 
%   
%         clear objfunc initVal;
%         clear fvalMinNum fvalMin prmMin initValMin;
% 
%   
%     end
% 
%     % 決定係数(心理物理関数の当てはまりのよさ) を求める SSE:残差平方和 SST:全分散の和 CoD:決定係数
%     for n = 1:length(data.condition)
%         SSE_Correct(n) = sum(( data.condition(n).rawDataValue - data.condition(n).fitdata.func( data.x.value, data.condition(n).fitdata.prm) ).^2);
%         meanrawDataValue = mean(data.condition(n).rawDataValue);
%         SST_Correct(n) = sum(( data.condition(n).rawDataValue - meanrawDataValue).^2);
%         data.condition(n).fitdata.r_sq = 1 - SSE_Correct(n)/SST_Correct(n);
%     end
%     clear SSE_Correct SST_Correct meanrawDataValue  
%     
%     
% %     for n = 1:length(data.condition)
% %         for m = 1:data.ExpNum
% %             dataMagDispVsConCorrectChoicePropMatTemp(:,m,n) = data.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat(:,n,m);
% %         end
% %         Ytemp(:,:,n) = repmat( data.condition(n).rawDataValue,1,data.ExpNum);
% %         SSE_Correct(n) = sum(( data.condition(n).rawDataValue - data.condition(n).fitdata.func( data.x.value, data.condition(n).fitdata.prm) ).^2);
% %         SST_Correct(n) = sum(sum((dataMagDispVsConCorrectChoicePropMatTemp(:,:,n) - Ytemp(:,:,n)).^2));
% %         data.condition(n).fitdata.r_sq = 1 - SSE_Correct(n)/SST_Correct(n);
% %     end
% end

if strcmp(data.type , 'CON')
   
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
            LoopNum_Correct = LoopNum_Correct +1;

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
        SSE_Correct(n) = sum(( data.all(n).rawDataValue - data.all(n).fitdata.func( data.x.value, data.all(n).fitdata.prm) ).^2);
        meanrawDataValue = mean(data.all(n).rawDataValue);
        SST_Correct(n) = sum(( data.all(n).rawDataValue - meanrawDataValue).^2);
        data.all(n).fitdata.r_sq = 1 - SSE_Correct(n)/SST_Correct(n);
    end
    clear SSE_Correct SST_Correct meanrawDataValue 
    
    % 決定係数(心理物理関数の当てはまりのよさ) を求める SSE:残差平方和 SST:全分散の和 CoD:決定係数

%     for n = 1:length(data.all)
%         for m = 1:data.ExpNum
%             dataAllMagDispVsConCorrectChoicePropMatTemp(:,m,n) = data.all.dataUsedinFitData.dataMagDispVsConCorrectChoicePropMat(:,n,m);
%         end
%         Ytemp(:,:,n) = repmat( data.all(n).rawDataValue,1,data.ExpNum);
%         SSE_Correct(n) = sum(( data.all(n).rawDataValue - data.all(n).fitdata.func( data.x.value, data.all(n).fitdata.prm) ).^2);
%         SST_Correct(n) = sum(sum((dataAllMagDispVsConCorrectChoicePropMatTemp(:,:,n) - Ytemp(:,:,n)).^2));
%         data.all(n).fitdata.r_sq = 1 - SSE_Correct(n)/SST_Correct(n);
%     end
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
    
    
    
    
    
    
    
