function [PslPhdDatA,PslPhdDatB] = PslPhds(InDat,Sizes,NumBin)

%%% This script makes pulse height distributions (PHDs) for a sample of
%%% psls
%%%
%%% INPUT %%%
%%% InDat is a cell array of Psl pids
%%% Sizes is a vector of sizes for each psl sample
%%% NumBin is the number of bins to be used in making the pulse height
%%% distributions
%%%
%%% OUTPUT %%%
%%% PslPhdDat a cell array with each element being the following matrix:
%%%           [Intensity,NormalizedCounts]
%%%
figure, 
for i = 1:length(InDat)  %%% Loop throught Psl pid array
    
    %%% Define size range and intensities 
    range = [Sizes(i)-Sizes(i)*0.2,Sizes(i)+Sizes(i)*0.2]; 
    SizeB = InDat{i}(:,2);
    SizeA = SizeB;
    InIntensA = InDat{i}(:,3);
    InIntensB = InDat{i}(:,4);
    [idxA] = find(SizeA > range(1) & SizeA < range(2));
    [idxB] = find(SizeB > range(1) & SizeB < range(2));
    
    %%% Take only intensities in the size range
    intensA = InIntensA(idxA);
    intensB = InIntensB(idxB);
    
    %%% Bin Data 
    xmax = max([intensA;intensB]);
    bincent = 0:(xmax/NumBin):xmax;
    [countsA,centersA] = hist(intensA,bincent);
    [countsB,centersB] = hist(intensB,bincent);
    
    %%% Normalize binned counts 
    DistYA=[centersA',countsA'/sum(countsA)]; 
    DistYB=[centersB',countsB'/sum(countsB)]; 
    
    %%% Compute error assuming Poisson
    errA = DistYA(:,2).*(sqrt(countsA)./countsA)';
    errB = DistYB(:,2).*(sqrt(countsB)./countsB)';
    
    %%% Make the figure with error bars
    subplot(ceil(length(InDat)/2),2,i),
    errorbar(DistYA(:,1),DistYA(:,2),errA,errA,'r.-'),hold on,
    errorbar(DistYB(:,1),DistYB(:,2),errB,errB,'b.-'),hold off,
    
    %%% Label the figure
    xlabel('R (cm^{2}/particle)','FontSize',12)
    ylabel('Normalized Counts','FontSize',12)
    title(sprintf('PHDs from %g to %gum',range(1),range(2)),'FontSize',12)
    legend({'PMTA','err','PMTB','err'})
    
    %%% Define output
    PslPhdDatA{i} = [DistYA,errA];
    PslPhdDatB{i} = [DistYB,errB];
    
    %%% Clear variables for next iteration
    clear range errA errB SizeA SizeB IntensA IntensB
end