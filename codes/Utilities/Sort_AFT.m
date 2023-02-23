function AFT_stack = Sort_AFT(AFT_stack)
if isempty(AFT_stack)
    return;
end

AFT_stack_tmp = AFT_stack;
for i =1:size(AFT_stack,1)
    if AFT_stack(i,7) == 3 || AFT_stack(i,7) == 9 
        AFT_stack_tmp(i,5) =0.00001* AFT_stack(i,5);
    end
end
 
[~,index] = min(AFT_stack_tmp(:,5));
tmp = AFT_stack(index,:);
AFT_stack(index,:) = AFT_stack(1,:);
AFT_stack(1,:) = tmp;
end