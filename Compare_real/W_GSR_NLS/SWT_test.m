function SWT_test(X)
%[cA,cH,cV,cD]=swt2(X,2,'haar');%��haarС��������2�߶�ƽ��С���ֽ�
[cA,cH,cV,cD]=swt2(X,2,'db1');%��haarС��������2�߶�ƽ��С���ֽ�
cA1=cA(:,:,1);cH1=cH(:,:,1);cV1=cV(:,:,1);cD1=cD(:,:,1);%�߶�1�͡���Ƶϵ��
cA2=cA(:,:,2);cH2=cH(:,:,2);cV2=cV(:,:,2);cD2=cD(:,:,2);%�߶�2�͡���Ƶϵ��
figure;
subplot(1,2,1),imshow(uint8(cA1));axis off;title('�߶�1�ĵ�Ƶϵ��ͼ��');
subplot(1,2,2),imshow(uint8(cA2));axis off;title('�߶�2�ĵ�Ƶϵ��ͼ��');
figure;
subplot(2,3,1),imshow(uint8(cH1));axis off;title('�߶�1ˮƽ�����Ƶϵ��');
subplot(2,3,2),imshow(uint8(cV1));axis off;title('�߶�1��ֱ�����Ƶϵ��');
subplot(2,3,3),imshow(uint8(cD1));axis off;title('�߶�1б�߷����Ƶϵ��');
subplot(2,3,4),imshow(uint8(cH2));axis off;title('�߶�2ˮƽ�����Ƶϵ��');
subplot(2,3,5),imshow(uint8(cV2));axis off;title('�߶�2��ֱ�����Ƶϵ��');
subplot(2,3,6),imshow(uint8(cD2));axis off;title('�߶�2б�߷����Ƶϵ��');
% F= iswt2(Z_A,Z_H,Z_V,Z_D,'db1');
end