function stimPattern = DrawContrastStim(env, tm, prm)
% DrawContrastStim    �Ȗ͗l�ɃK�{?[���t�B���^?[���|�������̂�?o�͂���

if prm.updateStim
    stimPattern = GenGbrPattern(env, tm, prm);
else
    stimPattern = prm.stimPattern;
end

% �K�{?[���p�b�`��`�悷��
% Screen('SelectStereoDrawBuffer', env.wndPtr, 0);
gabor_tex=Screen('MakeTexture', env.wndPtr, stimPattern.myImgMat); %this is the Gabor texture, gabor_tex, which we use anytime we draw a Gabor
if ~isempty(stimPattern.myImgMat)
    Screen('DrawTexture', env.wndPtr, gabor_tex,[],stimPattern.stimPos,[]);%draw at the center 
% Screen('DrawTexture', env.wndPtr, gabor_tex,stimPattern.gabor_tex_rect,stimPattern.stimPos,[]);%�h���̍���(00)����E��(�w��)��I��
% Screen('DrawTexture', env.wndPtr, gabor_tex,[],stimPattern.stimPos,10);

%     Screen('DrawTexture', w, gabor_tex, gabor_tex_rect, gabor_rect, TargetGabor(kk));
end

% Screen('SelectStereoDrawBuffer', env.wndPtr, 1);
% if ~isempty(stimPattern.right_pos)
%     Screen('DrawDots', env.wndPtr, stimPattern.right_pos, stimPattern.right_size, stimPattern.right_color, env.wndCenter, 1);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function gbr = GenGbrPattern(env, tm, prm)
% �p�b�`�̔��a
%pixel �ɂȂ���
gabor_size_x = env.deg2px_hrz(prm.gabor_Size);
gabor_size_y = env.deg2px_vrt(prm.gabor_Size);
xyRange = linspace(-prm.gabor_Size/2, prm.gabor_Size/2, env.deg2px_hrz(prm.gabor_Size/2));
[x,y] = meshgrid(xyRange);
%% Sinusoid grating
gratingPhaseRad = deg2rad(prm.gaborPhase);%converted to radians
gratingorientation = deg2rad(prm.orientation);
xt = x * cos(gratingorientation);
yt = y * sin(gratingorientation);
xyt = [xt + yt];
sineMat=sin(xyt*2*pi*prm.numCycles+gratingPhaseRad); % use the matrix of x-values as input into the equation for a sinusoid %This makes grating stimuli %adding orientation?
% sineMat=sin(x*2*pi*prm.numCycles+gratingPhaseRad); % use the matrix of x-values as input into the equation for a sinusoid %This makes grating stimuli %adding orientation?
%%
scrnNum = max(Screen('Screens'));
bgColor = [ WhiteIndex(scrnNum) + BlackIndex(scrnNum)] .* env.bgColor;
l_mean = bgColor(1);

%% Gabor
sineMat = l_mean+(l_mean*prm.contrast*sineMat); %adjust intensity values
%% Add Noise
%% Final note (Data Types) 
gbr.myImgMat = cast(sineMat,'uint8'); % this rounds up decimals and cuts off values outside the 0-255 range
%% ���̂܂܂��ƈʒu�ɂ���ď��������Ȃ���΂Ȃ�Ȃ�����(�����p) 
gbr.stimPos(1) = env.wndCenter(1) + env.deg2px_hrz(prm.stimPos(1) - prm.gabor_Size/2);%xaxis_upleft
gbr.stimPos(2) = env.wndCenter(2) + env.deg2px_vrt(-prm.stimPos(2) - prm.gabor_Size/2);%yaxis_ipleft
gbr.stimPos(3) = env.wndCenter(1) + env.deg2px_hrz(prm.stimPos(1) + prm.gabor_Size/2);%xaxis_downright
gbr.stimPos(4) = env.wndCenter(2) + env.deg2px_vrt(-prm.stimPos(2) + prm.gabor_Size/2);%yaxis_downright

gbr.gabor_tex_rect=[0 0 round(gabor_size_x) round(gabor_size_y) ];
% gbr.gabor_tex_rect=[0 0 gabor_size_x gabor_size_y ];
