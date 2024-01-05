classdef demoClass < handle
    properties (SetObservable, GetObservable)
        val = 1
    end

    events
        mEvt
    end
    
    methods (Access = public)
        function obj = setListener(obj)
            addlistener(obj, "val", "PreSet", @obj.handleValPreSet);
            addlistener(obj, "val", "PostSet", @obj.handleValPostSet);
            addlistener(obj, "val", "PreGet", @obj.handleValPreGet);
            addlistener(obj, "val", "PostGet", @obj.handleValPostGet);
            addlistener(obj, "mEvt", @obj.mEvtHandle);
        end

        function handleValPreSet(obj, src, evt)
            disp('PreSet');
        end

        function handleValPostSet(obj, src, evt)
            disp('PostSet');
            notify(obj, "mEvt");
        end

        function handleValPreGet(obj, src, evt)
            disp('PreGet');
        end

        function handleValPostGet(obj, src, evt)
            disp('PostGet');
        end

        function mEvtHandle(obj, src, evt)
            disp('mEvt handle');
        end
    end
end