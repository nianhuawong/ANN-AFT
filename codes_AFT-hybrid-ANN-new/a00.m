PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1)
PLOT_NODES(xCoord_AFT, yCoord_AFT, -1)
PLOT_CIRCLE(x_best_quad, y_best_quad, al, Sp, ds, node_best)
PLOT_CIRCLE(x_best, y_best, al, Sp, ds, node_best);
[direction, row] = FrontExist(452,331, AFT_stack_sorted)
[direction, row] = CellExist(331,324,323,452, cellNodeTopo)