function Seg = region_growing(Im,Points,Thresh_tolerance)
%=========================================================
% USAGE
% Seg = region_growing(Im,Points,Thresh_tolerance)
%
%=========================================================
FIGURE        = 1;
[M,N,P]       = size(Im);
Im            = double(Im);
ROI_size      = [10 10];
ROI_size_grow = [1 1];

Nber_points = size(Points,1);

for Slice=1:P
	if FIGURE
			subplot(1,2,1),my_imshow(Im(:,:,Slice));pause(0.1)
	end
	%======================
	% Initialize the result	
	%======================
	Label = zeros(M,N);
	
	%======================
	% Start at starting point 
	%======================
	Gray_level_ref_mean_vect    = [];
	for i=1:Nber_points
		Label(Points(i,1),Points(i,2)) = 1;
	
		%============================
		% Compute the reference Gray level
		% = mean value around the initial point
		%============================
		Temp                        = Im(Points(i,1)-ROI_size(1):Points(i,1)+ROI_size(1),Points(i,2)-ROI_size(2):Points(i,2)+ROI_size(2),Slice);
		Gray_level_ref_mean_vect    = [Gray_level_ref_mean_vect Temp(:)];
	end

	
	%======================
	%======================
	Gray_level_ref_mean = mean(Gray_level_ref_mean_vect);
	Gray_level_ref_std  = std(Gray_level_ref_mean_vect);
	
	%~~~~~~~~~~~~~~~~~~~~~~~~~~~
	% Loop to increase the region
	%~~~~~~~~~~~~~~~~~~~~~~~~~~~
	CONT = 1;
	while (CONT==1)
		
%		Perim     = my_edge(Label,'sobel');
		Perim     = my_perimeter(Label);
		[a,b]     = find(Perim==1);
		Label_new = Label;
		for i=1:length(a)
			u_center   = a(i);
			v_center   = b(i);
			u_left     = max(1,u_center-ROI_size_grow(1));
			v_left     = max(1,v_center-ROI_size_grow(2));
			u_right    = min(M,u_center+ROI_size_grow(1));
			v_right    = min(N,v_center+ROI_size_grow(2));
			Neigh      = Im(u_left:u_right,v_left:v_right,Slice);
			Mean_neigh = mean(Neigh(:));
			if ( abs(Mean_neigh-Gray_level_ref_mean) < (Thresh_tolerance*Gray_level_ref_std))
				Label_new(u_center,v_center) = 1;
			end
		end
		CONT  = ~isempty(find(Label(:)-Label_new(:)));
		Label = Label_new;
		if FIGURE
			subplot(1,2,2),my_imshow(Label);
			subplot(1,2,1),my_imshow(Im);
            pause(0.1)
		end
	end
	Seg(:,:,Slice) = Label;
end

