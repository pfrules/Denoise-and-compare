clear
addpath('../')
sigma = 0;
pathForImages ='D:\Image-Denoising\UseData\cc513\';
outpar.write_dir=pathForImages;
outpar.sigma=sigma;
outpar.method='BM3D';%outpar:路径，协方差，去噪方法，时间
fpath = fullfile(pathForImages, '*.mat');
im_dir  = dir(fpath);
num = length(im_dir);
for i=1:num

load(strcat([pathForImages,im_dir(i).name]));
IMin0=double(mean_img)/255;
if (length(size(IMin0))>2)
    IMin0 = rgb2gray(IMin0);
end
if (max(IMin0(:))<2)
    IMin0 = IMin0*255;
end
IMin=double(noise_img)/255;
if (length(size(IMin))>2)
    IMin = rgb2gray(IMin);
end
if (max(IMin(:))<2)
    IMin = IMin*255;
end

tic
[PSNR, y_est] = BM3D(IMin0, IMin, sigma);
outpar.time=toc;
GetResult(y_est*255,IMin0,outpar,im_dir(i).name);
end