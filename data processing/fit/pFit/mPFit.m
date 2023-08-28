function fitRes = mPFit(data, varargin)
% Description: do sigmoid fitting via psigfit toolbox
% Input:
%     data: n*2 | n*3 matrix, the first column is x, the second column is
%           correct ratio(when 2 columns) | correct counts (when 3 columns with
%           column 3 being the total counts corresponding to a certain x).
%     xFit: The custom x'. Default: 1000 points with linspace in the range of [min(data, max(data)]
%     sigmoidName: This sets the type of sigmoid you fit to your data.
%     expType: This sets which parameters you want to be free and which you fix and to
%              which values, for standard experiment types.
%     expN: The number of alternatives when "expType" is set to "nAFC".
%     threshPC: Which percent correct correspond to the threshold?
%     useGPU : Decide use GPU or not
%     plotFitRes: A boolean to control whether you immediately have a view
%                 of fit result

% Output:
%     fitRes: struct
%       -xFit:
%       -yFit:
%       -pFitRes:
%       -data:
% example:mPFit(data, "expType", "YesNo", "plotFitRes", 0, "sigmoidName", 'gaussint', "xFit", linspace(x1,x2, 1000));

mIp = inputParser;
mIp.addRequired("data", @(x) ismatrix(x) & ismember(size(x, 2), [2, 3]));
mIp.addParameter("xFit", linspace(data(1, 1), data(end, 1), 1000), @isnumeric);
mIp.addParameter("sigmoidName", "norm", @(x) any(validatestring(x, {'norm', 'gauss', 'gaussint', 'logistic', 'logn', 'weibull', 'gumbel', 'rgumbel', 'tdist'})));
mIp.addParameter("expType", "YesNo", @(x) any(validatestring(x, {'YesNo', '2AFC', 'nAFC'})));
mIp.addParameter("expN", 3, @(x) x>=3);
mIp.addParameter("threshPC", 0.5, @(x) x>0 & x < 1);
mIp.addParameter("useGPU", 0, @(x) ismember(x, [0, 1]));
mIp.addParameter("plotFitRes", 0, @(x) ismember(x, [0, 1]));


mIp.parse(data, varargin{:});
xFit = mIp.Results.xFit;
opts.sigmoidName = char(mIp.Results.sigmoidName);
opts.expType = char(mIp.Results.expType);
opts.expN = mIp.Results.expN;
opts.threshPC = mIp.Results.threshPC;
opts.useGPU = mIp.Results.useGPU;
plotFitRes = mIp.Results.plotFitRes;

if size(data, 2) == 1
    error("Invalid input 'data' !");
elseif size(data, 2) == 2
    if any(data(:, 2) > 1 | data(:, 2) < 0)
        error("Invalid input 'data' !");
    else
        data(:, 3) = 1000;
        data(:, 2) = fix(data(:, 2) * 1000);
    end
end

result = psignifit(data,opts);
yFit = result.psiHandle(xFit);

if plotFitRes
    plotPsych(result);
end

yFitChk = result.psiHandle(data(:, 1));
yRaw = data(:, 2)./data(:, 3);

fitRes.R2 = rsquare(yRaw, yFitChk);
fitRes.xFit = xFit;
fitRes.yFit = yFit;
fitRes.result = structSelect(result, ["Fit", "options"]);

fitRes.data = data;
fitRes.opts = opts;

