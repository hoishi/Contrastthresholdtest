function Copy_of_MakePlot(data, hf)
% MakeFigure    データをプロットする

if ~isnan( strfind( data.id, '4pos') ) || ~isnan( strfind( data.id, '3freq') )
    % Color and Marker types 
    b = [0 0 1];%青
    v = [0.85 0 0.502];%紫
    y = [0.753 0.753 0];%黄緑
    % c = [0 0.8 0.8];%シアン
    % Raw data のプロットに使用
    data.condition(1).color = b;
    data.condition(2).color = v;
    data.condition(3).color = y;
    % data.condition(4).color = c;

    data.condition(1).marker = 'o';
    data.condition(2).marker = 's';
    data.condition(3).marker = 'd';
    % data.condition(4).marker = '+';
    if ~isnan( strfind( data.id, '4pos') )
        c = [0 0.8 0.8];%シアン
        data.condition(4).color = c;
        data.condition(4).marker = 'h';
    end
end

axes('Position',[0 0 1 1],'Visible','off');
hold on;
expID = [ 'expID: ', data.id] ;
expID = text( .75, .98, expID );
set( expID, 'FontSize', 9 );
subjectID = [ 'subjectID: ', data.subjectID ];
subjectID = text( .75, .96, subjectID );
set( subjectID, 'FontSize', 9 );
date = [ 'date: ', data.date ];
date = text( .75, .94, date );
set( date, 'FontSize', 9 );

axes('Position',[0.1300 0.1100 0.7750 0.8150]);
hold on;
% Title
type = sprintf(data.type,'FontSize','18');
title(type);
saveName = [ data.type, '_', data.id, '_', data.subjectID, '_', data.date, '.fig'];

for n = 1:length(data.condition)
    X = data.x.value;
    Y = data.condition(n).rawDataValue;
    ER = data.condition(n).rawDataEbar;
%     if ~isnan(ER)
%         errorbar(X, Y, ER, ...
%                   'Color', data.condition(n).color,'Marker',data.condition(n).marker,'LineStyle','none');
%     else
        plot(X, Y, 'MarkerEdgeColor',data.condition(n).color,'MarkerFaceColor', data.condition(n).color, 'Marker', data.condition(n).marker,'LineStyle','none');
%     end
end


% プロットの整形
box off;
%「奥」選択率
if strcmp(data.type ,'PFC') 
    data.x.label = 'Disparity';
    data.y.label = 'Proportion of Far Choices';
    xlabel(data.x.label);
    ylabel(data.y.label);
    xlim([ min( data.x.value ) - 0.0001, max( data.x.value ) + 0.001 ]); ylim([ -0.01, 1.01 ]);
%     % Legend
%     legend({ data.condition(:).description }, 'Location', 'northwest');
    % Title
    type = sprintf(data.type,'FontSize','18');
    title(type);
           
    for n = 1:length(data.condition)
        if ~isnan(data.condition(n).fitdata.isFit)%「奥」選択率のフィッティングの描画
            %フィッティング関数のデータ点
            
                xPlotIndexFar{n} = ( min( data.x.value ) : 0.001 : max( data.x.value ) )';
                yPlotIndexFar{n} = data.condition(n).fitdata.func( xPlotIndexFar{n}, data.condition(n).fitdata.prm );
            
            %フィッティング関数を描画
            
                plot( xPlotIndexFar{n}, yPlotIndexFar{n},'Color',data.condition(n).color,'LineWidth',2.5,'LineStyle','--');
            
            %主観的等価点をプロット
            
                plot([ data.condition(n).sppData(1).value data.condition(n).sppData(1).value ], [ 0 1 ], 'Color',data.condition(n).color,'LineStyle',':');
            
            % 「奥」選択率が 25 % の視差のところに縦線を引く
            % for n = 1:length(data.condition)
            %     plot([ data.condition(1).fitdata.25far data.condition(n).fitdata.pse ], [ 0.25 0.25 ], 'Color',data.condition(n).color,'LineStyle',':');
            % end
            % 「奥」選択率が 75 % の視差のところに縦線を引く
            % for n = 1:length(data.condition)
            %     plot([ data.condition(n).fitdata.pse data.condition(1).fitdata.75far ], [ 0.75 0.75 ], 'Color',data.condition(n).color,'LineStyle',':');
            % end
% 
%             % 主観的等価点(pse)の視差の値をfigure中に記載
%             
%                 PseText(n) = text( 0.06 / max( data.x.value ) * max( data.x.value ), 0.4 - 0.05*n, sprintf('PSE(%d): %f\n', n, data.condition(n).sppData(1).value));
%                 set( PseText(n),'FontSize', 9 );
%                 
%             
%             % Near 閾値の視差の値をfigure中に記載
%             
%                 NTText(n) = text( 0.085 / max( data.x.value ) * max( data.x.value ), 0.4 - 0.05*n, sprintf('NearThreshold(%d): %f\n', n,  data.condition(n).sppData(4).value));
%                 set( NTText(n),'FontSize', 9 );
%                 
%             
%             %　Far 閾値の視差の値をfigure中に記載
%             
%                 FTText(n) = text( 0.125 / max( data.x.value ) * max( data.x.value ), 0.4 - 0.05*n, sprintf('FarThreshold(%d): %f\n', n, data.condition(n).sppData(5).value));
%                 set( FTText(n),'FontSize', 9 );
%                 
%             
%             % 決定係数の値をfigure中に記載
%             
%                 R_SQText(n) = text( -0.12 / max( data.x.value ) * max( data.x.value ),0.98 - 0.02*n,sprintf('R^2(%d): %f\n', n, data.condition(n).fitdata.r_sq));
%                 set( R_SQText(n),'FontSize', 9 );
                
                
        end
    end
end



%正答率    
if strcmp(data.type , 'CON') 
    data.x.label = 'Luminance magnitude';
    data.y.label = 'Proportion of correct';
    xlabel(data.x.label);
    ylabel(data.y.label);
    xlim([ 0, max( data.x.value ) + 0.001 ]); ylim([ 0, 1 + 0.01 ]);
%     % Legend
%     legend({ data.condition(:).description }, 'Location', 'southwest');
    % Title
    type = sprintf(data.type,'FontSize','18');
    title(type);
    
    for n = 1:length(data.condition)
        if ~isnan(data.condition(n).fitdata.isFit) %正答率のフィッティングの描画
            %フィッティング関数のデータ点
            
                xPlotIndexCorrect{n} = (0:0.001:max( data.x.value ))';
                yPlotIndexCorrect{n} = data.condition(n).fitdata.func( xPlotIndexCorrect{n}, data.condition(n).fitdata.prm );
            

            %フィッティング関数を描画
            
                plot(xPlotIndexCorrect{n}, yPlotIndexCorrect{n},'Color',data.condition(n).color,'LineWidth',2.5,'LineStyle','--');
            

            %閾値をプロット
            
                plot([ 0 max( data.x.value ) ], [0.75 0.75], 'Color', data.condition(n).color,'LineStyle' ,':');
                plot([ data.condition(n).sppData(1).value data.condition(n).sppData(1).value ], [ 0 1 ], 'Color', data.condition(n).color,'LineStyle' ,':');
            
            % 閾値の視差の値をfigure中に記載
%                 if data.condition(n).sppData(1).value > 0.32
%                     ThresholdText(n) = text( 0.08 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( 'Threshold(%d): %s\n', n, 'bigger' ));
%                 elseif data.condition(n).sppData(1).value < 0.01
%                     ThresholdText(n) = text( 0.08 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( 'Threshold(%d): %s\n', n, 'smaller' ));
%                 else                
%                     ThresholdText(n) = text( 0.08 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( 'Threshold(%d): %f\n', n, data.condition(n).sppData(1).value ));
%                     set( ThresholdText(n), 'FontSize', 9 );
%                 end
%                     ThresholdText(n) = text( 0.06 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( 'Threshold(%d): %f\n', n, data.condition(n).sppData(1).value ));
%                     set( ThresholdText(n), 'FontSize', 9 );
            % 正答率 60 %にあたる視差強度の値をfigure中に記載
%                 if data.condition(n).sppData(2).value > 0.32
%                     LowCorrectText(n) = text( 0.12 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( '60per Correct(%d): %s\n', n, 'bigger' ));
%                 elseif data.condition(n).sppData(2).value < 0.01
%                     LowCorrectText(n) = text( 0.12 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( '60per Correct(%d): %s\n', n, 'smaller' ));
%                 else            
%                     LowCorrectText(n) = text( 0.12 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( '60per Correct(%d): %f\n', n, data.condition(n).sppData(2).value ));
%                     set( LowCorrectText, 'FontSize', 9 );
%                 end
%                     LowCorrectText(n) = text( 0.09 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( '60per Correct(%d): %f\n', n, data.condition(n).sppData(2).value ));
%                     set( LowCorrectText, 'FontSize', 9 );
                
            % 正答率 90 %にあたる視差強度の値をfigure中に記載
%                 if data.condition(n).sppData(3).value > 0.32
%                     HighCorrectText(n) = text( 0.16 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( '90per Correct(%d): %s\n', n, 'bigger' ));
%                 elseif data.condition(n).sppData(3).value < 0.01
%                     HighCorrectText(n) = text( 0.16 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( '90per Correct(%d): %s\n', n, 'smaller' ));
%                 else            
%                     HighCorrectText(n) = text( 0.16 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( '90per Correct(%d): %f\n', n, data.condition(n).sppData(3).value ));
%                     set( HighCorrectText(n), 'FontSize', 9 );               
%                 end
%                     LowCorrectText(n) = text( 0.12 / max( data.x.value ) * max( data.x.value ), 0.5 - 0.1*n, sprintf( '60per Correct(%d): %f\n', n, data.condition(n).sppData(2).value ));
%                     set( LowCorrectText, 'FontSize', 9 );            
            % 決定係数の値をfigure中に記載
            
%                 R_SQText(n) =text( 0.20 / max( data.x.value ) * max( data.x.value ),0.5 - 0.1*n, sprintf('R^2(%d): %f\n', n, data.condition(n).fitdata.r_sq ));
%                 set( R_SQText(n), 'FontSize', 9 );
                
            ax = gca;
            set(ax,'XScale','log');
        end
    end
end

%Save figure
set(hf, 'Name', saveName);
set(hf, 'NumberTitle', ' off');
saveas( hf, saveName);



