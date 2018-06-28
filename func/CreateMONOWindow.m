function [ scrnNum, wndPtr ] = CreateMONOWindow( stereoMode,bgColor)
% CreateWindow    Create PTB window
%
% See source code of StereoDemo for the details of following processings
%

try
    stereoMode = 0;
    scrnNum = max(Screen('Screens'));

% Previous setting
%     bgColor = floor(( WhiteIndex(scrnNum) + BlackIndex(scrnNum)) .* bgColor);
% 
%     wndPtr = Screen('OpenWindow', scrnNum, bgColor, [], [], [], stereoMode);

%load('mcalibrator2_results_170207_8bit_LCD.mat');%BAD
%bgColor10bit = [lut{4,1}(1,127) ];%BAD
% 10 bit setting

    bgColor10bit = bgColor(512);%%
    wndPtr = PsychImaging('OpenWindow', scrnNum, bgColor10bit, [], [], [], stereoMode);
%     Screen('LoadNormalizedGammaTable', wndPtr)

% test script AdditiveBlendingForLinerSuperpositionTutorial.m
%     Screen('BlendFunction', wndPtr, GL_SRC_ALPHA, GL_ONE);
% Prevoius setting
    Screen('BlendFunction', wndPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    Screen('Flip', wndPtr);

catch
    Screen('CloseAll');
    ShowCursor;
    psychrethrow(psychlasterror);
    
    scrnNum = NaN;
    wndPtr  = NaN;
end

