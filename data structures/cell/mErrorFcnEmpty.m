function varargout = mErrorFcnEmpty(S, varargin)
    for index = 1:nargout
        varargout{index} = [];
    end
end