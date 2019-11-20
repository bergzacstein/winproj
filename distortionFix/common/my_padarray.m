function Volume_padded = my_padarray(Volume, Pad_size,Pad_method,Pad_direction)
%==========================================================================
%  USAGE
%     Volume_padded = my_padarray(Volume, Pad_size,Pad_method,Pad_direction) 
% PARAMETERS
%    Volume     = Volume to padd.
%    Pad_size   = [Nline Ncol]
%    Pad_method =    'circular'    Pads with circular repetion of elements.
%               =    'replicate'   Repeats border elements of A.
%               =    'symmetric'   Pads array with mirror reflections of itself. 
%    Pad_direction  = 'pre'         Pads before the first array element along each dimension .
%                     'post'        Pads after the last array element along each dimension. 
%                     'both'        Pads with 'pre' and 'post'.
%==========================================================================




%==========================================================================
%==========================================================================
if isempty(Volume),% treat empty matrix similar for any Pad_method

   if strcmp(Pad_direction,'both')
      sizeB = size(Volume) + 2*Pad_size;
   else
      sizeB = size(Volume) + Pad_size;
   end

   Volume_padded = mkconstarray(class(Volume), Pad_value, sizeB);
   
else
  switch Pad_method
    case 'constant'
        Volume_padded = ConstantPad(Volume, Pad_size, Pad_value, Pad_direction);
        
    case 'circular'
        Volume_padded = CircularPad(Volume, Pad_size, Pad_direction);
  
    case 'symmetric'
        Volume_padded = SymmetricPad(Volume, Pad_size, Pad_direction);
        
    case 'replicate'
        Volume_padded = ReplicatePad(Volume, Pad_size, Pad_direction);
  end      
end

if (islogical(Volume))
    Volume_padded = logical(Volume_padded);
end

%==========================================================================
%%% ConstantPad
%==========================================================================
function Volume_padded = ConstantPad(Volume, Pad_size, Pad_value, Pad_direction)

numDims = prod(size(Pad_size));

% Form index vectors to subsasgn input array into output array.
% Also compute the size of the output array.
idx   = cell(1,numDims);
sizeB = zeros(1,numDims);
for k = 1:numDims
    M = size(Volume,k);
    switch Pad_direction
        case 'pre'
            idx{k}   = (1:M) + Pad_size(k);
            sizeB(k) = M + Pad_size(k);
            
        case 'post'
            idx{k}   = 1:M;
            sizeB(k) = M + Pad_size(k);
            
        case 'both'
            idx{k}   = (1:M) + Pad_size(k);
            sizeB(k) = M + 2*Pad_size(k);
    end
end

%==========================================================================
% Initialize output array with the padding value.  Make sure the
% output array is the same type as the input.
%==========================================================================
Volume_padded         = mkconstarray(class(Volume), Pad_value, sizeB);
Volume_padded(idx{:}) = Volume;


%==========================================================================
%==========================================================================
%%% CircularPad
%==========================================================================
%==========================================================================
function Volume_padded = CircularPad(Volume, Pad_size, Pad_direction)

numDims = prod(size(Pad_size));

% Form index vectors to subsasgn input array into output array.
% Also compute the size of the output array.
idx   = cell(1,numDims);
for k = 1:numDims
  M = size(Volume,k);
  dimNums = [1:M];
  p = Pad_size(k);
    
  switch Pad_direction
    case 'pre'
       idx{k}   = dimNums(mod([-p:M-1], M) + 1);
    
    case 'post'
      idx{k}   = dimNums(mod([0:M+p-1], M) + 1);
    
    case 'both'
      idx{k}   = dimNums(mod([-p:M+p-1], M) + 1);
  
  end
end
Volume_padded = Volume(idx{:});

%==========================================================================
%==========================================================================
%%% SymmetricPad
%==========================================================================
%==========================================================================
function Volume_padded = SymmetricPad(Volume, Pad_size, Pad_direction)

numDims = prod(size(Pad_size));

% Form index vectors to subsasgn input array into output array.
% Also compute the size of the output array.
idx   = cell(1,numDims);
for k = 1:numDims
  M = size(Volume,k);
  dimNums = [1:M M:-1:1];
  p = Pad_size(k);
    
  switch Pad_direction
    case 'pre'
      idx{k}   = dimNums(mod([-p:M-1], 2*M) + 1);
            
    case 'post'
      idx{k}   = dimNums(mod([0:M+p-1], 2*M) + 1);
            
    case 'both'
      idx{k}   = dimNums(mod([-p:M+p-1], 2*M) + 1);
  end
end
Volume_padded = Volume(idx{:});

%==========================================================================
%==========================================================================
%%% ReplicatePad
%==========================================================================
%==========================================================================
function Volume_padded = ReplicatePad(Volume, Pad_size, Pad_direction)

numDims = prod(size(Pad_size));

% Form index vectors to subsasgn input array into output array.
% Also compute the size of the output array.
idx   = cell(1,numDims);
for k = 1:numDims
  M = size(Volume,k);
  p = Pad_size(k);
  onesVector = ones(1,p);
    
  switch Pad_direction
    case 'pre'
      idx{k}   = [onesVector 1:M];
            
    case 'post'
      idx{k}   = [1:M M*onesVector];
            
    case 'both'
      idx{k}   = [onesVector 1:M M*onesVector];
  end
end
 Volume_padded = Volume(idx{:});

%==========================================================================
%==========================================================================
%%% ParseInputs
%==========================================================================
%==========================================================================
function [Volume, Pad_method, Pad_size, Pad_value, Pad_direction] = ParseInputs(varargin)

% default values
Volume         = [];
Pad_method    = 'constant';
Pad_size   = [];
Pad_value    = 0;
Pad_direction = 'both';

checknargin(2,4,nargin,mfilename);

Volume = varargin{1};

Pad_size = varargin{2};
checkinput(Pad_size, {'double'}, {'real' 'vector' 'nonnan' 'nonnegative' ...
                    'integer'}, mfilename, 'PADSIZE', 2);

%==========================================================================
% Preprocess the padding size
%==========================================================================
if (prod(size(Pad_size)) < ndims(Volume))
    Pad_size           = Pad_size(:);
    Pad_size(ndims(Volume)) = 0;
end

if nargin > 2

    firstStringToProcess = 3;
    
    if ~ischar(varargin{3})
        % Third input must be pad value.
        Pad_value = varargin{3};
        checkinput(Pad_value, {'numeric' 'logical'}, {'scalar'}, ...
                   mfilename, 'PADVAL', 3);
        
        firstStringToProcess = 4;
        
    end
    
    for k = firstStringToProcess:nargin
        validStrings = {'circular' 'replicate' 'symmetric' 'pre' ...
                        'post' 'both'};
        string = checkstrs(varargin{k}, validStrings, mfilename, ...
                           'METHOD or DIRECTION', k);
        switch string
         case {'circular' 'replicate' 'symmetric'}
          Pad_method = string;
          
         case {'pre' 'post' 'both'}
          Pad_direction = string;
          
         otherwise
          error('Images:padarray:unexpectedError', '%s', ...
                'Unexpected logic error.')
        end
    end
end
    
%==========================================================================
% Check the input array type
%==========================================================================
if strcmp(Pad_method,'constant') & ~(isnumeric(Volume) | islogical(Volume))
    id = sprintf('Images:%s:badTypeForConstantPadding', mfilename);
    msg1 = sprintf('Function %s expected A (argument 1)',mfilename);
    msg2 = 'to be numeric or logical for constant padding.';
    error(id,'%s\n%s',msg1,msg2);
end
