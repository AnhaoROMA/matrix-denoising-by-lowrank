% 
function  [D] =  LNNM( Y, m, Iter )
    D = Y;
    for i=1:Iter
        [U,S1,V] =   svd(full(D),'econ');
        S1 = diag(S1);
        tempd = Lin(S1, 1);
        S1 = diag(tempd);
        D = U*S1*V';
    end
               D =  D + m;     
return;

% function  [X] =  WNNM( Y, C, NSig, m, Iter )
%     [U,SigmaY,~] =   svd(cov(Y'));    
%     PatNum       = size(Y,2);
%     Temp         =   sqrt(max( diag(SigmaY).^2 - PatNum*NSig^2, 0 ));
%     for i=1:Iter
%         W_Vec    =   (C*sqrt(PatNum)*NSig^2)./( Temp + eps );               % Weight vector
%        	SigmaX   =  soft(U'*Y, repmat(W_Vec,[1 PatNum]));
%        	Temp     = diag(SigmaX);
%     end
%                X =  U*SigmaX + m;     
% return;

