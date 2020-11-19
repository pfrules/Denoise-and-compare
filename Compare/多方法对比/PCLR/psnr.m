function psnr = psnr(x,y)
if max(max(x)) > 40
    maxv = 255;
else
    maxv = 1;
end
x = double(x);
y = double(y);
psnr = 20 * log10( maxv * sqrt(numel(x)) / norm(x-y,'fro') );
