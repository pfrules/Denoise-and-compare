function Result=KSVD_DeNoising(nim,Sigma,Way)
addpath(['../' Way '/'])
bb=8; % block size
RR=4; % redundancy factor
K=RR*bb^2; % number of atoms in the dictionary 
tic
[IoutAdaptive,output] = denoiseImageKSVD(nim, Sigma,K);
OutPut=IoutAdaptive;
Result.Denoising=OutPut;
Result.AllTime=toc;
addpath(['../' Way '/'])
end

