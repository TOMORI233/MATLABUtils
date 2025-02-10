function cm = mColormap(head, tail)
% use white as middle
narginchk(0, 2);

if nargin < 1
    head = 'b';
end

if nargin < 2
    tail = 'r';
end

cHead = validatecolor(head);
cTail = validatecolor(tail);

hsv1 = rgb2hsv(cHead);
hsv2 = rgb2hsv([1, 1, 1]);
hsv3 = rgb2hsv(cTail);

S_head = linspace(hsv1(2), hsv2(2), 128)';
V_head = linspace(hsv1(3), hsv2(3), 128)';
S_tail = linspace(hsv2(2), hsv3(2), 128)';
V_tail = linspace(hsv2(3), hsv3(3), 128)';

H_head = repmat(hsv1(1), [128, 1]);
H_tail = repmat(hsv3(1), [128, 1]);

cm = [H_head, S_head, V_head; ...
      H_tail, S_tail, V_tail];
cm = hsv2rgb(cm);

return;
end