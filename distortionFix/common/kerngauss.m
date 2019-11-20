function gaussm = kerngauss(sigma,size)

     x=(-size:1:size-1);
     y=(-size:1:size-1);
     gaussm=zeros(2*size,2*size);
     
     ss=2*size;

     for i=1:1:ss
     for j=1:1:ss
      ii=x(i);
      jj=y(j);
     gaussm(i,j)=1/sqrt(2*pi)/sigma*exp(-(ii*ii+jj*jj)/2/sigma/sigma);
     end
   end
figure(1)
mesh(x,y,gaussm)
