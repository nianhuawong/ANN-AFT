classdef PostProcessClass < handle
    properties
        adfrontObj;
        timeManagerObj;
        optimizeObj;

    end
    
    methods
        function this = PostProcessClass(paraObj, adfrontObj, timeManagerObj)
            
            this.adfrontObj = adfrontObj;
%             this.optimizeObj = optimizeObj;
            this.timeManagerObj = timeManagerObj;
            
        end
        
        function DisplayFinalResults(this)
            DisplayResults(this.adfrontObj, 0, 'finalRes');
        end
    end
end

