function S = Iterative_Solve(SourceInfo,S,range)
global num_label flag_label gridDim dx dy;
xMin = range(1);% xMax = range(2);
yMin = range(3);% yMax = range(4);

S1 = S;
omega = 1.8;
flag = 1.0;
iter = 0;
%%
LOWER = zeros(gridDim,gridDim);
UPPER = zeros(gridDim,gridDim);
for i = 2:gridDim-1
    for j = 2:gridDim-1
        
        xNode = xMin + (i-1)*dx;
        yNode = yMin + (j-1)*dy;
        
        [lower, upper] = SourceImpact(SourceInfo,xNode, yNode);
        LOWER(i,j) = lower;
        UPPER(i,j) = upper;
    end
end
%%
while flag >1e-10
    if mod(iter, 10) == 0 
        tstart1 = tic;
    end
    
    error = 0;
    for i = 2:gridDim-1
        for j = 2:gridDim-1
            
%             xNode = xMin + (i-1)*dx;
%             yNode = yMin + (j-1)*dy;
            
%             [lower, upper] = SourceImpact(SourceInfo,xNode, yNode);
            lower = LOWER(i,j);
            upper = UPPER(i,j);
            
            fai = S1(i-1,j) + S(i+1,j) + S1(i,j-1) + S(i,j+1) + dx * dx * upper;
            fai = fai / (4.0 + dx * dx * lower);
            
            S1(i,j) = (1.0 - omega) * S(i,j) + omega * fai;
            
            error = error + abs(S1(i,j)- S(i,j));
        end
    end
    S = S1;
    error = error / (gridDim-1) / (gridDim-1);
    if error < 1e-8
        flag = 0;
    end
    iter = iter + 1;
    if mod(iter, 100) == 0
        telapsed = toc(tstart1)
        iter
        error
    end
    
end
end