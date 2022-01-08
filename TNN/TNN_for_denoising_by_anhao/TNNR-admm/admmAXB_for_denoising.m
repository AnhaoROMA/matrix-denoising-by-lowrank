function [ X_opt ] = admmAXB_for_denoising(A, B, X, M_fro, para)
%--------------------------------------------------------------------------
% Xue Shengke, Zhejiang University, April 2017.
% Contact information: see readme.txt.
%
% Hu et al. (2013) TNNR paper, IEEE Transactions on PAMI.
% First written by debingzhang, Zhejiang Universiy, November 2012.
%--------------------------------------------------------------------------
%     iteratively solve the objective: min ||X||_*-trace(A*X*B')
% 
%     Inputs:
%         A                 --- left singular vector
%         B                 --- right singular vector
%         X                 --- incomplete image
%         M                 --- original image
%         known             --- index matrix of known elements
%         para              --- struct of parameters
% 
%     Outputs: 
%         X_opt             --- optimized image
%         iter              --- number of iterations
%--------------------------------------------------------------------------

max_iter = para.admm_iter;
tol = para.admm_tol;
rho = para.admm_rho;

W = X;
Y = X;
AB = A' * B;

for k = 1 : max_iter
    % X update
    last_X = X;
    
    temp = W - Y / rho;
    [U, sigma, V] = svd(temp, 'econ');
    X = U * max(sigma - 1/rho, 0) * V';
    
    delta = norm(X - last_X, 'fro') / M_fro;

    if delta < tol
%         fprintf('    converged at\n');
%         fprintf('    iter %d, ||X_k+1-X_k||_F/||M||_F=%.4f\n', k, delta);
        break ;
    end
    
    % W update
    W = X + (AB + Y) / rho;
    
    % Y update
    Y = Y + rho * (X - W);

%     obj_val(k) = nuclear_norm(X) - trace(A*W*B') ...
%         + rho / 2 * norm(X-W, 'fro')^2 + trace(Y'*(X-W));
% 
%     if k > 1 && abs(obj_val(k) - obj_val(k-1)) < tol
% %         fprintf('    converged at\n');
% %         fprintf('    iter %d, obj value=%.4f\n', k, obj_val(k));
%         break;
%     end
end
X_opt = X;

end