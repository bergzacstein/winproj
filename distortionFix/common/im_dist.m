function dist=im_dist(im,m,s)


dist=(im-m).^2/2/s/s+log(s);
