function varargout = snakedisp(Vect,Style,varargin)
%================================================
% USAGE 
%      h = snakedisp(Vect,Style,[Attributes])
%          Vect is in [u,v] image coordinates
%   or
%      h = snakedisp(x,y,Style,[Attributes])
%PARAMETERS
%   Style = string for Color (e.g: 'r*' for red stars)
%================================================
hold on
N = nargin;

if isempty(Vect), 
    varargout{1}=[]; 
else
    %================================================
    % Read points in vector
    %================================================
    if (size(Vect,2)==2)
        y     = Vect(:,1);
        x     = Vect(:,2);
        if iscell(Style)
            Color = Style{1};
        else
            Color      = Style;
            clear Style,
            Style{1}   = Color;
            N          = nargin-2;
            for i=1:N
                Style{i+1} = varargin{i};
            end
        end
        iter  = 1;
    else
        x     = Vect;
        y     = Style;
        Style = varargin;
        Color = Style{1}; 
        iter  = 2;
    end
    
    %================================================
    %================================================
    
    h = plot([x;x(1)],[y;y(1)],Color);
    axis(gca,'ij');
    
    %================================================
    %================================================
    Nber_styles = length(Style)-1;
    for i=2:2:Nber_styles
        set(h,Style{i},Style{i+1});
    end
    
    hold off
    
    if nargout == 1
        varargout{1}= h;
    end
end