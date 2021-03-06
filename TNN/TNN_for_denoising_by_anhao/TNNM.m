% 
function  [X] =  TNNM( Y, Truncated, C, NSig, m, Iter )
    [U,SigmaY,V] =   svd(full(Y),'econ');    
    PatNum       = size(Y,2);
    Temp         =   sqrt(max( diag(SigmaY).^2 - PatNum*NSig^2, 0 ));
    for i=1:Iter
        W_Vec    =   (C*sqrt(PatNum)*NSig^2)./( Temp + eps );               % Weight vector
        
        % W_Vec = ones(size(W_Vec));
        len = size(W_Vec, 1);
        for tr = Truncated+1:len
            W_Vec(tr) = 0;
        end
        
       	SigmaX   =  soft(SigmaY, diag(W_Vec));
       	Temp     = diag(SigmaX);
    end
               X =  U*SigmaX*V' + m;     
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

