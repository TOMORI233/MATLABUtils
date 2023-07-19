# README

写在前面：1~5循规蹈矩，6~8未来可期，9尽力而为

#### 1. 注意事项

1. 初次使用，请clone项目地址：

​	`git clone git@github.com:TOMORI233/MATLABUtils.git`

2. 请在使用前确保更新到最新版本：

​	`git pull origin master`

3. 如果需要推送代码，请向作者发送Pull Request或者联系加入Collaborators@TOMORI233。
4. 尽量不要修改通用函数，想要创建自己的版本，请创建自己的工具箱包。
5. 添加函数请添加在对应功能类型命名的文件夹下。
6. 推荐使用matlab创建初始版本脚本/函数文件，使用vscode进行修改（尤其是注释添加）和GIT版本控制，这里推荐几个插件：
   - MATLAB
   - MATLAB Extension Pack（需要设置`mlint.exe`路径用于格式化代码）
   - GitLens
   - Git History
   - Git Graph
7. 不要上传任何数据。可以编辑`.gitignore`，加入自己可能会意外添加进项目中的数据文件及其路径。对于其他具体protocol的处理项目更是如此。

#### 2. 编码方式规范

​	请在vscode和matlab中统一将编码格式设置为`UTF-8`。`GBK`和`UTF-8`的转换会导致中文内容乱码，如果你不想改变编码方式，请使用全英文写注释。

#### 3. 编程命名规范

1. 函数名及变量命名请遵循camelCase，如`variableName1, myValue`，并且名字明确代表其功能。camelCase的第一个单词首字母可大写，后续单词首字母必须大写，推荐对类文件（classdef）命名时首字母大写。
2. 当命名中需要包含大写字母缩写，可以将其变为小写，如`new HTML File`→`newHtmlFile`，尽量避免使用下划线。
3. 对于index类型的临时变量命名，请明确它是什么的索引，尽量不要使用`i, j, ii`这样的命名方式，推荐如`timeIdx, chIdx`对象明确的命名。

#### 4. 缩进规范

1. vscode（无需选中，全局格式化，快捷键`shift+alt+F`）和matlab（需要选中内容，快捷键`ctrl+I`）在格式化文件时的缩进方式存在一定差异，包括

   - 函数缩进

   - 运算符与变量间隔

   - `if, for, while, switch, ...`-`end`与上下语句之间是否有空行

     ```matlab
     % original version
     function y=demoFcn(x1,x2)
     disp(   'demoFcn is called'  );
        if   x1> x2
       y=2*x1 +x2;
       else
             y=x1/x2;
           end
      return;
     end
     
     % formatter
     % vscode version
     function y = demoFcn(x1, x2)
         disp('demoFcn is called');
     
         if x1 > x2
             y = 2 * x1 +x2;
         else
             y = x1 / x2;
         end
     
         return;
     end
     
     
     % matlab version
     function y=demoFcn(x1,x2)
     disp(   'demoFcn is called'  );
     if   x1> x2
         y=2*x1 +x2;
     else
         y=x1/x2;
     end
     return;
     end
     ```

2. **推荐使用vscode进行代码的格式化**，但这很可能让你特意对齐的一些语句错位（如：不同长度的变量名通过在后面加空格使`=`对齐，使用alt+鼠标拖动可以选中多行同时编辑方便修改）

#### 5. 注释规范

1. 请一定要写注释，请一定要写注释，请一定要写注释！为了别人，更为了自己！

2. 函数注释要求：在function一行下紧接着写上注释

   - 在没有`functionSignatures.json`文件时，在matlab编辑器中函数的输入提示是根据你在开头注释中写的示例用法来的
   - 命令行执行`help xxxFcn`将显示开头的注释
   - 注释应该包括：示例用法、函数功能描述、输入参数说明、输出参数说明、实际例子
   - 示例：

   ```matlab
   function axisRange = scaleAxes(varargin)
       % scaleAxes(axisName)
       % scaleAxes(axisName, axisRange)
       % scaleAxes(axisName, axisRange, cutoffRange)
       % scaleAxes(axisName, axisRange, cutoffRange, symOpt)
       % scaleAxes(axisName, autoScale, cutoffRange, symOpt)
       % scaleAxes(..., namevalueOptions)
       % scaleAxes(FigsOrAxes, ...)
       % axisRange = scaleAxes(...)
       %
       % Description: apply the same scale settings to all subplots in figures
       % Input:
       %     FigsOrAxes: figure object array or axis object array (If omitted, default: gcf)
       %     axisName: axis name - "x", "y", "z" or "c"
       %     autoScale: "on" or "off"
       %     axisRange: axis limits, specified as a two-element vector. If
       %                given value -Inf or Inf, or left empty, the best range
       %                will be used.
       %     cutoffRange: if axisRange exceeds cutoffRange, axisRange will be
       %                  replaced by cutoffRange.
       %     symOpt: symmetrical option - "min" or "max"
       %     type: "line" or "hist" for y scaling (default="line")
       %     uiOpt: "show" or "hide", call a UI control for scaling (default="hide")
       % Output:
       %     axisRange: axis limits applied
   ```

   ```matlab
   function addLines2Axes(varargin)
       % Description: add lines to all subplots in figures
       % Input:
       %     FigsOrAxes: figure object array or axes object array (If omitted, default: gcf)
       %     lines: a struct array of [X], [Y], [color], [width], [style], [marker] and [legend]
       %            If [X] or [Y] is left empty, then best x/y range will be
       %            used.
       %            If [X] or [Y] contains 1 element, then the line will be
       %            vertical to x or y axis.
       %            If not specified, line color will be black.
       %            If not specified, line width will be 1.
       %            If not specified, line style will be dash line("--").
       %            If specified, marker option will replace line style option.
       %            If not specified, line legend will not be shown.
       % Example:
       %     % Example 1: Draw lines to mark stimuli oneset and offset at t=0, t=1000 ms
       %     scaleAxes(Fig, "y"); % apply the same ylim to all axes
       %     lines(1).X = 0;
       %     lines(2).X = 1000;
       %     addLines2Axes(Fig, lines);
       %
       %     % Example 2: Draw a dividing line y=x for ROC
       %     addLines2Axes(Fig);
   ```

#### 6. 自定义函数签名

1. 函数签名为键入函数名时对输入参数的提示内容，`functionSignatures.json`中可以自定义，参考[自定义代码建议和自动填充 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/releases/R2021a/matlab/matlab_prog/customize-code-suggestions-and-completions.html#mw_0251b2cc-b271-42bb-a21e-09bd3dcb9229)。如果不生效，可以使用`validateFunctionSignaturesJSON`函数对该文件进行正确性校验（初次创建该文件需要重启matlab才会生效）。

2. 这个功能常用于输入中存在可选输入与`name-value`输入，可以自己对可变输入`varargin`进行参数解析，也可以通过matlab自带的`inputParser`进行参数解析，参考[函数的输入解析器 - MATLAB - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/ref/inputparser.html)

3. 示例参考`mSubplot.m, rowFcn.m`及其目录下的`functionSignatures.json`

#### 7. 创建自己的工具箱

1. 参考[包命名空间 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/matlab_oop/scoping-classes-with-packages.html)
2. 简单概括：使用`+`开头的英文命名的文件夹下的包空间会被自动加入matlab路径（前提是父包需要在matlab路径中），一个包可以有多级的子包，如`+mutils/+plot2D/plot.m`，通过`mutils.plot2D.plot()`调用可以与built-in函数`plot`区分开来，因此可以通过这种方式创建自己的工具箱。
3. 包函数与类静态方法命名存在冲突时，包函数优先（请尽量不要有冲突命名）。

#### 8. 风格与习惯

以下为私货，但你总会有自己的风格、习惯和更好的实现方式。

1. 每个trial都有自己的一些参数信息，因此可以用`struct array`来存，习惯命名为`trialAll`，方便人读，也方便使用其中的一个或几个参数作为筛选条件。
2. 对于时间上连续的多通道数据，如LFP、EEG、ECoG，对齐到一个时间点并截取相同长度，使用`cell array`来存，`nTrial*1`的`cell`，每个`cell`包含`nChannel*nSample`的数据。
3. 对于时间上不连续的多cluster的spike数据，`nSpike*2`的结构，第1列为spike时间，第2列为cluster index，直接存放在`trialAll`每个trial的`spike`字段中。
4. 基于以上`cell, struct, matrix`的混合数据存储方式，本项目包含了许多针对结构转换的工具函数，详见`data structures`目录。
5. 行为/其他处理函数以`ProcessFcn`开头或结尾，如`protocol1ProcessFcn, protocol2ProcessFcn`，当一个subject有多个protocol时：

```matlab
for pIndex = 1:length(protocolNames)
    processFcn = processFcneval(strcat("@", protocolNames{i}, "ProcessFcn"));
    trialAll = processFcn(epocs, params);
end
```

6. 对于不同项目中不通用的工具函数存在命名冲突的情况，如EEGProcess和ECOGProcess都有`excludeTrials`但是逻辑不同，推荐修改方式：各自的`utils`文件夹下新建`+EEGProcess`和`+ECOGProcess`，将存在冲突的函数放在其中，以类似`EEGProcess.excludeTrials`的方式调用。
7. 尽量减少循环的使用，matlab的循环是单线程，当次数很多且不使用平行计算的条件下效率会很低。对于大部分循环执行单语句的情况，可以使用`cellfun, arrayfun, rowFcn`这类函数提高效率与代码简洁性，其中`rowFcn`基于`cellfun`且对所有可以被`mat2cell`分割的数据类型兼容。

#### 9. Update Log

请将每次更新内容**置顶**写在这里，标注日期、修改者和兼容性（Incompatible/Compatible），对每条修改请标注修改类型（Add/Modify/Delete/Debug）。若为Incompatible，请给出修改方案。

- 2023/07/18 by XHX - Compatible

  | Type | Target            | Content                                                      |
  | ---- | ----------------- | ------------------------------------------------------------ |
  | Add  | `validateInput.m` | 增加了一个UI输入框，可以通过`validateInput(..., "UI", "on")`开启，替代命令行的输入方式 |
  | Add  | `pathManager.m`   | 返回`ROOTPATH\subject\protocol\datetime\*.mat`数据存放方式的完整mat路径，可以指定subject和protocol，如`matPaths = pathManager(ROOTPATH, "subjects", ["DDZ", "DD"], "protocols", "Noise");` |
  | Add  | `README.md`       | 添加说明文档                                                 |


