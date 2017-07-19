function [ClassDist,SmoothClassDist,SmoothClassSiz]=ClassFracDist(AtofmsDists,StdDists,SizBin)

%% AtofmsDist is a cell array of scaled ATOFMS class size distributions
%%            has columns of size and rows of time
%% StdDists are the size distributions (dn)
%%          has columns of size and rows of time
%% SizBin are the size bins

subidx=sort(find(SizBin<1));
supidx=sort(find(SizBin>1));

for i=1:length(AtofmsDists)-1
    for j=1:length(AtofmsDists{i}(:,1))
        SubNums{i}(j)=nansum(AtofmsDists{i}(j,subidx(1):subidx(end)));
        SupNums{i}(j)=nansum(AtofmsDists{i}(j,supidx(1):supidx(end)));
    end
    if i==1
        RunSubTot=SubNums{i};
        RunSupTot=SupNums{i};
    else
        RunSubTot=nansum([RunSubTot;SubNums{i}]);
        RunSupTot=nansum([RunSupTot;SupNums{i}]);
    end
end

for i=1:length(AtofmsDists)-1
    SubClassFrac{i}=SubNums{i}./RunSubTot;
    SupClassFrac{i}=SupNums{i}./RunSupTot;
end

SubDist=StdDists(:,subidx(1):subidx(end));
SupDist=StdDists(:,supidx(1):supidx(end));

for i=1:length(AtofmsDists)-1
    for j=1:length(StdDists(:,1))
        SubClassDist{i}(j,:)=[SubClassFrac{i}(j)*SubDist(j,:)];
        SupClassDist{i}(j,:)=[SupClassFrac{i}(j)*SupDist(j,:)];
        ClassDist{i}=[SubClassDist{i},SupClassDist{i}];
    end
end

for i=1:length(AtofmsDists)-1
    for j=1:length(StdDists(:,1))
        for k=3:length(ClassDist{i}(j,:))-3
            SmoothClassDist{i}(j,k-2)=nanmean(ClassDist{i}(j,k-2:k+2));
            if j==1
                SmoothClassSiz{i}(k-2)=nanmean(SizBin(k-2:k+2));
            end
        end
    end
end