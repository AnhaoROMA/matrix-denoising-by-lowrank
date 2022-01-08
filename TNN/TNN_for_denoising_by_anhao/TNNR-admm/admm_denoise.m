function [result, X_rec] = admm_denoise(X_standard, X_to_denoise, para)
%--------------------------------------------------------------------------
%     main part of TNNR algorithm via ADMM
% 
%     Inputs:
%         result_dir           --- result directory for saving figures
%         X_full               --- original image
%         para                 --- struct of parameters
% 
%     Outputs: 
%         result               --- result of algorithm
%         X_rec                --- denoised image under the best rank
%--------------------------------------------------------------------------

[m, n, dim] = size(X_to_denoise);

min_R    = para.min_R;        % minimum rank of chosen image
max_R    = para.max_R;        % maximum rank of chosen image
max_iter = para.outer_iter;   % maximum number of outer iteration
tol      = para.outer_tol;    % tolerance of outer iteration

% Erec = zeros(max_R, 1);  % reconstruction error, best value in each rank
Psnr = zeros(max_R, 1);  % PSNR, best value in each rank
% time_cost = zeros(max_R, 1);        % consuming time, each rank
% iter_cost = zeros(max_R, dim);      % number of iterations, each channel
% total_iter = zeros(max_R, dim);     % number of total iterations
X_rec = zeros(m, n, dim, max_R); % recovered image under the best rank

best_rank = 0;
best_psnr = 0;

for R = min_R : max_R
    % X_iter = zeros(m, n, dim, max_iter);
    X_temp = zeros(m, n, dim);
    for c = 1 : dim
        X = X_to_denoise(:, :, c);
        M = X_standard(:, :, c);
        M_fro = norm(M, 'fro');
        last_X = X;
        for i = 1 : max_iter
            [U, ~, V] = svd(X);
            A = U(:, 1:R)';
            B = V(:, 1:R)';
            
            % calculate X_{k+1}
            [X] = admmAXB_for_denoising(A, B, X, M_fro, para);
            
            delta = norm(X - last_X, 'fro') / M_fro;
            if delta < tol
                break ;
            end
            last_X = X;
        end
        X_temp(:, :, c) = X;
    end
    
    X_temp = max(X_temp, 0);
    X_temp = min(X_temp, 255);
    % X_temp = uint8(X_temp);
    X_rec(:, :, :, R) = X_temp;
    
    [Psnr(R)] = psnr_anhao(X_standard, X_temp);
    if best_psnr < Psnr(R)
        best_rank = R;
        best_psnr = Psnr(R);
    end
end
result.best_rank = best_rank;
result.best_psnr = best_psnr;
end