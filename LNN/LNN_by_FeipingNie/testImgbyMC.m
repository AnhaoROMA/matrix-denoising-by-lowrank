%% a code for RGB image inpainting 
%Input: par: a structure w.r.t parameters setting
function Out = testImgbyMC(Par)
%% The paprameters of test data
S_image = Par.show;
Xfull = Par.image;
[m, n, dim] = size(Xfull);
mask = Par.mask;
Xmiss = Xfull.*mask;
known = Xmiss(:,:,1) > 0;  % observed matrix
missing = ones(m,n) - known; % missing matrix
if isfield(Par,'rank')
    r = Par.rank;
end
Xrecover = zeros(m,n,3);
%% The paprameters of test algorithms
%%
for i = 1:3
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\n, channel(rgb) %1d\n',i);
    X = Xmiss(:,:,i);
    % Recovered by MC   
    % add noise
    noiseL = Par.noise;  % add noise
    X = X + noiseL * rand(m,n);
    X = X.*known;  % Xi represents the inout data
    if noiseL==0
    [X, obj, st] = Lin_MC_my(X,known);
    else
    [X, obj, st] = NLin_MC_my(X,known,10);   % noise 
    end
    Xrecover(:,:,i) = X;
    Obj_value  = obj;
end
%% calculate
% original image // recovered image // the locations of test pixels  
psnr= PSNR( Xfull,Xrecover,ones(size(mask))-mask); 
Out.PSNR = psnr;

if S_image==1
    %% show the missing image.
    figure(1);
    subplot(3,1,1);
    imshow(Xmiss/255); 
    xlabel('Test image with missing pixels');
    %% show recovered image
    subplot(3,1,2); % show the recovery image
    Xrecover = max(Xrecover,0);
    Xrecover = min(Xrecover,255);
    imshow(Xrecover/255);
    Out.image = Xrecover/255;
    xlabel('The recovered image by MC');
end
Out.Objvalue = Obj_value;