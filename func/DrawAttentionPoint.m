function stimPattern = DrawAttentionPoint(env, tm, prm)
% DrawAttentionPoint    Attention point ‚ð•`‰æ‚·‚é

dotsPos_px   = [ env.deg2px_hrz( prm.stimPos(1) );   env.deg2px_vrt( prm.stimPos(2) )   ]; % Attention point ‚ÌˆÊ’u
dotSize_px       = env.deg2px_hrz( prm.dotSize );
dot_color = env.blackIndex + env.whiteIndex .* prm.color;
% ƒhƒbƒg‚ð•`‰æ‚·‚é
Screen('DrawDots', env.wndPtr, dotsPos_px, dotSize_px, dot_color, env.wndCenter, 1);

stimPattern = NaN;

