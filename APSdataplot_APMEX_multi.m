%%%% APS data %%%%
%%%% 09 October 2004 %%%%%
%%%% Exported as rows and comma delimited 
%%%% NOTE %%%%% This doesn't handle time gaps well ... (it will fill in missing data with adjacent values??)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
contbins = 24;
dlogDp = 0.0312;
threshold = [1 10000]; % one number = autoscale, two numbers specify range of axes
% timerange = [291 293];
timerange = [];
timerange = [289.7917 310.4167];%%%%%ATOFMS sampling time
% timerange = [290.083 290.333] %%LST 07:00 - 13:00
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % flight1_2:  timerange = [290.083 290.333] %%LST 07:00 - 13:00

%%% Select aps files to plot
% October 08 - October 31
% first_day = 08;
% last_day = 08;
% for i = first_day:last_day 
%     apsfile{i} = sprintf('C:\\Data\\APMEX\\APS\\200410%02dapsdNdlogDp_row.txt',i);%  %02d gives number as 01, 12, etc.
% end
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
% apsfile{12} = 'C:\Data\APMEX\APS\20041018aps.txt'; %
% apsfile{13} = 'C:\Data\APMEX\APS\20041019aps.txt'; 
% apsfile{14} = 'C:\Data\APMEX\APS\20041020aps.txt'; 
% apsfile{15} = 'C:\Data\APMEX\APS\20041021aps.txt'; 
% apsfile{16} = 'C:\Data\APMEX\APS\20041022aps.txt'; 
% apsfile{17} = 'C:\Data\APMEX\APS\20041023aps.txt'; 
% apsfile{18} = 'C:\Data\APMEX\APS\20041024aps.txt'; 

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

%% Setup up figure windows
scrsz = get(0,'ScreenSize');
figrect = [0.05*scrsz(3) 0.6*scrsz(4) 0.9*scrsz(3) 0.3*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);

%%%%%% APS data analysis %%%%%%
%%concatenate files into a single matrix by appending new matrix onto existing one
for i = 1:length(apsfile)
    [jt sbin zdata] = getAPSmatrix(apsfile{i});% julian time, size bins, data
    if i == 1
        jt_full = jt;
        zdata_full = zdata;
    else
        jt_full = [jt_full;jt];
        zdata_full = [zdata_full zdata];
    end
end
clear jt zdata
jt = jt_full;
zdata = zdata_full;
clear jt_full zdata_full

for i = 1:length(zdata)
    TotalConc(i) = sum(zdata(:,i)) * dlogDp; % calculates as N/cm^3;
end

Z = log10(zdata + eps);
zbin = thresholdbar(Z, log10(threshold), contbins);

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
subplot(2,1,1); plot(jt,TotalConc)
set(gca,'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
axis('tight');
if length(timerange) == 2; set(gca, 'XLim', timerange); end;
% set(gca,'Axis','Visible','off');
ylabel('Total number concentration (#/cm^3)');
toc
