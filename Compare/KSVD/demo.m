% %
% 添加高斯噪声
clear
addpath('../')
bb=8; % block size
RR=4; % redundancy factor
K=RR*bb^2; % number of atoms in the dictionary

sigma = 50;

pathForImages ='D:\Image-Denoising\UseData\Set12\';
outpar.write_dir=pathForImages;
outpar.sigma=sigma;
outpar.method='KSVD';%outpar:路径，协方差，去噪方法，时间

fpath = fullfile(pathForImages, '*.png');
im_dir  = dir(fpath);
num = length(im_dir);
for i=7:num
[IMin0,pp]=imread(strcat([pathForImages,im_dir(i).name]));
IMin0=im2double(IMin0);
if (length(size(IMin0))>2)
    IMin0 = rgb2gray(Iin0);
end
if (max(IMin0(:))<2)
    IMin0 = IMin0*255;
end

IMin=IMin0+sigma*randn(size(IMin0));
tic
[IoutAdaptive,output] = denoiseImageKSVD(IMin, sigma,K);

PSNROut = 20*log10(255/sqrt(mean((IoutAdaptive(:)-IMin0(:)).^2)));
outpar.time=toc;
GetResult(IoutAdaptive,IMin0,outpar,im_dir(i).name);
end

% %%
% %cc数据集（文件太大截取其中一部分）
% clear
% addpath('../')
% bb=8; % block size
% RR=4; % redundancy factor
% K=RR*bb^2; % number of atoms in the dictionary
% 
% sigma = 0;
% 
% pathForImages ='D:\Image-Denoising\UseData\cc1\';
% outpar.write_dir=pathForImages;
% outpar.sigma=sigma;
% outpar.method='KSVD';%outpar:路径，协方差，去噪方法，时间
% 
% fpath = fullfile(pathForImages, '*.mat');
% im_dir  = dir(fpath);
% num = length(im_dir);
% for i=1:num
% load(strcat([pathForImages,im_dir(i).name]));
% IMin0=double(mean_img)/255;
% if (length(size(IMin0))>2)
%     IMin0 = rgb2gray(IMin0);
% end
% if (max(IMin0(:))<2)
%     IMin0 = IMin0*255;
% end
% IMin=double(noise_img)/255;
% if (length(size(IMin))>2)
%     IMin = rgb2gray(IMin);
% end
% if (max(IMin(:))<2)
%     IMin = IMin*255;
% end
% 
% tic
% [IoutAdaptive,output] = denoiseImageKSVD(IMin, sigma,K);
% 
% PSNROut = 20*log10(255/sqrt(mean((IoutAdaptive(:)-IMin0(:)).^2)));
% outpar.time=toc;
% GetResult(IoutAdaptive,IMin0,outpar,im_dir(i).name);
% end