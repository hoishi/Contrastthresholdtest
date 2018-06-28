% Creates gaussian mask

prm.gabordim = round(env.deg2px_hrz(prm.gabor_Size));
mask = ones(parmss.gabor_dim(1)+1, parmss.gabor_dim(1)+1, 2) * gray;
[x,y] = meshgrid(-parmss.gabor_dim(1)/2:parmss.gabor_dim(1)/2,-parmss.gabor_dim(1)/2:parmss.gabor_dim(1)/2);
mask(:, :, 2) = white * (1 - exp(-((x/gaussSD).^2)-((y/gaussSD).^2))); % 10 can see it               
masktex = Screen('MakeTexture', w, mask);
Screen('DrawTexture', w, masktex, gabor_tex_rect, gabor_rect,TargetGabor(kk));