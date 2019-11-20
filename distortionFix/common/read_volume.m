function Volume = read_volume(Name_volume,Dim,Data_format,varargin)
%========================================================================================
% USAGE                                                                                 
%   Volume = read_volume(Name_volume,Dim,Data_format,[little_endian],[Offset])                       
% PARAMETERS                                                                            
%   Name_volume   = Name of the volume to read                                        
%   Dim           = Dimension of the volume Volume to read [M N P] or [M N P Q]        
%                     The volume is read slice by slice                                
%   Data_format   = Format of the data to read                                         
%   little_endian = 'little' or 'big' ;                                                
%   Offset        = Offset value in elements unit 
%                   if want to read only a selected part of the volume    
%=========================================================================================

%=========================================================================================
%  Initialize parameters
%=========================================================================================
Machine_type = [];
Offset       = 0;

%=========================================================================================
% Read in parameters
%=========================================================================================
if nargin>3
    n = length(varargin) ;
    for i=1:n
        if ischar(varargin{i})
            Machine_type = lower(varargin{i});
        else
            Offset   = varargin{i};
        end
    end
end
N_Dim = length(Dim);

%=========================================================================================
% Open file
%=========================================================================================
fid = fopen(Name_volume);
if fid<0
    error(['File  "' Name_volume '"  does not exist']);
end

%==============================================
% Change 0 to real value in Dim
%==============================================
if ~isempty(find(Dim == 0))
   fid    = fopen(Name_volume ,'rb');
   u      = find(Dim==0);
   Dim(u) = 1;
   fseek(fid,Offset,'bof');
   x      = fread(fid,Data_format);
   Dim(u) = length(x)/prod(Dim);
   fclose(fid);
end
Dim = round(Dim);

%==============================================
% Make Dim a Column vector
%==============================================
if Dim(1)==1 & length(Dim)==2
    Nber_elements_minus_one_dimension = Dim(2);
else
    Nber_elements_minus_one_dimension = prod(Dim(1:end-1));
end

%==============================================
% Get machine type
%==============================================
if isempty(Machine_type)
	MACHINE = 'native';
else
    switch(Machine_type)
        case {'little','l'}
            MACHINE = 'ieee-le';
        case {'big','b'}
            MACHINE = 'ieee-be';
    	otherwise	
            MACHINE = 'native';
    end
end

%==============================================
% Get number of bytes per element
%==============================================
Bytes_per_element = dataformat2bytes(Data_format);

%==============================================
% Open the file for reading
%==============================================
fid        = fopen(Name_volume ,'rb',MACHINE);

%==============================================
% Move pointer to specified offset
%==============================================
Offset_bytes = Offset *  Bytes_per_element;
if (fid>0)
    fseek(fid,Offset_bytes,'bof');
end

%==============================================
% Read the file
%==============================================
if (N_Dim==2)
   Volume = zeros(Dim);
   Volume = fread(fid,[Dim(1),Dim(2)],Data_format,MACHINE);
elseif (N_Dim==3)
    if strcmp(Data_format,'uint8')
        Volume(:,:,1) = uint8(zeros(Dim(1:2)));
        Volume        = repmat(Volume,[1 1 Dim(3)]);
    else
        Volume = zeros(Dim);
    end
 
    for p=1:Dim(3) 
       if strcmp(Data_format,'uint8')
           Volume(:,:,p) = uint8(fread(fid,[Dim(1),Dim(2)],Data_format,MACHINE));
       elseif strcmp(Data_format,'uint16')
           Volume(:,:,p) = uint16(fread(fid,[Dim(1),Dim(2)],Data_format,MACHINE));
       else
           Volume(:,:,p) = fread(fid,[Dim(1),Dim(2)],Data_format,MACHINE);
       end
   end
elseif (N_Dim==4)
	Volume = zeros(Dim);
	for q=1:Dim(4)
		for p=1:Dim(3)   
			Volume(:,:,p,q) = fread(fid,[Dim(1),Dim(2)],Data_format,MACHINE);
		end
	end
end

%==============================================
%    Change to uint8 if you can
%==============================================
if strcmp(Data_format,'uint8')
    Volume = uint8(Volume);
end
      
