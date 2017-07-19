%%%% SMPS data %%%%
%%%% 03 April 2004 %%%%%
%%%% Exported as rows and comma delimited 

clear;
close('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smpsfile = 'C:\Data\CIFEX\Trinidad Head\APS_SMPS\SMPS\20040401smpsdNdlogDp_row.txt';
contbins = 24;
threshold = [1 10000];
% % CDFfilename = '20040402.c1.nc';
% % pthreshold = [0.01 1000];
% % pcontbins = 24;
% % timerange = [93.911 94.045]
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % % flight1:  timerange = [92.767 92.92]
% % % fligh22:  timerange = [93.911 94.045]
% % % flight3:  timerange = [94.745 94.88]

%% Setup up figure windows
scrsz = get(0,'ScreenSize');
figrect = [0.05*scrsz(3) 0.05*scrsz(4) 0.9*scrsz(4)/scrsz(3)*scrsz(4) 0.9*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 7.5 10.5]);

%%%%%% SMPS data analysis %%%%%%
[jt sbin zdata] = getSMPSmatrix(smpsfile); % julian time, size bins, data
%%%% correct for one hour offset %%%%%
%% jt = jt-3600/86400;
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

% % %%%%%%%%%%%%%%%%%% NETCDF Analysis %%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % %% time matrix from netCDF input
% % PAR(1).CDFfilename = {CDFfilename};
% % PAR(1).plottype = {'JULIAN'}; %% {'sec', 'julian'} %%
% % PAR(1).xlabel = {'julian time (UTC)'};
% % 
% % timematrix = getCDFtime(PAR(1));
% % if timematrix == -1
% %     disp('ERROR in retrieving time matrix!');
% %     finish;
% % end;
% % 
% % DATA(4).varstr = {'GALT'};  %% search strings
% % DATA(4).range = [0];
% % DATA(4).ylabel = {'altitude (m)'};
% % DATA(4).title = getCDFlongname(DATA(4), PAR(1));
% % ALT = getCDFmatrix(char(DATA(4).varstr), CDFfilename);
% % 
% % %%%%%%%%%%%%%%%% AEROSOL INSTRUMENTS %%%%%%%%%%%%%%%%%%%%
% % %%% aerosol number concentration
% % DATA(19).varstr = {'CPC_RAW', 'ccnA_conc', 'CPCASP_OBL'};  %% search strings
% % DATA(19).range = [0 2500];
% % DATA(19).ylabel = {'N (#/cm^3)'};
% % DATA(19).title = 'Aerosol instruments';
% % 
% % for i=1:length(DATA(19).varstr)
% %     Y(i) = getCDFmatrix(char(DATA(19).varstr(i)), CDFfilename);
% %     plotmatrix(:,i) = Y(i).data;
% % end;
% % subplot(3,1,3); h1 = plot(meshgrid(timematrix, 1:3)', plotmatrix);
% % if length(timerange) == 2; set(gca, 'XLim', timerange); end;
% % if length(DATA(19).range) == 2
% %     ymin = min(DATA(19).range);
% %     ymax = max(DATA(19).range);
% %     set(gca, 'YLim', [ymin ymax]);
% % end;
% % set(gca, 'Box', 'off', 'YAxisLocation', 'left', 'XGrid', 'on', 'GridLineStyle', '-.');
% % xlabel(PAR(1).xlabel);
% % ylabel(DATA(19).ylabel);
% % [lh oh] = legend(char(DATA(19).varstr),2);
% % set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
% %     
% % %%% overlay Altitude plot on current graph
% % xlim = get(gca, 'XLim');
% % dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
% %     'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
% % halt = plot(timematrix, ALT.data);  %%% Altitude sensors
% % set(gca, 'Xlim', xlim);
% % set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
% % ylabel(DATA(4).ylabel);
% % [lh oh] = legend(char(DATA(4).varstr),1);
% % set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
% % dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
% %     'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
% % end;
% % 
% % %%%  PCASP size distribution
% % DATA(1).varstr = {'APCASP_OBL'};  %% FSSP
% % DATA(1).ylabel = {'diameter (\mum)'};
% % DATA(1).zlabel = {'N_{PCASP} (cm^{-3})'};
% % DATA(1).contbins = 4;  %% number of contour levels
% % DATA(1).threshold = log10(0.1);
% % DATA(1).scale = {'log'}; %% {'log', 'linear'} %%
% % DATA(1).zcells = [1:30]; 
% % 
% % [jtCDF psbin pdata] = getCDFmatrix3(DATA(1).varstr, CDFfilename, [1:30]);
% % Zp = log10(pdata.data' + eps);  %% log10 of PCASP data
% % zbinp = thresholdbar(Zp, log10(pthreshold), pcontbins);
% % 
% % [Xavg Davg] = timeaverage(jtCDF, Zp', 30);  %% second averaging
% % 
% % %% plot PCASP distribution
% % subplot(3,1,1); [C1 hcp] = contourf(Xavg, psbin*1000, Davg', zbinp);
% % set(hcp, 'EdgeColor', 'none');
% % set(gca, 'YScale', 'log', 'YLim', [0.1 max(psbin)].*1000, 'Layer', 'top', 'Box', 'on', 'XGrid', 'on', 'GridLineStyle', '-.');
% % if length(timerange) == 2; set(gca, 'XLim', timerange); end;
% % ylabel('diameter (nm)');
% % ht = title(['Aerosol analysis (prelim):  ' CDFfilename]);
% % set(ht, 'Interpreter', 'none');
% % 
% % %% add color bar and modify axis to show log-scale
% % hc = thcolorbar(char(DATA(1).zlabel));
% % 
% % psfilename = ['QAero' CDFfilename(1:findstr('.nc', CDFfilename)) 'PS'];
% % print(f,'-dpsc2','-r150', psfilename);
% % 
% % 
% % 
% % 
