function nDCnlYhat=TWSC(nDCnlY, B, Opts,SigmaCol,index)
        [D, S, ~] = svd( full(nDCnlY), 'econ' );
        % update S
        S = sqrt(max( diag(S).^2 - length(index) * SigmaCol(index(1))^2, 0 ));
        W2 = 1 ./ (SigmaCol(index) + eps);
        D =getsvd(nDCnlY); % generate PCA basis
        % min |Z|_1 + |W1(Y-DSC)W2|_F,2  s.t.  C=Z
        C = TWSC_ADMM( nDCnlY, B,D,W2, Opts);
        % update Y
        nDCnlYhat = D* C;
end


function  [C] =  TWSC_ADMM( Y,B0,D,W2,Opts )
c1=Opts.c1;
nSig=Opts.nSig;
ee=Opts.eps;
% This routine solves the following trilateral weighted sparse coding problem
%
% min_{C,Z} |W1(Y-DSC)W2|_F,2 + |Z|_1 s.t.  C=Z
%
% inputs:
%        Y -- d*M data matrix, d is the data dimension, and M is the number
%             of image patches.
%        W1 -- d*d matrix of row weights
%        W2 -- M*M matrix of column weights
% outputs:
%        C -- d*M data matrix, sparse coding coefficient matrix
%        Z -- d*M data matrix, auxiliary variable, equal to C

tol = 1e-8;
Par.maxrho = 100;
Par.maxIter = 10;
Par.rho = 0.5;
Par.mu = 1.1;
Par.display = 0;
% Initializing optimization variables
C = zeros(size(B0));
Z = zeros(size(C));
U = zeros(size(C));
% Start main loop
iter = 0;
stopCZ = zeros(Par.maxIter, 1);
stopC = zeros(Par.maxIter, 1);
stopZ = zeros(Par.maxIter, 1);
while iter < Par.maxIter
    iter = iter + 1;
    Cpre = C;
    Zpre = Z;
    %% update C, fix Z and U
    % min_{C} ||W1 * (Y - DSC) * W2||_F^2 + 0.5 * rho * ||C - Z + 1/rho * U||_F^2
    % The solution is equal to solve A * X + X * B = E
    A = D' * D;
    W2inv = diag(1./(W2.^2));
    B = 0.5 * Par.rho * W2inv;
    E = D' * Y + 0.5 * (Par.rho * Z - U) * W2inv;
    C = sylvester(A, B, E);
    
    %     %% faster solution
    %     [Ua, Sa, ~] = svd(A);
    %     I1 = eye(size(A, 2));
    %     I2 = eye(size(B, 1));
    %     K = kron(I1, A) + kron(B', I2);
    %     invK = 1./diag(K);
    %     UTE = Ua'*E;
    %     vecUTE = UTE(:);
    %     vecUTC = invK .* vecUTE;
    %     MatvecUTC = reshape(vecUTC, [size(UTE, 1) size(UTE, 2)]);
    %     C = Ua*MatvecUTC;
    
    %% update Z, fix X and D
    % min_{Z} 0.5 * rho * ||Z - (C + 1/rho * U)||_F^2 + ||Z||_1
    Temp = C + U/Par.rho;
    B0=D'*B0;
    [~,m]=size (Y);
    s0=Temp-  B0;
    s0=mean (s0.^2,2);
    s0=max(0, s0-nSig^2);
    lam=repmat(((c1*sqrt(2)*nSig^2)./(sqrt(s0) + ee)),[1,m]);
    Z=soft (Temp-B0, lam)+ B0; %Eq. (9)
    %% check the convergence conditions
    stopCZ(iter) = max(max(abs(C - Z)));
    stopC(iter) = max(max(abs(C - Cpre)));
    stopZ(iter) = max(max(abs(Z - Zpre)));
    if Par.display %&& (iter==1 || mod(iter,10)==0 || stopC<tol)
        disp(['iter ' num2str(iter) ', mu=' num2str(Par.mu,'%2.1e') ...
            ', max(||c-z||)=' num2str(stopCZ(iter),'%2.3e') ...
            ', max(||c-cpre||)=' num2str(stopC(iter),'%2.3e') ...
            ', max(||z-zpre||)=' num2str(stopZ(iter),'%2.3e')]);
    end
    if stopCZ(iter) < tol && stopC(iter) < tol && stopZ(iter) < tol
        break;
    else
        %% update the augmented multiplier D, fix Z and X
        U = U + Par.rho * (C - Z);
        Par.rho = min(Par.maxrho, Par.mu * Par.rho);
    end
end
end