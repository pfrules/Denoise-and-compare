function Result=NCSR_Denoising(data,Sigma,Way)
addpath([Way '/'])
par =    Parameters_setting( Sigma );
par.nim = data.I;
[Denoising ,AllTime] =NCSR( par );
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

function  [Denoising ,AllTime]=NCSR( par)
n_im=par.nim;
par.step      =   1;
[h1 w1]     =   size(n_im);

par.tau1    =   0.1;
par.tau2    =   0.2;
par.tau3    =   0.3;
d_im        =   n_im;
lamada      =   0.02;
v           =   par.nSig;
cnt         =   1;
myway=0;
for k    =  1:par.K

Dict          =   KMeans_PCA( d_im, par, par.cls_num );
[blk_arr, wei_arr]     =   Block_matching( d_im, par);

for i  =  1 : 3  
    tic
    d_im    =   d_im + lamada*(n_im - d_im);
    dif     =   d_im-n_im;
    vd      =   v^2-(mean(mean(dif.^2)));
    if (i ==1 && k==1)
        par.nSig  = sqrt(abs(vd));            
    else
        par.nSig  = sqrt(abs(vd))*par.lamada;
    end
    [alpha, beta, Tau1]   =   Cal_Parameters( d_im, par, Dict, blk_arr, wei_arr );   
    d_im        =   NCSR_Shrinkage( d_im, par, alpha, beta, Tau1, Dict, 1 );
    Denoising{cnt}    = d_im;
    AllTime{cnt}=toc; 
    fprintf( 'Iteration %d : nSig = %2.2f\n', cnt, par.nSig);
    if  cnt >1
       dif      =  norm(abs(Denoising{cnt}) - abs(Denoising{cnt-1}),'fro')/norm(abs(Denoising{cnt-1}), 'fro');
       if dif<par.errr_or
           myway=1;
           break;
       end
    end
 cnt   =  cnt + 1;
    end
if myway==1
    break;
end
end
end