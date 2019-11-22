function Bin = vect2bin(Vect,Dim)
%=======================================================
% USAGE
%   Bin = vect2bin(Vect,Dim)
% PARAMETERS
%  Vect = 2D points [X Y] Y->Cols, X->Lines
%  Dim  = Size of image to create 1 at points location
%=======================================================
FIGURE=0;

%========================================
%  Initialize binary volume
%========================================
Bin       = zeros(Dim);
Nber_dims = size(Dim,2);

%========================================
%  Empty vector
%========================================
if isempty(Vect)
    return;
end

%========================================
%  Place points rounding to lowest round 
% value (floor)
%========================================
iter  = 1;

%========================================
% Round values of Vect1 and Vect2
%========================================
Vect(:,1:2) = round(Vect(:,1:2));
ind = find(Vect(:,1)<=0);Vect(ind,1)=1;
ind = find(Vect(:,2)<=0);Vect(ind,2)=1;
ind = find(Vect(:,1)>=Dim(1)+1);Vect(ind,1)=Dim(1);
ind = find(Vect(:,2)>=Dim(2)+1);Vect(ind,2)=Dim(2);
ind = find(Vect(:,1)<=Dim(1) & Vect(:,2)<=Dim(2));
Vect = Vect(ind,:);


Nber_points = length(Vect);

%========================================
% Iterate linear interpolations between points
%========================================
for i=1:Nber_points-1
	
	[ind_x,interp_y] = line_interp(Vect(i,:),Vect(i+1,:));
	ind      = sub2ind(Dim,ind_x,interp_y);
	Bin(ind) = 1;

end

[ind_x,interp_y] = line_interp(Vect(Nber_points,:),Vect(1,:));
ind              = sub2ind(Dim,ind_x,interp_y);
Bin(ind)         = 1;


%888888888888888888888888888888888888888888888888
%888888888888888888888888888888888888888888888888
function [ind_x,interp_y] = line_interp(Vect1,Vect2)

%=======================================
%=======================================
x = [Vect1(1);Vect2(1)];
y = [Vect1(2);Vect2(2)];

[x,ind] = sort(x);
y       = y(ind);

ind_x    = [x(1):x(2)];
slope    = (y(2)-y(1))/(x(2)-x(1));
b        = y(1)-slope * x(1);
interp_y = round(slope*ind_x+b);




