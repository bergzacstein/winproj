function Nber_bytes = dataformat2bytes(Data_format)
%=====================================================================
%USAGE
% Nber_bytes = dataformat2bytes(Data_format)
%     if strcmp(Data_format,'double')|strcmp(Data_format,'uint32')
%         Nber_bytes = 4;
%     elseif strcmp(Data_format,'uint8')|strcmp(Data_format,'char')
%          Nber_bytes = 1;
%      elseif strcmp(Data_format,'uint16')
%          Nber_bytes = 2;
%     end  
%=====================================================================
switch(Data_format)    
    case('double')
        Nber_bytes = 8;
    case{'uint32','int32'}
        Nber_bytes = 4;
    case{'uint8','char','int8'}
        Nber_bytes = 1;
    case{'uint16','int16'}
        Nber_bytes = 2;
    case{'float32','float'}
        Nber_bytes = 4;
end