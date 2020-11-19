function  Opts   =GSR_NLS_Opts_Set( nSig)

randn ('seed',0);

Opts.nSig      =   nSig;

Opts.Iter      =   30;

Opts.eps       =   0.2;


if nSig <= 10
    
    Opts.win       =   6;
    
    Opts.nblk      =   60;   
    
    Opts.c1        =  0.8;  
    
    Opts.gamma     =   0.2;     
    
    Opts.lamada    =  0.5;
    
    Opts.hp        =   45;   
    
    Opts.errr_or   =   0.0003;   

    
elseif nSig <= 20
    
    Opts.win       =   6;
    
    Opts.nblk      =   60;   
    
    Opts.c1        =   0.7;  
    
    Opts.gamma     =   0.2;     
    
    Opts.lamada    =    0.6;
    
    Opts.hp        =    45;
    
    Opts.errr_or   =   0.0008;   
    

elseif nSig <= 30
    
    Opts.win       =   7;
    
    Opts.nblk      =   60;
    
    Opts.c1        =   0.6;  
    
    Opts.gamma     =    0.1;     
    
    Opts.lamada    =   0.6;
    
    Opts.hp        =   60;
     
    Opts.errr_or   =   0.002;  
    
  
    
 elseif nSig <= 40
    
    Opts.win       =   7;
    
    Opts.nblk      =   70;
    
    Opts.c1        =   0.7;  
    
    Opts.gamma     =   0.1;     
    
    Opts.lamada    =   0.5;
    
    Opts.hp        =   80;
     
    Opts.errr_or   =   0.002;   
    
    
elseif nSig<=50
    
    Opts.win       =   7;
    
    Opts.nblk      =   80;
     
    Opts.c1        =   0.7;  
    
    Opts.gamma     =   0.1;     
    
    Opts.lamada    =   0.5;
    
    Opts.hp        =   115;
    
    Opts.errr_or   =   0.001;   

    
elseif nSig<=75
    
    Opts.win       =   8;
    
    Opts.nblk      =   90;
    
    Opts.c1        =   0.7;  
    
    Opts.gamma     =   0.1;     
    
    Opts.lamada    =   0.5;
    
    Opts.hp        =   160;
    
    Opts.errr_or   =   0.0005;   
    

    
else
    
    Opts.win       =   9; 
    
    Opts.nblk      =   100;
    
    Opts.c1        =   1;  
    
    Opts.gamma     =    0.1;     
    
    Opts.lamada    =   0.5;
    
    Opts.hp        =   160;
    
    Opts.errr_or   =   0.0005;   

    
end

Opts.step      =   min(4, Opts.win-1);

end

