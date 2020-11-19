function  [Denoising , iter]     =     GSR_NLS_Denoising( Opts)
b              =   Opts.win;
gamma          =   Opts.gamma;

nsig           =   Opts.nSig;

m              =   Opts.nblk;

Nim           =   Opts.nim;
[h, w, ch]     =   size(Nim);

N              =   h-b+1;

M              =   w-b+1;

r              =   [1:N];

c              =   [1:M]; 


Out_Put=Nim;
cnt            =   1;

AllPSNR        =  zeros(1,Opts.Iter );

Denoising      =  cell (1,Opts.Iter);
NY            =     Im2Patch( Out_Put, Opts );

for iter = 1 : Opts.Iter        


        Out_Put               =    Out_Put + gamma*(Nim - Out_Put);
%         BilateralOut=ImageBilateral(Out_Put,Opts.nSig,Opts.win);
%         Out_Put=Out_Put-BilateralOut;
         X             =     Im2Patch( Out_Put, Opts ); 
         dif                  =    Out_Put-Nim;
        
         vd                   =    nsig^2-(mean(mean(dif.^2)));
     
   [blk_arr, wei_arr]         =    Block_matching( Out_Put, Opts);          
%      SigmaCol = Opts.lamada * sqrt(abs(repmat(Opts.nSig^2, 1, size(X,2)) - mean((NY - X).^2))); %Estimated Local Noise Level    
SigmaCol = 0.2 * sqrt(abs(repmat(Opts.nSig^2, 1, size(X,2)) - mean((NY - X).^2)));    
if iter==1  
        SigmaCol = Opts.nSig * ones(size(SigmaCol)); 
        Opts.nSig         =    sqrt(abs(vd)); 
    else
           
        Opts.nSig         =    sqrt(abs(vd))*Opts.lamada;          
   end 
        
     
               
               
               Ys            =     zeros( size(X) );   
               
               W             =     zeros( size(X) );
               
               K             =     size(blk_arr,2);
               
    %           NL_A          =     zeros (b*b, Opts.nblk);
               
           SigmaCol =exp(-1 ./ (SigmaCol + eps).^2) ;
           SigmaCol=SigmaCol./max(SigmaCol);
           %SigmaCol=SigmaCol/max(SigmaCol);
        for  i  =  1 : K  
         
            % Get Nonlocal Similar patches from noisy image...
            %W2 = 1 ./ (SigmaCol(blk_arr(:, i)) + eps);
            W2 = SigmaCol(blk_arr(:, i));
            %W2=W2/max(W2);
%             W2=ones(size(W2));

            A             =      X(:, blk_arr(:, i));    
%             XX=TestBilateral(A,Opts.nSig);
%             A=A-XX;
            Weight           =      repmat(wei_arr(:, i)',size(A, 1), 1);       
               
              NL_A           =      repmat(sum(Weight.*A, 2), 1, m); %Eq.(6) and Eq.(7)
                 % *diag(W2)*diag(W2)
              TMP            =      GSR_NLS_CORE( double(A), double(NL_A), Opts.c1, Opts.nSig, Opts.eps,W2);
%              TMP=TMP+XX;
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
%  Out_Put=Out_Put+BilateralOut;

Denoising{iter}    =        Out_Put;
     AllPSNR(iter)      =        csnr( Out_Put, Opts.I0, 0, 0 );
              
    fprintf( 'Iteration %d : nSig = %2.2f, PSNR = %2.2f\n', cnt, Opts.nSig, csnr( Out_Put, Opts.I0, 0, 0 ));
    
    cnt   =  cnt + 1;
        
  if  iter >1
      
       dif      =  norm(abs(Denoising{iter}) - abs(Denoising{iter-1}),'fro')/norm(abs(Denoising{iter-1}), 'fro');
       
       if dif<Opts.errr_or
           
           break;
       end
       
  end
  
   
end

end

