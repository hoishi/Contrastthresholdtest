function [ scrnNum, wndPtr ] = CreateTestWindow
% CreateWindow    Create PTB window
%
% See source code of StereoDemo for the details of following processings
%

try
%     stereoMode = 0;
    scrnNum = max(Screen('Screens'));


    bgColor = (( WhiteIndex(scrnNum) + BlackIndex(scrnNum)) .* 0.5)+4;

    wndPtr = Screen('OpenWindow', scrnNum, bgColor, [], [], [], 0);
%     Screen('LoadNormalizedGammaTable', wndPtr)
    Screen('BlendFunction', wndPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    Screen('Flip', wndPtr);

catch
    Screen('CloseAll');
    ShowCursor;
    psychrethrow(psychlasterror);
    
    scrnNum = NaN;
    wndPtr  = NaN;
end

