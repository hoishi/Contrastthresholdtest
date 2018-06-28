function [ scrnNum, wndPtr ] = TestColor
% CreateWindow    Create PTB window
%
% See source code of StereoDemo for the details of following processings
%

try
    load('C:\Users\h.oishi\OneDrive\170204\HO\ContrastExperiment(HO)\PsyExp-Contrast\env.mat')
    % reset display gamma-function
ResetDisplayGammaPTB();
% force to 10-bit display output
AssertOpenGL;
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General','FloatingPoint32BitIfPossible'); % try to get 32 bpc fload precision if the hardware supports
PsychImaging('AddTask','General','EnableNative10BitFramebuffer'); % enable 10-bit color depth (generally for ATI graphic cards, but also effective for some nVidia cards)


    
    
    stereoMode = 0;
    scrnNum = max(Screen('Screens'));

% Previous setting
%     bgColor = floor(( WhiteIndex(scrnNum) + BlackIndex(scrnNum)) .* bgColor);
% 
%     wndPtr = Screen('OpenWindow', scrnNum, bgColor, [], [], [], stereoMode);

% 10 bit setting

    bgColor10bit = env.lut(512);
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

