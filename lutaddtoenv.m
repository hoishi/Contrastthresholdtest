function lutaddtoenv

load('env.mat')
load('mcalibrator2_results_170206_1024_ptb.mat');%load a lut result.
env.lut = lut{4,1}(1,:)';
save('env.mat','env');
keyboard;