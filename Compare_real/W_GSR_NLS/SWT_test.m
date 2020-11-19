function SWT_test(X)
%[cA,cH,cV,cD]=swt2(X,2,'haar');%用haar小波基进行2尺度平稳小波分解
[cA,cH,cV,cD]=swt2(X,2,'db1');%用haar小波基进行2尺度平稳小波分解
cA1=cA(:,:,1);cH1=cH(:,:,1);cV1=cV(:,:,1);cD1=cD(:,:,1);%尺度1低、高频系数
cA2=cA(:,:,2);cH2=cH(:,:,2);cV2=cV(:,:,2);cD2=cD(:,:,2);%尺度2低、高频系数
figure;
subplot(1,2,1),imshow(uint8(cA1));axis off;title('尺度1的低频系数图像');
subplot(1,2,2),imshow(uint8(cA2));axis off;title('尺度2的低频系数图像');
figure;
subplot(2,3,1),imshow(uint8(cH1));axis off;title('尺度1水平方向高频系数');
subplot(2,3,2),imshow(uint8(cV1));axis off;title('尺度1垂直方向高频系数');
subplot(2,3,3),imshow(uint8(cD1));axis off;title('尺度1斜线方向高频系数');
subplot(2,3,4),imshow(uint8(cH2));axis off;title('尺度2水平方向高频系数');
subplot(2,3,5),imshow(uint8(cV2));axis off;title('尺度2垂直方向高频系数');
subplot(2,3,6),imshow(uint8(cD2));axis off;title('尺度2斜线方向高频系数');
% F= iswt2(Z_A,Z_H,Z_V,Z_D,'db1');
end