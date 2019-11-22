function [xmin,xmax] = plotim(x,xmin,xmax)

%PLOTIM    Plot a matrix as a grey level image.
%
%plotim(x) plots x with its lowest value in black and its highest
%          value in white, and a linear scaling inbetween.
%
%plotim(x,xmin,xmax) plots x with xmin in black and xmax in white.
%          Values greater than xmax are displayed in white, values
%	   smaller than xmin are displayed in black.
%
%[xmin,xmax] = plotim(...) returns black and white values.
%
%Author : Elodie Roullot, May 1999.

colormap(gray(256))

if nargin==1
	xmin=min(min(x));
	xmax=max(max(x));
end

x=255*(x-xmin)/(xmax-xmin);

image(x) ;
%axis xy ;
set(gca,'DataAspectRatio',[1 1 1]) ;
