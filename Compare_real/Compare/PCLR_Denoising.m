function Result=PCLR_Denoising(data,Sigma,Way)
addpath([Way '/'])
par= ParSet(Sigma,data.I);
[Denoising ,AllTime] =PCLR(data.I,par );
if data.num==2
    for i=1:size(Denoising,2)
        AllResult{i}=GetAllResult(Denoising{i},data.I0);
    end
    Result.AllResult=AllResult;
    Result.I0=data.I0;
end
Result.I=data.I;
Result.Denoising=Denoising;
Result.AllTime=AllTime;
rmpath([Way '/'])
end
function [Denoising ,AllTime]= PCLR( y,par )
%Patch clustering based low-rank regularization for image denoising
sigma=par.nSig;
x=y;
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
AllTime{cnt}=toc; 
fprintf( 'Iteration %d\n', cnt);
if  cnt >1
dif      =  norm(abs(Denoising{cnt}) - abs(Denoising{cnt-1}),'fro')/norm(abs(Denoising{cnt-1}), 'fro');
if dif<par.errr_or
   break;
end
end
cnt   =  cnt + 1;
end
end

