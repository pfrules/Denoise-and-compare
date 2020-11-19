function Result=WNNM_DeNoising(I,Sigma,Way)
addpath(['../' Way '/'])
Par= ParSet(Sigma);   
[Denoising ,AllTime] =WNNMing( I, Par );
Result.Denoising=Denoising;
Result.AllTime=AllTime;
rmpath(['../' Way '/'])
end

function [Denoising ,AllTime]   =  WNNMing( N_Img, Par )


E_Img           = N_Img;                                                        % Estimated Image
[Height Width]  = size(E_Img);   
TotalPatNum     = (Height-Par.patsize+1)*(Width-Par.patsize+1);                 %Total Patch Number in the image
Dim             = Par.patsize*Par.patsize;  


[Neighbor_arr Num_arr Self_arr] =	NeighborIndex(N_Img, Par);                  % PreCompute the all the patch index in the searching window 
            NL_mat              =   zeros(Par.patnum,length(Num_arr));          % NL Patch index matrix
            CurPat              =	zeros( Dim, TotalPatNum );
            Sigma_arr           =   zeros( 1, TotalPatNum);            
            EPat                =   zeros( size(CurPat) );     
            W                   =   zeros( size(CurPat) );       
cnt=1;
for iter = 1 : Par.Iter  
    tic
    E_Img             	=	E_Img + Par.delta*(N_Img - E_Img);
    [CurPat Sigma_arr]	=	Im2Patch( E_Img, N_Img, Par );                      % image to patch and estimate local noise variance            
    
    if (mod(iter-1,Par.Innerloop)==0)
        Par.patnum = Par.patnum-10;                                             % Lower Noise level, less NL patches
        NL_mat  =  Block_matching(CurPat, Par, Neighbor_arr, Num_arr, Self_arr);% Caculate Non-local similar patches for each 
        if(iter==1)
            Sigma_arr = Par.nSig * ones(size(Sigma_arr));                       % First Iteration use the input noise parameter
        end
    end       
    try
     [EPat, W]  =  PatEstimation( NL_mat, Self_arr, Sigma_arr, CurPat, Par );   % Estimate all the patches
    catch
        break;
    end
     E_Img      =  Patch2Im( EPat, W, Par.patsize, Height, Width );
Denoising{iter}    =        E_Img;
AllTime{iter}=toc; 
fprintf( 'Iteration %d \n', iter);
    cnt   =  cnt + 1;
  if  iter >1
       dif      =  norm(abs(Denoising{iter}) - abs(Denoising{iter-1}),'fro')/norm(abs(Denoising{iter-1}), 'fro');
       if dif<Par.errr_or
           break;
       end
  end
end
end


