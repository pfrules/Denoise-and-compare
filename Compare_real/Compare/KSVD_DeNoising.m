function Result=KSVD_DeNoising(data,Sigma,Way)
addpath([Way '/'])
bb=8; % block size
RR=4; % redundancy factor
K=RR*bb^2; % number of atoms in the dictionary 
tic
[IoutAdaptive,output] = denoiseImageKSVD(data.I, Sigma,K);
OutPut=IoutAdaptive;
if data.num==2
    Result.AllResult=GetAllResult(OutPut,data.I0);
    Result.I0=data.I0;
end
Result.I=data.I;
Result.Denoising=OutPut;
Result.AllTime=toc;
addpath([Way '/'])
end

