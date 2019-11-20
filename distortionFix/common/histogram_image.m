function [H,Gray_levels] = histogram_image(Im,Gray_levels);
%==================================================
% USAGE
%    [H,Gray_levels] = histogram_image(Im,Gray_levels);
% or
%    [H,Gray_levels] = histogram_image(Im,Nber_bins);
%==================================================
FIGURE = 0;

Im    = double(Im);
Mini  = min(Im(:));
Maxi  = max(Im(:));
Range = Maxi-Mini+1;

if max(size(Gray_levels))==1
	Gray_levels = [Mini:round(Range/Gray_levels):Maxi];
end
	

H = hist(Im(:),Gray_levels);

if FIGURE
	figure,
	plot(Gray_levels,H);
	title('Histogram')
end