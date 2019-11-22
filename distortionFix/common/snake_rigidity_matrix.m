function [A_inverse,A] = snake_rigidity_matrix(N,Delta_x,Alpha,Beta,Gamma);
%=====================================================================
% USAGE
%    [A_inverse,A] = snake_rigidity_matrix(N,Delta_x,Alpha,Beta,Gamma)
% PARAMETERS
%    N       = number of points in snake (matrix size will be [N N])
%    Delta_x = spatial increment 
%    Alpha   = elasticity
%    Beta    = rigidity
%    Gamma   = viscosity
%    A_inverse   = Inverse "stiffness" matrix for the snake iterations
%    A       = Matrix of internal forces
%=====================================================================


%=====================================================================
% generates the parameters for snake
%=====================================================================
Alpha = Alpha* ones(1,N); 
Beta  = Beta*ones(1,N);

%=====================================================================
% produce the five diagonal vectors
%=====================================================================
a = Beta/Delta_x^4;
b = (-Delta_x^2*Alpha - 4*Beta)/Delta_x^4;
c = (2*Delta_x^2*Alpha + 6*Beta)/Delta_x^4 ;

%=====================================================================
% generate the parameters matrix
%=====================================================================
A = diag(a(1:N-2),-2) + diag(a(N-1:N),N-2);
A = A + diag(b(1:N-1),-1) + diag(b(N), N-1);
A = A + diag(c);
A = A + diag(b(1:N-1),1) + diag(b(N),-(N-1));
A = A + diag(a(1:N-2),2) + diag(a(N-1:N),-(N-2));

A_inverse = inv(A + Gamma * diag(ones(1,N)));
