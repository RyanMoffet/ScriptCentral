function [ClassDistsOut]=MakeClassSizDist(StdDist,ClassDists,SizBins)

%% This script comes up with a nice continous size distribution when the hourly
%% scaled counts are too low.

%% StdDist is the standard size distribution: usually APS and SMPS with time going in the 
%%         rows and size in the columns
%% ClassDists is a cell array of the size distributions for the particle classes. Each cell 
%%         has the same dimension as StdDist
%% SizBins is a vector of size bins
%% ClassDistsOut is a cell array of the "scaled" class size distributions. This has the same
%%         dimensions as ClassDists

SumDist=ClassDists{1};
for i=2:length(ClassDists)
    SumDist=SumDist+ClassDists{i};
end

SubMicIdx=find(SizBins<1.0);

for i=1:length(ClassDists)
    for j=1:length(StdDist(:,1))
        ModSca{i}(j,1)=sum(ClassDists{i}(j,1:SubMicIdx(end)))/...
            sum(SumDist(j,1:SubMicIdx(end)));
        ModSca{i}(j,2)=sum(ClassDists{i}(j,(SubMicIdx(end)+1):end))/...
            sum(SumDist(j,(SubMicIdx(end)+1):end));
    end
end

for i=1:length(ClassDists)
    for j=1:length(StdDists)
        ClassDistsOut{i}(j,1:1:SubMicIdx(end))=...
            