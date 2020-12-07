function [node_select,coordX, coordY, flag_best] = GenerateQuads_mode(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
    Sp, coeff, al, node_best, Grid_stack )
global stencilType useANN countMode_quad nn_fun_quad;
node_select = [-1,-1];
flag_best   = [0, 0];
flag_tri    = 0;
% node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
% node2_base = AFT_stack_sorted(1,2);
% ds_base = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %��׼����ĳ���

%%
if useANN == 1 
    [x_best_quad, y_best_quad, Sp, mode, nodeIndex] = ADD_POINT_ANN_quad(nn_fun_quad, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType, Sp);   
else
    mode = 1;
    nodeIndex = [-1,-1];
    [x_best_quad, y_best_quad, Sp] = ADD_POINT_quad(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp);
end
                                                
% PLOT_CIRCLE(x_best_quad, y_best_quad, al, Sp, ds_base, node_best);
%%
if  length(x_best_quad) == 1 && length(y_best_quad) == 1
%     node_select = [-1,-1];
%     coordX = -1;
%     coordY = -1;
    flag_tri = 1;
end
    %% ���������ı��Σ�������ɵ��ı�������̫�����������������
if flag_tri == 0
    if mode == 1
        [node_select,coordX, coordY, flag_best] = GenerateQuads_mode1(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
            Sp, coeff, al, node_best, Grid_stack, x_best_quad, y_best_quad);
    elseif mode == 2
        [node_select,coordX, coordY, flag_best] = GenerateQuads_mode2(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
            Sp, coeff, al, node_best, Grid_stack, x_best_quad, y_best_quad, nodeIndex );
    elseif mode == 3
        [node_select,coordX, coordY, flag_best] = GenerateQuads_mode3(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
            Sp, coeff, al, node_best, Grid_stack, x_best_quad, y_best_quad, nodeIndex );
    elseif mode == 4
        [node_select,coordX, coordY, flag_best] = GenerateQuads_mode4(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
            Sp, coeff, al, node_best, Grid_stack, nodeIndex );
    end
end

if sum(node_select==-1)>0   
%     node_select = [-1,-1];
%     coordX = -1;
%     coordY = -1;
    flag_tri = 1;
end

if flag_tri == 0 && mode ~= 1
    countMode_quad = countMode_quad + 1;
end

if flag_tri == 1
    [node_select,coordX, coordY, flag_best] = GenerateTri_mode(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack);
    
    while node_select == -1
        al = 2 * al;
        [node_select,coordX, coordY, flag_best] = GenerateTri_mode(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack);
    end
end

end