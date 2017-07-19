function [phddatA,phddatB]=plotphdrange(InIntens,Size,range,fid)

% warning off
% SpeedTol=2; % +/- tolerence interval to select psl size = +/- 
% intensarray={'saarea' 'sbarea'};
% NumBin=25;
% for j = 1:length(range)
% SelectPsl{j}=run_query(InId{j},sprintf('Da > %d and Da < %d'...
%     ,range{i}(1),range{i}(2)));
% end
% idx1=0;
% for counter1=1:length(intensarray)
%     figure
%     for i = 1:length(range)
%         SelectPsl{i}=run_query(InId,sprintf('Da > %d and Da < %d'...
%             ,range{i}(1,1),range{i}(1,2)));        
%         [intens,Size] = get_column(SelectPsl{i},eval(sprintf('intensarray{%d}'...
%             ,counter1)),'Da'); % make columns of speed and size for different psl samples defined above

[idx] = find(Size > range(1) & Size < range(2));'
intens = InIntens(idx);
[counts,centers] = hist(intens,NumBin);% vector of intensity histogram counts

% if counts==0
%     continue
% else
    ModDat=[centers',counts'/sum(counts)]; % histogram data in [x,y] pairs where x=intensity and y=histogram frequency
    subplot(4,3,i),plot(ModDat(:,1),ModDat(:,2)); % these next few lines make the intensity histogram plots
    xlabel(sprintf('%s (arb units)',intensarray{counter1}),'FontSize',10)
    ylabel('frequency','FontSize',10)
    title(sprintf('PHDs from %g to %g',range{i}(1),range{i}(2)),'FontSize',10)
    set(gca, 'XMinorTick', 'on')
    set(gca, 'xticklabel', floor(min(centers)):ceil((max(centers)...
        -min(centers))/10):ceil(max(centers)))
    set(gca, 'xtick', floor(min(centers)):ceil((max(centers)...
        -min(centers))/10):ceil(max(centers)))
    set(gca, 'FontSize', 6)
    %             if counter1==1
    %                 phddatA{i}=[ModDat(:,1),ModDat(:,2)];
    %             elseif counter1==2
    %                 phddatB{i}=[ModDat(:,1),ModDat(:,2)];
    %             end
    clear edges
% end
%     end
%     str={'A' 'B'};
%     FileName = sprintf('PHD%s%s.fig',str{counter1},fid); % Names the file (differently) for each cluster
%     saveas (gcf,FileName, 'fig');
%     close
% end

