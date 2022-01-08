%% add path
close all;
clear;
clc;
addpath(genpath(cd));

%% parameter configuration
para.min_R =  1;         % minimum rank of chosen image
para.max_R = 5;         % maximum rank of chosen image
% it requires to test all ranks from min_R to max_R, note that different
% images have different ranks, and various masks affect the ranks, too.

para.outer_iter = 100;     % maximum number of iteration
para.outer_tol = 1e-5;     % tolerance of iteration

para.admm_iter = 200;    % iteration of the ADMM optimization
para.admm_tol = 1e-5;    % epsilon of the ADMM optimization
para.admm_rho = 1;    % rho of the the ADMM optimization
para.progress = 0;

%% select an image and a mask for experiment
image_standard_name = "exp-0.jpg";
X_standard = double(imread(image_standard_name));
image_to_denoise_name = "exp-1.jpg";
X_to_denoise = double(imread(image_to_denoise_name));

%% run truncated nuclear norm regularization through ADMM
fprintf('ADMM optimization method to denoise an image.\n');
[result, X_rec]= admm_denoise(X_standard, X_to_denoise, para);

%% display the result
figure('NumberTitle', 'off', 'Name', 'TNNR-ADMM image');

subplot(1,3,1);
imshow(uint8(X_standard));   % show the original image
xlabel('original image');

subplot(1,3,2);
imshow(uint8(X_to_denoise));   % show the incomplete image
xlabel('noised image');

subplot(1, 3, 3);
imshow(uint8(X_rec(:,:,:, result.best_rank)));    % show the recovered image
xlabel('denoised image');