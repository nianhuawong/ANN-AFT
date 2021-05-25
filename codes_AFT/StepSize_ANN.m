function Sp = StepSize_ANN(xx, yy, Grid, Coord, sampleType, nn_step_size, maxWdist)
[wdist, index ] = ComputeWallDistOfNode(Grid, Coord, xx, yy, 3);
[wdist2,index2] = ComputeWallDistOfNode(Grid, Coord, xx, yy, 9);
term1 = 1.0/Grid(index,5 )^(1.0/6);
term2 = 1.0/Grid(index2,5)^(1.0/1);

if sampleType == 1  %ANN第1种输入
    input = [xx,yy]';
    Sp = nn_step_size(input) * Grid(index2,5);
elseif sampleType == 2  %ANN第2种输入
    input = [(wdist)^(1.0/6)]';
    %             Sp = ( nn_step_size(input)^6 ) / term1;   %物面
    Sp = ( nn_step_size(input)^6 ) / term2;     %远场
    
    %             input = [log10(wdist+1e-10)]';
    %             Sp = 10^nn_step_size(input) * Grid(index2,5);
    %             maxSp = sqrt(3.0) / 2.0 * BoundaryLength(Grid);
    %             if Sp > maxSp
    %                 Sp = maxSp;
    %             end
elseif sampleType == 3  %ANN第3种输入
    input = [(wdist/maxWdist)^(1.0/6)]';
    if wdist/maxWdist < 0.15
        Sp = (nn_step_size(input)^6) / ( term1 + term2 );   %物面
    else
        Sp = (nn_step_size(input)^6) / term2;                   %远场
    end
    kkk = 1;
end

if length(Sp)>1 || Sp <= 0
    disp('ANN输出的网格步长错误！请检查！')
    quit();
end