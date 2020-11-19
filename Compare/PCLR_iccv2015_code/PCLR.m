function [z PSNR] = PCLR( x,y,sigma )
%Patch clustering based low-rank regularization for image denoising
[par model]= ParSet(sigma,x);
z     =   y;
fprintf( 'Noisy Image: nSig = %2.3f \n', sigma);
for iter  =   1  : par.tot_iter
    z    =   z + par.lamada*(y - z);
    [X  Sigma_arr] =   Im2Patch( z,y, par );           
    if (iter==1)
         Sigma_arr = par.nSig * ones(size(Sigma_arr)); 
    end    
    [MY,ks,group,nSig,PF] = GmmCluster( Sigma_arr,X,par,model);
    if nSig<=15
         par.Maxgroupsize = round(par.Maxgroupsize/2);
    end
    [Ys,W] = FineCluster( x,X,group,ks,PF,par,MY,iter,Sigma_arr);
    z     = Reconstruct( x,par,Ys,W);
    PSNR=psnr(z,x);
    fprintf( 'Iteration %d : nSig = %2.2f, PSNR = %2.2f\n', iter, nSig, PSNR);
end
end

