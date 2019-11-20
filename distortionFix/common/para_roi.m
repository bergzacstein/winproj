function [m,st] = para_roi(bin,ima)

binfl=cast(bin(:),'double');
imabin=binfl.*ima(:);
m=sum(imabin(:))/sum(binfl(:));
v=sum(imabin(:).*imabin(:))/sum(binfl(:))-m*m;
st=sqrt(v);
