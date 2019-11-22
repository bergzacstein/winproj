function [Snake,Snake_iter,Edge_map]  = run_snake_2d_parametric(Im,Nber_iter,Parameters,Vect_initial,Parameters_gvf)
%=====================================================================
%USAGE
%  [Snake,Snake_iter,Edge_map]  = run_snake_2d_parametric(Im,Nber_iter,Parameters,Vect_initial,[Parameters_gvf])
%
% PARAMETERS
%   Im              = Image to segment.
%   Nber_iter       = Maximum number of iterations.
%   Parameters      = [Alpha, Beta , Gamma , Kappa , Kappap , Sigma ];
%                         Alpha:   elasticity parameter
%                         Beta:    rigidity parameter
%                         Gamma:   viscosity parameter
%                         Kappa:   external force weight
%                         Kappap:  balloon force weight
%                         Sigma :  standard deviation of Gaussian filtering
%                                  for the edge_map computation
%   Vect_initial    = [] => Manual initialization of the snake.
%                   = [X Y] => Point coordinates of initial contour.
%                   = [Center_point_coord, Radius ,angle_Rot].
%                   = [X_param,Y_param,Radius,angle_Rot].
%   Snake           = Vector of final contour points.
%   Snake_iter      = Celle arraty with vector of contour at each iteration.
%   Edge_map        = Map of contours used for computation of the gradient
%                     (used in the image data force).
%=====================================================================
[M,N]           = size(Im);
FIGURE          = 1;
GVF_ON          = (nargin==5);

%=====================================================================
% Set type of initilisation 
%=====================================================================
[N1,N2]                   = size(Vect_initial);
Center_point_coord        = Vect_initial(1,1:2);
Radius                    = Vect_initial(1,3:4);
Rotation_angle            = pi*Vect_initial(5)/180;

%=====================================================================
%Parameters
%=====================================================================
Alpha   = Parameters(1);
Beta    = Parameters(2);
Gamma   = Parameters(3);
Kappa   = Parameters(4);
Kappap  = Parameters(5);
Sigma   = Parameters(6);

%================================
%1. Compute Edge Map            =
%================================
Edge_map = edge_map(Im,2,Sigma,0);

%=====================================================================
% Compute the Gradient Field on the Edge Map
%=====================================================================
[Grad_potential_x,Grad_potential_y] = gradient(Edge_map);

%=====================================================================
% Initialize Balloon Deformation
%=====================================================================
%=======================================
% Center point provided by user
%=======================================
x_ini   = Center_point_coord(:,1);
y_ini   = Center_point_coord(:,2);

%=======================================
% Assign radius Rx and Ry
%=======================================
if length(Radius)==1,
    Rx = Radius   ;
    Ry = Radius;
else,
    Rx = Radius(1);
    Ry = Radius(2);
end

%=======================================
% Define points on ellipse
%=======================================
T       = [0:2*pi/20:2*pi];
x1      =  Rx*cos(T);
y1      =  Ry*sin(T);
x0      =  cos(Rotation_angle)*x1  - sin(Rotation_angle)*y1 + x_ini;
y0      =  sin(Rotation_angle)*x1  + cos(Rotation_angle)*y1 + y_ini;
   
%=======================================
% Interpolate initial contour points
% for smoother results
%=======================================
Snake_ini    = snakeinterp(x0,y0,2,0.5);

%=====================================================================
%  Display Edge Map and Gradient Field
%=====================================================================
subplot(1,2,1),  
imagesc(Edge_map);colormap('jet'),colorbar
axis off,
snakedisp(Snake_ini,'r');    
title('initial snake contour and Edgemap');
subplot(1,2,2),  
newplot,axis off
disp('>> Pause: hit any key to continue....')
pause
   
%=====================================================================
%2. Compute the GVF Gradient Field on the Edge Map
%=====================================================================
if GVF_ON
    disp(' Computing the GVF ...');
    Mu_gvf        = Parameters_gvf(1); 
    Iter_gvf      = Parameters_gvf(2);
    [Force_field_u,Force_field_v] = gvf(Edge_map,Mu_gvf,Iter_gvf);
else
    [Force_field_v,Force_field_u] = gradient(Edge_map.^2);
end
Force_field_mag       = sqrt(Force_field_u.^2+Force_field_v.^2);
ind                   = find(Force_field_mag(:)==0);
Force_field_mag(ind)  = 1;
Force_field_u         = Force_field_u./(Force_field_mag);
Force_field_v         = Force_field_v./(Force_field_mag);


%=====================================================================
%4. Iterative snake deformation
%=====================================================================
disp('Starting deformations ...');
[Snake,Snake_iter] =  snake_deform_classic(Snake_ini,Parameters(1:5),Force_field_u,Force_field_v,Nber_iter,FIGURE,Im);
   
%=====================================================================
%6. Display the results
%=====================================================================
subplot(1,2,2),
imagesc(Im);axis off,colormap('gray')
snakedisp(Snake,'r'); 
title(['Final result,  iter = ' num2str(Nber_iter)]);
pause(1)


