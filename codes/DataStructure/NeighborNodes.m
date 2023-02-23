function neighbors = NeighborNodes(node_base, AFT_stack, node)

% neighbors=[];
% for i = 1: size(AFT_stack,1)
%     if( AFT_stack(i,1)== node_base && AFT_stack(i,2) ~= node)
%         neighbors(end+1) = AFT_stack(i,2);
%     end
%     if( AFT_stack(i,2) == node_base && AFT_stack(i,1) ~= node)
%         neighbors(end+1) = AFT_stack(i,1);
%     end
% end
% neighbors = unique(neighbors);
% end

%%
neighbors=zeros(1,1000);
count = 0;
for i = 1: size(AFT_stack,1)
    if( AFT_stack(i,1)== node_base && AFT_stack(i,2) ~= node)
        count = count + 1;
        neighbors(count) = AFT_stack(i,2);        
    end
    if( AFT_stack(i,2) == node_base && AFT_stack(i,1) ~= node)
        count = count + 1;
        neighbors(count) = AFT_stack(i,1);
    end
end
% neighbors(neighbors==0)=[];
neighbors(count+1:end)=[];
neighbors = unique(neighbors);
end
