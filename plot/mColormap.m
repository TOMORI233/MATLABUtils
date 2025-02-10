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

[h1, s1, v1] = rgb2hsv(cHead);
[~, s2, v2] = rgb2hsv([1, 1, 1]);
[h3, s3, v3] = rgb2hsv(cTail);

S_head = linspace(s1, s2, 128)';
V_head = linspace(v1, v2, 128)';
S_tail = linspace(s2, s3, 128)';
V_tail = linspace(v2, v3, 128)';

H_head = repmat(h1, [128, 1]);
H_tail = repmat(h3, [128, 1]);

cm = [H_head, S_head, V_head; ...
      H_tail, S_tail, V_tail];
cm = hsv2rgb(cm);

return;
end