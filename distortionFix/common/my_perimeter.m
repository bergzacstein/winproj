function imout = my_perimeter( im )

[l,c]=size(im);
[y,x]=find(im==1);
n=size(x,1);
x1=max(ones(1,n) ,x'-1)';
x2=min(c*ones(1,n) ,x'+1)';
y1=max(ones(1,n) ,y'-1)';
y2=min(l*ones(1,n) ,y'+1)';
imout=zeros(l,c);
for i=1:n
    imout(y1(i,1),x(i,1))=1;
    imout(y2(i,1),x(i,1))=1;
    imout(y(i,1),x1(i,1))=1;
    imout(y(i,1),x2(i,1))=1;
end
for i=1:n
    imout(y(i,1),x(i,1))=0;
end
