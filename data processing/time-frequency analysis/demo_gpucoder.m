% Notice: DO NOT set Fieldtrip path to the BEGINNING
%         before you use gpucoder here, because there
%         are overwritten matlab-built-in files in Fieldtrip!
ccc;
ft_removePath;
cfg = coder.gpuConfig('mex');
codegen cwtMultiAll -config cfg -args {coder.typeof(gpuArray(0),[651 65]),coder.typeof(0)}