function quad1 = importfile(filename, startRow, endRow)
%IMPORTFILE1 ���ı��ļ��е���ֵ������Ϊ�����롣
%   QUAD1 = IMPORTFILE1(FILENAME) ��ȡ�ı��ļ� FILENAME ��Ĭ��ѡ����Χ�����ݡ�
%
%   QUAD1 = IMPORTFILE1(FILENAME, STARTROW, ENDROW) ��ȡ�ı��ļ� FILENAME ��
%   STARTROW �е� ENDROW ���е����ݡ�
%
% Example:
%   quad1 = importfile1('quad.cas', 1, 93);
%
%    ������� TEXTSCAN��

% �� MATLAB �Զ������� 2020/03/05 15:58:49

%% ��ʼ��������
delimiter = {'\t',' ','',')','��'};
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% ÿ���ı��еĸ�ʽ:
%   ��1: �ı� (%q)
%	��2: �ı� (%q)
%   ��3: �ı� (%q)
%	��4: �ı� (%q)
%   ��5: �ı� (%q)
%	��6: �ı� (%q)
% �й���ϸ��Ϣ������� TEXTSCAN �ĵ���
formatSpec = '%q%q%q%q%q%q%[^\n\r]';

%% ���ı��ļ���
fileID = fopen(filename,'r');

%% ���ݸ�ʽ��ȡ�����С�
% �õ��û������ɴ˴������õ��ļ��Ľṹ����������ļ����ִ����볢��ͨ�����빤���������ɴ��롣
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% �ر��ı��ļ���
fclose(fileID);

%% ���޷���������ݽ��еĺ���
% �ڵ��������δӦ���޷���������ݵĹ�����˲�����������롣Ҫ�����������޷���������ݵĴ��룬�����ļ���ѡ���޷������Ԫ����Ȼ���������ɽű���

%% �����������
quad1 = [dataArray{1:end-1}];

