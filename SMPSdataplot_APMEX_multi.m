% % % function SMPSdataplot_TH(smpsfile)
% % %%%% Call as SMPSdataplot_TH_fn('C:\Data\CIFEX\Trinidad Head\APS_SMPS\SMPS\20040404smpsdNdlogDp_row.txt');
% % %%%% SMPS data %%%%
% % %%%% 03 April 2004 %%%%%
% % %%%% Exported as rows and comma delimited 
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % smpsfile = 'C:\Data\CIFEX\Trinidad Head\APS_SMPS\SMPS\20040404smpsdNdlogDp_row.txt';
% % 
% % %%% Select aps files to plot
% % % October 08 - October 31
% %  first_day = 1;
% %  last_day = 1;
% % % for i = first_day:last_day 
% % %     smpsfile{i} = sprintf('C:\\Data\\APMEX\\SMPS\\200410%02dsmps.txt',i);%  %02d gives number as 01, 12, etc.
% % % end
% % %% October 01 = 275 Julian Day
% % %% October 16 = 290 Julian Day
% % % % smpsfile{1} = 'C:\Data\APMEX\SMPS\20041010_a.txt'; %works
% % % % smpsfile{2} = 'C:\Data\APMEX\SMPS\20041011smps.txt'; %works
% % % % smpsfile{3} = 'C:\Data\APMEX\SMPS\20041010_b_smps.txt'; %works
% % % % smpsfile{4} = 'C:\Data\APMEX\SMPS\20041011smps.txt'; %only one data point
% % % % smpsfile{5} = 'C:\Data\APMEX\SMPS\20041012smps.txt'; %works
% % 
% % % % smpsfile{6} = 'C:\Data\APMEX\SMPS\20041013smps.txt'; 
% % % % smpsfile{7} = 'C:\Data\APMEX\SMPS\20041014smps.txt'; 
% % % % smpsfile{8} = 'C:\Data\APMEX\SMPS\20041015smps.txt'; 
% % % % smpsfile{9} = 'C:\Data\APMEX\SMPS\20041015asmps.txt'; 
% % % % smpsfile{10} = 'C:\Data\APMEX\SMPS\20041016smps.txt'; 
% % % % smpsfile{11} = 'C:\Data\APMEX\SMPS\20041017smps.txt'; 
% % % % smpsfile{12} = 'C:\Data\APMEX\SMPS\20041017asmps.txt'; 
% % % % smpsfile{13} = 'C:\Data\APMEX\SMPS\20041017Weldingsmps.txt'; 
% % % % smpsfile{14} = 'C:\Data\APMEX\SMPS\20041017smps.txt'; 
% % % % smpsfile{15} = 'C:\Data\APMEX\SMPS\20041018smps.txt'; 
% % % % smpsfile{16} = 'C:\Data\APMEX\SMPS\20041019smps.txt'; 
% % 
% % smpsfile{1} = 'C:\Data\APMEX\SMPS\20041013smps.txt'; 
% % smpsfile{2} = 'C:\Data\APMEX\SMPS\20041014smps.txt'; 
% % smpsfile{3} = 'C:\Data\APMEX\SMPS\20041015smps.txt'; 
% % smpsfile{4} = 'C:\Data\APMEX\SMPS\20041015asmps.txt'; 
% % smpsfile{5} = 'C:\Data\APMEX\SMPS\20041016smps.txt'; 
% % smpsfile{6} = 'C:\Data\APMEX\SMPS\20041017smps.txt'; 
% % smpsfile{7} = 'C:\Data\APMEX\SMPS\20041017asmps.txt'; 
% % smpsfile{8} = 'C:\Data\APMEX\SMPS\20041017Weldingsmps.txt'; 
% % smpsfile{9} = 'C:\Data\APMEX\SMPS\20041017smps.txt'; 
% % smpsfile{10} = 'C:\Data\APMEX\SMPS\20041018smps.txt'; 
% % smpsfile{11} = 'C:\Data\APMEX\SMPS\20041019smps.txt'; 
% % 
% % contbins = 24;
% % threshold = [1 10000];
% % 
% % timematrix = [281.7917 282.7917];
% % for i = 2:12
% %     timematrix(i,:) = timematrix(i-1,:) + 1;
% % end
% % 
% % % % timerange = [93.911 94.045]
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % 
% % % % % flight1:  timerange = [92.767 92.92]
% % % % % flight2:  timerange = [93.911 94.045]
% % % % % flight3:  timerange = [94.745 94.88]
% % 
% % %% Setup up figure windows
% % scrsz = get(0,'ScreenSize');
% % %figrect = [0.05*scrsz(3) 0.05*scrsz(4) 0.9*scrsz(4)/scrsz(3)*scrsz(4) 0.9*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
% % figrect = [0.05*scrsz(3) 0.05*scrsz(4) 0.9*scrsz(3) 0.9*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
% % 
% % %%%%%% SMPS data analysis %%%%%%
% % % for i = 1:length(smpsfile)
% %   for i = first_day:last_day
% % [jt sbin zdata] = getSMPSmatrix(smpsfile{i}); % julian time, size bins, data
% %     if i == first_day
% %         jt_full = jt;
% %         zdata_full = zdata;
% %     else
% %         jt_full = [jt_full;jt];
% %         zdata_full = [zdata_full zdata];
% %     end
% % end
% % clear jt zdata
% % jt = jt_full;
% % zdata = zdata_full;
% % clear jt_full zdata_full
% % 
% % [m,n] = size(zdata);
% % for i = 1:n
% %     TotalConc(i) = sum(zdata(:,i));
% % end
% % 
% % 
% % Z = log10(zdata + eps);
% % zbin = thresholdbar(Z, log10(threshold), contbins);
% % 
% % % subplot(3,1,2); 
% % 
% % for i = 2:2% length(timematrix)
% %     timerange = [timematrix(i,1) timematrix(i,2)];
% %     f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);
% %     
% %     subplot(2,1,2)
% %     [C1 hcp] = contourf(jt, sbin, Z, zbin);
% % %     title(smpsfile);
% %     set(hcp, 'EdgeColor', 'none');
% %     set(gca, 'YScale', 'log', 'YLim', [10 max(sbin)], 'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
% %     if length(timerange) == 2; set(gca, 'XLim', timerange); end;
% %     ylabel('diameter (nm)');
% %     hc = thcolorbar('SMPS dN/dlog Dp (cm^{-3} nm^{-1})');
% %     
% %     subplot(2,1,1); plot(jt,TotalConc);
% %     set(gca,'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
% %     axis('tight');
% %     if length(timerange) == 2; set(gca, 'XLim', timerange); end;
% %     ylabel('Total number concentration (#/cm^3)');
% % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% SMPS data %%%%
%%%% 09 October 2004 %%%%%
%%%% Exported as rows and comma delimited 
%%%% NOTE %%%%% This doesn't handle time gaps well ... (it will fill in missing data with adjacent values??)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
contbins = 24;
threshold = [1 10000]; % one number = autoscale, two numbers specify range of axes
timematrix = [281.7917 282.7917];
for i = 2:12
    timematrix(i,:) = timematrix(i-1,:) + 1;
end
%% October 1 = 275 Julian Day
% smpsfile{1} = 'C:\Data\APMEX\SMPS\20041013smps.txt'; 
smpsfile{1} = 'C:\Data\APMEX\SMPS\20041014smps.txt'; 
smpsfile{2} = 'C:\Data\APMEX\SMPS\20041015smps.txt'; 
smpsfile{3} = 'C:\Data\APMEX\SMPS\20041015asmps.txt'; 
smpsfile{4} = 'C:\Data\APMEX\SMPS\20041016smps.txt'; 
smpsfile{5} = 'C:\Data\APMEX\SMPS\20041017smps.txt'; 
smpsfile{6} = 'C:\Data\APMEX\SMPS\20041017asmps.txt'; 
smpsfile{7} = 'C:\Data\APMEX\SMPS\20041017Weldingsmps.txt'; 
smpsfile{8} = 'C:\Data\APMEX\SMPS\20041017smps.txt'; 
smpsfile{9} = 'C:\Data\APMEX\SMPS\20041018smps.txt'; 
smpsfile{10} = 'C:\Data\APMEX\SMPS\20041019smps.txt'; 

%% Setup up figure windows
scrsz = get(0,'ScreenSize');
figrect = [0.05*scrsz(3) 0.6*scrsz(4) 0.9*scrsz(3) 0.3*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
% f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);

%%%%%% SMPS data analysis %%%%%%
%%concatenate files into a single matrix by appending new matrix onto existing one
for i = 1:length(smpsfile)
    [jt sbin zdata] = getSMPSmatrix(smpsfile{i});% julian time, size bins, data
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
    TotalConc(i) = sum(zdata(:,i));
end

Z = log10(zdata + eps);
zbin = thresholdbar(Z, log10(threshold), contbins);
    
for i = 1:1 %length(timematrix)
    timerange = [timematrix(i,1) timematrix(i,2)];
    f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);
   
    subplot(2,1,2)
    [C1 hcp] = contourf(jt, sbin, Z, zbin);
    % title(smpsfile);
    set(hcp, 'EdgeColor', 'none');
    set(gca, 'YScale', 'log', 'YLim', [0.5 5], 'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
    set(gca,'YTick', [.5 1 2 3 4 5],'YTickLabel',{'.5';'1';'2';'3';'4';'5'});
    if length(timerange) == 2; set(gca, 'XLim', timerange); end;
    ylabel('diameter (um)');
    hc = thcolorbar('SMPS dN/dlog Dp (cm^{-3} um^{-1})');
    
    % figure
    subplot(2,1,1); plot(jt,TotalConc);
    set(gca,'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
    axis('tight');
    if length(timerange) == 2; set(gca, 'XLim', timerange); end;
    % set(gca,'Axis','Visible','off');
    ylabel('Total number concentration (#/cm^3)');
end
toc

