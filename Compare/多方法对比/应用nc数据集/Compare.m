
clear
pathForImages ='D:\Image-Denoising\UseData\nc\';
fpath = fullfile(pathForImages, '*.png');
im_dir  = dir(fpath);
num = length(im_dir);

for i = 1:num
    filename=strcat([pathForImages,  '\',im_dir(i).name]);
    I0=double(imread(strcat([pathForImages,im_dir(i).name])));
    [~, ~, kk]       =     size (I0);
    if kk==3
        I0     =rgb2gray (I0/255)*255;
    end
    Sigma =NoiseEstimation(I0,6);
    %WGSR_NLS_max
    disp([im_dir(i).name '::WGSR_NLS_mean'])
    WGSR_NLS_mean=WGSR_NLS_mean_Denoising(I0, Sigma,'WGSR_NLS');%使用和WGSR_NLS一样的子文件
    save([filename(1:end-4),'__WGSR_NLS_mean.mat'],'WGSR_NLS_mean')
    %WGSR_NLS_max
    disp([im_dir(i).name '::WGSR_NLS_max'])
    WGSR_NLS_max=WGSR_NLS_max_Denoising(I0, Sigma,'WGSR_NLS');%使用和WGSR_NLS一样的子文件
    save([filename(1:end-4),'__WGSR_NLS_max.mat'],'WGSR_NLS_max')
    %GSR_NLS
    disp([im_dir(i).name '::GSR_NLS'])
    GSR_NLS=GSR_NLS_Denoising(I0,Sigma,'GSR_NLS');
    save([filename(1:end-4),'__GSR_NLS.mat'],'GSR_NLS')
    %WNNM
    disp([im_dir(i).name '::WNNM'])
    WNNM=WNNM_DeNoising(I0,Sigma,'WNNM');
    save([filename(1:end-4),'__WNNM.mat'],'WNNM')
%     %BM3D
%     disp([im_dir(i).name '::BM3D'])
%     BM3D=BM3D_Denoising(I0,Sigma,'BM3D');
%     save([filename(1:end-4),'__BM3D.mat'],'BM3D')
    %KSVD
    disp([im_dir(i).name '::KSVD'])
    KSVD=KSVD_DeNoising(I0,Sigma,'KSVD');
    save([filename(1:end-4),'__KSVD.mat'],'KSVD')
    %NCSR
    disp([im_dir(i).name '::NCSR'])
    NCSR=NCSR_Denoising(I0,Sigma,'NCSR');
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
