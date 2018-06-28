function stimPattern = DrawFixationPoint(env, tm, prm)
% DrawFixationPoint    Fixation point Çï`âÊÇ∑ÇÈ

pos    = [ env.deg2px_hrz(prm.position(1)) env.deg2px_vrt(prm.position(2)) ]; % Nonius lines ÇÃà íu
width  = env.deg2px_hrz(prm.width);    % Nonius lines ÇÃïù
length = env.deg2px_vrt(prm.length);   % Nonius lines ÇÃí∑Ç≥

lcolor = env.blackIndex + env.whiteIndex .* prm.color;

left_lines  = [ length, -length, 0, 0;
                0,      0,       0, length ];
right_lines = [ length, -length, 0, 0;
                0,       0,      0, -length ];

% Left
Screen('SelectStereoDrawBuffer', env.wndPtr, 0);
Screen('DrawLines', env.wndPtr, left_lines, width, lcolor, env.wndCenter + [ pos(1), pos(2) ], 1);

% Right
Screen('SelectStereoDrawBuffer', env.wndPtr, 1);
Screen('DrawLines', env.wndPtr, right_lines, width, lcolor, env.wndCenter + [ pos(1), pos(2) ] , 1);

stimPattern = NaN;

