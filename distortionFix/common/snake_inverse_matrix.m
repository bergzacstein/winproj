function invAI = snake_inverse_matrix(N,h,alpha,beta,gamma);
%=====================================================================
% USAGE
%    invAI = snake_inverse_matrix(N,h,alpha,beta,gamma)
% PARAMETERS
%    N      = number of points in snake (matrix size will be [N N])
%    h      = spatial increment 
%    alpha  = elasticity
%    beta   = rigidity
%    gamma  = viscosity
%    invAI  = Inverse "stiffness" matrix for the snake iterations
%=====================================================================


%=====================================================================
% generates the parameters for snake
%=====================================================================
alpha = alpha* ones(1,N); 
beta = beta*ones(1,N);

%=====================================================================
% produce the five diagonal vectors
%=====================================================================
a = beta/h^4;
b = (-h^2*alpha - 4*beta)/h^4;
c = (2*h^2*alpha + 6*beta)/h^4 ;

%=====================================================================
% generate the parameters matrix
%=====================================================================
A = diag(a(1:N-2),-2) + diag(a(N-1:N),N-2);
A = A + diag(b(1:N-1),-1) + diag(b(N), N-1);
A = A + diag(c);
A = A + diag(b(1:N-1),1) + diag(b(N),-(N-1));
A = A + diag(a(1:N-2),2) + diag(a(N-1:N),-(N-2));

invAI = inv(A + gamma * diag(ones(1,N)));
