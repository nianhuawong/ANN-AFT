function S = Iterative_Solve(SourceInfo,S,range, LOWER, UPPER)
global num_label flag_label gridDim dx dy;
disp('迭代求解网格密度场...');
xMin = range(1);% xMax = range(2);
yMin = range(3);% yMax = range(4);

omega =1.8;
flag = true;
iter = 0;
%%
while flag
    if mod(iter, 10) == 0 
        tstart1 = tic;
    end
    
%     error = 0;
    error = -1e40;
    for i = 2:gridDim-1
        for j = 2:gridDim-1          
%             xNode = xMin + (i-1)*dx;
%             yNode = yMin + (j-1)*dy;            
%             [lower, upper] = SourceImpact(SourceInfo,xNode, yNode);
            lower = LOWER(i,j);
            upper = UPPER(i,j);
            
            fai = S(i-1,j) + S(i+1,j) + S(i,j-1) + S(i,j+1) + dx * dx * upper;
            fai = fai / (4.0 + dx * dx * lower);
            
            S_new = (1.0 - omega) * S(i,j) + omega * fai;
            
            %error = error + abs(S_new- S(i,j));
            error = max(error, abs(S_new-S(i,j)));
            S(i,j) = S_new;
        end
    end
    
%     error = error / (gridDim-1) / (gridDim-1);
    if error < 5e-4
        flag = false;
    end
    iter = iter + 1;
    if mod(iter, 50) == 0
        telapsed = toc(tstart1)
        iter
        error
    end  
end
end