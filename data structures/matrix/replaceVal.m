function x = replaceVal(x, val, val0)
narginchk(2, 3);

if nargin < 3
    val0 = [];
end
    
if isequal(x, val0)
    x = val;
end
