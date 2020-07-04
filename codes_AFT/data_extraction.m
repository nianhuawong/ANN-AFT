clear;clc;
tic
format long
%%
gridType    = 0;        % 0-��һ��Ԫ����1-��ϵ�Ԫ����
Sp          = 1.0;      % ���񲽳�  % Sp = sqrt(3.0)/2.0;  %0.866         
al          = 3.0;      % �ڼ�����Χ������
coeff       = 0.8;      % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
dt          = 0.0001;   % ��ͣʱ��
outGridType = 0;        % 0-����ͬ������1-������������
%%
[AFT_stack,Coord,~]  = read_grid('../grid/inv_cylinder/inv_cylinder-20.cas', gridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);
PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% ѡ����С���棬����Pbest
nCells_AFT = 0;
iFace = 1;
Grid_stack = [];
node_best = node_num;     %��ʼʱ��ѵ�Pbest�����

%%  �Ƚ��߽������ƽ�
for i =1:size(AFT_stack,1)
    AFT_stack(i,5) = 0.00001* AFT_stack(i,5);
%     AFT_stack(i,5) = 1e5* AFT_stack(i,5);
end
AFT_stack_sorted = sortrows(AFT_stack, 5); 

% AFT_stack_sorted = sortrows(AFT_stack, 5,'descend');

while size(AFT_stack_sorted,1)>0
    
    if nCells_AFT ==227
        kkk = 1;
    end
    
    size0 = size(AFT_stack_sorted,1);
   
    [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack);
    
    while node_select == -1
        al = 1.2 * al;
        [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack);
    end
    
    if( flag_best == 1 )
        xCoord_AFT = [xCoord_AFT;coordX];
        yCoord_AFT = [yCoord_AFT;coordY];
        node_best = node_best + 1;
    end
    [AFT_stack_sorted,nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best);
        
    size1 = size(AFT_stack_sorted,1);
    PLOT_NEW_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, size1-size0);
    pause(dt);
    hold on;
    
    interval = 100;
    if(mod(nCells_AFT,interval)==0)
        disp('================================');
        disp('==========�ƽ�������...==========');
        disp(['nCells = ', num2str(nCells_AFT)]);
        disp(['����ʵʱ���ȣ�', num2str(size(AFT_stack_sorted,1))]);
        disp(['������������',num2str(size1-size0)]);
    end
  %%  
  %�ҳ��ǻ�Ծ���棬��ɾ��
  for i = 1: size(AFT_stack_sorted,1)
      if((AFT_stack_sorted(i,3) ~= -1) && (AFT_stack_sorted(i,4) ~= -1))  %��Ԫ���ҵ�Ԫ��ž���Ϊ-1
          Grid_stack(iFace,:) = AFT_stack_sorted(i,:);
          iFace = iFace + 1;
          AFT_stack_sorted(i,:)=-1;
      end
  end
  
  AFT_stack_sorted( AFT_stack_sorted(:,1) == -1, : ) = [];
  
  AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
  %         AFT_stack_sorted = sortrows(AFT_stack_sorted, 5, 'descend');
  
  if(node_select == -1)
      %%δ�ҵ�node_select�������Ӧ�ñȽ��ټ�
      disp('δ�ҵ�node_select�����...,�޷��ƽ������飡');
      node_best = node_best - 1;
      
      tmp = AFT_stack_sorted(1,:);
      AFT_stack_sorted(1,:) = AFT_stack_sorted(2,:);
      AFT_stack_sorted(2,:) = tmp;
  end
end

disp(['�����ƽ���ɣ���Ԫ����', num2str(nCells_AFT)]);
disp(['�����ƽ���ɣ��ڵ�����', num2str(length(xCoord_AFT))]);
disp(['�����ƽ���ɣ��������', num2str(size(Grid_stack,1))]);
toc
    
    





