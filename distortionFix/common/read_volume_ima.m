function [Volume,Voxel_size] = read_volume_ima(Filename);
%=====================================================
% USAGE
%   [Volume,Voxel_size] = read_volume_ima(Filename);
% PARAMETERS
%   Filename  = Name of file for:
%                - the data file      "Filename.ima"  
%                - the dimension file "Filename.dim" 
% The header file looks like:
%  512 512 328 1
%  -type S16
%  -dx 0.410156 -dy 0.410156 -dz 1 -dt 1
%  -bo DCBA
%  -om binar
%=====================================================

ind = strfind(Filename,'.ima');
if isempty(ind)
	Filename_ima = [Filename '.ima'];
	Filename_dim = [Filename '.dim'];
else
	Filename_ima = [Filename ];
	Filename_dim = [Filename(1:ind) 'dim'];
end

%=====================================================
% READ: Data size 
%=====================================================

fid              = fopen(Filename_dim);
if fid<0
	error(['!!!!! cannot read file '  Filename_dim '  !!!!!!!!!!!']);
	return;
end
	
Text             = fgetl(fid);
Dim              = str2num(Text);

%=====================================================
% READ: Data type 
%=====================================================
Text             = fgetl(fid);
ind              = find(Text=='e');
Data_type        = Text(ind+1:end);
Test             = isspace(Data_type);
ind              = find(~Test);
Data_type        = Data_type(ind);

%=====================================================
% CHANGE: string of data type
%=====================================================
switch(Data_type)
	case 'S16'
        	Data_format = 'int16';
	case 'U16'
        	Data_format = 'uint16';
	case 'U8'
        	Data_format = 'uint8';
		case 'FLOAT'
        	Data_format = 'float32';

	otherwise
		error(['!!!!!!!!!! Data_type ' Data_type 'unknown  !!!!!!!!!']);
end

%=====================================================
% READ: Voxel size 
%=====================================================
Voxel_dim = ['x';'y'; 'z';'t'];
iter = 1;
while (iter<4)
    Text      = fgetl(fid);
    Ind       = find(Text=='-');
    if length(Ind)>1
        for ind=1:length(Ind)-1
            Voxel_size(iter)  = str2num(Text(Ind(ind)+3:Ind(ind+1)-1));
            iter = iter+1;
        end
        Voxel_size(iter)  = str2num(Text(Ind(end)+3:end));
        iter = iter+1;
    else
        Voxel_size(iter)  = str2num(Text(Ind+3:end));
        iter = iter+1;
    end
end

%=====================================================
% CLOSE header file
%=====================================================
fclose(fid);

%=====================================================
% Read volume
%=====================================================
Volume = read_volume(Filename_ima,Dim,Data_format);


