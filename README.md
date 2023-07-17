# README

#### 注意事项

1. 初次使用，请clone项目地址

​	`git clone git@github.com:TOMORI233/MATLABUtils.git`

2. 请在使用前确保更新到最新版本：

​	`git pull origin master`

3. 如果需要推送代码，请向作者发送Pull Request或者联系加入Collaborators。
4. 尽量不要修改通用函数，想要创建自己的版本，请创建自己的工具箱包。
5. 添加函数请添加在对应功能类型命名的文件夹下。
6. 推荐使用matlab创建初始版本脚本/函数文件，使用vscode进行修改（尤其是注释添加）和GIT版本控制，这里推荐几个插件：
   - MATLAB
   - MATLAB Extension Pack
   - GitLens
   - Git History
   - Git Graph

#### 编码方式规范

​	请在vscode和matlab中统一将编码格式设置为`UTF-8`。

#### 编程命名规范

1. 函数名及变量命名请遵循camelCase，如`variableName1, myValue`，并且名字明确代表其功能。camelCase的第一个单词首字母可大写，后续单词首字母必须大写，推荐对类文件（classdef）命名时首字母大写。
2. 当命名中需要包含大写字母缩写，可以将其变为小写，如`new HTML File`→`newHtmlFile`，尽量避免使用下划线。
3. 对于index类型的临时变量命名，请明确它是什么的索引，尽量不要使用`i, j, ii`这样的命名方式，推荐如`timeIdx, chIdx`对象明确的命名。

#### 缩进规范

1. vscode（无需选中，全局格式化，快捷键shift+alt+F）和matlab（需要选中内容，快捷键ctrl+I）在格式化文件时的缩进方式存在一定差异，包括

   - 函数缩进

   - 运算符与变量间隔

   - `if, for, while, switch`-`end`与上下语句之间是否有空行

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

#### 注释规范

1. 请一定要写注释，请一定要写注释，请一定要写注释！

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

#### 自定义函数签名

1. 函数签名为键入函数名时对输入参数的提示内容，`functionSignatures.json`中可以自定义，参考[自定义代码建议和自动填充 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/releases/R2021a/matlab/matlab_prog/customize-code-suggestions-and-completions.html#mw_0251b2cc-b271-42bb-a21e-09bd3dcb9229)

2. 这个功能常用于输入中存在可选输入与`name-value`输入，可以自己对可变输入`varargin`进行参数解析，也可以通过matlab自带的`inputParser`进行参数解析，参考[函数的输入解析器 - MATLAB - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/ref/inputparser.html)

3. 示例参考`mSubplot.m, rowFcn.m`及其目录下的`functionSignatures.json`

#### 创建自己的工具箱

1. 参考[包命名空间 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/matlab_oop/scoping-classes-with-packages.html)

2. 简单概括：使用`+`开头的英文命名的文件夹下的包空间会被自动加入matlab路径（前提是父包需要在matlab路径中），一个包可以有多级的子包，如`+mutils/+plot2D/plot.m`，通过`mutils.plot2D.plot()`调用可以与built-in函数`plot`区分开来，因此可以通过这种方式创建自己的工具箱。
3. 包函数与类静态方法命名存在冲突时，包函数优先（请尽量不要有冲突命名）。





