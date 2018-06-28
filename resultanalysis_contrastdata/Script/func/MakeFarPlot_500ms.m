function MakeFarPlot_500ms()
% MakeFigure    データをプロットする

% if ~isnan( strfind( data.id, '4pos') ) || ~isnan( strfind( data.id, '3freq') )
%     % Color and Marker types 
%     b = [0 0 1];%青
%     v = [0.85 0 0.502];%紫
%     y = [0.753 0.753 0];%黄緑
%     % c = [0 0.8 0.8];%シアン
%     % Raw data のプロットに使用
%     data.all(1).color = b;
%     data.all(2).color = v;
%     data.all(3).color = y;
%     % data.all(4).color = c;
% 
%     data.all(1).marker = 'o';
%     data.all(2).marker = 's';
%     data.all(3).marker = 'p';
%     % data.all(4).marker = 'h';
%     if ~isnan( strfind( data.id, '4pos') )
%         c = [0 0.8 0.8];%シアン
%         data.all(4).color = c;
%         data.all(4).marker = '+';
%     end
% end
%  b = [0 0 1];%青
%  v = [0.85 0 0.502];%紫
%  y = [0.753 0.753 0];%黄緑
%  c = [0 0.8 0.8];%シアン
%  g = [0.2 1 0.5];%緑
%  r  = [1 0.6 0.2];%オレンジ
%  data.all.disp2nd.color{1} = b;
%  data.all.disp2nd.color{2} = v;
%  data.all.disp2nd.color{3} = y;
%  data.all.disp2nd.color{4} = c;
%  data.all.disp2nd.color{5} = g;
%  data.all.disp2nd.color{6} = r;

 

addpath('./StereoDiffusionMRI/Script');
addpath('./StereoDiffusionMRI/Script/lib');
addpath('./StereoDiffusionMRI/Script/func');
addpath('./lib');
addpath('./func');
%% データの読み込み
dataFiles = GetFilesUI('mat');

for n = 1:length(dataFiles)
    load(dataFiles{n});
    data(n) = dataPfc;
end

hf = figure;
axes('Position',[0 0 1 1],'Visible','off');
hold on;
% expID = [ 'expID: ', data.id] ;
% expID = text( .75, .98, expID );
% set( expID, 'FontSize', 9 );
% subjectID = [ 'subjectID: ', data.subjectID ];
% subjectID = text( .75, .96, subjectID );
% set( subjectID, 'FontSize', 9 );
% date = [ 'date: ', data.date ];
% date = text( .75, .94, date );
% set( date, 'FontSize', 9 );

axes('Position',[0.1300 0.1100 0.7750 0.8150]);
hold on;
% Title
type = sprintf(data(1).type,'FontSize','18');
title(type);
saveName = [ '500ms',data(1).type, '_', data(1).id, '_','.fig'];

for n = 1:length(data)
    X = data(n).x.value;
    Y = data(n).all.rawDataValue;
    ER = data(n).all.rawDataEbar;
%     if ~isnan(ER)
%         errorbar(X, Y, ER, ...
%                   'Color', data(n).all.color,'Marker',data(n).all.marker,'LineStyle','none');
%     else
%         plot(X, Y, 'Color', data(n).all.color, 'Marker', data(n).all.marker,'LineStyle','none');        
%     end
    plot(X, Y, 'Marker', 's','MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k','LineStyle','none');
end

% プロットの整形
box off;




%「奥」選択率
if strcmp(data.type ,'PFC') 
    data.x.label = 'Disparity';
    data.y.label = 'Proportion of Far Choices';
    xlabel(data.x.label);
    ylabel(data.y.label);
    xlim([ min( data.x.value ) - 0.001, max( data.x.value ) + 0.001 ]); ylim([ -0.01, 1.01 ]);
%     % Legend
%     legend({ data.all(:).description }, 'Location', 'northwest');
    % Title
    type = sprintf(data.type,'FontSize','18');
    title(type);
           
    for n = 1:length(data.all)
        if ~isnan(data.all.fitdata.isFit)%「奥」選択率のフィッティングの描画
            %フィッティング関数のデータ点
            
                xPlotIndexFar{n} = ( min( data.x.value ) : 0.001 : max( data.x.value ) )';
                yPlotIndexFar{n} = data.all.fitdata.func( xPlotIndexFar{n}, data.all.fitdata.prm );
            
            %フィッティング関数を描画
            
                plot( xPlotIndexFar{n}, yPlotIndexFar{n},'Color','k','LineWidth',2.5,'LineStyle','--');
            
            %主観的等価点をプロット
            
                plot([ data.all.sppData(1).value data.all.sppData(1).value ], [ 0 1 ], 'Color','k','LineStyle',':');
            
            % 「奥」選択率が 25 % の視差のところに縦線を引く
            % for n = 1:length(data.all)
            %     plot([ data.all(1).fitdata.25far data.all.fitdata.pse ], [ 0.25 0.25 ], 'Color',data.all.color,'LineStyle',':');
            % end
            % 「奥」選択率が 75 % の視差のところに縦線を引く
            % for n = 1:length(data.all)
            %     plot([ data.all.fitdata.pse data.all(1).fitdata.75far ], [ 0.75 0.75 ], 'Color',data.all.color,'LineStyle',':');
            % end

%             % 主観的等価点(pse)の視差の値をfigure中に記載
%             
%                 PseText(n) = text( 0.06 / max( data.x.value ) * max( data.x.value ), 0.4 - 0.05*n, sprintf('PSE(%d): %f\n', n, data.all.sppData(1).value));
%                 set( PseText(n),'FontSize', 9 );
%                 
%             
%             % Near 閾値の視差の値をfigure中に記載
%             
%                 NTText(n) = text( 0.085 / max( data.x.value ) * max( data.x.value ), 0.4 - 0.05*n, sprintf('NearThreshold(%d): %f\n', n,  data.all.sppData(4).value));
%                 set( NTText(n),'FontSize', 9 );
%                 
%             
%             %　Far 閾値の視差の値をfigure中に記載
%             
%                 FTText(n) = text( 0.125 / max( data.x.value ) * max( data.x.value ), 0.4 - 0.05*n, sprintf('FarThreshold(%d): %f\n', n, data.all.sppData(5).value));
%                 set( FTText(n),'FontSize', 9 );
%                 
%             
%             % 決定係数の値をfigure中に記載
%             
%                 R_SQText(n) = text( -0.12 / max( data.x.value ) * max( data.x.value ),0.98 - 0.02*n,sprintf('R^2(%d): %f\n', n, data.all.fitdata.r_sq));
%                 set( R_SQText(n),'FontSize', 9 );
                
                
        end
    end
end

%Save figure
set(hf, 'Name', saveName);
set(hf, 'NumberTitle', ' off');
saveas( hf, saveName);



