function Edge_map = edge_map(Volume,Method,Sigma,Nber_iter,NORMALIZE);
%=================================================
% USAGE
%  Edge_map = edge_map(Volume,Method,Sigma,Nber_iter,NORMALIZE);
% PARAMETERS
%  Volume    = Volume of data.
%  Method    = 1 => canny edge detector (2D).
%            = 2 => conv with Gaussian mask (2D)+ gradient.
%  Sigma     = Sigma of Gaussian filter.
%  Nber_iter = Number of iterations for smoothing.
%  NORMALIZE = option to normalize Edgemap to original range of values in Volume [default=0].
%=================================================
if nargin==4
    NORMALIZE=0;
end

%=================================================
% Initialize variables
%=================================================
Volume     = double(Volume);
[M, N, P]  = size(Volume);
Edge_map   = zeros(size(Volume));

%=================================================
% Create Gaussian mask
%=================================================
if Method==2
    x          = [-1:1];
    Gauss_mask = 1/sqrt(2*pi*Sigma^2)*exp(-(x.^2)/2*Sigma)'*exp(-(x.^2)/2*Sigma^2);
end

%=================================================
% Iterations on slices
%=================================================
for p=1:P
    Im = double(Volume(:,:,p));
    if Method==1
        Edge_tmp          = double(edge(Im,'canny',.25,Sigma));
        Edge_map(:,:,p)   = gaussianblur(Edge_tmp,1);
    elseif Method==2
        Edge_tmp = Im;
        for iter=1:Nber_iter
            Edge_tmp = gaussianblur(Edge_tmp,Sigma);
        end
        Edge_map(:,:,p) = gradient_image(Edge_tmp,1,1); 
    end
end

%=================================================
% Padd border of edgemap
%=================================================
Edge_map(1,:,:)   = Edge_map(2,:,:);
Edge_map(end,:,:) = Edge_map(end-1,:,:);
Edge_map(:,1,:)   = Edge_map(:,2,:);
Edge_map(:,end,:) = Edge_map(:,end-1,:);


%=================================================
% Normalize values of Edge_map between [0 1]
%=================================================
if NORMALIZE
    Maxi       = max(Edge_map(:));
    Mini       = min(Edge_map(:));
    Edge_map   = ( Edge_map-min( Edge_map(:)))/(Maxi-Mini);
end