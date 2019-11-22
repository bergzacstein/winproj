% Exemple pour faire tourner run_snake_parametric_2d


%==========================================================================
%==========================================================================
%==========================================================================
%==========================================================================
% PARAMETERS 
%==========================================================================
Alpha  = 1;     % Alpha:   elasticity parameter [minimum = 0]
Beta   = 1;     % Beta:    rigidity parameter    [minimum = 0]
Gamma  = 1;     % Gamma:   viscosity parameter   [minimum = 1]
Kappa  = 1.;     % Kappa:   external force weight
Kappap = 0.5;   % Kappap:  balloon force weight

Sigma   = 0.1;    %standard deviation of Gaussian filtering for the edge_map computation


%==========================================================================
% For gradient vector flow computation 
%==========================================================================
Mu_gvf       = .2;  %[max value = ??]
Iter_gvf     = 10;

Nber_iterations = 200;


Snake_method = 1;  %Snake_method = (1=>classic) (2=>gvf)

%==========================================================================
%==========================================================================
%==========================================================================

%==========================================================================
% Initial Snake Shape
%==========================================================================
Vect_initial    = [48 76, 5 5 ,0]; % Smooth rectangle
%Vect_initial    = [64 64, 15 15 ,0]; % Smooth star
%Vect_initial    = [64 64, 50 60 ,0]; % Smooth star deflate
%Vect_initial    = [89 72, 5 10 ,0]; % brain mri

%==========================================================================
% Variables to set
%==========================================================================
Parameters_snake          = [Alpha, Beta , Gamma , Kappa , Kappap , Sigma ];
Parameters_gvf            = [Mu_gvf,Iter_gvf];


%==========================================================================
% Run snake segmentation
%==========================================================================
switch Snake_method
    case 1
        %==========================================================================
        % Run snake segmentation with standard force: balloon+gradient
        %==========================================================================
        [Snake,Snake_iter,Edge_map]  = run_snake_2d_parametric(Im,Nber_iterations,Parameters_snake,Vect_initial);
    case 2
        %==========================================================================
        % Run snake segmentation with standard force: balloon+gradient
        %==========================================================================
        [Snake,Snake_iter,Edge_map]  = run_snake_2d_parametric(Im,Nber_iterations,Parameters_snake,Vect_initial,Parameters_gvf);
end