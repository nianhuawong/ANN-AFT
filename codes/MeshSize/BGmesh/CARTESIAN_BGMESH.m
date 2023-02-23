classdef CARTESIAN_BGMESH < handle
    properties
        bgmesh_dim = [0, 0];
        bgmesh_ds = [0, 0];
        SourceInfo;
        range;
        xCoord;
        yCoord;
        Boundary_stack;
        Boundary_coord;
    end
    
    methods
%         function this = CARTESIAN_BGMESH(boundaryDataObj)
% %             this.Boundary_stack = boundaryDataObj.BC_stack;
% %             this.Boundary_coord = boundaryDataObj.BC_coord;
%         end
        
        function InitCartesianBGmesh(this)
            [this.range,this.xCoord,this.yCoord] = RectangularBackgroundMesh(this.Boundary_stack, this.Boundary_coord, this.bgmesh_dim);
            this.bgmesh_ds = [this.range(2)-this.range(1), this.range(4)-this.range(3)]./ (this.bgmesh_dim - 1);
        end
        
        function CalculateSourceFromBoundary(this, type)
            this.SourceInfo = CalculateSourceInfo(this.Boundary_stack, this.Boundary_coord, type);
        end
        
        function ReduceSourcesByGreedy(this)
            [~,SelectedSourcesIndex] = CalculateSpByRBF_Greedy(this.SourceInfo, this.range, this.bgmesh_ds);    %贪婪算法
            this.SourceInfo = this.SourceInfo(SelectedSourcesIndex,:);
        end
        
        function Sp = GetSp(x, y)
            Sp = Interpolate2Grid(x, y, this.SpField, this.range);
        end
%         PLOT_Background_Grid(xcoord,ycoord);
    end
end

