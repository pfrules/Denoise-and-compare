function [ Ys,W] = FineCluster( x,X,group,ks,PF,par,MY,iter,Sigma_arr)
 Ys   =   zeros( size(X) );        
 W    =   zeros( size(X) );
 for i = 1:length(group) 
     inds0 = find(ks==i);
     [~, inds01] = sort(PF(group(i),inds0));
     inds0       = inds0(inds01);
     len_inds0   = length(inds0);
     sbig        = floor(len_inds0/par.Maxgroupsize)+1;
            
     for sb = 1:sbig
          if sb==sbig
                inds1 = inds0((sb-1)*par.Maxgroupsize+1:end);
                sl    = len_inds0-(sb-1)*par.Maxgroupsize;
          else
                inds1 = inds0((sb-1)*par.Maxgroupsize+1:sb*par.Maxgroupsize);
                sl    = par.Maxgroupsize;  
          end
    
          subc  = round(sl/(par.win^2));
    
          if subc>1
                indr         = [(mod(inds1,par.M)-size(x,1)/2)/(size(x,1)/2);(floor(inds1/par.M)-size(x,1)/2)/(size(x,1)/2); 2*par.xf*MY(inds1)];  
                [inds2, ~, ~]= kmeans2(indr',subc,(par.tot_iter-iter+par.win)*10,round(sl/(subc))-iter*round(par.win/2));  
                  %kmeans for fine classification
          else
                inds2 = inds1;
                subc  = 1;
          end
                    
          for subi = 1:subc
                 if subc>1
                       inds3 = inds1(inds2 == subi);
                 else
                       inds3 = inds2;
                 end
                 if ~isempty(inds3)
                        B    =   double(X(:, inds3));
                        mB   =   repmat(mean( B, 2 ), 1, size(B, 2));
                        B    =   B-mB;        
                        [Ys(:,inds3), W(:, inds3)] =  Low_rank( double(B), par.tao,mean(Sigma_arr(:,inds3)) , mB);
                 end
           end
     end
 end
end

