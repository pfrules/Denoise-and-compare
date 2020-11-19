
clear
addpath('../')
sigma = 50;
pathForImages ='D:\Image-Denoising\UseData\Set12\';
outpar.write_dir=pathForImages;
outpar.sigma=sigma;
outpar.method='NCSR';%outpar:路径，协方差，去噪方法，时间
fpath = fullfile(pathForImages, '*.png');
im_dir  = dir(fpath);
num = length(im_dir);

par =    Parameters_setting( sigma );
for i=1:num
[IMin0,pp]=imread(strcat([pathForImages,im_dir(i).name]));
IMin0=im2double(IMin0);
if (length(size(IMin0))>2)
    IMin0 = rgb2gray(Iin0);
end
if (max(IMin0(:))<2)
    IMin0 = IMin0*255;
end

IMin=IMin0+sigma*randn(size(IMin0));
par.I            =    IMin0;
par.nim          =    IMin;
tic
im    =    NCSR_Denoising( par );  
outpar.time=toc;
GetResult(im,IMin0,outpar,im_dir(i).name);
end

 