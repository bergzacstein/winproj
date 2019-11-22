function [BW_inside,varargout] = contour2bw_convex(Volume_contour,Missing_line_option)
%============================================================================
%USAGE
%    [BW_inside,[BW_contours] ] = contour2bw_convex(Volume_contour,[Missing_line_option])
%PARAMETERS
%   Volume_contour      =  2D or 3D bw volume with contours.
%   Missing_line_option =  'correct' if want to correct for non connected pixels [default].
%   BW_inside           =  Filled in bw for points inside the CONVEX envelloppe of
%                          the contours defined in Volume_contour.
%   BW_contour          =  Corrected bw contours defined in Volume_contour.
%============================================================================
if nargin==1
    Missing_line_option = 'correct';
end

[M,N,P]   = size(Volume_contour);

%============================================================================
% Create Black and White Volume_contour of the Contour
%============================================================================
BW_inside  = uint8(zeros(size(Volume_contour)));
BW_outside = uint8(zeros(size(Volume_contour)));

for p=1:P
   
   %============================================
   % Get the indices where slice has points
   %============================================
   missing_line = [];
   [u1,u2]      = find(Volume_contour(:,:,p)==1);
   
   %============================================
   % For each line, get nber of white pts
   %============================================
   if isempty(u1)
       BW_contour(:,:,p) = Volume_contour(:,:,p);
   else
       for i = min(u1):max(u1)
           v        = find(Volume_contour(i,:,p)==1);
           nber_pts = length(v);
           %============================================
           % if more two points, fill the line
           %============================================
           if nber_pts >= 2
               BW_inside(i,floor([v(1):v(end)]),p)=1;
               BW_contour(i,v(1),p) = 1;
               BW_contour(i,v(end),p) = 1;   
           end
           %============================================
           % Else store line as Missing line
           %============================================
           if (nber_pts < 2) & (i > min(u1)) & (i < max(u1))
               missing_line = [missing_line i];
           end
       end
   end
   
   %============================================================================
   % For each missing line, correct the filling
   %============================================================================
   if strcmp(lower(Missing_line_option),'correct')
       for ind=1:length(missing_line)
           vup   = []; 
           k1    = 1;
           vdown = [];
           k2    = 1;
           Index = missing_line(ind);
           %============================================
           % Look at up lines 
           %============================================
           while ((Index-k1) >= min(u1)) & ( length(vup) < 2)
               vup_tmp  = find(Volume_contour(Index-k1,:,p)==1);
               if length(vup_tmp)>length(vup)
                   vup = vup_tmp;
               end
               k1 = k1+1;
           end
           
           while ((Index+k2) <= max(u1)) & ( length(vdown) < 2)
               vdown_tmp = find(Volume_contour(Index+k2,:,p)==1);
               if length(vdown_tmp)>length(vdown)
                   vdown = vdown_tmp;
               end
               k2 = k2+1;
           end
           v_fill = floor([vup(1)+vdown(1) vup(end)+vdown(end)]/2);
           BW_inside(Index,v_fill,p) = 1;
           BW_contour(Index,v_fill(1),p) = 1;
           BW_contour(Index,v_fill(end),p) = 1;
       end
       
       BW_contour(:,:,p) = bwmorph(BW_contour(:,:,p),'close');
   end
end

%=============================================
% ASSIGN OUTPUT
%=============================================
BW_inside  = squeeze(BW_inside);
BW_contour = squeeze(BW_contour);
if nargout==2
   varargout{1} = BW_contour;
end
