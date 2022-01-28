function Out = main()

clear; clc
pic_list = {'re1.jpg','re2.jpg','re3.jpg','re4.jpg','re5.jpg','re6.jpg','re7.jpg','re8.jpg','re9.jpg','re10.jpg','re11.jpg'};

imagenum = 11; % the number of test image 

pic_name = pic_list{imagenum}; % the name of test image

cd Picture
Xfull = double(imread(pic_name));
cd ..

  Missing = load('Missing1.mat');  % 50% missing entries
% Missing = load('Missing2.mat');  % two blocks

W  = Missing.W;
ind = W{imagenum};

mask(:,:,1)=ind;mask(:,:,2)=ind;mask(:,:,3) = ind; % the observed matrix
%
Par.image =Xfull;  % original data
Par.show = 1;     % show image
Par.mask = mask;
Par.noise = 5;   % the level of adding Gausian noise
Par.mu = 10;

%% Test
disp('Test Lin\n')
OutPut = testImgbyMC(Par);
PSNRv = OutPut.PSNR; 
Out.PSNRLin = PSNRv;
% Convergence analysis
Obj_value = OutPut.Objvalue;
subplot(3,1,3); 
plot(1:length(Obj_value),Obj_value)