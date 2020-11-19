
clear all;
clear
addpath('../')
nSig = 25;
pathForImages ='D:\Image-Denoising\UseData\cc724\';
outpar.write_dir=pathForImages;
outpar.method='PCLR';%outpar:路径，协方差，去噪方法，时间
fpath = fullfile(pathForImages, '*.mat');
im_dir  = dir(fpath);
num = length(im_dir);

    % record all the results in each iteration
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
    tic
    [im_out PSNR] = PCLR( I0,I,estsigma );
    outpar.time=toc;

    % OUTPUT
    GetResult(im_out*255,IMin0*255,outpar,im_dir(i).name);
end