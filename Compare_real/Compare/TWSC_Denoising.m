function Result=TWSC_Denoising(data,Sigma,Way)
addpath([Way '/'])
Par=Par_Set (Sigma);
Par.nim=data.I/255;
Par.I0=data.I0/255;
Par.nSig=Sigma/255;
%[Denoising ,AllResult,AllTime] =TWSC_Sigma_AWGN(Par);
[Denoising ,AllResult,AllTime] =TWSC_NC(Par);
if data.num==2
    for i=1:size(Denoising,2)
        AllResult{i}=GetAllResult(Denoising{i},data.I0);
    end
end
Result.Denoising=Denoising;
Result.AllResult=AllResult;
Result.AllTime=AllTime;
rmpath([Way '/'])
end

function  [Denoising ,AllResult,AllTime] = TWSC_NC(Par)
im_out    =   Par.nim;
% parameters for noisy image
[h,  w, ch]      =  size(im_out);
Par.h = h;
Par.w = w;
Par.ch = ch;
Par = SearchNeighborIndex( Par );
% original noisy image to patches
NY = Image2Patch( Par.nim, Par );
cnt=1;
for ite  =  1 : Par.outerIter
    tic
    % iterative regularization
    im_out = im_out + Par.delta * (Par.nim - im_out);
    % image to patches
    Y = Image2Patch( im_out, Par );
    % estimate local noise variance, par.lambdals is put here since the MAP
    % and Bayesian rules
    if Par.lambda1 ~= 0
        SigmaRow = (NY-Y).^2;
    end
    SigmaCol = Par.lambda2 * sqrt(abs(repmat(Par.nSig^2, 1, size(Y,2)) - mean((NY - Y).^2))); %Estimated Local Noise Level
    % estimation of noise variance
    if mod(ite-1, Par.innerIter)==0
        Par.nlsp = max(Par.nlspgap, Par.nlsp - Par.nlspgap);
        % searching  non-local patches
        blk_arr = Block_Matching( Y, Par );
        if ite == 1
            SigmaCol = Par.nSig * ones(size(SigmaCol));
        end
    end
    % Trilateral Weighted Sparse Coding
    Y_hat = zeros(Par.ps2ch, Par.maxrc, 'double');
    W_hat = zeros(Par.ps2ch, Par.maxrc, 'double');
    for i = 1:Par.lenrc
        index = blk_arr(:, i);
        nlY = Y( : , index );
        DC = mean(nlY, 2);
        nDCnlY = bsxfun(@minus, nlY, DC);
        
        % Compute W2
        W2 = 1 ./ (SigmaCol(index) + eps);
        % update D
        [D, S, ~] = svd( full(nDCnlY), 'econ' );
        % update S
        S = sqrt(max( diag(S).^2 - length(index) * SigmaCol(index(1))^2, 0 ));
        if Par.lambda1 == 0
            % update weight for sparse coding
            Wsc = bsxfun( @rdivide, SigmaCol(index).^2, S + eps );
            % update C by soft thresholding
            B = D' * nDCnlY;
            C = sign(B) .* max( abs(B) - Wsc, 0 );
            % update Y
            nDCnlYhat = D * C;
        else
            W1 = exp( - Par.lambda1*mean(SigmaRow(:, index), 2)); % mean or max?
            S = diag(S);
            % min |Z|_1 + |W1(Y-DSC)W2|_F,2  s.t.  C=Z
            C = TWSC_ADMM( nDCnlY, D, S, W1, W2, Par );
            % update Y
            nDCnlYhat = D * S * C;
        end
        % add back DC components
        nlYhat = bsxfun(@plus, nDCnlYhat, DC);
        % aggregation
        Y_hat(:, index) = Y_hat(:, index) + bsxfun(@times, nlYhat, W2);
        W_hat(:, index) = W_hat(:, index) + repmat(W2, [Par.ps2ch, 1]);
        %         Y_hat(:, index) = Y_hat(:, index) + bsxfun(@times, bsxfun(@times, W1, nlYhat), W2);
        %         W_hat(:, index) = W_hat(:, index) + W1 * W2;
    end
    % Reconstruction
    im_out = PGs2Image(Y_hat, W_hat, Par);
    % calculate the PSNR and SSIM
Denoising{cnt}    = im_out*255;
AllResult{cnt}=GetAllResult(im_out*255,Par.I0*255);
AllTime{cnt}=toc; 
fprintf( 'Iteration %d : nSig = %2.2f, PSNR = %2.2f,SSIM = %2.2f\n', cnt,  mean(SigmaCol)*255, AllResult{cnt}.PSNR, AllResult{cnt}.SSIM);
if  cnt >1
dif      =  norm(abs(Denoising{cnt}) - abs(Denoising{cnt-1}),'fro')/norm(abs(Denoising{cnt-1}), 'fro');
if dif<Par.errr_or
   break;
end
end
cnt   =  cnt + 1;
end
end
function Par=Par_Set (nSig)
%% Parameters

Par.innerIter = 2;
Par.win = 30;
Par.lambda1 = 0.1;
Par.ps = 8;
Par.outerIter = 10;
Par.step = 3;
Par.nlspini = 90;
Par.nlspgap = 10;
if 0 < nSig <= 20
    Par.outerIter = 8;
    Par.delta = .07;
    Par.nlspini = 70;
    Par.lambda2 = .9;
elseif 20 < nSig <= 30
    Par.delta = .06;
    Par.lambda2 = .76;
elseif 30 < nSig <= 40
    Par.delta = .07;
    Par.lambda2 = .78;
elseif 40 < nSig <= 60
    Par.nlspini = 120;
    Par.nlspgap = 15;
    Par.delta = .05;
    Par.lambda2 = .72;
elseif 60 < nSig <= 80
    Par.ps = 9;
    Par.outerIter = 14;
    Par.step = 4;
    Par.nlspini = 140;
    Par.delta = .05;
    Par.lambda2 = .68; % .66
else
    disp('Please tune the above parameters by yourself, thanks!');
end
Par.nlsp = Par.nlspini;
Par.outerIter = 30;
if nSig <= 10
    Par.errr_or   =   0.0003;    
elseif nSig <= 20
    Par.errr_or   =   0.0008;   
elseif nSig <= 30
    Par.errr_or   =   0.002;  
 elseif nSig <= 40
    Par.errr_or   =   0.002;   
elseif nSig<=50  
    Par.errr_or   =   0.001;   
elseif nSig<=75
    Par.errr_or   =   0.0005;   
else
    Par.errr_or   =   0.0005;    
end
end

