function stimPattern = DrawFixationPointWithRDS(env, tm, prm)
% DrawFixationPointwithRDS    Fixation point (RDS 付き) を描画する

%prm.stimPos = prm.position;

stimPattern = DrawRandomDotStereogram(env, tm, prm);
DrawFixationPoint(env, tm, prm);

