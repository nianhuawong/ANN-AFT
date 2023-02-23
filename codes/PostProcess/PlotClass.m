classdef PlotClass < handle
    
    properties
        flag_label;
        label_points = 0;
        max_num_points = 100000; %最大支持点数
    end
    
    methods
        function this = PlotClass(label_points)
            this.label_points = label_points;
            this.flag_label   = zeros(1, this.max_num_points);
        end
        
        function PlotBoundary(this, DataObj)
            this.PLOT(DataObj.BC_stack, DataObj.BC_coord(:, 1), DataObj.BC_coord(:, 2));
        end
        
        function PlotGrid(this, DataObj)
            this.PLOT(DataObj.Grid_stack, DataObj.Grid_coord(:, 1), DataObj.Grid_coord(:, 2));
        end
        
        function PLOT(this, AFT_stack, xCoord, yCoord)
            fig = figure;
            fig.Color = 'white'; hold on;
            len = size(AFT_stack,1);
            for i = 1:len
                node1 = AFT_stack(i,1);
                node2 = AFT_stack(i,2);
                
                dist = DISTANCE(node1,node2,xCoord,yCoord);
                
                xx = [xCoord(node1),xCoord(node2)];
                yy = [yCoord(node1),yCoord(node2)];
                
                plot( xx, yy, '-r','LineWidth',1); %'MarkerSize',14
                hold on;
            end
            
            nodeList = AFT_stack(:,1:2);
            nNodes = max( max(nodeList)-min(nodeList)+1 );
            for i = 1 : nNodes
                str = num2str(i);
                if  this.flag_label(i) == 0 && this.label_points == 1
                    text(xCoord(i)+0.00005*dist,yCoord(i)+0.00005*dist,str, 'Color', 'red', 'FontSize', 9)
                    this.flag_label(i) = 1;
                end
            end
            axis equal;
            axis off;
        end
        
        function PLOT_NEW_FRONT(this, AFT_stack, xCoord, yCoord, num, flag_best)
            for i = 1:num
                node1 = AFT_stack(end-i+1,1);
                node2 = AFT_stack(end-i+1,2);

                dist = DISTANCE(node1,node2,xCoord,yCoord);
                
                xx = [xCoord(node1),xCoord(node2)];
                yy = [yCoord(node1),yCoord(node2)];
                
                if flag_best == 1
                    plot( xx, yy, 'r-');  %,'MarkerSize',14
                else
                    plot( xx, yy, 'b-');
                end
                
                hold on;
                
                if this.flag_label(node1) == 0 && this.label_points == 1
                    text(xCoord(node1)+0.05*dist,yCoord(node1),num2str(node1), 'Color', 'red', 'FontSize', 9)
                    this.flag_label(node1) = 1;
                end
                if this.flag_label(node2) == 0 && this.label_points == 1
                    text(xCoord(node2)+0.05*dist,yCoord(node2),num2str(node2), 'Color', 'red', 'FontSize', 9)
                    this.flag_label(node2) = 1;
                end
            end
            axis equal
            axis off;
            hold on;
            pause(0.000001);
        end
    end
end
    
