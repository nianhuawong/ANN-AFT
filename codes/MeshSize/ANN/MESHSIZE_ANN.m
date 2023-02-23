classdef MESHSIZE_ANN < handle
    
    properties
        sampleType;
        maxWdist;
        Grid_stack;
        Grid_coord;
        nn_fun;
    end
    
    methods
        function this = MESHSIZE_ANN(paraObj, boundaryDataObj)
            this.Grid_stack = boundaryDataObj.Grid_stack;
            this.Grid_coord = boundaryDataObj.Grid_coord;
            
            this.sampleType = paraObj.sampleType;
            this.nn_fun = paraObj.nn_step_size;
            
            this.ComputeMaxWallDist();
        end
        
        function ComputeMaxWallDist(this)
            this.maxWdist = ComputeMaxWallDist(this.Grid_stack, this.Grid_coord);
        end
        
        function Sp = GetSp(x, y)
            Sp = this.StepSize_ANN(x, y);
        end
        
        function Sp = StepSize_ANN(xx, yy)
            [wdist, index ] = ComputeWallDistOfNode(this.Grid_stack, this.Grid_coord, xx, yy, 3);
            [wdist2,index2] = ComputeWallDistOfNode(this.Grid_stack, this.Grid_coord, xx, yy, 9);
            term1 = 1.0/Grid(index,5 )^(1.0/6);
            term2 = 1.0/Grid(index2,5)^(1.0/1);
            
            if this.sampleType == 1  %ANN第1种输入
                input = [xx,yy]';
                Sp = this.nn_step_size(input) * this.Grid_stack(index2,5);
            elseif this.sampleType == 2  %ANN第2种输入
                input = [(wdist)^(1.0/6)]';
                %             Sp = ( nn_step_size(input)^6 ) / term1;   %物面
                Sp = ( this.nn_step_size(input)^6 ) / term2;     %远场
                
                %             input = [log10(wdist+1e-10)]';
                %             Sp = 10^nn_step_size(input) * Grid(index2,5);
                %             maxSp = sqrt(3.0) / 2.0 * BoundaryLength(Grid);
                %             if Sp > maxSp
                %                 Sp = maxSp;
                %             end
            elseif this.sampleType == 3  %ANN第3种输入
                input = [(wdist/this.maxWdist)^(1.0/6)]';
                if wdist/this.maxWdist < 0.25
                    Sp = (this.nn_step_size(input)^6) / ( term1 + term2 );   %物面
                else
                    Sp = (this.nn_step_size(input)^6) / term2;                   %远场
                end
                kkk = 1;
            end
            
            if length(Sp)>1 || Sp <= 0
                disp('ANN输出的网格步长错误！请检查！')
                quit();
            end
        end
    end
end 
