clear
addpath('../')

sigma = 50;
pathForImages ='D:\Image-Denoising\UseData\Set12\';
outpar.write_dir=pathForImages;
outpar.sigma=sigma;
outpar.method='WNNM';%outpar:路径，协方差，去噪方法，时间

fpath = fullfile(pathForImages, '*.png');
im_dir  = dir(fpath);
num = length(im_dir);
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
tic
Par   = ParSet(sigma);   
E_Img = WNNM_DeNoising( IMin, IMin0, Par );     
outpar.time=toc;
GetResult(E_Img,IMin0,outpar,im_dir(i).name);
end