clear

%% set parameter
nSig  = 100;

%% get original image
O_Img = double(imread("exp-0.jpg"));

%% get noisy image
N_Img = double(imread("exp-1.jpg"));

%% calculate the original psnr-value
PSNR  =  csnr( N_Img, O_Img, 0, 0 );
fprintf( 'Noisy Image: nSig = %2.3f, PSNR = %2.2f \n\n\n', nSig, PSNR );

%% WNNM denoisng function
Par   = ParSet(nSig);
E_Img = TNNM_DeNoising( N_Img, O_Img, Par );
PSNR  = csnr( O_Img, E_Img, 0, 0 );

%% presentation
fprintf( 'Estimated Image: nSig = %2.3f, PSNR = %2.2f \n\n\n', nSig, PSNR );
imshow(uint8(N_Img));
figure
imshow(uint8(E_Img));