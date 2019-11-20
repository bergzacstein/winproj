function [Snake,Snake_iter] = snake_deform_classic(Snake,Parameters_snake,Force_field_u,Force_field_v,Nber_iter,FIGURE,Im)
%=====================================================================
% USAGE
%     [Snake_res,Snake_iter] = snake_deform_classic(Snake,Parameters_snake,Force_field_u,Force_field_v,Nber_iter,FIGURE,Im)
% PARAMETERS
%     Snake            =   Initial snake vector.
%     Parameters_snake = [alpha, beta, kappa, kappap]
%                         alpha      =   elasticity parameter
%                         beta       =   rigidity parameter
%                         gamma      =   viscosity parameter
%                         kappa      =   external force weight
%     Force_field_u    =   external force field in u (line)
%     Force_field_v    =   external force field in v (col)
%     FIGURE           =   option to display the snake every n iterations.
%     Im               =   Image to display to view iterative deformation (the
%                          original image for example).
%     Snake_res        =   Final snake vector
%     Snake_iter       =   cell array with snakes from every n iterations
%=====================================================================

%=====================================================================
% Initialize some parameters and variables
%=====================================================================
REFRESH_STEP = 1;
VIEW_STEP    = 10;
iter_save    = 1;
Snake_iter   = [];
if nargin==10
    Im = [];
end

%=====================================================================
% generates the parameters for snake
%=====================================================================
N                 = size(Snake,1);
[M_image,N_image] = size(Force_field_u);

%================================================================================
%  Delta_x =  distance between succesive 'snaxels'.
% It can be fixed to constant and equal to the mean distance between points 
%================================================================================
Delta_x = 1;

%================================================================================
% Stiffness Matrix A
%================================================================================
A_inverse = snake_rigidity_matrix(N,Delta_x,Parameters_snake(1),Parameters_snake(2),Parameters_snake(3));

%================================================================================
% Iteration
%================================================================================
for iter = 1:Nber_iter,
    
    %============================================================
    % Pressure term from Edgemap 
    %============================================================
    Pressure_u  = interp2(Force_field_u,Snake(:,2),Snake(:,1),'*linear');
    Pressure_v  = interp2(Force_field_v,Snake(:,2),Snake(:,1),'*linear');
    
    %============================================================
    % Balloon pressure force along the normal direction 	
    %============================================================
    X_right = [Snake((2:N),1);Snake(1,1)];
    Y_right = [Snake((2:N),2);Snake(1,2)];
    X_left  = [Snake(N,1);Snake(1:N-1,1)]; 
    Y_left  = [Snake(N,2);Snake(1:N-1,2)];  
    
    N_x = X_right-X_left;
    N_y = Y_right-Y_left;
    N_magnitude = sqrt(N_x.^2+N_y.^2);
    
    if (N_magnitude>0)
        Normal_u =   N_y./N_magnitude;   %Normal is Oriented outside for clockwise points with origin un upper left corner!
        Normal_v =  -N_x./N_magnitude;
    else
        Normal_u = N_y;
        Normal_v = -N_x;
    end
    
    
    %=====================================================================
    % Deform snake
    %=====================================================================
    Snake(:,1) = A_inverse * (Parameters_snake(3) * Snake(:,1) + Parameters_snake(4) * Pressure_u + Parameters_snake(5) * Normal_u);
    Snake(:,2) = A_inverse * (Parameters_snake(3) * Snake(:,2) + Parameters_snake(4) * Pressure_v + Parameters_snake(5) * Normal_v);
    
    %=================================================================================
    % Test if the value of x and y are in the acceptable range [1:M_image,1:N_image]
    %=================================================================================
    if ( (min(Snake(:,1))<1) |(min(Snake(:,2))<1) | (max(Snake(:,1))>M_image) | (max(Snake(:,2))>N_image) )
        disp('snake_deform_classic: snake contour shrank to 1 pixel!')
        break
    end
    
    %=====================================================================
    % Test if snake is bigger than one pixel
    %=====================================================================
    if ( (floor(max(Snake(:,1))-min(Snake(:,1)))==0) |(floor(max(Snake(:,2))-min(Snake(:,2)))==0) )
        disp('snake_deform_classic: snake contours are outside the image limit!')
        break
    end
    
    
    %=====================================================================
    % display every 5 snakes if option is selected
    %=====================================================================
    if  (mod(iter,VIEW_STEP)==0) & FIGURE
        subplot(121)
        Step_points = round(length(Snake)/20);
		newplot
        axis(gca,'ij');
        hold on,
        quiver(Snake(1:Step_points:end,2),Snake(1:Step_points:end,1),...
			Parameters_snake(4)*Pressure_v(1:Step_points:end),Parameters_snake(4)*Pressure_u(1:Step_points:end),'r')
        hold on,
        quiver(Snake(1:Step_points:end,2),Snake(1:Step_points:end,1),...
			Parameters_snake(5) *Normal_v(1:Step_points:end),Parameters_snake(5) *Normal_u(1:Step_points:end),'g')
        hold off,
        axis off,whitebg('blue')
        title('External Force field');
        pause(0.5);
        
        subplot(122),
        imagesc(Im),hold on,colormap('gray')
        axis off,
        snakedisp(Snake,'r','linewidth',2) 
        title(['Deformation in progress,  iter = ' num2str(iter)])
        pause(0.5);
    end
    
    %=====================================================================
    % Resample the snake & recompute Stifness matrix A
    %=====================================================================
    if  (mod(iter,REFRESH_STEP)==0) 
        
        Snake                 = snakeinterp(Snake(:,1),Snake(:,2),2,0.5);
        Snake_iter{iter_save} = Snake;
        N                     = size(Snake_iter{iter_save},1);
        A_inverse             = snake_rigidity_matrix(N,Delta_x,Parameters_snake(1),Parameters_snake(2),Parameters_snake(3));
        
        iter_save = iter_save+1;
    end
    
    
end
