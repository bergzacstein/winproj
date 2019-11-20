function [X_interp,Y_interp] = snakeinterp(X,Y,Dist_max,Dist_min)
%================================================================================
% USAGE
%   [X_interp,Y_interp] = snakeinterp(X,Y,Dist_max,Dist_min)
% or
%   Vect = snakeinterp(X,Y,Dist_max,Dist_min)
% PARAMETERS
%   Dist_max  = maximum distance between two snake points
%   Dist_min = maximum distance between two snake points
%              d(i,i+1)>Dist_max, then a new point is added between i and i+1
%              d(i,i+1)<Dist_min, then either i or i+1 is removed 
%================================================================================


%=======================================
%        convert to column vector      =
%=======================================
X = X(:);
Y = Y(:);

N = length(X);
d = abs(X([2:N 1])- X(:)) + abs(Y([2:N 1])- Y(:));

%================================================================================
% remove the points which distance to neighbor points is shorter than Dist_min
%================================================================================
IDX = (d<Dist_min);

idx = find(IDX==0);
if ~isempty(idx)
   X = X(idx);
   Y = Y(idx);
end

%================================================================================
% remove the points which distance to neighbor points is larger than Dist_max
%================================================================================
N   = length(X);
d   = abs(X([2:N 1])- X(:)) + abs(Y([2:N 1])- Y(:));
IDX = (d>Dist_max);

%================================================================================
% Reinterpolate points
%================================================================================
z = snakeindex(IDX);
p = 1:N+1;
X_interp = interp1(p,[X;X(1)],z');
Y_interp = interp1(p,[Y;Y(1)],z');

N = length(X_interp);
d = abs(X_interp([2:N 1])- X_interp(:)) + abs(Y_interp([2:N 1])- Y_interp(:));

%================================================================================
% Iterate
%================================================================================
while (max(d)>Dist_max),
    IDX = (d>Dist_max);
    z = snakeindex(IDX);
    p = 1:N+1;
    X_interp = interp1(p,[X_interp;X_interp(1)],z');
    Y_interp = interp1(p,[Y_interp;Y_interp(1)],z');
    N = length(X_interp);
    d = abs(X_interp([2:N 1])- X_interp(:)) + abs(Y_interp([2:N 1])- Y_interp(:));
end

%================================================================================
% Output
%================================================================================
if nargout==1
    X_interp = [X_interp Y_interp];
end