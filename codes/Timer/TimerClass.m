classdef TimerClass < handle
    
    properties
        tstart;
        timeSpan;
        totalTime;
    end
    
    methods
        function this = TimerClass()
            this.timeSpan  = 0.0;
            this.totalTime = 0.0;
        end
        
        function ReStart(this)
            this.tstart = tic;
        end
        
        function AccumulateTime(this)
            this.totalTime = this.totalTime + this.timeSpan;
        end
        
        function ClearTotalTime(this)
            this.totalTime = 0.0;
        end
        
        function Span(this, disp)
            this.timeSpan = toc(this.tstart);
            if disp
                disp(['Time span = ', num2str(this.timeSpan)]);
            end
            this.ReStart();
        end
    end
end

