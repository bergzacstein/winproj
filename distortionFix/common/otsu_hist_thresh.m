function Seg  = otsu_hist_thresh(Im,Nber_bins);
%=====================================================
% USAGE
%    Seg  = otsu_hist_thresh(Im,Nber_bins);
% PARAMETERS
%    Im        = image to segment.
%    Nber_bins = Number of histogram bins.
%    Seg       = binary image with result of segmentation.
%=====================================================



%=====================================================
% Histogram computation
%=====================================================
Im              = double(Im);
Dim_all         = prod(size(Im));
[H,Gray_levels] = histogram_image(Im,Nber_bins);

Nber_levels = length(Gray_levels);

%=====================================================
% Iterative thresholding -> statistics of 2 classes
%=====================================================
for i=1:Nber_levels
	Thresh(i)     = Gray_levels(i);
	Ind_low{i}    = find(Im(:)<=Thresh(i));
	Ind_high{i}   = find(Im(:)>Thresh(i));
	Mean_low(i)   = mean(Im(Ind_low{i}));
	Std_low(i)    = std(Im(Ind_low{i}));
	Mean_high(i)  = mean(Im(Ind_high{i}));
	Std_high(i)   = std(Im(Ind_high{i}));
	P_low(i)      = sum(H(1:i));
	P_high(i)     = sum(H(i+1:end));
end

%=====================================================
% Intra class variance for all thresholds
%  Minimal value given by the Otsu threshold
%=====================================================
Var_intraclass = (P_low./Dim_all) .* (Std_low.^2) + (P_high./Dim_all) .* (Std_high.^2);
Var_intraclass(1) = max(Var_intraclass); %avoid solution being lowest threshold (not 2 objects!)
Var_mini       = min(Var_intraclass);
Ind_mini       = find(Var_intraclass==Var_mini);

%=====================================================
% Thresh_otsu value
%=====================================================
Thresh_otsu    = Thresh(Ind_mini(1));

%=====================================================
% Image thresholding
%=====================================================
Seg    =  (Im<Thresh_otsu);


figure,
subplot(1,3,2),my_imshow(Seg);

subplot(1,3,1),plot(Gray_levels,H,'k');hold on
plot(Thresh_otsu*[1 1],[0 max(H(:))],'r--');
legend('Hist',['Otsu thresh = ' num2str(Thresh_otsu)]);
subplot(1,3,3),my_imshow(Im);


