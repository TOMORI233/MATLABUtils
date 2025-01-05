function res = mMapminmax(data, ymax)
% Map data to [-ymax, ymax] with zero point unshifted.
% This conversion is linear.
% 
% e.g.
%     data = [-2, -1, 0, 1, 2, 3, 4];
%     res = mMapminmax(data, 1)
% >> res = [-0.5, -0.25, 0, 0.25, 0.5, 0.75, 1]

narginchk(1, 2);

if nargin < 2
    ymax = 1;
end

res = data / max(abs(data), [], "all") * ymax;