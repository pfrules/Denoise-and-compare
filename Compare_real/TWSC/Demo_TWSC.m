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
pathForImages ='D:\Image-Denoising\UseData\cc513\';
outpar.write_dir=pathForImages;
outpar.method='TWSC';%outpar:路径，协方差，去噪方法，时间
fpath = fullfile(pathForImages, '*.mat');
im_dir  = dir(fpath);
num = length(im_dir);

 % Parameters
Par.ps = 6;        % patch size
Par.step = 3;       % the step of two neighbor patches
Par.win = 20;   % size of window around the patch
Par.Outerloop = 7;
Par.Innerloop = 2;
Par.nlspini = 70;
Par.display = 0;
Par.delta = 0;
Par.nlspgap = 0;
Par.lambda1 = 0.1;
Par.lambda2 = 4.9;
Par.nlspini = 70;
    % record all the results in each iteration
    for i = 1:num
        Par.nlsp = Par.nlspini;  % number of non-local patches
        Par.image = i;
        time0         =   clock;
        tic
        load(strcat([pathForImages,im_dir(i).name]));
        [~, ~, kk]       =     size (mean_img);
        if kk==3
            I0     = rgb2gray (mean_img/255)*255;
        end
        [~, ~, kk]       =     size (noise_img);
        if kk==3
            I     = rgb2gray (noise_img/255)*255;
        end
        Par.nSig =NoiseEstimation(I,6);
        Par.I = I0;
        Par.nim =   I;
        tic
        [im_out, Par]  =  TWSC_Sigma_RW(Par);
        outpar.time=toc;
        im_out(im_out>255)=255;
        im_out(im_out<0)=0;
        % OUTPUT
        GetResult(im_out,IMin0,outpar,im_dir(i).name);
    end
