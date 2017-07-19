
clear;
close('all');

CDFfilename = '20040401.c1.nc';
psfilename = ['Q' CDFfilename(1:findstr('.nc', CDFfilename)) 'PS'];

%% Setup up figure windows
scrsz = get(0,'ScreenSize');
figrect = [0.05*scrsz(3) 0.05*scrsz(4) 0.9*scrsz(4)/scrsz(3)*scrsz(4) 0.9*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen

%% time matrix from netCDF input
PAR(1).CDFfilename = {CDFfilename};
PAR(1).plottype = {'sec'}; %% {'sec', 'julian'} %%
PAR(1).xlabel = {'mission time (sec)'};

timematrix = getCDFtime(PAR(1));
if timematrix == -1
    disp('ERROR in retrieving time matrix!');
    finish;
end;

DATA(4).varstr = {'GALT'};  %% search strings
DATA(4).range = [0];
DATA(4).ylabel = {'altitude (m)'};
DATA(4).title = getCDFlongname(DATA(4), PAR(1));

%%%%%%%%%%%%%%%% UNIV WYOMING CCN INSTRUMENT DIAGNOSTIC %%%%%%%%%%%%%%%%%%%%
%%% CCN number concentration
DATA(19).varstr = {'ccnA_conc'};  %% search strings
DATA(19).range = [0];
DATA(19).ylabel = {'NCCN (#/cm^3)'};
%%% Temperatures
DATA(20).varstr = {'ccnA_toptmp', 'ccnA_dtemp'};  %% search strings
DATA(20).range = [0];
DATA(20).ylabel = {'Temperature (C)'};
%%% supersaturation
DATA(21).varstr = {'ccnA_ssat'};  %% search strings
DATA(21).range = [0];
DATA(21).ylabel = {'supersaturation (%)'};
%%% quality factor
DATA(22).varstr = {'ccnA_qf'};  %% search strings
DATA(22).range = [0];
DATA(22).ylabel = {'quality factor'};

f5 = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 7.5 10.5]);
X = [19:22];  %%% range of cells to plot
for i=1:length(X)
    subplot(length(X),1,i); h1 = CDFplot(timematrix, DATA(X(i)), PAR(1));
    DATA(X(i)).title = getCDFlongname(DATA(X(i)), PAR(1));
    text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), cellstr(DATA(X(i)).title), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    set(gca, 'Box', 'off', 'YAxisLocation', 'left');
    if(i == length(X)) xlabel(PAR(1).xlabel); end;
    ylabel(DATA(X(i)).ylabel);
    [lh oh] = legend(char(DATA(X(i)).varstr),2);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    
    %%% overlay Altitude plot on current graph
    dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
    halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
    set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
    ylabel(DATA(4).ylabel);
    [lh oh] = legend(char(DATA(4).varstr),1);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
end;
print(f5,'-dpsc2','-r150',psfilename);

%%%%%%%%%%%%%%%%  Cloud droplet spectra, Reff, and LWC  %%%%%%%%%%%%%%%%%%%%%%%%%%%
DATA(1).varstr = {'CFSSP_IBL'};  %% FSSP
DATA(1).ylabel = {'radius (\mum)'};
DATA(1).zlabel = {'N_{FSSP} (cm^{-3})'};
DATA(1).contbins = 8;
DATA(1).threshold = log10(0.01);
DATA(1).scale = {'log'}; %% {'log', 'linear'} %%
DATA(1).zcells = [17:32]; %33:48];  %%%************* CHECK THIS ******************%%

DATA(2).varstr = {'REffective_IBL'};  %% Effective radius
DATA(2).range = [0];
DATA(2).ylabel = {''};
DATA(2).title = getCDFlongname(DATA(2), PAR(1));

DATA(3).varstr = {'lwc100', 'jlb_lwc2_IBL', 'pvmlwc'};  %% lwc
DATA(3).range = [0 0.5];
DATA(3).ylabel = {'lwc (g m^{-3})'};
DATA(3).title = getCDFlongname(DATA(3), PAR(1));

f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 7.5 10.5]);
%% plot FSSP distribution
subplot(2,1,1);  h = CDFdistplot(timematrix, DATA(1), PAR(1));
ht = get(f, 'Children');
d1 = axes('Position', get(ht(2), 'Position'), 'Color', 'none');
set(d1, 'NextPlot', 'add', 'YTick', [], 'YTickLabel', [], ...
    'XTick', [], 'XTickLabel', []);
%%% effective radius
DATA(2).range = get(ht(2), 'YLim');
hre = CDFplot(timematrix, DATA(2), PAR(1));
text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), DATA(2).title, ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
set(hre, 'Color', 'black', 'LineStyle', 'none', 'Marker', '.');
[lh oh] = legend(char(DATA(2).varstr),0);
set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter

subplot(2,1,2); hlwc = CDFplot(timematrix, DATA(3), PAR(1)); %%% liquid water content
text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), DATA(3).title, ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
set(gca, 'Box', 'off', 'YAxisLocation', 'left');
xlabel(PAR(1).xlabel);
ylabel(DATA(3).ylabel);
[lh oh] = legend(char(DATA(3).varstr),2);
set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
%%% overlay Altitude plot on current graph
dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
    'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
ylabel(DATA(4).ylabel);
[lh oh] = legend(char(DATA(4).varstr),1);
set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
    'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
print(f,'-dpsc2','-r150',psfilename);

%%%%%%%%%%%%%%%%%%% met. parameters %%%%%%%%%%%%%%%%%%%%%%%
%%%%% ADD RELATIVE HUMIDITY
%%% Temperature sensors
DATA(16).varstr = {'trf', 'trose', 'tdp', 'tdplicor'};  %% search strings
DATA(16).range = [0];
DATA(16).ylabel = {'temperature (C)'};
DATA(16).title = getCDFlongname(DATA(16), PAR(1));
%%% Pressure sensors
DATA(17).varstr = {'ps_hads_a', 'ps_hads_b'};  %% search strings
DATA(17).range = [0];
DATA(17).ylabel = {'pressure (mbar)'};
DATA(17).title = getCDFlongname(DATA(17), PAR(1));
%%% Altitude sensors
DATA(18).varstr = {'ztrue', 'GALT'};  %% search strings
DATA(18).range = [0];
DATA(18).ylabel = {'altitude (m)'};
DATA(18).title = getCDFlongname(DATA(18), PAR(1));

f1 = figure('Position', figrect, 'Color', 'white');
X = [16:18];  %%% range of cells to plot
for i=1:length(X)
    subplot(length(X),1,i); h1 = CDFplot(timematrix, DATA(X(i)), PAR(1));
    text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), cellstr(DATA(X(i)).title), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    ylabel(DATA(X(i)).ylabel);
    [lh oh] = legend(char(DATA(X(i)).varstr),2);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
end;
xlabel(PAR(1).xlabel);
orient landscape;
print(f1,'-dpsc2','-r150','-append', psfilename);

%%%%%%%%%%%%%%%% WIND SENSORS %%%%%%%%%%%%%%%%%%%%
%%% wind vectors
DATA(19).varstr = {'hw', 'hivs'};  %% search strings
DATA(19).range = [0];
DATA(19).ylabel = {'vertical wind (m s^{-1})'};
%%% wind vectors
DATA(20).varstr = {'hu', 'hv', 'hwmag'};  %% search strings
DATA(20).range = [0];
DATA(20).ylabel = {'winds (m s^{-1})'};
%%% wind vectors
DATA(21).varstr = {'hwdir'};  %% search strings
DATA(21).range = [0];
DATA(21).ylabel = {'wind direction (deg)'};

f5 = figure('Position', figrect, 'Color', 'white');
X = [19:21];  %%% range of cells to plot
for i=1:length(X)
    subplot(length(X),1,i); h1 = CDFplot(timematrix, DATA(X(i)), PAR(1));
    DATA(X(i)).title = getCDFlongname(DATA(X(i)), PAR(1));
    text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), cellstr(DATA(X(i)).title), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    set(gca, 'Box', 'off', 'YAxisLocation', 'left');
    if(i == length(X)) xlabel(PAR(1).xlabel); end;
    ylabel(DATA(X(i)).ylabel);
    [lh oh] = legend(char(DATA(X(i)).varstr),2);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    
    %%% overlay Altitude plot on current graph
    dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
    halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
    set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
    ylabel(DATA(4).ylabel);
    [lh oh] = legend(char(DATA(4).varstr),1);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
end;
orient portrait;
print(f5,'-dpsc2','-r150','-append', psfilename);

%%%%%%%%%%%%   LICOR   %%%%%%%%%%%%%%%%%%
DATA(22).varstr = {'co2ml'};  %% search strings
DATA(22).range = [0];
DATA(22).ylabel = {'CO_2 mole fraction'};

DATA(23).varstr = {'h2oml', 'h2omx'};  %% search strings
DATA(23).range = [0];
DATA(23).ylabel = {'H_2O mole fraction and mixing ratio'};

DATA(24).varstr = {'licort', 'tdplicor'};  %% search strings
DATA(24).range = [0];
DATA(24).ylabel = {'licor temperature (C)'};

DATA(25).varstr = {'licorp'};  %% search strings
DATA(25).range = [0];
DATA(25).ylabel = {'licor pressure (kPa)'};

f6 = figure('Position', figrect, 'Color', 'white');
X = [22:25];  %%% range of cells to plot
for i=1:length(X)
    subplot(length(X),1,i); h1 = CDFplot(timematrix, DATA(X(i)), PAR(1));
    DATA(X(i)).title = getCDFlongname(DATA(X(i)), PAR(1));
    text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), cellstr(DATA(X(i)).title), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    set(gca, 'Box', 'off', 'YAxisLocation', 'left');
    if(i == length(X)) xlabel(PAR(1).xlabel); end;
    ylabel(DATA(X(i)).ylabel);
    [lh oh] = legend(char(DATA(X(i)).varstr),2);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    
    %%% overlay Altitude plot on current graph
    dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
    halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
    set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
    ylabel(DATA(4).ylabel);
    [lh oh] = legend(char(DATA(4).varstr),1);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
end;
orient portrait;
print(f6,'-dpsc2','-r150','-append', psfilename);

%%%%%%% cloud droplet concentrations  %%%%%%%%%%%%%%%%%%%
DATA(13).varstr = {'jlb_conc2_IBL'};  %%%% number concentration
DATA(13).range = [0];
DATA(13).ylabel = {'concentration (cm^{-3})'};

%%%% per liter
DATA(15).varstr = {'concic', 'conctotc', 'concip', 'conctotp'};  %% search strings
DATA(15).range = [0];
DATA(15).ylabel = {'per liter (L^{-1})'};

f2 = figure('Position', figrect, 'Color', 'white');
X = [13, 15];  %%% range of cells to plot
for i=1:length(X)
    subplot(length(X),1,i); h1 = CDFplot(timematrix, DATA(X(i)), PAR(1));
    DATA(X(i)).title = getCDFlongname(DATA(X(i)), PAR(1));
    text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), cellstr(DATA(X(i)).title), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    set(gca, 'Box', 'off', 'YAxisLocation', 'left');
    if(i == length(X)) xlabel(PAR(1).xlabel); end;
    ylabel(DATA(X(i)).ylabel);
    [lh oh] = legend(char(DATA(X(i)).varstr),2);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    
    %%% overlay Altitude plot on current graph
    dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
    halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
    set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
    ylabel(DATA(4).ylabel);
    [lh oh] = legend(char(DATA(4).varstr),1);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
end;
orient portrait;
print(f2,'-dpsc2','-r150','-append', psfilename);

%%%%%%%%%%%%% Cloud and water %%%%%%%%%%%%%%%%%%%%
DATA(8).varstr = {'pvmlwc', 'PLWCX_OBR', 'lwcfocp', 'PLWCF_IBL', 'jlb_lwc2_IBL', 'lwc2dc', 'lwc2dcm', 'lwc2dp', 'lwc2dpm', 'lwc100', 'rlwc'};  %%% liquid water
DATA(8).range = [0 1];
DATA(8).ylabel = {'liquid water content (g m^{-3})'};

DATA(9).varstr = {'iwcc', 'iwcp'};  %% ice water
DATA(9).range = [0 0.5];
DATA(9).ylabel = {'ice water content (g m^{-3})'};

DATA(10).varstr = {'rwcc', 'rwcp'};  %%% rain water
DATA(10).range = [0 1];
DATA(10).ylabel = {'rain water content (g m^{-3})'};

DATA(11).varstr = {'pvmre', 'REffective_IBL'};  %%% radius
DATA(11).range = [0 15];
DATA(11).ylabel = {'effective radius (m/um)'};

f3 = figure('Position', figrect, 'Color', 'white');
X = [8:11];  %%% range of cells to plot
for i=1:length(X)
    subplot(length(X),1,i); h1 = CDFplot(timematrix, DATA(X(i)), PAR(1));
    DATA(X(i)).title = getCDFlongname(DATA(X(i)), PAR(1));
    text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), cellstr(DATA(X(i)).title), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    set(gca, 'Box', 'off', 'YAxisLocation', 'left');
    if(i == length(X)) xlabel(PAR(1).xlabel); end;    
    ylabel(DATA(X(i)).ylabel);
    [lh oh] = legend(char(DATA(X(i)).varstr),2);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    
    %%% overlay Altitude plot on current graph
    dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
    halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
    set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
    ylabel(DATA(4).ylabel);
    [lh oh] = legend(char(DATA(4).varstr),1);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
end;
orient portrait;
print(f3,'-dpsc2','-r150','-append', psfilename);

%%%%%%%%%%%%% Radiation %%%%%%%%%%%%%%%%%%%%
DATA(5).varstr = {'irtc', 'irbc'};  %% pyrgeometers
DATA(5).range = [0];
DATA(5).ylabel = {'irradiance (W m^{-2})'};

DATA(6).varstr = {'swt', 'swb'};  %% pyranometers
DATA(6).range = [0];
DATA(6).ylabel = {'irradiance (W m^{-2})'};

DATA(7).varstr = {'rstb'};  %% search strings
DATA(7).range = [0];
DATA(7).ylabel = {'IR temp (K)'};

f4 = figure('Position', figrect, 'Color', 'white');
X = [5:7];  %%% range of cells to plot
for i=1:length(X)
    subplot(length(X),1,i); h1 = CDFplot(timematrix, DATA(X(i)), PAR(1));
    DATA(X(i)).title = getCDFlongname(DATA(X(i)), PAR(1));
    text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), cellstr(DATA(X(i)).title), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    set(gca, 'Box', 'off', 'YAxisLocation', 'left');
    if(i == length(X)) xlabel(PAR(1).xlabel); end;
    ylabel(DATA(X(i)).ylabel);
    [lh oh] = legend(char(DATA(X(i)).varstr),2);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    
    %%% overlay Altitude plot on current graph
    dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
    halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
    set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
    ylabel(DATA(4).ylabel);
    [lh oh] = legend(char(DATA(4).varstr),1);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
end;
orient portrait;
print(f4,'-dpsc2','-r150','-append', psfilename);

%%%%%%%%%%%%% Cloud and water %%%%%%%%%%%%%%%%%%%%
DATA(8).varstr = {'pvmlwc', 'PLWCX_OBR', 'lwcfocp', 'PLWCF_IBL', 'jlb_lwc2_IBL', 'lwc2dc', 'lwc2dcm', 'lwc2dp', 'lwc2dpm', 'lwc100', 'rlwc'};  %%% liquid water
DATA(8).range = [0 1];
DATA(8).ylabel = {'liquid water content (g m^{-3})'};

f7 = figure('Position', figrect, 'Color', 'white');
X = [8];  %%% range of cells to plot
for i=1:length(X)
    subplot(length(X),1,i); h1 = CDFplot(timematrix, DATA(X(i)), PAR(1));
    DATA(X(i)).title = getCDFlongname(DATA(X(i)), PAR(1));
    text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), cellstr(DATA(X(i)).title), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    set(gca, 'Box', 'off', 'YAxisLocation', 'left');
    if(i == length(X)) xlabel(PAR(1).xlabel); end;
    ylabel(DATA(X(i)).ylabel);
    [lh oh] = legend(char(DATA(X(i)).varstr),2);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    
    %%% overlay Altitude plot on current graph
    dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
    halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
    set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
    ylabel(DATA(4).ylabel);
    [lh oh] = legend(char(DATA(4).varstr),1);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
end;
orient portrait;
print(f7,'-dpsc2','-r150','-append', psfilename);


%%%%%%%%%%%%%%%% AEROSOL INSTRUMENTS %%%%%%%%%%%%%%%%%%%%
%%% aerosol number concentration
DATA(19).varstr = {'CPC_RAW', 'ccnA_conc', 'CPCASP_OBL'};  %% search strings
DATA(19).range = [0];
DATA(19).ylabel = {'N (#/cm^3)'};

DATA(20).varstr = {'aethconc'};  %% search strings
DATA(20).range = [0];
DATA(20).ylabel = {'ug m^{-3})'};

f = figure('Position', figrect, 'Color', 'white', 'PaperPosition', [0.5 0.5 7.5 10.5]);
X = [19:20];  %%% range of cells to plot
for i=1:length(X)
    subplot(length(X)+1,1,i); h1 = CDFplot(timematrix, DATA(X(i)), PAR(1));
    DATA(X(i)).title = getCDFlongname(DATA(X(i)), PAR(1));
    text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), cellstr(DATA(X(i)).title), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
    set(gca, 'Box', 'off', 'YAxisLocation', 'left');
    if(i == length(X)) xlabel(PAR(1).xlabel); end;
    ylabel(DATA(X(i)).ylabel);
    [lh oh] = legend(char(DATA(X(i)).varstr),2);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    
    %%% overlay Altitude plot on current graph
    dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
    halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
    set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
    ylabel(DATA(4).ylabel);
    [lh oh] = legend(char(DATA(4).varstr),1);
    set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
    dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
        'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
end;

%%%  PCASP size distribution
DATA(1).varstr = {'APCASP_OBL'};  %% FSSP
DATA(1).ylabel = {'diameter (\mum)'};
DATA(1).zlabel = {'N_{PCASP} (cm^{-3})'};
DATA(1).contbins = 4;  %% number of contour levels
DATA(1).threshold = log10(0.1);
DATA(1).scale = {'log'}; %% {'log', 'linear'} %%
DATA(1).zcells = [1:30]; %33:48];  %%%************* CHECK THIS ******************%%

DATA(2).varstr = {'DBARP_OBL'};  %% Effective radius
DATA(2).range = [0];
DATA(2).ylabel = {''};
DATA(2).title = getCDFlongname(DATA(2), PAR(1));

%% plot PCASP distribution
subplot(length(X)+1,1,length(X)+1);  h = CDFdistplot(timematrix, DATA(1), PAR(1));
ht = get(f, 'Children');
d1 = axes('Position', get(ht(2), 'Position'), 'Color', 'none');
set(d1, 'NextPlot', 'add', 'YTick', [], 'YTickLabel', [], ...
    'XTick', [], 'XTickLabel', []);
%%% effective radius
DATA(2).range = get(ht(2), 'YLim');
hre = CDFplot(timematrix, DATA(2), PAR(1));
text(min(get(gca, 'Xlim')), max(get(gca, 'Ylim')), DATA(2).title, ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Interpreter', 'none');
set(hre, 'Color', 'black', 'LineStyle', 'none', 'Marker', '.');
[lh oh] = legend(char(DATA(2).varstr),0);
set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter

%%% overlay Altitude plot on current graph
dlwc = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
    'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], 'YAxisLocation', 'right');
halt = CDFplot(timematrix, DATA(4), PAR(1));  %%% Altitude sensors
set(halt, 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
ylabel(DATA(4).ylabel);
[lh oh] = legend(char(DATA(4).varstr),1);
set(oh(1), 'Interpreter', 'none');  %disables Tex interpreter
dalt = axes('Position', get(gca, 'Position'), 'Color', 'none', ...
    'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], 'YTick', []);
print(f,'-dpsc2','-r150', '-append', psfilename);

