%%% 04 April 2004

function hc = aps_thcolorbar(bstring,zbin);

%% add color bar and modify axis to show log-scale
hc = colorbar('horizontal');
set(hc, 'XTick', [], 'XTickLabel', [], 'YTick', [], 'YTickLabel', []);
Xlim(1) = zbin(1);
Xlim(2) = zbin(length(zbin));
% xlim = 10.^get(hc, 'Xlim');
xlim = 10.^Xlim;
% xlim = [1 30000]; %% force uniform axis
d1 = axes('Position', get(hc, 'Position'), 'TickDir', 'in', 'TickLength', [0.01 0], ... 
    'Visible', 'on', 'Xlim', xlim, 'XScale', 'log', 'YTick', [], 'YTickLabel', [], .....
    'Color', 'none', 'Box', 'on', 'Layer', 'top');
set(hc, 'XLabel', text('Parent', hc, 'String', bstring));
set(hc, 'Title', text('Parent', hc, 'String', [])); %% necessary to force xlabel in previous command