function [Out] = RhPartCntHist(RHTim,RH,PDat)

%% RHSepDat{i,j}(k,l) is a cell array of matrices with i being the inid
%% index, j is the RH bin, k is the single particle index, and l is the
%% column index: 1=Time, 2=Size, 3=Saarea, 4=height
step=10;
RHBin=5:step:100;
%% The following loop marks the times when the RH matches the perscibed
%% bins
for i = 1:length(RHBin)-1  
    rhidx{i} = find(RH > RHBin(i) & RH < RHBin(i+1));
    RHBinC(i)=RHBin(i)+step/2;
end
% % % %% This makes a cell array of matrices for light scattering data
% % % for i = 1:length(inid)
% % %     [PDat{i}(:,1),PDat{i}(:,2),PDat{i}(:,3),PDat{i}(:,4)] = get_column(inid{i},...
% % %         'Time','Da','Saarea','Sbarea');
% % % end

%% This bins the ATOFMS data in the time bins given by the RH data assuming
%% the bins are an hour wide
for i = 1:length(PDat)
    for j = 1:length(RHTim)
        tidx{i,j} = find(PDat{i}(:,1) > (RHTim(j,1) - datenum(0,0,0,0.5,0,0)) & ...  %% gives index of particles in pid i, in time bin j
            PDat{i}(:,1) < (RHTim(j,1) + datenum(0,0,0,0.5,0,0)));
    end
end

for i = 1:length(PDat) %% loop over clusters
    for j = 1:length(rhidx) %% loop over rh bins
        RHSepidx{i,j}=tidx{i,rhidx{j}(1)};  %% this gives atofms times when the rh was a given value
        for k = 2:length(rhidx{j})
            RHSepidx{i,j}=union(RHSepidx{i,j},tidx{i,rhidx{j}(k)});
        end
%         RHSepDat{i,j} = PDat{i}(RHSepidx{i,j},:);
        Cnt(i,j)=length(RHSepidx{i,j});
    end
end

Out=[RHBinC',Cnt'];

% figure,
% plot(temp(:,1),temp(:,2)/sum(temp(:,2)));
% Out=[temp(:,1),temp(:,2)/sum(temp(:,2))];    