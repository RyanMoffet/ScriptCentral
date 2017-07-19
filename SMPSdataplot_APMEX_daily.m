% %%%% SMPS data %%%%
%%%% 09 October 2004 %%%%%
%%%% Exported as rows and comma delimited 
%%%% NOTE %%%%% This doesn't handle time gsmps well ... (it will fill in missing data with adjacent values??)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Daily plots of SMPS data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fpath = 'C:\Data\APMEX\SMPS\Results\temp\';
contbins = 24;
threshold = [1 10000]; % one number = autoscale, two numbers specify range of axes
% timerange = [291 293];
% timerange = [];

timematrix = [287.7917 288.7917]; %%% Oct 14 = 288 julian day
for i = 2:24
    timematrix(i,:) = timematrix(i-1,:) + 1;
end

%%% Select smps files to plot
%% October 1 = 275 Julian Day
smpsfile{1} = 'C:\Data\APMEX\SMPS\20041014smps.txt'; 
smpsfile{2} = 'C:\Data\APMEX\SMPS\20041015smps.txt'; 
smpsfile{3} = 'C:\Data\APMEX\SMPS\20041015asmps.txt'; 
smpsfile{4} = 'C:\Data\APMEX\SMPS\20041016smps.txt'; 
smpsfile{5} = 'C:\Data\APMEX\SMPS\20041017smps.txt'; 
smpsfile{6} = 'C:\Data\APMEX\SMPS\20041017Weldingsmps.txt'; 
smpsfile{7} = 'C:\Data\APMEX\SMPS\20041017asmps.txt'; 

% first_day = 18;
% last_day = 29;
% cnt_1 = first_day - 10;
% cnt_2 = last_day - 10;
% 
% for i = cnt_1:cnt_2 
%     smpsfile{i} = sprintf('C:\\Data\\APMEX\\SMPS\\200410%02dsmps.txt',i);%  %02d gives number as 01, 12, etc.
% end
% % 
% % smpsfile{8} = 'C:\Data\APMEX\SMPS\20041017smps.txt'; 
% % smpsfile{9} = 'C:\Data\APMEX\SMPS\20041018smps.txt'; 
% % smpsfile{10} = 'C:\Data\APMEX\SMPS\20041019smps.txt'; 




%% Setup up figure windows
scrsz = get(0,'ScreenSize');
figrect = [0.05*scrsz(3) 0.6*scrsz(4) 0.9*scrsz(3) 0.3*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
% f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);

%%%%%% SMPS data analysis %%%%%%
%%concatenate files into a single matrix by appending new matrix onto existing one
clear jt sbin zdata jt_full zdata_full
first = 1;
for i = first:length(smpsfile)
    [jt sbin zdata] = getSMPSmatrix(smpsfile{i});% julian time, size bins, data
    if i == first
        jt_full = jt;
        zdata_full = zdata;
    else
        jt_full = [jt_full;jt];
        zdata_full = [zdata_full zdata];
    end
end
clear jt zdata

for i = first:length(timematrix)
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
    clear TotalConc
    for i = 1:size(zdata,2); %% columns in zdata
        TotalConc(i) = sum(zdata(:,i));
    end
    
    Z = log10(zdata + eps);
    zbin = thresholdbar(Z, log10(threshold), contbins);
    
    %%%%% Plot %%%%%
    f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);
    subplot(2,1,2)
    [C1 hcp] = contourf(jt, sbin, Z, zbin);
    % title(smpsfile);
    set(hcp, 'EdgeColor', 'none');
    set(gca, 'YScale', 'log', 'YLim', [10 max(sbin)], 'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
    %     set(gca, 'YScale', 'log', 'YLim', [0.5 5], 'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
    %     set(gca,'YTick', [.5 1 2 3 4 5],'YTickLabel',{'.5';'1';'2';'3';'4';'5'});
    if length(timerange) == 2; set(gca, 'XLim', timerange); end;
    ylabel('diameter (nm)');
    hc = thcolorbar('SMPS dN/dlog Dp (cm^{-3} um^{-1})');
    
    % figure
    subplot(2,1,1); plot(jt,TotalConc);
    set(gca,'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
    axis('tight');
    if length(timerange) == 2; set(gca, 'XLim', timerange); end;
    % set(gca,'Axis','Visible','off');
    ylabel('Total number concentration (#/cm^3)');
    
    doy = floor(mean(timerange));
    FileName = sprintf('%sJulian%03d',fpath,doy); % Names the file
    saveas (gcf,FileName, 'emf');
    saveas (gcf,FileName, 'fig');
    close
end
toc
