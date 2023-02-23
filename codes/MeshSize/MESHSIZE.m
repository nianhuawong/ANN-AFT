function meshSizeObj = MESHSIZE(paraObj, boundaryDataObj)
switch paraObj.Sp_method
    case 1
        meshSizeObj = MESHSIZE_ANN(paraObj, boundaryDataObj);
    case 2
        meshSizeObj = MESHSIZE_FILE(paraObj.boundaryFile);
    case 3
        meshSizeObj = MESHSIZE_DIFFUSION(boundaryDataObj);
    case 4
        meshSizeObj = MESHSIZE_RBF(boundaryDataObj);
    case 5
        meshSizeObj = 0;% MESHSIZE_OCTREE(boundaryDataObj);
end
end

