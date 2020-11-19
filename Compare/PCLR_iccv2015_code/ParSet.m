function [par model] = ParSet(sigma,x)
    [h  w]        =   size(x);
    sizex         =   0.5*(h+w);
    par.xf        =   (512-sizex)*45/256+(sizex-256)*10/256;
    par.lamada    =   0.18;
    par.siglamda  =   0.67;
    par.Maxgroupsize  =  sigma*1000;
    par.nSig          =  sigma;
    
    if sigma <= 20
        par.win      = 7;
        par.tao      = 4.7;
        par.tot_iter = 4;
        load para_gmm\model7.mat;
    elseif sigma <= 40
        par.win      = 8;
        par.tao      = 4.8;
        par.tot_iter = 5;
        load para_gmm\model8.mat;
    elseif sigma <= 60
        par.win       = 9;
        par.tao       = 5.0;
        par.tot_iter  = 5;
        load para_gmm\model9.mat;
    else
        par.win       = 10;
        par.tao       = 5.2;
        par.tot_iter  = 6; 
        load para_gmm\model10.mat;
    end
    
    par.N   =   h - par.win + 1;
    par.M   =   w - par.win + 1;
    par.r   =   1:par.N;
    par.c   =   1:par.M; 

end

