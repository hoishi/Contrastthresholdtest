function myImgMat = GaborMeshgrid (gabor_size, noise_size, SF, Phase, l_mean, contrast, pixelsPerDeg,noiseGabor)

% 1 size 2 SD 3 SF 4 Phase 5 l_mean 6 contrast 7pixelsPerDeg 8 noiseGabor

gabor_size=gabor_size/2;

%convert this to pixels, either by multiplying by pixels per degree:
%pixelsPerDeg =26; %pixels per degree of visual angle for 1024 x 768 res 
params.stimPixels = gabor_size*pixelsPerDeg;
%next, define the range of your x and y-values by creating a set of linearly spaced values
% for a square grid x and y will be the same, (so we can call it "xyRange")
xyRange = linspace(-gabor_size, gabor_size, params.stimPixels*2); %with this range, (0,0) will be the center of your stimulus 

%Then, just plug in the range into meshgrid. If you give it just one inputargument, it will create a square grid:
[x,y] = meshgrid(xyRange);

%% Sinusoid grating
params.gratingPhaseRad = deg2rad(Phase);%converted to radians
sineMat=sin(x*2*pi*SF+params.gratingPhaseRad); % use the matrix of x-values as input into the equation for a sinusoid %This makes grating stimuli %adding orientation?

%% Gabor
sineMat = l_mean+(l_mean*contrast*sineMat); %adjust intensity values
%% Add noise
blur_filter = fspecial('gaussian', 35, 30);%??
sineMat = sineMat + imfilter(((resizem(rand(noise_size,noise_size),[size(sineMat,1) size(sineMat,1)]) - .5)*noiseGabor),blur_filter,'replicate');


%% Final note (Data Types) 
myImgMat = cast(sineMat,'uint8'); % this rounds up decimals and cuts off values outside the 0-255 range