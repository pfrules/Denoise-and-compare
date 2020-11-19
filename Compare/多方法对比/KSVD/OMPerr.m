function [A]=OMPerr(D,X,errorGoal); 
%=============================================
% Sparse coding of a group of signals based on a given 
% dictionary and specified number of atoms to use. 
% input arguments: D - the dictionary
%                  X - the signals to represent
%                  errorGoal - the maximal allowed representation error for
%                  each siganl.
% output arguments: A - sparse coefficient matrix.
%=============================================
[n,P]=size(X);%n=64  P= 62001=249*249
[n,K]=size(D);%n=64 K=256
E2 = errorGoal^2*n;
maxNumCoef = n/2;%%%%%%32
A = sparse(size(D,2),size(X,2));%�ο�ϡ�����İ���256*10000
for k=1:1:P,
    a=[];
    x=X(:,k);
    residual=x;
	indx = [];
	a = [];
	currResNorm2 = sum(residual.^2);
	j = 0;

    while currResNorm2>E2 & j < maxNumCoef,
		j = j+1;
        proj=D'*residual;%�ο�pinv�����İ��� 256*1
        pos=find(abs(proj)==max(abs(proj)));%����D��256�У�����һ�е�ֵ���
        pos=pos(1);
        indx(j)=pos;%%%index��ֵΪ1��256
        %c++��opm�Ż��ٶȵ��㷨     http://blog.csdn.net/pi9nc/article/details/26593003
        a=pinv(D(:,indx(1:j)))*x;%j*64  *64*1=j*1    
        residual=x-D(:,indx(1:j))*a;
		currResNorm2 = sum(residual.^2);
   end;
   if (length(indx)>0)
       A(indx,k)=a;%%%a��j*1�ľ���,����j=maxNumCoef
   end
end;
return;
