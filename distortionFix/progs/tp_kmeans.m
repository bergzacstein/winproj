clear all ; close all ;

global BAS_DROITE BAS_GAUCHE HAUT_DROITE HAUT_GAUCHE CHEMIN

initialize ;

% AJOUT DU CHEMIN D'ACCES AUX IMAGES :

path(path, '/tsi/zone/images/bref/SPOT_XS/') ;

% LECTURE DES IMAGES :

im1 = ima2mat('cam1') ;
im2 = ima2mat('cam2') ;
im3 = ima2mat('cam3') ;

%visualisation de l'histogramme 
 mean(im1(:)); %moyenne de l'image
hist_im1=hist(im1(:),(0:255)); %il faut specifier sinon iltravaille lg par lg 
% specifier (0:255) sinon juste 255 il le fait entre le min et le max
bar(hist_im1(0:100)) % pour avoir une visu en barres

%visualisation de l'image 
colormap(gray);
image(im1);
%visiblement il fait un eclaicissemnt standard
image((im1-min(im1(:)))*255/(max(im1(:))-min(im1(:))));  
% pour faire un etalement de la dynamique entre le min et le max

%taille de l'image 
lg=size(im1,1);
lcol=size(im1,2);


% ALGORITHME DES K-MEANS :

% 1. Initialisation.

% Choix de centres initiaux :
m=ones(3,3);
m(:,1) = [25 ; 15 ; 20] ;
m(:,2) = [33 ; 25 ; 30] ;
m(:,3) = [41 ; 35 ; 40] ;
m
m_ = inf * ones(3) ;

figbg = figure('position',BAS_GAUCHE) ;

while m ~= m_

   % 2. Affectation.
   
   dist1 = (im1-m(1,1)).^2 + (im2-m(2,1)).^2 + (im3-m(3,1)).^2 ;
   dist2 = (im1-m(1,2)).^2 + (im2-m(2,2)).^2 + (im3-m(3,2)).^2 ;
   dist3 = (im1-m(1,3)).^2 + (im2-m(2,3)).^2 + (im3-m(3,3)).^2 ;
   etiq = (dist1<=dist2 & dist1<dist3)*1 + ...
          (dist2<=dist3 & dist2<dist1)*2 + ...
          (dist3<=dist1 & dist3<dist2)*3  ;
   figure(figbg) ; plotim(etiq) ; pause(0.5) ;
   

%avec image
% image(etiq); colormap(prism);


% for i=1:lg 
%    for j=1:lcol
%          dist1(i,j)=(im1(i,j)-m1(1))^2+(im2(i,j)-m1(2))^2+(im3(i,j)-m1(3))^2;
% dist2(i,j)=
% dist3(i,j)=
% if((dist(i,j)< )) & ......
%for i = 1:n
%        for j = 1:n
%                if ((dens1(i,j) > dens2(i,j)) & (dens1(i,j) > dens3(i,j)))
%                        Z(i,j) = 1 ;
%                elseif ((dens2(i,j) > dens1(i,j)) & (dens2(i,j) > dens3(i,j)))
%                        Z(i,j) = 2 ;
%                else
%                        Z(i,j) = 3 ;
%                end
%        end
% end


   % 3. Mise a jour des centres.
   
   m_ = m ;
   m(1,1) = sum(sum((etiq==1).*im1))./sum(sum(etiq==1)) ;
   m(2,1) = sum(sum((etiq==1).*im2))./sum(sum(etiq==1)) ;
   m(3,1) = sum(sum((etiq==1).*im3))./sum(sum(etiq==1)) ;
   
   m(1,2) = sum(sum((etiq==2).*im1))./sum(sum(etiq==2)) ;
   m(2,2) = sum(sum((etiq==2).*im2))./sum(sum(etiq==2)) ;
   m(3,2) = sum(sum((etiq==2).*im3))./sum(sum(etiq==2)) ;
   
   m(1,3) = sum(sum((etiq==3).*im1))./sum(sum(etiq==3)) ;
   m(2,3) = sum(sum((etiq==3).*im2))./sum(sum(etiq==3)) ;
   m(3,3) = sum(sum((etiq==3).*im3))./sum(sum(etiq==3)) ;
   
   m
   
end
   
figure('position',BAS_DROITE) ; plotim(im1) ;
figure('position',HAUT_GAUCHE) ; plotim(im2) ;
figure('position',HAUT_DROITE) ; plotim(im3) ;

