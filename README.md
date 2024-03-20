# README

#### 1. 注意事项

1. 初次使用，请clone项目地址：

​	`git clone git@github.com:TOMORI233/MATLABUtils.git`

2. 请在使用前确保更新到最新版本：

​	`git pull origin master`

3. 如果需要推送代码，请向作者发送Pull Request或者联系加入Collaborators@TOMORI233。
4. 尽量不要修改通用函数，想要创建自己的版本，请创建自己的工具箱包。
5. 添加函数请添加在对应功能类型命名的文件夹下。
6. 推荐使用matlab创建初始版本脚本/函数文件，使用vscode进行修改（尤其是注释添加）和GIT进行版本管理，这里推荐几个插件：
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
             y = 2 * x1 + x2;
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

1. 参考[包命名空间 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/matlab_oop/scoping-classes-with-packages.html) 和 [函数优先顺序 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/matlab_prog/function-precedence-order.html)

2. 简单概括：使用`+`开头的英文命名的文件夹下的包空间会被自动加入matlab路径（前提是父包需要在matlab路径中），一个包可以有多级的子包，如`+mutils/+plot2D/plot.m`，通过`mutils.plot2D.plot()`调用可以与built-in函数`plot`区分开来，因此可以通过这种方式创建自己的工具箱。注意：可以不同目录下都包含同名`+XXX`文件夹。

3. 包函数与类静态方法命名存在冲突时，包函数优先（请尽量不要有冲突命名）。

4. 如果不想使用类似`mutils.plot2D.plot`而是直接使用`plot`来调用自定义的`plot`函数，那么可以在脚本开头加上

   ```matlab
   global plot
   plot = @mutils.plot2D.plot;
   ```
   
   那么matlab将以文件中变量作为最高优先级对`plot`进行调用（这里的`plot`被认为是一个变量名）。当项目存在冲突时，可以建一个这样的脚本将函数指向特定的工具包（中间不要有`clear`的操作）。注意：这个方式会让函数签名失效。
   
4. 【新增】替代全局变量调用函数的方法：使用`path2func`函数，将函数完整路径转为函数句柄，以解决重名函数问题和满足对一些`private`文件夹下函数调用的需求。

5. 私有函数：在`private`文件夹下的函数，只能被该文件夹父级目录中的函数调用，且不会被添加到搜索路径，优先级高于内置同名函数。注意：`private`文件夹下的子文件夹还是可以被添加至搜索路径，并不会被屏蔽。

#### 8. 风格与习惯

以下为私货，但你总会有自己的风格、习惯和更好的实现方式。

1. 每个trial都有自己的一些参数信息，因此可以用`struct array`来存，习惯命名为`trialAll`，方便人读，也方便使用其中的一个或几个参数作为筛选条件。
1. 尽量不要在脚本文件中使用固定参数，尤其是当这些参数需要应用于多个处理脚本中并且需要同步变动时。可以用一个单独的脚本/函数存，使用`run`命令调用该脚本或直接调用函数将参数加载到工作区。
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
7. matlab执行每条语句时会将临时存储于C盘的工作区变量载入内存中，当中间结果较小时可以不设中间变量而使用一条语句完成，但是当中间结果很大时，往往会出现内存不足的问题，这时需要使用临时的中间变量将该语句拆分。比如`res = permute(cat(4, res{:}), [4, 3, 1, 2]);`是将`N*1`的cell数组`res`（其中每个元胞为`A*B*C`的矩阵）转为`N*C*A*B`的矩阵，当`res`较大时可能出现内存不足，因此需要拆分为`res = cat(4, res{:});`和`res = permute(res, [4, 3, 1, 2]);`两条语句执行。
8. 关于类和类方法（面向对象编程）
   - MATLAB对类的说明：创建类可以简化涉及与特殊类型的数据交互的专用数据结构体或大量函数的编程任务。MATLAB 类支持函数和运算符重载、对属性和方法的控制访问、引用和值语义以及事件和侦听程序。
   - 当一个类对象被创建，对它进行的所有操作都将直接指向它在内存中的位置（参考C语言中的指针）。这意味着当一个被实例化的类对象作为函数的输入参数时，它将以指针的方式被函数访问（区别于其他类型的参数以**形式参数**的方式被copy内存中而占用**额外的内存空间**，并且在函数执行完毕后该部分内存会被释放），在函数中对该类对象的属性值（Properties）所做的一切更改将在函数执行后仍然有效。
   - 与struct的区别：当函数（以`mfcn`代指）需要输入的参数很多并且有较多可选输入时，可以使用struct（以下用`params`指代）来承载这些参数（事实上如FieldTrip和Kilosort都是这么做的），但是仍然需要在`mfcn`中或者单独的脚本/函数中为这些变量赋初值，并且在`mfcn`中对这些变量进行校验；而如果`params`被定义为一个类，那么赋初值和校验的操作就可以在Properties声明属性值时完成（校验在再次赋值时也会生效），且当它继承自`handle`时，可以使用监听（`addlistener`）的方式对参数冲突等情况进行处理。注意：与struct不同，class的属性不能动态增减，这也就意味着它不能中途加参数和删除参数。
   - 枚举类：参考[定义枚举类 - MATLAB & Simulink - MathWorks 中国](https://ww2.mathworks.cn/help/matlab/matlab_oop/enumerations.html)。当某个属性值有一个固定的有限取值集合，或者需要定义类似于[R,G,B]→color name、数字电路真值表→输出情况的映射时，可以使用枚举类，它会规范限制程序结果。
   - Demo见`data structures\class`目录下，一个是监听的Demo，一个是类的Demo。

#### 9. Update Log

请将每次大更新内容**置顶**写在这里，标注日期、修改者和兼容性（Incompatible/Compatible），对每条修改请标注修改类型（Add/Modify/Delete/Debug）。若为Incompatible，请给出修改方案。

- 2024/03/20 by XHX - Incompatible

  | Type   | Target             | Content                                                      |
  | ------ | ------------------ | ------------------------------------------------------------ |
  | Modify | `structcat.m`      | 改变其功能，新功能为拼接含有不同字段名的结构体数组，原功能移至`getOrFull` |
  | Modify | `getOrFull.m`      | 【新增】支持结构体数组的补全                                 |
  | Add    | `syncXY.m`         | 用于在散点图绘制时同步XY坐标范围                             |
  | Add    | `addTitle2Fig.m`   | 为figure添加一个大标题，可以自定义位置（normalized）         |
  | Add    | `maxt.m`, `mint.m` | 返回波形最大/最小值`x`及其对应的时间`t`                      |
  | Add    | `filewrite.m`      | 将字符串输出为文件                                           |

- 2024/03/14 by XHX - Incompatible

  | Type   | Target               | Content                                                 |
  | ------ | -------------------- | ------------------------------------------------------- |
  | Delete | `mCheckUpdate.m`     |                                                         |
  | Add    | `syncRepositories.m` | 替代原来的`mCheckUpdate.m`，可以更新根目录下所有Git项目 |

- 2024/03/11 by XHX - Compatible

  | Type | Target        | Content                              |
  | ---- | ------------- | ------------------------------------ |
  | Add  | `path2func.m` | 【重要】将函数的绝对路径转为函数句柄 |

- 2023/12/25 by XHX - Compatible

  | Type   | Target                   | Content                                     |
  | ------ | ------------------------ | ------------------------------------------- |
  | Add    | `addLines2AxesApp.mlapp` | 添加了一个动态添加图线的App                 |
  | Modify | `scaleAxesApp.mlapp`     | 【新增】添加了一个`Line`按钮用于调用画线App |

- 2023/11/25 by XHX - Compatible

  | Type | Target                                 | Content                                                      |
  | ---- | -------------------------------------- | ------------------------------------------------------------ |
  | Add  | `cwtAny.m`, `cwtMultiAll.m`            | `cwtAny.m`返回任意trial和通道数目data的小波变换结果(complex)，可以指定分隔的数目(即每x个合并在一起做小波变换)以更好地使用GPU计算(内置了gpucoder部分生成对应大小的`mex`文件，请注意实际是否支持) |
  | Add  | `ft_removePath.m`                      | 移除FiledTrip的相关路径，但保留`ft_defaults`和本脚本所在文件夹路径，防止与builtin函数冲突 |
  | Add  | `calLatency.m`, `calPSTH.m`, `calFR.m` | 在`data processing\spike\`下添加了用于计算latency、PSTH和firing rate的3个函数，输入为包含了`spike`字段的`trials`结构体或者spike数据的cell数组(需要对齐至0时刻)，单位为ms。`calPSTH`和`calFR`可能存在冲突，请注意。 |

- 2023/09/25 by XHX - Compatible

  | Type | Target               | Content                                                      |
  | ---- | -------------------- | ------------------------------------------------------------ |
  | Add  | `figureViewer.mlapp` | 将图片拼接滚动查看。输入参数`srcPaths`为字符串数组，指定图片完整路径；输入参数`orientation`指定图片拼接方向：`"vertical"`为纵向，`"horizontal"`为横向 |

- 2023/09/19 by XHX - Compatible

  | Type  | Target          | Content                                                      |
  | ----- | --------------- | ------------------------------------------------------------ |
  | Debug | `mHistogram.m`  | 修复了在未指定legend时出现legend框的问题                     |
  | Add   | `addfield.m`    | 用于向列向量的struct数组添加字段，要求添加的字段所赋值在行数与原结构体相同 |
  | Add   | `fitBehavior.m` | 使用`pFit`对行为进行结果拟合，返回`2*1000`的矩阵，第一行为`x`，第二行为`ratio` |

- 2023/08/06 by XHX - Compatible

  | Type | Target               | Content                                                      |
  | ---- | -------------------- | ------------------------------------------------------------ |
  | Add  | `scaleAxesApp.mlapp` | 为`scaleAxes`的UI增加`Reset`按钮，还原初始设置               |
  | Add  | `mCheckUpdate.m`     | 检查更新的脚本，建议在`startup.m`中执行该脚本。该脚本也可以在其他项目中使用，需要放在根目录并更改命名 |

- 2023/07/29 by XHX - Compatible

  | Type | Target             | Content                  |
  | ---- | ------------------ | ------------------------ |
  | Add  | `Instruction.xlsx` | 为每个常用函数添加了说明 |

- 2023/07/18 by XHX - Compatible

  | Type | Target            | Content                                                      |
  | ---- | ----------------- | ------------------------------------------------------------ |
  | Add  | `validateInput.m` | 增加了一个UI输入框，可以通过`validateInput(..., "UI", "on")`开启，替代命令行的输入方式 |
  | Add  | `pathManager.m`   | 返回`ROOTPATH\subject\protocol\datetime\*.mat`数据存放方式的完整mat路径，可以指定subject和protocol，如`matPaths = pathManager(ROOTPATH, "subjects", ["DDZ", "DD"], "protocols", "Noise");` |
  | Add  | `README.md`       | 添加说明文档                                                 |

