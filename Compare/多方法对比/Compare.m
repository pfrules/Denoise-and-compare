   %%
%添加高斯噪声
clear
Sigma =50;
% pathForImages ='D:\Image-Denoising\UseData\Set12\';
%pathForImages ='C:\document\image-denoising\UseData\Set12\';
pathForImages ='C:\document\image-denoising\UseData\Medical\';
fpath = fullfile(pathForImages, '*.png');
im_dir  = dir(fpath);
num = length(im_dir);

for i = 2:num
   filename=strcat([pathForImages,'All\' num2str(Sigma) '\',im_dir(i).name]);
 %  filename=strcat([pathForImages,'\25_35\' ,im_dir(i).name]);
        randn ('seed',0);
    I0=double(imread(strcat([pathForImages,im_dir(i).name])));
    [~, ~, kk]       =     size (I0);
    if kk==3
        I0     =rgb2gray (I0);
    end
    I=I0+Sigma*randn(size(I0));
    data.I0=I0;
    data.I=I;
    save([filename(1:end-4),'.dat'],'data')

    load([filename(1:end-4),'.dat'],'-mat');
    I0=data.I0;
    I=data.I;
    %WGSR_NLS_mean
    disp([im_dir(i).name '::WGSR_NLS_mean'])
    WGSR_NLS_mean=WGSR_NLS_mean_Denoising(I0,I, Sigma,'WGSR_NLS');%使用和WGSR_NLS一样的子文件
    save([filename(1:end-4),'__WGSR_NLS_mean.mat'],'WGSR_NLS_mean')
   % WGSR_NLS_max
    disp([im_dir(i).name '::WGSR_NLS_max'])
    WGSR_NLS_max=WGSR_NLS_max_Denoising(I0,I, Sigma,'WGSR_NLS');%使用和WGSR_NLS一样的子文件
    save([filename(1:end-4),'__WGSR_NLS_max.mat'],'WGSR_NLS_max')
    %GSR_NLS
    disp([im_dir(i).name '::GSR_NLS'])
    GSR_NLS=GSR_NLS_Denoising(I0,I,Sigma,'GSR_NLS');
    save([filename(1:end-4),'__GSR_NLS.mat'],'GSR_NLS')
%     %WNNM
%     disp([im_dir(i).name '::WNNM'])
%     WNNM=WNNM_DeNoising(I0,I,Sigma,'WNNM');
%     save([filename(1:end-4),'__WNNM.mat'],'WNNM')
    %BM3D
    disp([im_dir(i).name '::BM3D'])
    BM3D=BM3D_Denoising(I0,I,Sigma,'BM3D');
    save([filename(1:end-4),'__BM3D.mat'],'BM3D')
    %KSVD
    disp([im_dir(i).name '::KSVD'])
    KSVD=KSVD_DeNoising(I0,I,Sigma,'KSVD');
    save([filename(1:end-4),'__KSVD.mat'],'KSVD')
    %NCSR
    disp([im_dir(i).name '::NCSR'])
    NCSR=NCSR_Denoising(I0,I,Sigma,'NCSR');
    save([filename(1:end-4),'__NCSR.mat'],'NCSR')
%     %PCLR
%     disp([im_dir(i).name '::PCLR'])
%     PCLR=PCLR_Denoising(I0,I,Sigma,'PCLR');
%     save([filename(1:end-4),'__PCLR.mat'],'PCLR')
%     %TWSC
%     disp([im_dir(i).name '::TWSC'])
%     TWSC=TWSC_Denoising(I0,I,Sigma,'TWSC');
%     save([filename(1:end-4),'__TWSC.mat'],'TWSC')

end
