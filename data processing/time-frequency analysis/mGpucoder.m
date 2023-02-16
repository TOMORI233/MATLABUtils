cfg = coder.gpuConfig('mex');
codegen cwtMulti -config cfg -args {coder.typeof(gpuArray(0),[5001 64]),coder.typeof(0),coder.typeof(0,[1 2])} -report