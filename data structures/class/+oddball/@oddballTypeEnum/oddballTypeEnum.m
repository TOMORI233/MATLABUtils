classdef oddballTypeEnum
    enumeration
        STD, DEV, INTERRUPT
    end
    
    methods
        function res = String(obj)
            res = string(obj);
        end
    end
end