function hybrid = importfile(filename, startRow, endRow)
%IMPORTFILE1 ���ı��ļ��е���ֵ������Ϊ�����롣
%   HYBRID = IMPORTFILE1(FILENAME) ��ȡ�ı��ļ� FILENAME ��Ĭ��ѡ����Χ�����ݡ�
%
%   HYBRID = IMPORTFILE1(FILENAME, STARTROW, ENDROW) ��ȡ�ı��ļ� FILENAME ��
%   STARTROW �е� ENDROW ���е����ݡ�
%
% Example:
%   hybrid = importfile1('hybrid.cas', 1, 204);
%
%    ������� TEXTSCAN��

% �� MATLAB �Զ������� 2020/05/30 10:39:50

%% ��ʼ��������
delimiter = {'\t',' ',')',':'};
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% ÿ���ı��еĸ�ʽ�ַ���:
%   ��1: �ı� (%q)
%	��2: �ı� (%q)
%   ��3: �ı� (%q)
%	��4: �ı� (%q)
%   ��5: �ı� (%q)
%	��6: �ı� (%q)
%   ��7: �ı� (%q)
%	��8: �ı� (%q)
%   ��9: �ı� (%q)
% �й���ϸ��Ϣ������� TEXTSCAN �ĵ���
formatSpec = '%q%q%q%q%q%q%q%q%q%[^\n\r]';

%% ���ı��ļ���
fileID = fopen(filename,'r');

%% ���ݸ�ʽ�ַ�����ȡ�����С�
% �õ��û������ɴ˴������õ��ļ��Ľṹ����������ļ����ִ����볢��ͨ�����빤���������ɴ��롣
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

%% �ر��ı��ļ���
fclose(fileID);

%% ���޷���������ݽ��еĺ���
% �ڵ��������δӦ���޷���������ݵĹ�����˲�����������롣Ҫ�����������޷���������ݵĴ��룬�����ļ���ѡ���޷������Ԫ����Ȼ���������ɽű���

%% �����������
% hybrid = table(dataArray{1:end-1}, 'VariableNames', {'VarName1','ExportedfromPointwise','VarName3','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9'});
hybrid = [dataArray{1:end-1}];

