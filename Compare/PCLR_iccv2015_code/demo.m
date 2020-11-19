
clear all;
clear
addpath('../')
nSig = 25;
pathForImages ='D:\Image-Denoising\UseData\Set12\';
outpar.write_dir=pathForImages;
outpar.sigma=nSig;
outpar.method='PCLR';%outpar:路径，协方差，去噪方法，时间
fpath = fullfile(pathForImages, '*.png');
im_dir  = dir(fpath);
num = length(im_dir);
randn('seed', 0 );
rand ('seed', 0 );
    % record all the results in each iteration
for i = 1:num
    [IMin0,pp]=imread(strcat([pathForImages,im_dir(i).name]));
    IMin0=im2double(IMin0)*255;
    y      =   IMin0 + randn(size(IMin0))*nSig; %Generate noisy image
    tic
    [im_out PSNR] = PCLR( IMin0,y,nSig );
    outpar.time=toc;
    im_out(im_out>1)=1;
    im_out(im_out<0)=0;
    % OUTPUT
    GetResult(im_out*255,IMin0*255,outpar,im_dir(i).name);
end