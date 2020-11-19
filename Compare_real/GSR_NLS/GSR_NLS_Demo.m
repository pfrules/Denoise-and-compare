clear
addpath('../')
pathForImages ='D:\Image-Denoising\UseData\cc724\';
outpar.write_dir=pathForImages;
outpar.method='GSR_NLS';%outpar:路径，协方差，去噪方法，时间
fpath = fullfile(pathForImages, '*.mat');
im_dir  = dir(fpath);
num = length(im_dir);

    for i = 1:num

        time0         =   clock;
        tic
        load(strcat([pathForImages,im_dir(i).name]));
        [~, ~, kk]       =     size (mean_img);
        if kk==3
            I0     = rgb2gray (mean_img/255)*255;
        end
        [~, ~, kk]       =     size (noise_img);
        if kk==3
            I     = rgb2gray (noise_img/255)*255;
        end
        
        estsigma =NoiseEstimation(I,6);
        Opts              =    Opts_Set (estsigma, I);
        Opts.nim=I;
        Opts.I0=I0;
        % x = DDID(Opts.nim, Sigma);
       [Denoising ,  iter]              =    GSR_NLS_Denoising( Opts);
        Time_s =(etime(clock,time0));
        im  = Denoising{iter-1};
        outpar.time=toc;
        % OUTPUT
        GetResult_realdata(im,double(I0),outpar,im_dir(i).name);
    end
       