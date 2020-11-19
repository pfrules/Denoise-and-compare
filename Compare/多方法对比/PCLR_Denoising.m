function Result=PCLR_Denoising(IMin0,nim,Sigma,Way)
addpath([Way '/'])
par= ParSet(Sigma,IMin0);
[Denoising ,AllResult,AllTime] =PCLR(IMin0,nim,par );
Result.Denoising=Denoising;
Result.AllResult=AllResult;
Result.AllTime=AllTime;
rmpath([Way '/'])
end
function [Denoising ,AllResult,AllTime]= PCLR( x,y,par )
%Patch clustering based low-rank regularization for image denoising
sigma=par.nSig;
z     =   y;
fprintf( 'Noisy Image: nSig = %2.3f \n', sigma);
cnt=1;
for iter  =   1  : par.tot_iter
    tic
    z    =   z + par.lamada*(y - z);
    [X  Sigma_arr] =   Im2Patch( z,y, par );           
    if (iter==1)
         Sigma_arr = par.nSig * ones(size(Sigma_arr)); 
    end    
    [MY,ks,group,nSig,PF] = GmmCluster( Sigma_arr,X,par,par.model);
    if nSig<=15
         par.Maxgroupsize = round(par.Maxgroupsize/2);
    end
    [Ys,W] = FineCluster( x,X,group,ks,PF,par,MY,iter,Sigma_arr);
    z     = Reconstruct( x,par,Ys,W);
Denoising{cnt}    = z;
AllResult{cnt}=GetAllResult(z,x);
AllTime{cnt}=toc; 
fprintf( 'Iteration %d : nSig = %2.2f, PSNR = %2.2f,SSIM = %2.2f\n', cnt,  mean(Sigma_arr), AllResult{cnt}.PSNR, AllResult{cnt}.SSIM);
if  cnt >1
dif      =  norm(abs(Denoising{cnt}) - abs(Denoising{cnt-1}),'fro')/norm(abs(Denoising{cnt-1}), 'fro');
if dif<par.errr_or
   break;
end
end
cnt   =  cnt + 1;
end
end

