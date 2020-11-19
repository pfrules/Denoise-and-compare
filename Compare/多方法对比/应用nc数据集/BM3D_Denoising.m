function Result=BM3D_Denoising(IMin0,IMin,Sigma,Way)
addpath(['../' Way '/'])
tic
[PSNR, y_est] = BM3D(IMin0, IMin, Sigma);
OutPut=y_est*255;
Result.Denoising=OutPut;
Result.AllTime=toc;
rmpath(['../' Way '/'])
end
