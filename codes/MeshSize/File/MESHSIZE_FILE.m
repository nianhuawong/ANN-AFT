classdef MESHSIZE_FILE < handle
    properties
        stepSizeFile;
        SpField;
        backGrid;
        backCoord;
    end
    
    methods
        function this = MESHSIZE_FILE(stepSizeFile)
            this.stepSizeFile = stepSizeFile;
            
            this.InitStepSizeFieldFromFile();
        end
        
        function InitStepSizeFieldFromFile(this)
            [this.SpField, this.backGrid, this.backCoord] = StepSizeField(this.stepSizeFile, 0);
        end
        
        function Sp = GetSp(this, x, y)
            Sp = StepSize(x, y, this.SpField, this.backGrid, this.backCoord);
        end
    end
end

