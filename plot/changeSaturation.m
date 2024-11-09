function rgb = changeSaturation(c, ratio)
rgb = validatecolor(c);
hsv = rgb2hsv(rgb);
hsv(2) = hsv(2) * ratio;
rgb = hsv2rgb(hsv);
return;
end