function varargout = obtainArgoutN(fcn, Ns, varargin) %#ok<*STOUT,*INUSL> 
    % Description: return the [fcn] output value of specified ordinal number.
    %              You can use it in arrayfun, cellfun, rowFcn.
    % Input:
    %     fcn: function handle
    %     Ns: a double vector that specifies which argouts of fcn to return
    %     varargin: args for fcn
    % Output:
    %     varargout: [fcn] output value of specified ordinal number [Ns]
    % Example:
    %     [res1, res2] = obtainArgoutN(@size, [2, 3], ones(10, 20, 30))
    %     >> res1 = 20
    %     >> res2 = 30
    %     ext = obtainArgoutN(@fileparts, 3, 'D:\Education\Test.wav')
    %     >> ext = '.wave'

    nout = numel(Ns);
    str = repmat("~", [1, max(Ns)]);

    for idx = 1:nout
        str(Ns(idx)) = strcat("varargout{", num2str(idx), "}");
    end

    str = strcat("[,", join(str, ","), "]=fcn(varargin{:});");
    eval(str);

    return;
end