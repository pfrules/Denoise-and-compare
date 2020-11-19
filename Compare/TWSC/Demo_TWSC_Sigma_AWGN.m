%-------------------------------------------------------------------------------------------------------------
% This is an implementation of the TWSC algorithm for additive white Gaussian noise
% noise removal.
%
% Author:  Jun Xu, csjunxu@comp.polyu.edu.hk / nankaimathxujun@gmail.com
%          The Hong Kong Polytechnic University
%
% Please refer to the following paper if you find this code helps:
%
% @article{TWSC_ECCV2018,
% 	author = {Jun Xu and Lei Zhang and David Zhang},
% 	title = {A Trilateral Weighted Sparse Coding Scheme for Real-World Image Denoising},
% 	journal = {ECCV},
% 	year = {2018}
% }
%
% Please see the file License.txt for the license governing this code.
%-------------------------------------------------------------------------------------------------------------



clear
addpath('../')
nSig = 15;
pathForImages ='D:\Image-Denoising\UseData\Set12\';
outpar.write_dir=pathForImages;
outpar.sigma=nSig;
outpar.method='TWSC';%outpar:路径，协方差，去噪方法，时间
fpath = fullfile(pathForImages, '*.png');
im_dir  = dir(fpath);
num = length(im_dir);

    %% Parameters
    Par.innerIter = 2;
    Par.win = 30;
    Par.lambda1 = 0;
    Par.ps = 8;
    Par.outerIter = 10;
    Par.step = 3;
    Par.nlspini = 90;
    Par.nlspgap = 10;
    if 0 < nSig <= 20
        Par.outerIter = 8;
        Par.delta = .07;
        Par.nlspini = 70;
        Par.lambda2 = .9;
    elseif 20 < nSig <= 30
        Par.delta = .06;
        Par.lambda2 = .76;
    elseif 30 < nSig <= 40
        Par.delta = .07;
        Par.lambda2 = .78;
    elseif 40 < nSig <= 60
        Par.nlspini = 120;
        Par.nlspgap = 15;
        Par.delta = .05;
        Par.lambda2 = .72;
    elseif 60 < nSig <= 80
        Par.ps = 9;
        Par.outerIter = 14;
        Par.step = 4;
        Par.nlspini = 140;
        Par.delta = .05;
        Par.lambda2 = .68; % .66
    else
        disp('Please tune the above parameters by yourself, thanks!');
    end
    % record all the results in each iteration
    for i = 1:num
        Par.nlsp = Par.nlspini;  % number of non-local patches
        Par.image = i;
        Par.nSig = nSig/255;
        [IMin0,pp]=imread(strcat([pathForImages,im_dir(i).name]));
        IMin0=im2double(IMin0);
        Par.I = IMin0;
        Par.nim =   Par.I + Par.nSig*randn(size(Par.I));
        tic
        [im_out, Par]  =  TWSC_Sigma_AWGN(Par);
        outpar.time=toc;
        im_out(im_out>1)=1;
        im_out(im_out<0)=0;
        % OUTPUT
        GetResult(im_out*255,IMin0*255,outpar,im_dir(i).name);
    end
