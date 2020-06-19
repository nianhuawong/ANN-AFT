function quality = QualityCheckQuad(node1, node2, node3, node4, xCoord_AFT, yCoord_AFT, Sp)

dist12  = DISTANCE(node1, node2, xCoord_AFT, yCoord_AFT);
dist13  = DISTANCE(node1, node3, xCoord_AFT, yCoord_AFT);
dist24  = DISTANCE(node2, node4, xCoord_AFT, yCoord_AFT);
dist34  = DISTANCE(node3, node4, xCoord_AFT, yCoord_AFT);

v12 = [xCoord_AFT(node2)-xCoord_AFT(node1), yCoord_AFT(node2)-yCoord_AFT(node1)];

v13 = [xCoord_AFT(node3)-xCoord_AFT(node1), yCoord_AFT(node3)-yCoord_AFT(node1)];

v24 = [xCoord_AFT(node4)-xCoord_AFT(node2), yCoord_AFT(node4)-yCoord_AFT(node2)];

v34 = [xCoord_AFT(node4)-xCoord_AFT(node3), yCoord_AFT(node4)-yCoord_AFT(node3)];

quality = 1.0 / ( ( 2.0 * dist13/dist12 - Sp ) +( 2.0 * dist24/dist12 - Sp ) + abs(v12 * v13') + abs(v12 * v24'));

quality = Sp * quality / 0.5; 
end