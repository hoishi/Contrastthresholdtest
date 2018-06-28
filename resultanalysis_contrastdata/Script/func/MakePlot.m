function MakePlot(data, hf)
% MakeFigure    �f�[�^���v���b�g����

lineWidth  = 2;
markerSize = 4;

sppStr = ''; % �T�v���f�[�^�\���p�̕�����

hold on;
for n = 1:length(data.condition)
    x = data.x.value;
    y = data.condition(n).rawDataValue;
    er = data.condition(n).rawDataEbar;

    if data.condition(n).fitdata.isFit
        lineStyle = 'none';
    else
        lineStyle = data.condition(n).line;
    end

    if ~isnan(er)
        errorbar(x, y, er, ...
                 'Color', data.condition(n).color, 'Marker', data.condition(n).marker, 'MarkerSize', markerSize, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    else
        plot(x, y, 'Color', data.condition(n).color, 'Marker', data.condition(n).marker, 'MarkerSize', markerSize, 'LineStyle', lineStyle, 'LineWidth', lineWidth);
    end
end
legend(  { data.condition(:).description } , 'Location', data.posLegend);

for n = 1:length(data.condition)
    % �t�B�b�e�B���O�����J�[�u�̃v���b�g
    if data.condition(n).fitdata.isFit
        x = [ min(data.x.value):0.001:max(data.x.value) ];
        y = data.condition(n).fitdata.func(x, data.condition(n).fitdata.prm);
 
        plot(x, y, data.condition(n).line, 'Color', data.condition(n).color, 'LineWidth', lineWidth);
    end

    % �⏕���̕`��
    if isfield(data.condition(n), 'sppLine')
        for t = 1:length(data.condition(n).sppLine)
            cSpLine = data.condition(n).sppLine(t);
            plot(cSpLine.x, cSpLine.y, ...
                 'Color', cSpLine.color, 'LineStyle', cSpLine.line, 'LineWidth', cSpLine.width);
        end
    end

    % �T�v���f�[�^�̕\��
    if isfield(data.condition(n), 'sppData')
        for t = 1:length(data.condition(n).sppData)
            cSpData = data.condition(n).sppData(t);
            sppStr = sprintf('%s    \t%s: %.3f', sppStr, cSpData.description, cSpData.value);
        end
        sppStr = sprintf('%s\n', sppStr);
    end
end

if ~isempty(sppStr)
    text(data.posSppData(1), data.posSppData(2), sppStr);
end

%% �v���b�g�̏C��
box off;

xlabel(data.x.label);
xlim(data.x.lim);
ylabel(data.y.label);
ylim(data.y.lim);
title(data.description);

