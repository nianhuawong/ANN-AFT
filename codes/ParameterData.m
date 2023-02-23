classdef ParameterData < handle
    
    properties
%         boundaryFile    = '../grid/simple/tri.cas';
%         boundaryFile     = '../grid/inv_cylinder/tri/inv_cylinder-20.cas';
%         boundaryFile    = '../grid/naca0012/tri/naca0012-tri-coarse.cas';
        boundaryFile     = '../grid/inv_cylinder/tri/inv_cylinder-20.cas';
%         boundaryFile     = '../grid/RAE2822/rae2822.cas';
%         boundaryFile     = '../grid/30p30n/30p30n-fine.cas';%-small
        
        Sp_method = 2;         % 1-神经网络控制；2-非结构背景网格文件；3-矩形背景网格控制；4-RBF径向基函数
        label_points    = 0;   % 是否在图中输出点的编号
        
        sampleType = 2;
        nn_mode_predict = @net_naca0012_20201104;
        nn_step_size = @nn_mesh_size_naca_3;
    end
    
    methods
        function this = ParameterData()
            
        end
        
    end
end

