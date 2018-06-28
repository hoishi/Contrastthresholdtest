function dataFile = GetFilesUI(ext)
% GetFilesUI    GUI で選択されたファイルをセル配列で返す
%

if exist('ext', 'var')
    extspec = [ './*.' ext ];
else
    extspec = [ './*' ];
end

[ files pathToFile ] = uigetfile(extspec, 'Select file(s)', 'MultiSelect', 'on');

if iscell(files)
    for n = 1:length(files)
        dataFile{n} = [ pathToFile files{n} ];
    end
else
    dataFile{1} = [ pathToFile files ];
end

