function se = makeSE(type,size)

% makeSE(type,size)
% create a structuring element of "radius" size and shape defined by type

switch type
case 'diamond'
    temp = tril(ones(size-1));
    se = [ fliplr(temp), temp ; rot90(temp,2),flipud(temp)];
    se = [zeros(2*size-2,1),se,zeros(2*size-2,1)];
    se = [zeros(1,2*size);se;zeros(1,2*size)];
    se = [se(1:size,:);ones(1,2*size);se(size+1:2*size,:)];
    se = [se(:,1:size),ones(2*size+1,1),se(:,size+1:2*size)];

case 'square'
    se = ones((2 * size + 1),(2 * size + 1));

case 'disk'
    support = 2*size+1;
    se = zeros((support),(support));
    for i=1:support
      for j=1:support
        r2 = (i-size-1)*(i-size-1) + (j-size-1)*(j-size-1);
        if r2<(size*size+1) 
          se(i,j)=1;
        end
      end
    end

otherwise
   return
end

se=uint8(se);
