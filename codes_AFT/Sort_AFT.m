function AFT_stack = Sort_AFT(AFT_stack)
if isempty(AFT_stack)
    return;
end

[~,index] = min(AFT_stack(:,5));
tmp = AFT_stack(index,:);
AFT_stack(index,:) = AFT_stack(1,:);
AFT_stack(1,:) = tmp;
end