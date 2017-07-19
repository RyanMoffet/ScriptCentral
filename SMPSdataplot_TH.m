function SMPSdataplot_TH(smpsfile)
%%%% Call as SMPSdataplot_TH_fn('C:\Data\CIFEX\Trinidad Head\APS_SMPS\SMPS\20040404smpsdNdlogDp_row.txt');
%%%% SMPS data %%%%
%%%% 03 April 2004 %%%%%
%%%% Exported as rows and comma delimited 

% clear;
% close('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% smpsfile = 'C:\Data\CIFEX\Trinidad Head\APS_SMPS\SMPS\20040404smpsdNdlogDp_row.txt';
contbins = 24;
threshold = [1 10000];
% % CDFfilename = '20040402.c1.nc';
% % pthreshold = [0.01 1000];
% % pcontbins = 24;
% % timerange = [93.911 94.045]
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % % flight1:  timerange = [92.767 92.92]
% % % flight2:  timerange = [93.911 94.045]
% % % flight3:  timerange = [94.745 94.88]

%% Setup up figure windows
scrsz = get(0,'ScreenSize');
%figrect = [0.05*scrsz(3) 0.05*scrsz(4) 0.9*scrsz(4)/scrsz(3)*scrsz(4) 0.9*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
figrect = [0.05*scrsz(3) 0.05*scrsz(4) 0.9*scrsz(3) 0.9*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 10.5 7.5]);

%%%%%% SMPS data analysis %%%%%%
[jt sbin zdata] = getSMPSmatrix(smpsfile); % julian time, size bins, data
Z = log10(zdata + eps);
zbin = thresholdbar(Z, log10(threshold), contbins);

% subplot(3,1,2); 
[C1 hcp] = contourf(jt, sbin, Z, zbin);
title(smpsfile);
set(hcp, 'EdgeColor', 'none');
set(gca, 'YScale', 'log', 'YLim', [10 max(sbin)], 'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
% if length(timerange) == 2; set(gca, 'XLim', timerange); end;
ylabel('diameter (nm)');
hc = thcolorbar('SMPS dN/dlog Dp (cm^{-3} nm^{-1})');

