function s = psnr_anhao(A, B)

    A = double(A);
    B = double(B);
    [~, ~, ch] = size(A);
    if ch==1
        e=A-B;
        me=mean(mean(e.^2));
        s=10*log10(255^2/me);
    else
        e=A-B;
        e1=e(:,:,1);
        e2=e(:,:,2);
        e3=e(:,:,3);
        me1=mean(mean(e1.^2));
        me2=mean(mean(e2.^2));
        me3=mean(mean(e3.^2));
        mse=(me1+me2+me3)/3;
        s  = 10*log10(255^2/mse);
    end

return;