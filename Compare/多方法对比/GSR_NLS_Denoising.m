function Result=GSR_NLS_Denoising(I,nim,Sigma,Way)
addpath([Way '/'])
Opts=GSR_NLS_Opts_Set (Sigma, I);
Opts.nim=nim;
[Denoising ,AllResult,AllTime] =GSR_NLS( Opts);
Result.Denoising=Denoising;
Result.AllResult=AllResult;
Result.AllTime=AllTime;
rmpath([Way '/'])
end
    
function  [Denoising ,AllResult,AllTime]    =     GSR_NLS( Opts)
Nim            =   Opts.nim;
b              =   Opts.win;
[h, w, ch]     =   size(Nim);

N              =   h-b+1;

M              =   w-b+1;

r              =   [1:N];

c              =   [1:M]; 

Out_Put        =   Nim;

gamma          =   Opts.gamma;

nsig           =   Opts.nSig;
m              =   Opts.nblk;
cnt            =   1;

for iter = 1 : Opts.Iter    
    tic
        Out_Put               =    Out_Put + gamma*(Nim - Out_Put);
        
         dif                  =    Out_Put-Nim;
        
         vd                   =    nsig^2-(mean(mean(dif.^2)));
     
   [blk_arr, wei_arr]         =    Block_matching( Out_Put, Opts);          
        
    if iter==1
                             
            Opts.nSig         =    sqrt(abs(vd)); 
    else
        
            Opts.nSig         =    sqrt(abs(vd))*Opts.lamada;          
   end 
        
     
               X             =     Im2Patch( Out_Put, Opts );  
               
               Ys            =     zeros( size(X) );   
               
               W             =     zeros( size(X) );
               
               K             =     size(blk_arr,2);
               
    %           NL_A          =     zeros (b*b, Opts.nblk);
               
                 
        for  i  =  1 : K  
         
            % Get Nonlocal Similar patches from noisy image...
            
               A             =      X(:, blk_arr(:, i));    
               
            Weight           =      repmat(wei_arr(:, i)',size(A, 1), 1);       
               
              NL_A           =      repmat(sum(Weight.*A, 2), 1, m); %Eq.(6) and Eq.(7)
                  
              TMP            =      GSR_NLS_CORE( double(A), double(NL_A), Opts.c1, Opts.nSig, Opts.eps);
            
    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
    Ys(:, blk_arr(1:m,i))    =   Ys(:, blk_arr(1:m,i)) + TMP;
    
    W(:, blk_arr(1:m,i))     =   W(:, blk_arr(1:m,i)) + 1;
    
        end

     Out_Put        =   zeros(h,w);       
     
     im_wei        =  zeros(h,w);     
     
      k            =   0;
      
     for i   =  1:b
         for j  = 1:b
                k    =  k+1;
                Out_Put(r-1+i,c-1+j)  =  Out_Put(r-1+i,c-1+j) + reshape( Ys(k,:)', [N M]);
                im_wei(r-1+i,c-1+j)  =  im_wei(r-1+i,c-1+j) + reshape( W(k,:)', [N M]);
          end
     end
     
      Out_Put            =        Out_Put./(im_wei+eps);

     Denoising{iter}    =        Out_Put;
    AllResult{iter}=GetAllResult(Out_Put,Opts.I);
    AllTime{iter}=toc;     
fprintf( 'Iteration %d : nSig = %2.2f, PSNR = %2.2f,SSIM = %2.2f\n', cnt, Opts.nSig, AllResult{iter}.PSNR, AllResult{iter}.SSIM);
 
    cnt   =  cnt + 1;
        
      if  iter >1
          
           dif      =  norm(abs(Denoising{iter}) - abs(Denoising{iter-1}),'fro')/norm(abs(Denoising{iter-1}), 'fro');
           
           if dif<Opts.errr_or
               
               break;
           end
           
      end
      
   
end


end





