
clear
%pathForImages ='C:\document\image-denoising\UseData\nc\';flag='png'; 
% pathForImages ='D:\Image-Denoising\UseData\cc512\';flag='mat';
% pathForImages ='C:\document\image-denoising\UseData\cc512\';flag='mat';
pathForImages ='C:\document\image-denoising\UseData\Medical\';flag='png';
folder='Result';
im_dir=readfolder(pathForImages,flag);
num = length(im_dir);

for i =3:num
    filename=strcat([pathForImages,'\', folder, '\',im_dir(i).name]);
    data=loadfile(pathForImages,im_dir(i).name);
    Sigma =NoiseEstimation(data.I,6);
%     %WGSR_NLS_mean
%     disp([im_dir(i).name '::WGSR_NLS_mean'])
%     WGSR_NLS_mean=WGSR_NLS_mean_Denoising(data,Sigma,'WGSR_NLS');%使用和WGSR_NLS一样的子文件
%     save([filename(1:end-4),'__WGSR_NLS_mean.mat'],'WGSR_NLS_mean')
    %WGSR_NLS_max
    disp([im_dir(i).name '::WGSR_NLS_max'])
    WGSR_NLS_max=WGSR_NLS_max_Denoising(data,Sigma,'WGSR_NLS');%使用和WGSR_NLS一样的子文件
    save([filename(1:end-4),'__WGSR_NLS_max.mat'],'WGSR_NLS_max')
%     %GSR_NLS
%     disp([im_dir(i).name '::GSR_NLS'])
%     GSR_NLS=GSR_NLS_Denoising(data,Sigma,'GSR_NLS');
%     save([filename(1:end-4),'__GSR_NLS.mat'],'GSR_NLS')
%     %WNNM
%     disp([im_dir(i).name '::WNNM'])
%     WNNM=WNNM_DeNoising(data,Sigma,'WNNM');
%     save([filename(1:end-4),'__WNNM.mat'],'WNNM')
%     %BM3D
%     disp([im_dir(i).name '::BM3D'])
%     BM3D=BM3D_Denoising(data,Sigma,'BM3D');
%     save([filename(1:end-4),'__BM3D.mat'],'BM3D')
%     %KSVD
%     disp([im_dir(i).name '::KSVD'])
%     KSVD=KSVD_DeNoising(data,Sigma,'KSVD');
%     save([filename(1:end-4),'__KSVD.mat'],'KSVD')
%     %NCSR
%     disp([im_dir(i).name '::NCSR'])
%     NCSR=NCSR_Denoising(data,Sigma,'NCSR');
%     save([filename(1:end-4),'__NCSR.mat'],'NCSR')
%     %PCLR
%     disp([im_dir(i).name '::PCLR'])
%     PCLR=PCLR_Denoising(data,Sigma,'PCLR');
%     save([filename(1:end-4),'__PCLR.mat'],'PCLR')
%     %TWSC
%     disp([im_dir(i).name '::TWSC'])
%     TWSC=TWSC_Denoising(data,Sigma,'TWSC');%%对于自然图像参数取0.1时效果最差，论文中没有添加
%     save([filename(1:end-4),'__TWSC.mat'],'TWSC')

end


function im_dir=readfolder(pathForImages,flag)
fpath = fullfile(pathForImages, ['*.' flag]);
im_dir  = dir(fpath);
end
function data=loadfile(pathForImages,name)
flag=name(end-2:end);
if flag=='png'
 I=double(imread(strcat([pathForImages,name])));
    [~, ~, kk]       =     size (I);
    if kk==3
        I     =rgb2gray (I/255)*255;
    end
    data.I=I;
    data.num=1;
else
    load(strcat([pathForImages,name]));
    [~, ~, kk]       =     size (mean_img);
    if kk==3
        I0     = rgb2gray (mean_img/255)*255;
    end
    [~, ~, kk]       =     size (noise_img);
    if kk==3
        I     = rgb2gray (noise_img/255)*255;
    end
    data.I=I;
    data.I0=I0;
    data.num=2;
end
end
