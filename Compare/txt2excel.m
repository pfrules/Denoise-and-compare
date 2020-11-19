clear
fileroad='D:\Image-Denoising\UseData\Set12';
%method='BM3D';
% method='KSVD';
% method='NCSR';
% method='TWSC';
%  method='WNNM';
% method='TWSC0.1';
% method='GSR_NLS';
% method='MY_GSR_NLS';
method='MY_TWSC';
Resultdir=[fileroad '\' method '\'];
fpath = fullfile(Resultdir, '*.txt');
txt_dir  = dir(fpath);
num = length(txt_dir);
% data15=[];
% data25=[];
% data50=[];
% result15=[];
% result25=[];
% result50=[];
imgname={};
for i=1:num
data=importdata(fullfile(Resultdir, txt_dir(i).name));
sigma=str2num(txt_dir(i).name(end-5:end-4));
result(ceil(i/3),(mod(i-1,3)*3)+[1:3])=data.data;
if(sigma==15)
%     result15=[result15;[data.data(1),data.data(2),data.data(3)]];
    imgname=[imgname;txt_dir(i).name(1:end-6)];
% elseif(sigma==25)
%     result25=[result25;[data.data(1),data.data(2),data.data(3)]];
% elseif(sigma==50)
%     result50=[result50;[data.data(1),data.data(2),data.data(3)]];
end
end
title={'Time','PSNR','SSIM','Time','PSNR','SSIM','Time','PSNR','SSIM'};
xlswrite([fileroad '\' method '.xlsx'],title,'sheet1','B1')
xlswrite([fileroad '\' method '.xlsx'],imgname,'sheet1','A2')
xlswrite([fileroad '\' method '.xlsx'],result,'sheet1','B2')