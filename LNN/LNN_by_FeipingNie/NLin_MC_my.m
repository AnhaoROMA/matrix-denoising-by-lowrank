%% Logarithm function with noise

%  min_X  ||L.*W - X.*W||_F^2 + lambda*||L||_log
%  matrix completion problem
function [L, obj, st] = NLin_MC_my(X, W,lambda)
% X: m*n input data matrix, Y.*A is the observed elements in the data matrix
% W: m*n mask matrix, A(i,j)=1 if Y(i,j) is observed, otherwise A(i,j)=0
% lambda: the regularization parameter  
% L: the p value of the Schatten p-Norm
% obj: objective values during iterations

[m, n] = size(X);
X = X.*W;
L = X;
temp = X'*X;
st = 0.01*max(abs(diag(temp)));  % sometimes a larger st will achieve better result
% weighted matrix 
temp = temp + st*eye(n);
[U S V] = svd(temp,'econ');
S = diag(S);
tempd = Lin(S,1);
S = diag(tempd);
D = U*S*V';
num = 50;
obj = zeros(1,num);
for iter = 1:num
    for i = 1:m
        Wi = W(i,:);
        Yi = X(i,:);
        WY = Wi.*Yi;
        Wid = diag(Wi);
        L(i,:) = (Wid+lambda*D)\(WY');
    end;
    temp = L'*L + st*eye(n);
    [U S1 V] = svd(temp,'econ');
    S1 = diag(S1);
    tempd = Lin(S1,1);
    S = diag(tempd);
    D = U*S*V'; 
    if ~isreal(D)
        disp('not real');
    end;
    objv = lambda*sum(log((S1.^0.5)+1))+ norm((L-X).*W,'fro'); % objective function value 
    obj(iter) = objv;
end;
