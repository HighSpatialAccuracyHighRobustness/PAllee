function getMeanTrajectory(inputMaker,runFunc, batchSize)
    inputProperties = inputMaker();
    PAllee = runFunc(inputProperties);
    sizeTimeSpan = length(PAllee.totalCellNumber);
    trajectoryLog = zeros(batchSize, sizeTimeSpan);
       parfor iter = 1:batchSize
           PAlleeParallel = @runFunc(inputProperties);
           trajectoryLog(iter,:) = PAlleeParallel.totalCellNumber;
       end
end