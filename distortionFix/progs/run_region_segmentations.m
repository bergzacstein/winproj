%============================================
% Read Data
%============================================
%Filename = 'images/fetus_one_slice';
Filename = 'images/ibsr_05_slice_145'
%Filename = 'images/house.ima'
close all
Im       = read_volume_ima(Filename);

%============================================
% Run Otsu_thresholding
%============================================
Nber_bins  =20;
Seg        = otsu_hist_thresh(Im,Nber_bins);
disp('result of Otsu optimal thresholding');
pause
close(gcf);

%============================================
% Run Region Growing
%============================================
%
% EX: MRI :Points =[ 48 ,107];Thresh_tolerance=1.65;

my_imshow(Im)
disp('acquire 1 manual point ');
P   = my_getpts;
P   = round([P(2) P(1)]);
Thresh_tolerance=1.1;
Seg = region_growing(Im,P,Thresh_tolerance);
