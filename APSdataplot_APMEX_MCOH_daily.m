%%%% APS data %%%%
%%%% 09 October 2004 %%%%%
%%%% Exported as rows and comma delimited 
%%%% NOTE %%%%% This doesn't handle time gaps well ... (it will fill in missing data with adjacent values??)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Daily plots of APS data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
contbins = 24;
threshold = [1 50]; % one number = autoscale, two numbers specify range of axes
% timerange = [291 293];
% timerange = [];
% timerange = [290.083 290.333] %%LST 07:00 - 13:00

timematrix = [281.7917 282.7917];
for i = 2:27
timematrix(i,:) = timematrix(i-1,:) + 1;
end

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % flight1_2:  timerange = [290.083 290.333] %%LST 07:00 - 13:00

%%% Select aps files to plot
% October 08 - October 31
%% October 1 = 275 Julian Day
i = 1;
apsfile{i} = 'C:\Data\APMEX\MCOH\APS\APS20041030.txt'; i = i+1;
apsfile{i} = 'C:\Data\APMEX\MCOH\APS\APS20041102.txt'; i = i+1;
clear i
% % % 
% % % first_day = 18;
% % % last_day = 31;
% % % del = 6;
% % % cnt_1 = first_day - del;
% % % cnt_2 = last_day - del;
% % % for i = cnt_1:cnt_2 
% % %     apsfile{i} = sprintf('C:\\Data\\\APMEX\\MCOH\APS\\200410%02daps.txt',i+del);%  %02d gives number as 01, 12, etc.
% % % end
% % % 
% % % for j = 1:2
% % %     apsfile{i+j} = sprintf('C:\\Data\\APMEX\\MCOH\\APS\\200411%02daps.txt',j);%  %02d gives number as 01, 12, etc.
% % % end


%% Setup up figure windows
scrsz = get(0,'ScreenSize');
figrect = [0.05*scrsz(3) 0.6*scrsz(4) 0.9*scrsz(3) 0.3*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
% f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);

%%%%%% APS data analysis %%%%%%
%%concatenate files into a single matrix by appending new matrix onto existing one
first = 1;
for i = first:length(apsfile)
[jt sbin zdata] = getAPSmatrix(apsfile{i});% julian time, size bins, data
    if i == first
        jt_full = jt;
        zdata_full = zdata;
    else
        jt_full = [jt_full;jt];
        zdata_full = [zdata_full zdata];
    end
end
clear jt zdata

for i = 2:length(jt_full)
    if jt_full(i) < jt_full(i-1)
        jt_full(i)
        i
    end
end

% for i = first:length(timematrix)
for i = 24:27
    timerange = [timematrix(i,1) timematrix(i,2)];
    
    cnt  = 0;
    for j = 1:length(jt_full)
        if ( jt_full(j) >= timerange(1) ) 
            if ( jt_full(j) <= timerange(2) )
                cnt = cnt + 1;
                jt(cnt) = jt_full(j);
                zdata(:,cnt) = zdata_full(:,j);
            end
        end
    end
    
    %%%% calculates Total Concentration
    for i = 1:length(zdata)
        TotalConc(i) = sum(zdata(:,i));
    end
    
    Z = log10(zdata + eps);
    zbin = thresholdbar(Z, log10(threshold), contbins);
    
%%%%% Plot %%%%%
    f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);
    subplot(2,1,2)
    [C1 hcp] = contourf(jt, sbin, Z, zbin);
    % title(apsfile);
    set(hcp, 'EdgeColor', 'none');
    set(gca, 'YScale', 'log', 'YLim', [0.5 5], 'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
    set(gca,'YTick', [.5 1 2 3 4 5],'YTickLabel',{'.5';'1';'2';'3';'4';'5'});
    if length(timerange) == 2; set(gca, 'XLim', timerange); end;
    ylabel('diameter (um)');
    hc = thcolorbar('APS dN/dlog Dp (cm^{-3} um^{-1})');
    
    % figure
    subplot(2,1,1); plot(jt,TotalConc);
    set(gca,'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
    axis('tight');
    if length(timerange) == 2; set(gca, 'XLim', timerange); end;
    % set(gca,'Axis','Visible','off');
    ylabel('Total number concentration (#/cm^3)');
end
toc
