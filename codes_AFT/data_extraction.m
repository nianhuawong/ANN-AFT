clear;clc;
tic
grid = importfile1('./grid/hybrid.cas');
%%
%读入基本信息
gridType        = 1;    % 0-单一单元网格，1-混合单元网格
dimension       = hex2dec(grid(4,2));
nNodes          = hex2dec(grid(6,4));
nFaces          = hex2dec(grid(10,4));
nCells          = hex2dec(grid(14,4));
%%
%读入节点坐标
nStart=17;  %节点坐标起始行
xCoord = str2double( grid(nStart:nStart+nNodes-1,1) );
yCoord = str2double( grid(nStart:nStart+nNodes-1,2) );
% plot(xCoord,yCoord,'x');
%%
% 读入face信息，两个节点编号，左右单元编号
% facePos = find(grid(:,1)=='(13');
facePos = find(strcmp(grid(:,1),'(13') == 1);
% facePos =[];
% for i = 1:size(grid,1)
%     if(strcmp(grid(i,1),'(13') == 1)
%         facePos = [facePos, i]; 
%     end
% end

node1 = zeros(nFaces,1);
node2 = zeros(nFaces,1);
leftCell    = zeros(nFaces,1);
rightCell   = zeros(nFaces,1);

nn = facePos( length(facePos) : -1 : 2 );
nBoundaryFacesList = hex2dec(grid(nn,4))- hex2dec(grid(nn,3)) + 1; %最后一个为内部面，其他为边界面
nBoundaryFaces = sum(nBoundaryFacesList(1:end-1), 1);
count = 1;
for j = length(facePos) : -1 : 2
    N = facePos(j);
    nFaces1 = hex2dec(grid(N,4))- hex2dec(grid(N,3)) + 1;
    startIn = count;
    endIn   = count + nFaces1 - 1;

    if gridType == 0 %以下针对纯三角形或四边形网格   
        node1(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,1));
        node2(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,2));
        leftCell(startIn:endIn,1)  = hex2dec(grid(N + 1:N + nFaces1,3));
        rightCell(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,4));

    elseif gridType == 1 %以下针对混合网格  
        node1(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,2));
        node2(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,3));
        leftCell(startIn:endIn,1)  = hex2dec(grid(N + 1:N + nFaces1,4));
        rightCell(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,5));
    end
    
    count = count + nFaces1;
end
%%
% 全局网格显示
Grid_stack = zeros(nFaces,6);
for i = 1:nFaces
    Grid_stack(i,1) = node1(i,1);
    Grid_stack(i,2) = node2(i,1);
    Grid_stack(i,3) = leftCell(i,1);
    Grid_stack(i,4) = rightCell(i,1);
    Grid_stack(i,5) = DISTANCE(Grid_stack(i,1), Grid_stack(i,2), xCoord, yCoord);
    Grid_stack(i,6) = i;
end
% PLOT(Grid_stack, xCoord, yCoord);
%%
% 完成边界面信息的提取，建立阵面信息
AFT_stack = [];
for i = 1:nBoundaryFaces
    AFT_stack(i,1) = node1(i,1);
    AFT_stack(i,2) = node2(i,1);
    AFT_stack(i,3) = -1;
    AFT_stack(i,4) = rightCell(i,1);
    AFT_stack(i,5) = DISTANCE(AFT_stack(i,1), AFT_stack(i,2), xCoord, yCoord);
    AFT_stack(i,6) = i;
end

nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%边界点的个数，或者，初始阵面点数
xCoord_AFT = xCoord(1:node_num);                %初始阵面点坐标
yCoord_AFT = yCoord(1:node_num);
% PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% 选择最小阵面，生成Pbest
nCells_AFT = 0;
% Sp = 1.0;
Sp = sqrt(3.0)/2.0;
al = 3.0;
node_best = node_num;

while size(AFT_stack,1)>0
    AFT_stack_sorted = sortrows(AFT_stack, 5);
    [x_best, y_best] = ADD_POINT(AFT_stack_sorted(1,:), xCoord_AFT, yCoord_AFT, Sp);
    node_best = node_best + 1;

    %%
    % 查询临近点
    % 可以画出圆来看看临近点有哪些
%     figure;
    PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);
%     hold on
%     plot(x_best,y_best,'*')
%     hold on
%     txt = text(x_best+0.1,y_best,num2str(node_best), 'Color', 'red', 'FontSize', 14);
    syms xxx yyy
%     ezplot((xxx-x_best)^2+(yyy-y_best)^2==al*al*Sp*Sp);
%     fimplicit(@(xxx,yyy) (xxx-x_best)^2+(yyy-y_best)^2-al*al*Sp*Sp);
    hold on
    pause(0.1);
    
    node1_base = AFT_stack_sorted(1,1);
    node2_base = AFT_stack_sorted(1,2);
    
    nodeCandidate = node_best;  
    for i = 2:size(AFT_stack_sorted,1)
        node1 = AFT_stack_sorted(i,1);
        node2 = AFT_stack_sorted(i,2);
        x_p1 = xCoord_AFT(node1);
        y_p1 = yCoord_AFT(node1);

        x_p2 = xCoord_AFT(node2);
        y_p2 = yCoord_AFT(node2);  

        if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*Sp*Sp &&  node1 ~= node1_base && node1 ~= node2_base)
            nodeCandidate(end+1) = node1;
        elseif( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*Sp*Sp &&  node2 ~= node1_base && node2 ~= node2_base)
            nodeCandidate(end+1) = node2;
        end
    end
    nodeCandidate = unique(nodeCandidate);

    %%
    % 临近点的质量参数Qp
    Qp = zeros(length(nodeCandidate),1);

    xCoord_tmp = [xCoord_AFT; x_best];
    yCoord_tmp = [yCoord_AFT; y_best];   
    for i = 1 : length(nodeCandidate)
        node3 = nodeCandidate(i);
        a = DISTANCE( node1_base, node2_base, xCoord_tmp, yCoord_tmp);
        b = DISTANCE( node1_base, node3, xCoord_tmp, yCoord_tmp);
        c = DISTANCE( node3, node2_base, xCoord_tmp, yCoord_tmp);

        theta = acos( ( a^2 + b^2 - c^2 ) / ( 2.0 * a * b + 1e-40 ) );
        area = 0.5 * a * b * sin(theta);
        r = 2.0 * area / ( ( a + b + c ) + 1e-40 );   %内切圆半径
        R = a * b * c / 4.0 / ( area + 1e-40 );       %外接圆半径

        Qp(i) =   3.0 * r / ( R + + 1e-40 );

        if( node3 == node_best )
            Qp(i) = 0.8 * Qp(i);
        end
    end

    %%     
    % 查询临近阵元
    frontCandidate = [];
    nodeCandidate_tmp = [nodeCandidate, node1_base, node2_base];
    for i = 2:size(AFT_stack_sorted,1)
        node1 = AFT_stack_sorted(i,1);
        node2 = AFT_stack_sorted(i,2);

        if( size(find(nodeCandidate_tmp == node1), 2) ~= 0 && size(find(nodeCandidate_tmp == node2), 2) ~= 0 )
    %         frontCandidate(end+1) = AFT_stack_sorted(i,6);
            frontCandidate(end+1) = i;
        end
    end

    frontCandidateNodes = AFT_stack_sorted(frontCandidate,1:2);
    %%
    %按质量参数逐一选择点，判断是否与临近阵面相交，如相交则下一个候选点，如不想交，则选定该点构成新的三角形
    Qp_sort = sort(Qp, 'descend');
    node_select = -1;
    
    if nCells_AFT == 45
        kkk = 1;
    end
    
    for i = 1 : length(nodeCandidate)
        node_test_list = nodeCandidate( find(Qp==Qp_sort(i)) );
%%     
        for j = 1:length(node_test_list)
            node_test = node_test_list(j);
            flagCross = IsNotCross(node1_base, node2_base, node_test, frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp);            
            flagLeftCell = IsLeftCell(node1_base, node2_base, node_test, xCoord_tmp, yCoord_tmp);

            if flagCross == 1 && flagLeftCell == 1
                node_select = node_test;           
                break;
            end               
        end
        
        if node_select ~= -1
            break;
        end
    end

%% 
    %更新阵面信息
    if node_select ~= -1                      
        if(node_select == node_best)    %只有在选择了新生成的点时，才需要将新点坐标存下来            
            xCoord_AFT(end+1) = x_best;
            yCoord_AFT(end+1) = y_best;
        else
             node_best = node_best - 1;
        end       
        dist1 = DISTANCE(node1_base, node_select, xCoord_AFT, yCoord_AFT);
        dist2 = DISTANCE(node2_base, node_select, xCoord_AFT, yCoord_AFT);
        
        %阵面及左单元编号更新   
        nCells_AFT = nCells_AFT + 1;
        flag1 = IsLeftCell(node1_base, node2_base, node_select, xCoord_AFT, yCoord_AFT);     
        if( flag1 == 1 )
            AFT_stack_sorted(1,3) = nCells_AFT;
        else
            AFT_stack_sorted(1,4) = nCells_AFT;
        end
        
        flag2 = IsLeftCell(node_select, node1_base, node2_base, xCoord_AFT, yCoord_AFT);
        [direction, row] = FrontExist(node_select,node1_base, AFT_stack_sorted); 
        if( flag2 == 1 )
            if( row ~= -1 )
                if(direction == 1)
                    AFT_stack_sorted(row, 3) = nCells_AFT;
                elseif(direction == -1)
                    AFT_stack_sorted(row, 4) = nCells_AFT;
                end
            else
                AFT_stack_sorted(end+1,:) = [node1_base, node_select, -1, nCells_AFT, dist1,  size(AFT_stack_sorted,1)+1];  
            end
        else
            if( row ~= -1 )
                if(direction == 1)
                    AFT_stack_sorted(row, 4) = nCells_AFT;
                elseif(direction == -1)
                    AFT_stack_sorted(row, 3) = nCells_AFT;
                end
            else
                AFT_stack_sorted(end+1,:) = [node1_base, node_select, nCells_AFT, -1, dist1,  size(AFT_stack_sorted,1)+1];  
            end
        end 
        
        flag3 = IsLeftCell(node2_base, node_select, node1_base, xCoord_AFT, yCoord_AFT);
        [direction, row] = FrontExist(node2_base,node_select, AFT_stack_sorted); 
        if( flag3 == 1 )
            if( row ~= -1 )
                if(direction == 1)
                    AFT_stack_sorted(row, 3) = nCells_AFT;
                elseif(direction == -1)
                    AFT_stack_sorted(row, 4) = nCells_AFT;
                end
            else            
                AFT_stack_sorted(end+1,:) = [node_select, node2_base, -1, nCells_AFT, dist2,  size(AFT_stack_sorted,1)+1];  
            end
        else
            if( row ~= -1 )
                if(direction == 1)
                    AFT_stack_sorted(row, 4) = nCells_AFT;
                elseif(direction == -1)
                    AFT_stack_sorted(row, 3) = nCells_AFT;
                end
            else
                AFT_stack_sorted(end+1,:) = [node_select, node2_base, nCells_AFT, -1, dist2,  size(AFT_stack_sorted,1)+1];              
            end
        end      

        PLOT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT);
        hold on;
        
        %在已有阵面中查找自动构成的单元
        %新增点的邻点
        if(node_select ~= node_best)
            neighbor = [node1_base, node2_base];
            for i = 1: size(AFT_stack_sorted,1)
                if( AFT_stack_sorted(i,1)== node_select)
                    neighbor(end+1) = AFT_stack_sorted(i,2);
                end
                if( AFT_stack_sorted(i,2) == node_select)
                    neighbor(end+1) = AFT_stack_sorted(i,1);
                end
            end
            neighbor = unique(neighbor);
            
    %         邻点中若是有互相相邻的，则形成新单元
            new_cell = [];
            for i = 1:length(neighbor)
                neighborNode = neighbor(i);
                for j = 1: size(AFT_stack_sorted,1)
                    if( AFT_stack_sorted(j,1) == neighborNode )
                        if( find(neighbor==AFT_stack_sorted(j,2)) )
                            new_cell(end+1,:) = [node_select, neighborNode, AFT_stack_sorted(j,2)];
                        end
                    end
                    if(AFT_stack_sorted(j,2) == neighborNode)
                        if( find(neighbor==AFT_stack_sorted(j,1)) )
                            new_cell(end+1,:) = [node_select, neighborNode, AFT_stack_sorted(j,1)];
                        end                    
                    end
                end
            end
            
            for i = 1 : size(new_cell,1)
               iCell = new_cell(i,:);
               for j = i+1:size(new_cell,1)
                   jCell = new_cell(j,:); 
                   if( sum(jCell([3,2]) == iCell([2,3])) == 2)
                       new_cell(j,:)=-1;
                   end
               end
            end
            
            II = find(new_cell(:,1) == -1);
            new_cell(II,:)=[];
            
            %还要去掉已经有的单元
            for i = 1 : size(new_cell,1)
                iCell = new_cell(i,:);
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) && size(find(iCell==node_select),2))
                    new_cell(i,:)=-1;
                end
            end
            
            II = find(new_cell(:,1) == -1);
            new_cell(II,:)=[]; 
            
            %将新单元加入数据结构
            for i = 1:size(new_cell,1) 
                nCells_AFT = nCells_AFT + 1;
                node1 = new_cell(i,1);
                node2 = new_cell(i,2);
                node3 = new_cell(i,3);

                dist1 = DISTANCE(node1, node2, xCoord_AFT, yCoord_AFT);
                dist2 = DISTANCE(node1, node3, xCoord_AFT, yCoord_AFT);
                dist3 = DISTANCE(node2, node3, xCoord_AFT, yCoord_AFT);

                flag1 = IsLeftCell(node1, node2, node3, xCoord_AFT, yCoord_AFT);
                [direction, row] = FrontExist(node1,node2, AFT_stack_sorted);    
                if( flag1 == 1 )               
                    if( row ~= -1 )
                        if(direction == 1)
                            AFT_stack_sorted(row, 3) = nCells_AFT;
                        elseif( direction == -1 )
                            AFT_stack_sorted(row, 4) = nCells_AFT;
                        end                                                   
                    else
                        AFT_stack_sorted(end+1,:) = [node2, node1, -1, nCells_AFT, dist1, size(AFT_stack_sorted,1)+1];                     
                    end
                else
                    if( row ~= -1 )
                        if(direction == 1)
                            AFT_stack_sorted(row, 4) = nCells_AFT; 
                        elseif(direction == -1)
                            AFT_stack_sorted(row, 3) = nCells_AFT;
                        end                        
                    else
                        AFT_stack_sorted(end+1,:) = [node2, node1, nCells_AFT, -1, dist1, size(AFT_stack_sorted,1)+1];                     
                    end
                end

                flag2 = IsLeftCell(node1, node3, node2, xCoord_AFT, yCoord_AFT);
                [direction, row] = FrontExist(node1,node3, AFT_stack_sorted); 
                if( flag2 == 1 )
                    if( row ~= -1 )
                        if(direction == 1)
                            AFT_stack_sorted(row, 3) = nCells_AFT;
                        elseif( direction == -1 )
                            AFT_stack_sorted(row, 4) = nCells_AFT;
                        end  
                    else
                        AFT_stack_sorted(end+1,:) = [node3, node1, -1, nCells_AFT, dist2, size(AFT_stack_sorted,1)+1];                     
                    end                
                else
                    if( row ~= -1 )
                        if(direction == 1)
                            AFT_stack_sorted(row, 4) = nCells_AFT; 
                        elseif(direction == -1)
                            AFT_stack_sorted(row, 3) = nCells_AFT;
                        end 
                    else
                        AFT_stack_sorted(end+1,:) = [node3, node1, nCells_AFT, -1, dist2, size(AFT_stack_sorted,1)+1];                     
                    end
                end

                flag3 = IsLeftCell(node2, node3, node1, xCoord_AFT, yCoord_AFT);
                [direction, row] = FrontExist(node2,node3, AFT_stack_sorted); 
                if( flag3 == 1 )
                    if( row ~= -1 )
                        if(direction == 1)
                            AFT_stack_sorted(row, 3) = nCells_AFT;
                        elseif( direction == -1 )
                            AFT_stack_sorted(row, 4) = nCells_AFT;
                        end  
                    else
                        AFT_stack_sorted(end+1,:) = [node3, node2, -1, nCells_AFT, dist3, size(AFT_stack_sorted,1)+1];                     
                    end                
                else
                    if( row ~= -1 )
                        if(direction == 1)
                            AFT_stack_sorted(row, 4) = nCells_AFT; 
                        elseif(direction == -1)
                            AFT_stack_sorted(row, 3) = nCells_AFT;
                        end 
                    else
                        AFT_stack_sorted(end+1,:) = [node3, node2, nCells_AFT, -1, dist3, size(AFT_stack_sorted,1)+1];                     
                    end
                end            
            end            
        end
    
        %找出非活跃阵面，并删除
        for i = 1: size(AFT_stack_sorted,1)
            if((AFT_stack_sorted(i,3) ~= -1) && (AFT_stack_sorted(i,4) ~= -1))  %左单元和右单元编号均不为-1
                AFT_stack_sorted(i,:)=-1;
            end
        end
        
        AFT_stack_sorted( find(AFT_stack_sorted(:,1) == -1), : ) = [];       
    else
        node_best = node_best - 1;

        tmp = AFT_stack_sorted(1,1);
        AFT_stack_sorted(1,1) = AFT_stack_sorted(1,2);
        AFT_stack_sorted(1,2) = tmp;        
    end
    
    AFT_stack = AFT_stack_sorted;
end
str = {'阵面推进完成，单元数：', num2str(nCells_AFT) };
display(str);
toc
    
    






