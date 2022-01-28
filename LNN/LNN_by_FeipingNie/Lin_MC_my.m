% min_L \|L\|   s.t. X.*W = L.*W; 

function [L, obj, st] = Lin_MC_my(X,W)
% X: the input data matrix 
% W: the mask matrix, W(i,j)=1 if Y(i,j) is observed, otherwise W(i,j)=0
% L: recovered low rank matrix
% obj: objective values during iterations

disp('Test New Lin_MC method');
[m, n] = size(X);
X = X.*W;
L = X;
temp = X'*X;                     
st = 0.01*max(abs(diag(temp))); % sometimes a larger st will achieve better result

% weighted matrix
temp = temp + st*eye(n);
[U S V] = svd(temp,'econ');
S = diag(S);
tempd = Lin(S,1);
S = diag(tempd);
D = U*S*V';
D = D^-1;
num = 50;  
obj = zeros(1,num);
% iteration
for iter = 1:num
    % initialize
    Y = zeros(m,n);
    % update Y
    for i = 1:m
        Wi = W(i,:);
        idx = find(Wi==1);
        DA1 = D(idx,idx);
        Y(i,idx) =(DA1)\(2*X(i,idx)');
    end;
    %update L
    
    L = 0.5*(W.*Y)*D;
    
    % update weighted matrix D
    temp = L'*L + st*eye(n);
    [U S1 V] = svd(temp,'econ');
    S1 = diag(S1);
    tempd = Lin(S1,1); % Gamma
    S = diag(tempd);
     % invD
    S = 1./diag(S);  %
    D = V*(diag(S))*U';
    
    if ~isreal(D)
        disp('not real');
    end;
    objv = sum(log((S1.^0.5)+1)); % objective value 
    obj(iter) = objv;
end;

