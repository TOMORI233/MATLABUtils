% Notice: DO NOT set Fieldtrip path to the BEGINNING
%         before you use gpucoder here, because there
%         are overwritten matlab-built-in files in Fieldtrip!
cfg = coder.gpuConfig('mex');
codegen cwtMulti -config cfg -args {coder.typeof(gpuArray(0),[4001 64]),coder.typeof(0),coder.typeof(0,[1 2])}