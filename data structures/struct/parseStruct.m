function varargout = parseStruct(S, varargin)
    % Description: Parse struct vector S
    % Input:
    %     S: struct vector or scalar
    %     sIndex: index of S to parse (only S(sIndex) will be parsed)
    %             If not specified, sIndex=1:length(S).
    %             If numel(sIndex)>1, return vars in column vector.
    %     fieldNames: fieldnames of S to parse (default: parse all)
    % Output:
    %     varNames: variable names to receive S.(fieldNames)
    % Notice:
    %     An error occurs if not all values of S(sIdx).(f) are of the same class
    %     because vertcat(S(sIdx).(f)) does not work.
    % Example:
    %     A(1).a1=1;
    %     A(1).a2=2;
    %     A(1).a3=3;
    %     A(2).a1=11;
    %     A(2).a2=12;
    %     A(2).a3=13;
    %
    %     [varName1, varName2, ...] = parseStruct(S, sIndex, fieldName1, fieldName2, ...)
    %     [varName1, varName2, ...] = parseStruct(S, fieldName1, fieldName2, ...)
    %     parseStruct(A, 1, "a1") returns a1=1 in workspace
    %     parseStruct(A, 2, "a1") returns a1=11 in workspace
    %     parseStruct(A, "a1") returns a1=[1;11] in workspace
    %     parseStruct(A) returns a1=[1;11] a2=[2;12] a3=[3;13] in workspace
    %     b1=parseStruct(A, "a1") returns b1=[1;11] in workspace (same as b1=vertcat(A.a1))

    if nargin > 1

        if isnumeric(varargin{1}) && isvector(varargin{1})
            sIndex = varargin{1};
            varargin = varargin(2:end);
        else
            sIndex = 1:length(S);

            if ~all(cellfun(@(x) isstring(x) || ischar(x), varargin))
                error("Invalid variable name input");
            end

        end

    else
        sIndex = 1:length(S);
    end

    if ~isempty(varargin) && nargout > 0 && nargout ~= length(varargin)
        error("The number of output does not match the number of input field names");
    end

    if isempty(varargin)
        sField = fieldnames(S);

        for fIndex = 1:length(sField)
            % add local var to base workspace
            eval(['assignin(''caller'', ''', sField{fIndex}, ''', vertcat(S(sIndex).', sField{fIndex}, '));']);
        end
    
    else
        
        if nargout == 0

            for fIndex = 1:length(varargin)
                % add local var to base workspace
                eval(['assignin(''caller'', ''', char(varargin{fIndex}), ''', vertcat(S(sIndex).', char(varargin{fIndex}), '));']);
            end

        else

            for fIndex = 1:nargout
                varargout{fIndex} = vertcat(S(sIndex).(varargin{fIndex}));
            end

        end
        
    end

    return;
end