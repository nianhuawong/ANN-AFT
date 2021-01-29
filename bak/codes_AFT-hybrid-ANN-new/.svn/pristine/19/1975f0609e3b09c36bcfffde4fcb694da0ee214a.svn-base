function frontCandidate = FrontCandidate(AFT_stack, nodeCandidate)
frontCandidate = zeros(1,1000);
count = 1;
for i = 2:size(AFT_stack,1)
    node1 = AFT_stack(i,1);
    node2 = AFT_stack(i,2);      %如果阵面的2个点都是候选点，那么阵面是邻近阵面    
    if( size(find(nodeCandidate == node1), 2) ~= 0 || size(find(nodeCandidate == node2), 2) ~= 0 )
        frontCandidate(count) = i;
        count = count + 1;
    end
end
frontCandidate( frontCandidate == 0 ) = [];
frontCandidate = unique(frontCandidate);