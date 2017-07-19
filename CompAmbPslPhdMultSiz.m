function [PslPhdDatA] = CompAmbPslPhdMultSiz(InDat,Sizes,NumBin,varargin)

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
for i = 1:length(Sizes)  %%% Loop throught Psl pid array
    
    %%% Define size range and intensities 
    range = [Sizes(i)-Sizes(i)*0.05,Sizes(i)+Sizes(i)*0.05]; 
    SizeA = InDat(:,1);
    InIntensA = InDat(:,2);
    [idxA] = find(SizeA > range(1) & SizeA < range(2));
    
    %%% Take only intensities in the size range
    intensA = InIntensA(idxA);
    
    %%% Bin Data 
    xmax = 4*mean(intensA);
    bincent = 0:(xmax/NumBin):xmax;
    [countsA,centersA] = hist(intensA,bincent);
    
    %%% Normalize binned counts 
    DistYA=[centersA',countsA'/sum(countsA)]; 
    
    %%% Compute error assuming Poisson
    errA = DistYA(:,2).*(sqrt(countsA)./countsA)';
    
    %%% Make the figure with error bars
    subplot(ceil(length(Sizes)/2),2,i),
    errorbar(DistYA(:,1),DistYA(:,2),errA,errA,'r.-')
%     xlim([0,xmax]);
    legendstr{1}='AllEC B'
    legendstr{2}='err'
    if nargin == 4
        hold on,
        errorbar(varargin{1}{i}(:,1),varargin{1}{i}(:,2),...
            varargin{1}{i}(:,3),varargin{1}{i}(:,3),'b.-')
        legendstr{3}='PSL B';
        legendstr{4}='err';
    end
    %%% Label the figure
    xlabel('R (cm^{2}/particle)','FontSize',10)
    ylabel('Normalized Counts','FontSize',10)
    title(sprintf('PHDs from %g to %gum',range(1),range(2)),'FontSize',10)
    set(gca,'FontSize',9)
    legend(legendstr)

    %%% Define output
    PslPhdDatA{i} = [DistYA,errA];
    
    %%% Clear variables for next iteration
    clear range errA SizeA IntensA 
end