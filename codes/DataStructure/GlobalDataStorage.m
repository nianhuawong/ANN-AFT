classdef GlobalDataStorage < handle
    properties
        data1;
        data2;
        data3;
        data4;
        data5;
    end
    methods
        function this = DataStorage(data1, data2, data3, data4)
            switch nargin
                case 1
                    this.data1 = data1;
                case 2
                    this.data1 = data1;
                    this.data2 = data2;
                case 3
                    this.data1 = data1;
                    this.data2 = data2;
                    this.data3 = data3;
                case 4
                    this.data1 = data1;
                    this.data2 = data2;
                    this.data3 = data3;
                    this.data4 = data4;
            end
        end
    end
end