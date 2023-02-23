classdef AdFront2 < handle
    
    properties
        AFT_stack;
        xCoord_AFT;
        yCoord_AFT;
        
        meshSizeObj;
        timeManagerObj;
        plotObj;
        
        %% 阵面推进控制参数
        al          = 3.0;      % 在几倍范围内搜索
        coeff       = 0.8;      % 尽量选择现有点的参数，Pbest质量参数的系数
        outGridType = 0;        % 0-各向同性网格，1-各向异性网格
        epsilon     = 0.9;      % 网格质量要求, 值越大要求越高
        isSorted    = true;     % 是否对阵面进行排序推进
        
        %% 画图相关参数
        isPlotNew    = 0;   % 是否plot生成过程
        
        %% ANN控制参数
        useANN       = 0;        % 是否使用ANN生成网格
        tolerance    = 0.2;      % ANN进行模式判断的容差
        stencilType  = 'all';    % 在ANN生成点时，如何取当前阵面的引导点模板，可以随机取1个，或者所有可能都取，最后平均
        standardlize = 1;        % 是否进行坐标归一化
        nn_fun       = @net_naca0012_20201104;
        
        %%
        nFronts  = 0;
        nNodes   = 0;
        nFaces   = 0;
        nCells   = 0;
        
        Grid_stack   = []; 
        cellNodeTopo = [];
        
        countMode    = 0;  
        crossCount   = 0;
        node_best    = 0;   %初始时最佳点Pbest的序号
        
        %%
        node1_base; 
        node2_base;
        x_mid;
        y_mid;
        Sp;
    end
    
    methods
        function this = AdFront2(paraObj, boundaryDataObj, meshSizeObj, timeManagerObj, plotObj)
            this.InitParameters(paraObj);
            
            this.meshSizeObj = meshSizeObj;
            this.timeManagerObj = timeManagerObj;
            this.plotObj = plotObj;
            this.AFT_stack   = boundaryDataObj.BC_stack;
            
            if this.isSorted
                this.AFT_stack = Sort_AFT(boundaryDataObj.BC_stack);
            end
            
            this.xCoord_AFT = boundaryDataObj.BC_coord(:,1);
            this.yCoord_AFT = boundaryDataObj.BC_coord(:,2);
            
            this.node_best  = boundaryDataObj.nBoundaryNodes;
            
            this.UpdateCounters();
        end
        
        function InitParameters(this, paraObj)

        end
        
        function UpdateCounters(this)
            this.nFronts = size(this.AFT_stack,  1);
            this.nNodes  = size(this.xCoord_AFT, 1);
            this.nFaces  = size(this.Grid_stack, 1);            
        end
        
        function AdvancingFront(this)
            while this.nFronts>0               
                this.node1_base = this.AFT_stack(1,1);
                this.node2_base = this.AFT_stack(1,2);
                this.x_mid = 0.5 * ( this.xCoord_AFT(this.node1_base) + this.xCoord_AFT(this.node2_base) );
                this.y_mid = 0.5 * ( this.yCoord_AFT(this.node1_base) + this.yCoord_AFT(this.node2_base) );
                
                %     if nCells >= 0
                %         if node1_base == 47 && node2_base == 48 %|| node1_base == 748 && node2_base == 743|| ...
                % %                 node1_base == 580 && node2_base == 468
                % %             kkk = 1;
                %             PLOT_FRONT(AFT_stack, xCoord_AFT, yCoord_AFT, 1);
                %         end
                %         PLOT_FRONT(AFT_stack, xCoord_AFT, yCoord_AFT, 1);
                %         kkk = 1;
                %     end
                
                this.timeManagerObj.spTimer.ReStart();
                this.Sp = this.meshSizeObj.GetSp(this.x_mid, this.y_mid);
                this.timeManagerObj.spTimer.Span(0);
                this.timeManagerObj.spTimer.AccumulateTime();
                
%%
                this.timeManagerObj.generateTimer.ReStart();
                [node_select, Pselect, flag_best] = this.GenerateTri();
                while node_select == -1
                    this.al = 1.2 * this.al;
                    [node_select, Pselect, flag_best] = this.GenerateTri();
                end
                this.timeManagerObj.generateTimer.Span(0);
                this.timeManagerObj.generateTimer.AccumulateTime();
                
                %%
                this.timeManagerObj.updateTimer.ReStart();
                if( flag_best == 1 )
                    this.xCoord_AFT = [this.xCoord_AFT; Pselect(1)];
                    this.yCoord_AFT = [this.yCoord_AFT; Pselect(2)];
%                     this.node_best = this.node_best + 1;
                end
                
                size0 = size(this.AFT_stack,1);
                [this.AFT_stack, this.nCells] = UpdateTriCells(this.AFT_stack, this.nCells, this.xCoord_AFT, this.yCoord_AFT, node_select, flag_best);
                this.timeManagerObj.updateTimer.Span(0);
                this.timeManagerObj.updateTimer.AccumulateTime();
                
                %%
                this.timeManagerObj.plotTimer.ReStart();
                size1 = size(this.AFT_stack,1);
                numberOfNewFronts = size1-size0;
                if this.isPlotNew
                    this.plotObj.PLOT_NEW_FRONT(this.AFT_stack, this.xCoord_AFT, this.yCoord_AFT, numberOfNewFronts, flag_best)
                end
                this.timeManagerObj.plotTimer.Span(0);
                this.timeManagerObj.plotTimer.AccumulateTime();
               
                %% 找出非活跃阵面，并删除
                [this.AFT_stack, this.Grid_stack] = DeleteInactiveFront(this.AFT_stack, this.Grid_stack);
                
                if this.isSorted
                    this.AFT_stack = Sort_AFT(this.AFT_stack);
                end
                
                this.UpdateCounters();
                
                this.timeManagerObj.totalTimer.Span(0) ;
                this.timeManagerObj.totalTimer.AccumulateTime();
                %%
                interval = 500;
                if(mod(this.nCells,interval)==0)
                    DisplayResults(this, numberOfNewFronts, 'midRes');
                end                
            end
        end
        
        function [node_select, Pselect, flag_best] =  GenerateTri(this)
            %%
            mode = 0;
            if this.useANN
                [x_best, y_best, this.Sp, mode, nodeIndex] = ADD_POINT_ANN(this.nn_fun, this.AFT_stack, this.xCoord_AFT, this.yCoord_AFT, this.stencilType, this.Sp);
            else
                mode = 1;
                [x_best, y_best] = ADD_POINT_tri(this.AFT_stack, this.xCoord_AFT, this.yCoord_AFT, this.Sp, this.outGridType);
            end
            this.node_best = this.node_best + 1;      %新增最佳点Pbest的序号
            
            % PLOT_CIRCLE(x_best, y_best, al, Sp, ds, node_best);
            if mode == 2 || mode == 3
                %在现有阵面中，查找临近点，作为候选点，与 新增点或基准阵面中点 的距离小于al*Sp的点，要遍历除自己外的所有阵面
                nodeCandidate_AFT = NodeCandidate(this.AFT_stack, this.node1_base, this.node2_base, this.xCoord_AFT, this.yCoord_AFT, [x_best, y_best], this.al * this.Sp );
                nodeCandidate_AFT = [nodeCandidate_AFT, this.node_best];
                %%
                % 查询临近阵元，为避免与邻近阵面相交
                frontCandidate = FrontCandidate(this.AFT_stack, [nodeCandidate_AFT, this.node1_base, this.node2_base]);
                flagNotCross1 = IsNotCross(this.node1_base, this.node2_base, nodeIndex, frontCandidate, this.AFT_stack, this.xCoord_AFT, this.yCoord_AFT ,0);
                
                flagLeftCell = IsLeftCell(this.node1_base, this.node2_base, nodeIndex, this.xCoord_AFT, this.yCoord_AFT);
                if flagLeftCell == 0 || flagNotCross1 == 0
                    node_select = -1;
                else
                    node_select =  nodeIndex;
                    this.countMode = this.countMode + 1;
                end
            end
            
            if mode == 4
                node_select =  nodeIndex;
                this.countMode = this.countMode + 1;
            end
            
            if mode == 1 || node_select == -1
                nodeCandidate_AFT = NodeCandidate(this.AFT_stack, this.node1_base, this.node2_base, this.xCoord_AFT, this.yCoord_AFT, [x_best, y_best], this.al*this.Sp);
                nodeCandidate_AFT = [nodeCandidate_AFT, this.node_best];
                % 查询临近阵元，为避免与邻近阵面相交
                frontCandidate = FrontCandidate(this.AFT_stack, [nodeCandidate_AFT, this.node1_base, this.node2_base]);
                % frontCandidateNodes = AFT_stack(frontCandidate,1:2);
                
                %%  在非阵面中查找可能相交的点
                nodeCandidate_Grid = NodeCandidate(this.Grid_stack, this.node1_base, this.node2_base, this.xCoord_AFT, this.yCoord_AFT, [x_best, y_best], this.al * this.Sp );
                nodeCandidate_Grid = [nodeCandidate_Grid(:)', this.node1_base, this.node2_base, this.node_best];
                
                %在非阵面中查找临近面
                faceCandidate = FrontCandidate(this.Grid_stack, [nodeCandidate_Grid, nodeCandidate_AFT]);
                %     faceCandidateNodes = Grid_stack(faceCandidate,1:2);
                %%
                % 临近点的质量参数Qp
                lenNodeCandidate = length(nodeCandidate_AFT);
                Qp = zeros(lenNodeCandidate,1);
                xCoord_tmp = [this.xCoord_AFT; x_best];
                yCoord_tmp = [this.yCoord_AFT; y_best];
                for i = 1 : lenNodeCandidate
                    node3 = nodeCandidate_AFT(i);
                    [quality,~] = QualityCheckTri(this.node1_base, this.node2_base, node3, xCoord_tmp, yCoord_tmp, this.Sp);
                    Qp(i) = quality;
                    if( node3 == this.node_best )            %为了尽量选择现有阵面上的点，将Pbest的质量降低一点
                        Qp(i) = this.coeff * Qp(i);
                    end
                end
                %%
                %按质量参数逐一选择点，判断是否与临近阵面相交，如相交则下一个候选点，如不相交，则选定该点构成新的三角形
                Qp_sort = sort(Qp, 'descend');
                node_select = -1;
                
                for i = 1 : lenNodeCandidate
                    node_test_list = nodeCandidate_AFT( Qp==Qp_sort(i) );
                    %%     %除判断相交外，还需判断是否构成左单元，只选择构成左单元的点
                    for j = 1:length(node_test_list)
                        node_test = node_test_list(j);
                        
                        flagNotCross1 = IsNotCross(this.node1_base, this.node2_base, node_test, ...
                            frontCandidate, this.AFT_stack, xCoord_tmp, yCoord_tmp ,0);
                        if flagNotCross1 == 0
                            continue;
                        end
                        
                        flagNotCross2 = IsNotCross(this.node1_base, this.node2_base, node_test, ...        %除判断相交外，还需判断是否构成左单元，只选择构成左单元的点
                            faceCandidate, this.Grid_stack, xCoord_tmp, yCoord_tmp,0);
                        if flagNotCross2 == 0
                            continue;
                        end
                        
                        flagLeftCell = IsLeftCell(this.node1_base, this.node2_base, node_test, xCoord_tmp, yCoord_tmp);
                        if flagLeftCell == 0
                            continue;
                        end
                        
                        if node_test == this.node_best
                            %                 flagClose = IsPointClose2Edge([Grid_stack;AFT_stack], xCoord_tmp, yCoord_tmp, node_test);
                            %                 if flagClose == 1
                            %                     continue;
                            %                 end
                            
                            %                 flagClose2 = IsEdgeClose2Point([node1_base,node_test], xCoord_tmp, yCoord_tmp, node2_base);
                            %                 flagClose3 = IsEdgeClose2Point([node2_base,node_test], xCoord_tmp, yCoord_tmp, node1_base);
                            %                 if flagClose2 == 1 || flagClose3 == 1
                            %                     continue;
                            %                 end
                        end
                        
                        node_select = node_test;
                        break;
                    end
                    
                    if node_select ~= -1
                        break;
                    end
                end
            end
            
            if(node_select == this.node_best)    %只有在选择了新生成的点时，才需要将新点坐标存下来
                flag_best = 1;
                Pselect = [x_best, y_best];
            else
                flag_best = 0;
                this.node_best = this.node_best - 1;
                Pselect = [];
            end
        end
    end
end

