function hybrid = importfile1(filename, startRow, endRow)
%IMPORTFILE1 将文本文件中的数值数据作为矩阵导入。
%   HYBRID = IMPORTFILE1(FILENAME) 读取文本文件 FILENAME 中默认选定范围的数据。
%
%   HYBRID = IMPORTFILE1(FILENAME, STARTROW, ENDROW) 读取文本文件 FILENAME 的
%   STARTROW 行到 ENDROW 行中的数据。
%
% Example:
%   hybrid = importfile1('hybrid.cas', 1, 204);
%
%    另请参阅 TEXTSCAN。

% 由 MATLAB 自动生成于 2020/05/30 10:39:50

%% 初始化变量。
delimiter = {'\t',' ',')',':'};
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% 每个文本行的格式字符串:
%   列1: 文本 (%q)
%	列2: 文本 (%q)
%   列3: 文本 (%q)
%	列4: 文本 (%q)
%   列5: 文本 (%q)
%	列6: 文本 (%q)
%   列7: 文本 (%q)
%	列8: 文本 (%q)
%   列9: 文本 (%q)
% 有关详细信息，请参阅 TEXTSCAN 文档。
formatSpec = '%q%q%q%q%q%q%q%q%q%[^\n\r]';

%% 打开文本文件。
fileID = fopen(filename,'r');

%% 根据格式字符串读取数据列。
% 该调用基于生成此代码所用的文件的结构。如果其他文件出现错误，请尝试通过导入工具重新生成代码。
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% 关闭文本文件。
fclose(fileID);

%% 对无法导入的数据进行的后处理。
% 在导入过程中未应用无法导入的数据的规则，因此不包括后处理代码。要生成适用于无法导入的数据的代码，请在文件中选择无法导入的元胞，然后重新生成脚本。

%% 创建输出变量
% hybrid = table(dataArray{1:end-1}, 'VariableNames', {'VarName1','ExportedfromPointwise','VarName3','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9'});
hybrid = [dataArray{1:end-1}];

