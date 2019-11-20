function [x,y] = my_getpts(varargin)
%===================================================================================================
% USAGE
%   [x,y] = my_getpts(h)  
% PARAMETERS
%   h      = [Figure handle] or Axes handle or nothing for current figure
%  [x,y]   = point coordinates
%===================================================================================================

global GETPTS_FIG GETPTS_AX GETPTS_H1 GETPTS_H2
global GETPTS_PT1 
%===================================================================================================
% Callback invocation: 'KeyPress', 'FirstButtonDown', or  'NextButtonDown'.
%===================================================================================================
if ((nargin >= 1) & (isstr(varargin{1})))
    feval(varargin{:});
    return;
end

if (nargin < 1)
    GETPTS_AX  = gca;
    GETPTS_FIG = get(GETPTS_AX, 'Parent');
else
    if (~ishandle(varargin{1}))
        error('First argument is not a valid handle');
    end
    
    switch get(varargin{1}, 'Type')
    case 'figure'
        GETPTS_FIG = varargin{1};
        GETPTS_AX = get(GETPTS_FIG, 'CurrentAxes');
        if (isempty(GETPTS_AX))
            GETPTS_AX = axes('Parent', GETPTS_FIG);
        end

    case 'axes'
        GETPTS_AX = varargin{1};
        GETPTS_FIG = get(GETPTS_AX, 'Parent');

    otherwise
        error('First argument should be a figure or axes handle');

    end
end

%===================================================================================================
% Bring target figure forward
%===================================================================================================
figure(GETPTS_FIG);

%===================================================================================================
% Remember initial figure state
%===================================================================================================
state = uisuspend(GETPTS_FIG);

%===================================================================================================
% Set up initial callbacks for initial stage
%===================================================================================================
[pointerShape, pointerHotSpot] = CreatePointer;
set(GETPTS_FIG, 'WindowButtonDownFcn', 'my_getpts(''FirstButtonDown'');', ...
        'KeyPressFcn', 'my_getpts(''KeyPress'');', ...
        'Pointer', 'custom', ...
        'PointerShapeCData', pointerShape, ...
        'PointerShapeHotSpot', pointerHotSpot);

%===================================================================================================
% Initialize the lines to be used for the drag
%===================================================================================================
markerSize = 9;
GETPTS_H1 = line('Parent', GETPTS_AX, ...
                  'XData', [], ...
                  'YData', [], ...
                  'Visible', 'off', ...
                  'Clipping', 'off', ...
                  'Color', [1 0 0], ...
                  'LineStyle', 'none', ...
                  'Marker', '+', ...
                  'MarkerSize', markerSize, ...
                  'MarkerEdgeColor' , [1 0 0],...
                  'EraseMode', 'xor');

GETPTS_H2 = line('Parent', GETPTS_AX, ...
                  'XData', [], ...
                  'YData', [], ...
                  'Visible', 'on', ...
                  'Clipping', 'off', ...
                  'Color', [1 0 0], ...
                  'LineStyle', '-', ...
                  'LineWidth' , [2],...
                  'Marker', 'x', ...
                  'MarkerSize', markerSize, ...
                  'MarkerEdgeColor' , [1 0 0],...
                  'EraseMode', 'background');
%===================================================================================================
%===================================================================================================



%===================================================================================================
% Wait for the user to do the drag
% Wrap the call to waitfor in try-catch 
%===================================================================================================
errCatch = 0;
try
   waitfor(GETPTS_H1, 'UserData', 'Completed');
catch
   errCatch=1;
end

%===================================================================================================
% After the waitfor, if GETPTS_H1 is still valid:
% UserData is 'Completed' => the user completed the drag.  
% If not                  => the user interrupted the action somehow, perhaps by a Ctrl-C in the
%                            command window or by closing the figure.
%===================================================================================================

if (errCatch == 1)
    errStatus = 'trap';
    
elseif (~ishandle(GETPTS_H1) | ~strcmp(get(GETPTS_H1, 'UserData'), 'Completed'))
    errStatus = 'unknown';
 else
    errStatus = 'ok';
    x = get(GETPTS_H1, 'XData');
    y = get(GETPTS_H1, 'YData');
    x = x(:);
    y = y(:);
    %===================================================================================================
    % If no points were selected, return rectangular empties.
    % This makes it easier to handle degenerate cases in
    % functions that call getpts.
    %===================================================================================================
    if (isempty(x))
        x = zeros(0,1);
    end
    if (isempty(y))
        y = zeros(0,1);
    end
end

%===================================================================================================
% Delete the animation objects
%===================================================================================================
if (ishandle(GETPTS_H1))
    delete(GETPTS_H1);
end
if (ishandle(GETPTS_H2))
    delete(GETPTS_H2);
end

%===================================================================================================
% Restore the figure state
%===================================================================================================
if (ishandle(GETPTS_FIG))
    uirestore(state);
end

%===================================================================================================
% Clean up the global workspace
%===================================================================================================
clear global GETPTS_FIG GETPTS_AX GETPTS_H1 GETPTS_H2
clear global GETPTS_PT1 

%===================================================================================================
% Depending on the error status, return the answer or generate
% an error message.
%===================================================================================================
switch errStatus
case 'ok'
    % No action needed.
    
case 'trap'
    % An error was trapped during the waitfor
    error('Interruption during mouse point selection.');
    
case 'unknown'
    % User did something to cause the point selection to
    % terminate abnormally.  For example, we would get here
    % if the user closed the figure in the middle of the selection.
    error('Interruption during mouse point selection.');
end
%=================================================
% If only one output
%=================================================
if nargout==1
	x = [x y];
end

%===================================================================================================
%--------------------------------------------------------------------------------------------------------
%                                            Subfunction KeyPress
%--------------------------------------------------------------------------------------------------------
%===================================================================================================
function KeyPress

global GETPTS_FIG GETPTS_AX GETPTS_H1 GETPTS_H2
global GETPTS_PT1 

key = real(get(GETPTS_FIG, 'CurrentCharacter'));
switch key
   %=====================================================================
   % Delete and backspace keys
   %=====================================================================
case {8, 127}  
   x = get(GETPTS_H1, 'XData');
   y = get(GETPTS_H1, 'YData');
   switch length(x)
      %=====================================================================
      % Nothing to do
      %=====================================================================
   case 0
      %=====================================================================
      % remove point and start over
      %=====================================================================
   case 1
      set([GETPTS_H1 GETPTS_H2], ...
         'XData', [], ...
         'YData', []);
      set(GETPTS_FIG, 'WindowButtonDownFcn', ...
         'my_getpts(''FirstButtonDown'');');
      %=====================================================================
      % remove last point
      %=====================================================================
   otherwise
      set([GETPTS_H1 GETPTS_H2], ...
         'XData', x(1:end-1), ...
         'YData', y(1:end-1));
   end
   
%=====================================================================
% Enter and Return keys
% return control to line after waitfor
%=====================================================================
case {13,3}   
    set(GETPTS_H1, 'UserData', 'Completed');
end

%===================================================================================================
%---------------------------------------------------------------------------------------------
%                                     Subfunction FirstButtonDown
%---------------------------------------------------------------------------------------------
%===================================================================================================
function FirstButtonDown

global GETPTS_FIG GETPTS_AX GETPTS_H1 GETPTS_H2

[x,y] = my_getcurpt(GETPTS_AX);

set([GETPTS_H1 GETPTS_H2], ...
        'XData', x, ...
        'YData', y, ...
        'Visible', 'on');

%=================================================
% If right mouse click, end the program
%=================================================
%if (~strcmp(get(GETPTS_FIG, 'SelectionType'), 'normal'))
%    % We're done!
%    set(GETPTS_H1, 'UserData', 'Completed');
%else
    set(GETPTS_FIG, 'WindowButtonDownFcn', 'my_getpts(''NextButtonDown'');');
%end

%===================================================================================================
%---------------------------------------------------------------------------------------------
%                                      Subfunction NextButtonDown
%----------------------------------------------------------------------------------------------
%===================================================================================================
function NextButtonDown

global GETPTS_FIG GETPTS_AX GETPTS_H1 GETPTS_H2

selectionType = get(GETPTS_FIG, 'SelectionType');

%=================================================
% We don't want to add a point on the second click
% of a double-click
%=================================================
if (~strcmp(selectionType, 'open'))
    [newx, newy] = my_getcurpt(GETPTS_AX);
    x = get(GETPTS_H1, 'XData');
    y = get(GETPTS_H2, 'YData');
    set([GETPTS_H1 GETPTS_H2], 'XData', [x newx], ...
            'YData', [y newy]);
end

%=================================================
% If right mouse click, end the program
%=================================================
if (~strcmp(get(GETPTS_FIG, 'SelectionType'), 'normal'))
    set(GETPTS_H1, 'UserData', 'Completed');
end


%===================================================================================================
%------------------------------------------------------------------------------------------------
%                                          Subfunction CreatePointer
%-------------------------------------------------------------------------------------------------
%===================================================================================================
function [pointerShape, pointerHotSpot] = CreatePointer

pointerHotSpot = [8 8];
pointerShape = [ ...
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
              1   1   1   1   1   1   2 NaN   2   1   1   1   1   1   1   1
              2   2   2   2   2   2   2 NaN   2   2   2   2   2   2   2   2
            NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
              2   2   2   2   2   2   2 NaN   2   2   2   2   2   2   2   2
              1   1   1   1   1   1   2 NaN   2   1   1   1   1   1   1   1
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];

        
