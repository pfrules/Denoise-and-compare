function Io = Reconstruct( x,par,Ys,W)
 
        Io   =  zeros(size(x));
        Iw   =  zeros(size(x));

        k    =   0;
        for i  = 1:par.win
            for j  = 1:par.win
                k    =  k+1;
                Io(par.r-1+i,par.c-1+j)  =  Io(par.r-1+i,par.c-1+j) + reshape( Ys(k,:)', [par.N par.M]);
                Iw(par.r-1+i,par.c-1+j)  =  Iw(par.r-1+i,par.c-1+j) + reshape( W(k,:)', [par.N par.M]);
            end
        end
        Io  =  Io./(Iw+eps);

end

