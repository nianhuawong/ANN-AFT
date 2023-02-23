classdef TimerManager < handle
    properties
        generateTimer;
        spTimer;
        updateTimer;
        plotTimer;
        totalTimer;
    end
    
    methods
        function this = TimerManager()
            this.generateTimer   = TimerClass();%生成时间
            this.spTimer         = TimerClass();%读取背景网格的时间
            this.updateTimer     = TimerClass();%更新结构时间
            this.plotTimer       = TimerClass();%画图时间
            this.totalTimer      = TimerClass();%总时间
        end
    end
end

