function X=TestBilateral(A,nSig)
d=A-repmat(A(floor((size(A,1))/2),:)/2+A(floor((size(A,1))/2)+1,:)/2,size(A,1),1);
D = fspecial('gaussian',[sqrt(size(A,1)),sqrt(size(A,1))],nSig);
gt=[];
for my=1:size(A,2)
   sigma=max( A(:,my) ) - min( A(:,my));
     S = exp(-d(:,my).^2/(2*sigma^2));
     H = S.*D(:);
    gt(1,my) = sum(A(:,my).*H)/sum(H);
end
%X=A-repmat(gt,size(A,1),1);
X=repmat(gt,size(A,1),1);
end