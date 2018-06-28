function stimPattern = DrawContrastStim(env, tm, prm)
% DrawContrastStim    縞模様にガボ?[ルフィルタ?[を掛けたものを?o力する

if prm.updateStim
    stimPattern = GenGbrPattern(env, tm, prm);
else
    stimPattern = prm.stimPattern;
end

% ガボ?[ルパッチを描画する
% Screen('SelectStereoDrawBuffer', env.wndPtr, 0);
gabor_tex=Screen('MakeTexture', env.wndPtr,stimPattern.grating,[],[],2);%float
masktex=Screen('MakeTexture', env.wndPtr, stimPattern.mask,[],[],2);

% gabor_tex=Screen('MakeTexture', env.wndPtr, stimPattern.myImgMat); %this is the Gabor texture, gabor_tex, which we use anytime we draw a Gabor
if ~isempty(stimPattern)
    % Prevoius setting
    Screen('BlendFunction', env.wndPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    % test script AdditiveBlendingForLinerSuperpositionTutorial.m
%     Screen('BlendFunction', env.wndPtr, GL_SRC_ALPHA, GL_ONE);
    Screen('DrawTexture', env.wndPtr, gabor_tex,stimPattern.dstRect,stimPattern.stimPos,prm.orientation);%draw at the center 
    
    Screen('DrawTexture', env.wndPtr, masktex,stimPattern.dstRect,stimPattern.stimPos,prm.orientation);%draw at the center 
% Screen('DrawTexture', env.wndPtr, gabor_tex,stimPattern.gabor_tex_rect,stimPattern.stimPos,[]);%刺激の左上(00)から右下(指定)を選択
% Screen('DrawTexture', env.wndPtr, gabor_tex,[],stimPattern.stimPos,10);



%     Screen('DrawTexture', w, gabor_tex, gabor_tex_rect, gabor_rect, TargetGabor(kk));
end

% Screen('SelectStereoDrawBuffer', env.wndPtr, 1);
% if ~isempty(stimPattern.right_pos)
%     Screen('DrawDots', env.wndPtr, stimPattern.right_pos, stimPattern.right_size, stimPattern.right_color, env.wndCenter, 1);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function gbr = GenGbrPattern(env, tm, prm)
% パッチの半径
%pixel になおせ
f = 1/env.deg2px_hrz(1/prm.numCycles);
% f = 0.05;% this f is fitted to DEMO param
fr = f*2*pi;
p = ceil(1/f);
gratingsize = round(env.deg2px_hrz(prm.gabor_Size));
% gratingsize = 400;% this is DEMO param
texsize= gratingsize/2;
visiblesize=2*texsize+1;

% scrnNum = max(Screen('Screens'));
white = env.lut(1024);
black = env.lut(1);
% gray = round( (white + black) .* env.bgColor(1) );% Assumption that RGB is equal
gray = env.lut(512);% Assumption that RGB is equal
inc = white - gray;
x = meshgrid(-texsize:texsize + p,1);%driftdemo2 way
% x = meshgrid(-texsize:texsize,1);
% gbr.grating = gray + inc*cos(fr*x);% Max contrast is 255
% gbr.grating = gray + ceil(inc*prm.contrast*cos(fr*x));% Contrast modulates &ここが整数であればOK丸められたことになる
rawgrating = gray + ((prm.contrast-gray).*cos(fr.*x))';
lutnumber = knnsearch(env.lut,rawgrating);%raw and raw
rawgrating(:) = env.lut(lutnumber(:));
gbr.grating = rawgrating';

% gbr.grating = prm.contrast*cos(fr*x);
% gbr.grating = gray + (inc*prm.contrast*cos(fr*x));% Contrast modulates &ここが整数であればOK丸められたことになる

gbr.mask=ones(2*texsize+1, 2*texsize+1, 2) * gray;
[x,y]=meshgrid(-1*texsize:1*texsize,-1*texsize:1*texsize);
gaussSD = env.deg2px_hrz(prm.aperture);
gbr.mask(:, :, 2)=white * (1 - exp(-((x/gaussSD).^2)-((y/gaussSD).^2)));%1stmat is brightness 2nd is transparency
% for m = 1:size(gbr.mask,2)
%     stepnumber = knnsearch(env.lut,gbr.mask(:, m, 2));%raw and raw
%     gbr.mask(:, m, 2) = env.lut(stepnumber(:));
% end
% gbr.mask(:, :, 2)=white * (1 - exp(-((x/39.6).^2)-((y/39.6).^2)));% this gaussSD is fitted to DEMO param


gbr.dstRect = [0 0 visiblesize visiblesize];
%% このままだと位置によって書き換えなければならない注意(左上専用) %dstRectに相当
gbr.stimPos(1) = env.wndCenter(1) + env.deg2px_hrz(prm.stimPos(1) - prm.gabor_Size/2);%xaxis_upleft
gbr.stimPos(2) = env.wndCenter(2) + env.deg2px_vrt(prm.stimPos(2) - prm.gabor_Size/2);%yaxis_upleft
gbr.stimPos(3) = env.wndCenter(1) + env.deg2px_hrz(prm.stimPos(1) + prm.gabor_Size/2);%xaxis_downright
gbr.stimPos(4) = env.wndCenter(2) + env.deg2px_vrt(prm.stimPos(2) + prm.gabor_Size/2);%yaxis_downright
%

% gabor_size_x = env.deg2px_hrz(prm.gabor_Size);
% gabor_size_y = env.deg2px_vrt(prm.gabor_Size);
% xyRange = linspace(-prm.gabor_Size/2, prm.gabor_Size/2, env.deg2px_hrz(prm.gabor_Size/2));
% [x,y] = meshgrid(xyRange);
% %% Sinusoid grating
% gratingPhaseRad = deg2rad(prm.gaborPhase);%converted to radians
% gratingorientation = deg2rad(prm.orientation);
% xt = x * cos(gratingorientation);
% yt = y * sin(gratingorientation);
% xyt = [xt + yt];
% sineMat=sin(xyt*2*pi*prm.numCycles+gratingPhaseRad); % use the matrix of x-values as input into the equation for a sinusoid %This makes grating stimuli %adding orientation?
% % sineMat=sin(x*2*pi*prm.numCycles+gratingPhaseRad); % use the matrix of x-values as input into the equation for a sinusoid %This makes grating stimuli %adding orientation?
% 
% %% Gaussian filter
% gaussSD = env.deg2px_hrz(prm.aperture);%シグマ
% % s = gaussSD / gabor_size_x;
% s = gaussSD / prm.gabor_Size;
% gauss = exp( -(((x.^2)+(y.^2)) ./ (2* s^2)) );
% trim = .005;
% % gauss(gauss < trim) = 0;
% gabor = sineMat .* gauss; 
% 
% %%
% scrnNum = max(Screen('Screens'));
% bgColor = [ WhiteIndex(scrnNum) + BlackIndex(scrnNum)] .* env.bgColor;
% l_mean = bgColor(1);
% 
% %% Gabor
% gaborMat = l_mean+(l_mean*prm.contrast*gabor); %adjust intensity values
% 
% %% Add Noise
% %% Final note (Data Types) 
% gbr.myImgMat = cast(gaborMat,'uint8'); % this rounds up decimals and cuts off values outside the 0-255 range
% %% このままだと位置によって書き換えなければならない注意(左上専用) 
% gbr.stimPos(1) = env.wndCenter(1) + env.deg2px_hrz(prm.stimPos(1) - prm.gabor_Size/2);%xaxis_upleft
% gbr.stimPos(2) = env.wndCenter(2) + env.deg2px_vrt(-prm.stimPos(2) - prm.gabor_Size/2);%yaxis_ipleft
% gbr.stimPos(3) = env.wndCenter(1) + env.deg2px_hrz(prm.stimPos(1) + prm.gabor_Size/2);%xaxis_downright
% gbr.stimPos(4) = env.wndCenter(2) + env.deg2px_vrt(-prm.stimPos(2) + prm.gabor_Size/2);%yaxis_downright

% gbr.gabor_tex_rect=[0 0 round(gabor_size_x) round(gabor_size_y) ];
% gbr.gabor_tex_rect=[0 0 gabor_size_x gabor_size_y
% ];%%引き算でgabor_tex_rectを求める stimPos-env.wndCenter(2)とか
