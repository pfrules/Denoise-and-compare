%%
%添加高斯噪声
clear
addpath('../')
Sigma = 50;
pathForImages ='D:\Image-Denoising\UseData\Set12\';
outpar.write_dir=pathForImages;
outpar.sigma=Sigma;
outpar.method='GSR_NLS';%outpar:路径，协方差，去噪方法，时间
fpath = fullfile(pathForImages, '*.png');
im_dir  = dir(fpath);
num = length(im_dir);

    for i = 1:num
        randn ('seed',0);
        time0         =   clock;
        tic
        [I,pp]=imread(strcat([pathForImages,im_dir(i).name]));
        [~, ~, kk]       =     size (I);
        if kk==3
            I     = rgb2gray (I);
        end
        Opts              =    Opts_Set (Sigma, I);
        Opts.nim          =    Opts.I + Opts.nSig* randn(size( Opts.I ));
        % x = DDID(Opts.nim, Sigma);
       [Denoising ,  iter]              =    GSR_NLS_Denoising( Opts);
        Time_s =(etime(clock,time0));
        im  = Denoising{iter-1};
        outpar.time=toc;
        % OUTPUT
        GetResult(im,double(I),outpar,im_dir(i).name);
    end
         