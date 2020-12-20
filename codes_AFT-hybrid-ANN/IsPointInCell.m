function flagInCell = IsPointInCell(cellNodeTopo, xCoord, yCoord, node_test,nodeCandidate)
flagInCell = 0;

node0_ori = [xCoord(node_test),yCoord(node_test)];
nCells = size(cellNodeTopo,1);

for i = 1:nCells
    cell = cellNodeTopo(i,:);
    cell(cell==0) = [];
    cell(cell==-11) = [];
    cell(cell==-22) = [];
%     cell = unique(cell,'stable');
    if sum( node_test == cell ) ~= 0
        flagInCell = 0;
        return;
    end
end
    
for i = 1:nCells
    cell = cellNodeTopo(i,:);
    
    node1Index = cell(1);
    node2Index = cell(2);
    node3Index = cell(3);
    node4Index = cell(4);
    if sum(node1Index == nodeCandidate) == 0 && sum(node2Index == nodeCandidate) == 0 && ...
            sum(node3Index == nodeCandidate) == 0 && sum(node4Index == nodeCandidate) == 0
        continue;
    end

    cell(cell==0) = []; 
    cell(cell==-11) = [];
    cell(cell==-22) = [];
%     cell = unique(cell,'stable');
    if i == 14
        kkk = 1;
    end
    
    if length(cell)==3
        node1 = [xCoord(cell(1)),yCoord(cell(1))];
        node2 = [xCoord(cell(2)),yCoord(cell(2))];
        node3 = [xCoord(cell(3)),yCoord(cell(3))]; 
        
        [node0(1), node0(2)] = Transform( node0_ori, node1, node2 );
        [node3(1), node3(2)] = Transform( node3, node1, node2 );
        node1 = [0,0]; node2 = [1,0];    
        
        area0 = AreaTriangle(node1, node2, node3);
        area1 = AreaTriangle(node0, node1, node2);
        area2 = AreaTriangle(node0, node1, node3);
        area3 = AreaTriangle(node0, node2, node3);
        
        if abs(area0-area1-area2-area3) <1e-3 %...
%                 && abs(area0) > 1e-5 && abs(area1) > 1e-5 ...
%                 && abs(area2) > 1e-5 && abs(area3) > 1e-5              
           flagInCell = 1;
           break;
        end
        
    elseif length(cell)==4
        node1 = [xCoord(cell(1)),yCoord(cell(1))];
        node2 = [xCoord(cell(2)),yCoord(cell(2))];
        node3 = [xCoord(cell(3)),yCoord(cell(3))];     
        node4 = [xCoord(cell(4)),yCoord(cell(4))]; 
        
        [node0(1), node0(2)] = Transform( node0_ori, node1, node2 );
        [node3(1), node3(2)] = Transform( node3, node1, node2 );
        [node4(1), node4(2)] = Transform( node4, node1, node2 );
        node1 = [0,0]; node2 = [1,0];
        
        area0 = AreaQuadrangle(node1, node2, node3, node4);
        area1 = AreaTriangle(node0, node1, node2);
        area2 = AreaTriangle(node0, node2, node3);
        area3 = AreaTriangle(node0, node3, node4);
        area4 = AreaTriangle(node0, node4, node1);  
        
        if abs(area0-area1-area2-area3-area4) <1e-3 %...
%                 && abs(area0) > 1e-5 && abs(area1) > 1e-5 ...
%                 && abs(area2) > 1e-5 && abs(area3) > 1e-5 && abs(area4) > 1e-5       
            flagInCell = 1;
            break;
        end
    end
end


