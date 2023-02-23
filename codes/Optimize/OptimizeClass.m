classdef OptimizeClass < handle
    
    properties
        adfrontObj;
        boundaryDataObj;
        delaunayTriMesh;
        invalidCellIndex;
        
        xCoord;
        yCoord;
        BC_nodes;
        Wall_nodes;
        
        xCoord_opt;
        yCoord_opt;
    end
    
    methods
        function this = OptimizeClass(boundaryDataObj,adfrontObj)
            this.boundaryDataObj = boundaryDataObj;
            this.adfrontObj = adfrontObj;
            this.xCoord = this.adfrontObj.xCoord_AFT;
            this.yCoord = this.adfrontObj.yCoord_AFT;
            this.BC_nodes = this.boundaryDataObj.BC_nodes;
            this.Wall_nodes = this.boundaryDataObj.Wall_nodes;
        end
        
        function EdgeSwap(this)
            %% Delaunay对角线变换
            [this.delaunayTriMesh,this.invalidCellIndex] = DelaunayMesh(this.xCoord, this.yCoord, this.Wall_nodes);
            this.GridSummaryDelaunayMesh();
        end
        
        function GridSummaryDelaunayMesh(this)
            GridQualitySummaryDelaunay(this.delaunayTriMesh, this.invalidCellIndex);
        end
        
        function SpringOptimize(this, nsteps)
            [this.xCoord_opt, this.yCoord_opt] = SpringOptimize(this.delaunayTriMesh, this.invalidCellIndex, this.BC_nodes, nsteps);
            GridQualitySummaryDelaunay(this.delaunayTriMesh, this.invalidCellIndex, this.xCoord_opt, this.yCoord_opt);
        end
        
        function CombineTriangles(this)
            %% 用变形优化后的网格合并
            combinedMesh = CombineMesh(triMesh, this.invalidCellIndex, this.BC_nodes, 0.5, this.xCoord_opt, this.yCoord_opt);
            GridQualitySummary(combinedMesh, this.xCoord_opt, this.yCoord_opt);
        end
    end
end

