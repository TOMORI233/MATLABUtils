function alphaAxes(FigOrAxes, alphaValue, childType)
% Description: apply the same alpha settings to all subplots in one figure
% Input:
%     FigOrAxes: figure object or target axes object array
%     childType: 'image','line','patch'
%     alphaValue:

narginchk(2,3)
if nargin < 3
    childType = {'image','line','patch'};
end

if ~iscell(childType)
    childType = {childType};
end

for i = 1 : length(childType)
    switch childType{i}
        case 'image'
            alphaName{i} = 'AlphaData';
        case 'line'
            alphaName{i} = 'Color';
        case 'patch'
            alphaName{i} = 'FaceAlpha';
    end
end

if strcmp(class(FigOrAxes), "matlab.ui.Figure")
    allAxes = findobj(FigOrAxes, "Type", "axes");
else
    allAxes = FigOrAxes;
end

for aIndex = 1:length(allAxes)
    for i = 1 : length(alphaName)
        for n = 1 : length(allAxes(aIndex).Children)
            try
                
                allAxes(aIndex).Children(n).(alphaName{i});

                if strcmp(alphaName{i},'Color')
                    allAxes(aIndex).Children(n).(alphaName{i})(4) = alphaValue;

                else
                    allAxes(aIndex).Children(n).(alphaName{i}) = alphaValue;

                end
              
            catch
 
            end
        end
    end
    drawnow
end

