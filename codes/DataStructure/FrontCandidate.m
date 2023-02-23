function frontCandidate = FrontCandidate(AFT_stack, nodeCandidate)
frontCandidate = zeros(1,1000);
count = 0;
for i = 2:size(AFT_stack,1)
    node1 = AFT_stack(i,1);
    node2 = AFT_stack(i,2);      %��������2���㶼�Ǻ�ѡ�㣬��ô�������ڽ�����    
    if( sum(nodeCandidate == node1) ~= 0 || sum(nodeCandidate == node2) ~= 0 )
        count = count + 1;
        frontCandidate(count) = i;      
    end
end
% frontCandidate( frontCandidate == 0 ) = [];
frontCandidate(count+1:end) = [];
frontCandidate = unique(frontCandidate);