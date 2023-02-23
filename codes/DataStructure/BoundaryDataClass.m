classdef BoundaryDataClass < handle
    properties
        Grid_stack;
        Grid_coord;
        
        nBcTypes;
        n_of_type;
        
        BC_stack;
        BC_coord;
        BC_nodes;
        
        FAR_stack;
        FAR_coord;
        FAR_nodes;
        nFarNodes;
        
        nBoundaryNodes;
        nBoundaryFaces;
        
        Wall_stack;
        Wall_Coord;
        Wall_nodes;
        nWallNodes;
        
        BC_WALL = 3;        %BC=3为物面
        BC_FAR  = 9;        %BC=9为外场边界
        BC_INTERIOR = 2;    %BC=2为内部面
    end
    
    methods
        function this = BoundaryDataClass(boundaryFile)
            [this.Grid_stack, this.Grid_coord]  = read_grid(boundaryFile, 0);
            this.ConstructBoundaryInfo();
        end
        
        function ConstructBoundaryInfo(this)
            this.nBcTypes = 0;
            this.n_of_type = zeros(100,1);
            %%
            nFaces = size(this.Grid_stack, 1);
            for i = 1:nFaces
                bcType = this.Grid_stack(i, 7);
                if bcType ~= this.BC_INTERIOR
                    this.n_of_type(bcType) = this.n_of_type(bcType) + 1;
                end
            end
            this.nBcTypes = sum(this.n_of_type > 0);
            
            %% All BCs
            this.nBoundaryFaces = sum(this.n_of_type);
            this.BC_stack = zeros(this.nBoundaryFaces, 7);
            count = 1;
            for i = 1:nFaces
                bcType = this.Grid_stack(i, 7);
                if bcType ~= this.BC_INTERIOR
                    this.BC_stack(count,:) = this.Grid_stack(i, :);
                    this.BC_stack(count,3) = -1;
                    this.BC_stack(count,4) = 0;
                    
                    node1 = this.Grid_stack(i, 1);
                    node2 = this.Grid_stack(i, 2);
                    this.BC_nodes(end+1:end+2) = [node1, node2];
                    count = count + 1;
                end
            end
            this.BC_nodes = unique(this.BC_nodes);
            this.BC_coord = this.Grid_coord(this.BC_nodes, :);
            this.nBoundaryNodes = length(this.BC_nodes);
            
            %% BC_FAR
            nFarfieldFaces = this.n_of_type(this.BC_FAR);
            this.FAR_stack = zeros(nFarfieldFaces, 7);
            count = 1;
            for i = 1:nFaces
                bcType = this.Grid_stack(i, 7);
                if bcType == this.BC_FAR
                    this.FAR_stack(count,:) = this.Grid_stack(i, :);
                    this.FAR_stack(count,3) = -1;
                    this.FAR_stack(count,4) = 0;
                    
                    node1 = this.Grid_stack(i, 1);
                    node2 = this.Grid_stack(i, 2);
                    this.FAR_nodes(end+1:end+2) = [node1, node2];
                    count = count + 1;
                end
            end
            this.FAR_nodes = unique(this.FAR_nodes);
            this.FAR_coord = this.Grid_coord(this.FAR_nodes, :);
            this.nFarNodes = length(this.FAR_nodes);
            
            %% BC_WALL
            nWallFaces = this.n_of_type(this.BC_WALL);
            this.Wall_stack = zeros(nWallFaces, 7);
            count = 1;
            for i = 1:nFaces
                bcType = this.Grid_stack(i, 7);
                if bcType == this.BC_WALL
                    this.Wall_stack(count,:) = this.Grid_stack(i, :);
                    this.Wall_stack(count,3) = -1;
                    this.Wall_stack(count,4) = 0;
    
                    node1 = this.Grid_stack(i, 1);
                    node2 = this.Grid_stack(i, 2);
                    this.Wall_nodes(end+1:end+2) = [node1, node2];
                    count = count + 1;
                end
            end
            this.Wall_nodes = unique(this.Wall_nodes);
            this.Wall_Coord = this.Grid_coord(this.Wall_nodes, :);
            this.nWallNodes = length(this.Wall_nodes);
        end
    end
end

