classdef MESHSIZE_RBF < CARTESIAN_BGMESH
    properties
        SelectedSources
    end
    
    methods
        function this = MESHSIZE_RBF(boundaryDataObj)
            this.Boundary_stack = boundaryDataObj.BC_stack;
            this.Boundary_coord = boundaryDataObj.BC_coord;
            
            this.InitCartesianBGmesh();
            this.CalculateSourceFromBoundary();
%             this.SolveMeshSizeByRBF();
            this.SolveMeshSizeByRBF_Greedy();
        end
        
        function SolveMeshSizeByRBF_Greedy(this)
            [this.SpField,SelectedSourcesIndex] = CalculateSpByRBF_Greedy(this.SourceInfo, this.range);
            this.SelectedSources = this.SourceInfo(SelectedSourcesIndex,:);
        end
        
        function SolveMeshSizeByRBF(this)
            this.SpField = CalculateSpByRBF(this.SourceInfo, this.range);
        end
    end
end

