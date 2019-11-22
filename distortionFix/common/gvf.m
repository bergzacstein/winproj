function [Field_gvf_u,Field_gvf_v] = gvf(Edge_map, Mu, Nber_iter)
%====================================================================
% USAGE
%   [Field_gvf_u,Field_gvf_v] = gvf(Edge_map, Mu, Nber_iter) 
% PARAMETERS
%   Edge_map                  = Map of edges
%   Mu                        = GVF regularization coefficient
%   Nber_iter                 = number of iterations that will be computed.  
%   [Field_gvf_u,Field_gvf_v] = GVF vector field of the edge map Edge_map.
%====================================================================

%====================================================================
% Normalize Edge_map
%====================================================================
[M,N] = size(Edge_map);
Emin  = min(Edge_map(:));
Emax  = max(Edge_map(:));
Edge_map = (Edge_map-Emin)/(Emax-Emin);

%====================================================================
% Boundary conditions
%====================================================================
Edge_map = padd_array_mirror(Edge_map);

%====================================================================
% Compute the gradient of the edge map
%====================================================================
[Edge_map_dv,Edge_map_du] = gradient(Edge_map); 

%====================================================================
% Initialize GVF to the gradient
%====================================================================
Field_gvf_u = Edge_map_du;
Field_gvf_v = Edge_map_dv;

%====================================================================
% Squared magnitude of the gradient field
%====================================================================
Field_gvf_mag = Edge_map_du.^2 + Edge_map_dv.^2; 

%====================================================================
% Iteratively solve for the GVF Field_gvf_x,Field_gvf_y
%====================================================================
for i=1:Nber_iter,
  Field_gvf_u = Field_gvf_u + Mu * 4 * del2(Field_gvf_u) - Field_gvf_mag.*(Field_gvf_u-Edge_map_du);
  Field_gvf_v = Field_gvf_v + Mu * 4 * del2(Field_gvf_v) - Field_gvf_mag.*(Field_gvf_v-Edge_map_dv);
end

%====================================================================
% Shrink boundary conditions
%====================================================================
Field_gvf_u=unpadd_array(Field_gvf_u);
Field_gvf_v=unpadd_array(Field_gvf_v);
