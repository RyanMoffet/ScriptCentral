%%%% APS data %%%%
%%%% 7 November 2004 %%%%%
%%%% John Holecek %%%%%
%%%% Exported as rows and comma delimited 
%%%% NOTE %%%%% This doesn't handle time gaps well ... (it will fill in missing data with adjacent values)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Daily plots of APS data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
newyear = datenum('31-Dec-2003 00:00');
fpath = 'C:\Data\APMEX\APS\Results\';%% path for saving

contbins = 24; threshold = [1 50]; %% for plotting
dlogDp = 0.0312;%% should double check this used in Total Concentration

%% sets time to plot one day, LST 
%% Adjust start and stop and duration to suit needs
%% Julian Day 282 = Oct 08
timematrix = [281.7917 282.7917];
for i = 2:29
timematrix(i,:) = timematrix(i-1,:) + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Select aps files 
%% October 1 = 275 Julian Day
apsfile{1} = 'C:\Data\APMEX\APS\20041007aps.txt'; %works
apsfile{2} = 'C:\Data\APMEX\APS\20041010_a_aps.txt'; %works
apsfile{3} = 'C:\Data\APMEX\APS\20041010_b_aps.txt'; %works
apsfile{4} = 'C:\Data\APMEX\APS\20041011aps.txt'; %only one data point
apsfile{5} = 'C:\Data\APMEX\APS\20041012aps.txt'; %works
apsfile{6} = 'C:\Data\APMEX\APS\20041014_a.txt'; %
apsfile{7} = 'C:\Data\APMEX\APS\20041015aps.txt'; %
apsfile{8} = 'C:\Data\APMEX\APS\20041016aps.txt'; %
apsfile{9} = 'C:\Data\APMEX\APS\20041017aps.txt'; %
apsfile{10} = 'C:\Data\APMEX\APS\20041017Weldingaps.txt'; %
apsfile{11} = 'C:\Data\APMEX\APS\20041017a_aps.txt'; %

first_day = 18;
last_day = 31;
del = 6;
cnt_1 = first_day - del;
cnt_2 = last_day - del;
for i = cnt_1:cnt_2 
    apsfile{i} = sprintf('C:\\Data\\APMEX\\APS\\200410%02daps.txt',i+del);%  %02d gives number as 01, 12, etc.
end
for j = 1:4
    apsfile{i+j} = sprintf('C:\\Data\\APMEX\\APS\\200411%02daps.txt',j);%  %02d gives number as 01, 12, etc.
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Setup up figure windows
scrsz = get(0,'ScreenSize');
figrect = [0.05*scrsz(3) 0.6*scrsz(4) 0.9*scrsz(3) 0.3*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
% f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);

%%%%%% APS data analysis %%%%%%
%%concatenate files into a single matrix by appending new matrix onto existing one
clear jt zdata jt_full zdata_full
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Loop through and make daily plots %%%%%
for i = first:length(timematrix)
    timerange = [timematrix(i,1) timematrix(i,2)];
    clear TotalConc Z zbin jt zdata
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
    for i = 1:size(zdata,2)
        TotalConc(i) = sum(zdata(:,i)) * dlogDp; % calculates as N/cm^3
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
    
    %%%%% Save and label figure
    doy = floor(mean(timerange));
    timestamp = (doy + newyear);
    month = datestr(timestamp,3);
    day = datestr(timestamp,7);
    FileName = sprintf('%sJulian%03d_%s%s',fpath,doy,month,day); % Names the file
    saveas (gcf,FileName, 'emf');
    saveas (gcf,FileName, 'fig');
    close  
end
toc
