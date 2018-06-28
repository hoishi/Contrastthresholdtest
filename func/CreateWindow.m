function [ scrnNum, wndPtr ] = CreateMONOWindow( stereoMode,bgColor)
% CreateWindow    Create PTB window
%
% See source code of StereoDemo for the details of following processings
%

try
    stereoMode = 0;
    scrnNum = max(Screen('Screens'));


    bgColor = [ WhiteIndex(scrnNum) + BlackIndex(scrnNum)] .* bgColor;

    wndPtr = Screen('OpenWindow', scrnNum, bgColor, [], [], [], stereoMode);
    
    Screen('BlendFunction', wndPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    Screen('Flip', wndPtr);

catch
    Screen('CloseAll');
    ShowCursor;
    psychrethrow(psychlasterror);
    
    scrnNum = NaN;
    wndPtr  = NaN;
end

