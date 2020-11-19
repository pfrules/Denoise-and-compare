function Result=BM3D_Denoising(data,Sigma,Way)
addpath([Way '/'])
tic
y_est = BM3D(data.I/255, Sigma);
OutPut=y_est*255;
Result.Denoising=OutPut;
if data.num==2
    Result.AllResult=GetAllResult(OutPut,data.I0);
    Result.I0=data.I0;
end
Result.I=data.I;
Result.AllTime=toc;
rmpath([Way '/'])
end
