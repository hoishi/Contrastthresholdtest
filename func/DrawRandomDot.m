function stimPattern  =DrawRandomDot(env, tm, prm)
% DrawRandomDot    ランダムドット刺激を描画する

radius = prm.patchSize / 2;
dot_radius = prm.dotSize / 2;

% ランダムドットの数を求める
numDots = round(prm.patchSize * prm.patchSize * prm.dotDensity / (pi * dot_radius * dot_radius));

%ドットの初期座標を求める
dots = radius * ( 2 .* rand(2, numDots) - 1);

% 描画範囲に含まれるドットを取り出す
%m = 1;
%for n = 1:numDots
%    if dots(1,n) * dots(1,n) + dots(2,n)* dots(2,n) <= radius * radius
%       dots_draw(1:2, m) = dots(1:2, n);
%       m = m + 1;
%    end
%end
dots_draw   = dots(:, dots(1, :) .^ 2 + dots(2, :) .^ 2 <= radius .^ 2);
numDotsDraw = size(dots_draw, 2);

% ドットの位置を設定する
dots_draw = dots_draw + repmat(prm.stimPos', 1, numDotsDraw);

% Deg --> Pixel 変換
%env.deg2px_hrz = @(x) 2 * env.viewDistance * env.wndSize(1) / ( env.scrnSize(1) * 0.1 ) * tan( (x / 180) * pi / 2 );
%env.deg2px_vrt = @(x) 2 * env.viewDistance * env.wndSize(2) / ( env.scrnSize(2) * 0.1 ) * tan( (x / 180) * pi / 2 );

dotSize_px       = env.deg2px_hrz( prm.dotSize ); %stim 内で dot Size 変更を書いておけないのか
dots_draw_px   = [ env.deg2px_hrz( dots_draw(1,:) );   env.deg2px_vrt( dots_draw(2,:) )   ];

% ドットの色を設定する
dotColorPair = [ env.blackIndex + env.whiteIndex .* prm.darkDotColor', ...
                 env.blackIndex + env.whiteIndex .* prm.brightDotColor' ];
dots_color = repmat(dotColorPair, 1, numDotsDraw);
dots_color = dots_color(:, 1:numDotsDraw);

% ドットを描画する
Screen('DrawDots', env.wndPtr, dots_draw_px, dotSize_px, dots_color, env.wndCenter, 1);

stimPattern = NaN;

