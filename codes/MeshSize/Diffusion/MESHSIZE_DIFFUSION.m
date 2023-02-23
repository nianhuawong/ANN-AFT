classdef MESHSIZE_DIFFUSION < CARTESIAN_BGMESH
    properties
        type = 1;
    end
    
    methods
        function this = MESHSIZE_DIFFUSION(boundaryDataObj)
            this.bgmesh_dim = [101, 101];
            
            this.Boundary_stack = boundaryDataObj.BC_stack;
            this.Boundary_coord = boundaryDataObj.BC_coord;
            
            this.InitCartesianBGmesh();
            
            this.CalculateSourceFromBoundary(this.type);
            
%             this.ReduceSourcesByGreedy();
            
%             this.InitialValue();
            
            this.SolveMeshSizeIteratively();
        end
        
        function SolveMeshSizeIteratively(this)
            [StepSize, LOWER, UPPER] = InitialValue(this.SourceInfo, this.range);
            this.SpField = Iterative_Solve(this.SourceInfo, StepSize, this.range, LOWER, UPPER);
        end
        
%         function InitialValue(this)
            
%         end
    end
end

