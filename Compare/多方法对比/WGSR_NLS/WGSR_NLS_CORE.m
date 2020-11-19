function  X=WGSR_NLS_CORE( A, B, c1, nSig,ee,W)

        U_i                =              getsvd(A); % generate PCA basis
        
        A0                 =              U_i'*A;
        
        [~,m]              =              size (A0);
        
        B0                 =              U_i'*B;
            
        s0                 =              A0   -  B0;

        s0                 =              mean (s0.^2,2);

        s0                 =              max  (0, s0-nSig^2);
        
        lam                =              repmat(((c1*sqrt(2)*nSig^2)./(sqrt(s0) + ee)),[1,m]);
 
        Alpha              =              soft (A0-B0, lam*(diag(1./W.^2)))+ B0; %Eq. (9)
 
        X                  =              U_i*Alpha;%*diag(1./W)


return;