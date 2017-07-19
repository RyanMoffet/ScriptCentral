
clear;
close('all');

CDFfilename = '20040215.c1.nc';

scrsz = get(0,'ScreenSize');
figrect = [0.1*scrsz(3) 0.1*scrsz(4) 0.8*scrsz(3) 0.8*scrsz(4)]; %figrect = [left bottom width height]; scrsz(4) = height of screen
f = figure('Position', figrect, 'Color', 'white');

subplot(2,1,1);
h2 = CDFdistplot(CDFfilename, {'CFSSP_IBL'}, 'sec', 16, log10(0.01));
ht = get(f, 'Children');
d1 = axes('Position', get(ht(2), 'Position'), 'Color', 'none');
set(d1, 'NextPlot', 'add', 'YTick', [], 'YTickLabel', [], ...
    'XTick', [], 'XTickLabel', []);
%%% radius
varstr = {'REffective_IBL'};  %% search strings
range = get(ht(2), 'YLim');

h1 = CDFplot(CDFfilename, varstr, 'sec', range);
set(h1, 'Color', 'black', 'LineWidth', 1);
xlabel('');
ylabel('');
title('Effective radius');

subplot(2,1,2);
%%% liquid water
varstr = {'lwc100', 'PLWCF_IBL'};  %% search strings
range = [0 0.5];
h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Liquid water content');
set(gca, 'Box', 'off', 'YAxisLocation', 'left');
d1 = axes('Position', get(gca, 'Position'), 'Color', 'none');
set(d1, 'NextPlot', 'add', 'XTick', [], 'XTickLabel', [], ...
    'YAxisLocation', 'right');
%%% Altitude sensors
varstr = {'GALT'};  %% search strings
range = [0 2000];
h1 = CDFplot(CDFfilename, varstr, 'sec', range);
set(h1, 'Color', 'red', 'LineWidth', 2);
xlabel('');
d1 = axes('Position', get(gca, 'Position'), 'Color', 'none');
set(d1, 'Box', 'on', 'XTick', get(gca, 'XTick'), 'XTickLabel', [], ...
    'YTick', []);

%%%%%%%%%%%%% Radiation %%%%%%%%%%%%%%%%%%%%
f5 = figure;
%%% Pyranometers
varstr = {'irtc', 'irbc'};  %% search strings
range = [0];
subplot(3,1,1); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Eppley pir radiometer');

%%% Pyranometers
varstr = {'swt', 'swb'};  %% search strings
range = [0];
subplot(3,1,2); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Eppley SW radiometer');

%%% Pyranometers
varstr = {'rstb'};  %% search strings
range = [0];
subplot(3,1,3); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('IR temperature');

%%%%%%%%%%%%% Cloud and water %%%%%%%%%%%%%%%%%%%%
f4 = figure;
%%% liquid water
varstr = {'pvmlwc', 'PLWCX_OBR', 'lwcfocp', 'PLWCF_IBL', 'jlb_lwc2_IBL', 'jlb_lwc3_IBL', 'jlb_lwc4_IBL', 'lwc2dc', 'lwc2dcm', 'lwc2dp', 'lwc2dpm', 'lwc100', 'rlwc'};  %% search strings
range = [0 1];
subplot(7,1,1); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Liquid water content');

%%% ice water
varstr = {'iwcc', 'iwcp'};  %% search strings
range = [0 0.5];
subplot(7,1,2); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Ice water content');

%%% rain water
varstr = {'rwcc', 'rwcp'};  %% search strings
range = [0 1];
subplot(7,1,3); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Rain water content');

%%% radius
varstr = {'pvmre', 'REffective_IBL', 'RBarVol_IBL'};  %% search strings
range = [0 15];
subplot(7,1,4); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Effective radius');

%%% surface area
varstr = {'pvmpsa', 'SurfArea_IBL'};  %% search strings
range = [0 2000];
subplot(7,1,5); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Surface area');

%%% number concentration
varstr = {'CONCF_IBL', 'jlb_conc2_IBL', 'jlb_conc3_IBL', 'jlb_conc4_IBL'};  %% search strings
range = [0];
subplot(7,1,5); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Number concentration');

%%% concentration
varstr = {'DBARF_IBL', 'DBARX_OBR'};  %% search strings
range = [0];
subplot(7,1,6); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Concentration');

%%%% per liter
varstr = {'CONCX_OBR', 'concic', 'conctotc', 'concip', 'conctotp'};  %% search strings
range = [0];
subplot(7,1,7); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('per liter');

%%%%%%%%%%%%%%%%%%% met. parameters %%%%%%%%%%%%%%%%%%%%%%%5
f1 = figure;
%%% Temperature sensors
varstr = {'trf', 'trose', 'tdp', 'tdplicor'};  %% search strings
range = [10 -45];
subplot(3,1,1); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Temperature');

%%% Pressure sensors
varstr = {'pmb', 'ps_hads_a', 'ps_hads_b'};  %% search strings
range = [0];
subplot(3,1,2); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Pressure');
%% licorp

%%% Altitude sensors
varstr = {'ralt2', 'z', 'ztrue', 'hi3', 'PALT', 'GALT'};  %% search strings
range = [0 2000];
subplot(3,1,3); h1 = CDFplot(CDFfilename, varstr, 'sec', range);

%%%%%%%%%%%%%%%% WIND SENSORS %%%%%%%%%%%%%%%%%%%%
f3 = figure;
%%% wind vectors
varstr = {'hw', 'hivs', 'hwp3'};  %% search strings
range = [0];
subplot(3,1,1); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Vertical winds');

%%% wind vectors
varstr = {'hu', 'hv', 'hwmag'};  %% search strings
range = [0];
subplot(3,1,2); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Horizontal winds');

%%% wind vectors
varstr = {'hwdir'};  %% search strings
range = [0];
subplot(3,1,3); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Wind direction');


%%%%%%%%%%%%   LICOR   %%%%%%%%%%%%%%%%%%
f2 = figure;
varstr = {'co2ml'};  %% search strings
range = [370 380];
subplot(4,1,1); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('CO_2 mole fraction');

varstr = {'h2oml', 'h2omx'};  %% search strings
range = [0 2.5];
subplot(4,1,2); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('H_2O mole fraction and mixing ratio');

varstr = {'licort', 'tdplicor'};  %% search strings
range = [-50 30];
subplot(4,1,3); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Temperature');

varstr = {'licorp'};  %% search strings
range = [0];
subplot(4,1,4); h1 = CDFplot(CDFfilename, varstr, 'sec', range);
title('Pressure');
