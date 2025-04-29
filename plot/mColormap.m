function cm = mColormap(head, tail, n)
% use white as middle
narginchk(0, 3);

if nargin < 1
    head = 'b';
end

if nargin < 2
    tail = 'r';
end

if nargin < 3
    n = 1 / 2;
end

cHead = validatecolor(head);
cTail = validatecolor(tail);

hsv1 = rgb2hsv(cHead);
hsv2 = rgb2hsv([1, 1, 1]);
hsv3 = rgb2hsv(cTail);

x = linspace(0, 1, 128)';
S_head = (hsv2(2) - hsv1(2)) * x .^ n + hsv1(2);
V_head = (hsv2(3) - hsv1(3)) * x .^ n + hsv1(3);

S_tail = flip((hsv2(2) - hsv3(2)) * x .^ n + hsv3(2));
V_tail = flip((hsv2(3) - hsv3(3)) * x .^ n + hsv3(3));

H_head = repmat(hsv1(1), [128, 1]);
H_tail = repmat(hsv3(1), [128, 1]);

cm = [H_head, S_head, V_head; ...
      H_tail, S_tail, V_tail];
cm = hsv2rgb(cm);

return;
end