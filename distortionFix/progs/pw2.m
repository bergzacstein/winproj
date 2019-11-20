im=ima2mat('images/brain');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Bayesian classification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% supervised learning of the parameters

% class 1
Bin1=my_get_roi(im);
[m1,s1]=para_roi(Bin1,im)


% class 2
Bin2=my_get_roi(im);
[m2,s2]=para_roi(Bin2,im)

% class 3
Bin3=my_get_roi(im)
[m3,s3]=para_roi(Bin3,im)



% images of the distance of the pixels to the class 
% Modify this version to take standard deviation into account 
% or prior probabilities for the classes

dist1=(im-m1).^2;
figure(1); plotim(dist1);

dist2=(im-m2).^2;
figure(2); plotim(dist2);

dist3=(im-m3).^2;
figure(3); plotim(dist3);


etiq_m = (dist1<=dist2 & dist1<dist3)*1 + ...
          (dist2<=dist3 & dist2<dist1)*2 + ...
          (dist3<=dist1 & dist3<dist2)*3  ;
figure(4) ; plotim(etiq_m) ; colormap(cool) ; pause(0.5) ;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%k-means 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
min_im=min(im(:));
max_im=max(im(:));

nb_classes=3;
m1=;
m2=;
m3=;

m=[m1 m2 m3]

m_=[1 1 1]


% loop on the class centers
while m ~= m_

  %classification of the pixels in the classes
  dist1_km=(im-m(1)).^2;
  dist2_km=(im-m(2)).^2;
  dist3_km=(im-m(3)).^2;

  etiq_km = (dist1_km<=dist2_km & dist1_km<=dist3_km)*1 + ...
          (dist2_km<=dist3_km & dist2_km<=dist1_km)*2 + ...
          (dist3_km<=dist1_km & dist3_km<=dist2_km)*3;
figure(5) ; plotim(etiq_km) ; colormap(cool) ; pause(0.5) ;

   %updating of the class centers
   m_ = m ;
   m(1) = sum(sum((etiq_km==1).*im))./sum(sum(etiq_km==1)) ;
   m(2) = sum(sum((etiq_km==2).*im))./sum(sum(etiq_km==2)) ;
   m(3) = sum(sum((etiq_km==3).*im))./sum(sum(etiq_km==3)) ;
   
   m
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% region growing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the Thres_tolerance controls the pixel agglomeration
% a starting point must be manually given

my_imshow(im)
disp('acquire 1 manual point ');
P   = my_getpts;
P   = round([P(2) P(1)]);
Thresh_tolerance=1.1;
Seg = region_growing(im,P,Thresh_tolerance);
