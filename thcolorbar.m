%%% 04 April 2004

function hc = thcolorbar(bstring);

%% add color bar and modify axis to show log-scale
hc = colorbar('horizontal');
set(hc, 'XTick', [], 'XTickLabel', [], 'YTick', [], 'YTickLabel', []);
xlim = 10.^get(hc, 'Xlim');
d1 = axes('Position', get(hc, 'Position'), 'TickDir', 'in', 'TickLength', [0.01 0], ... 
    'Visible', 'on', 'Xlim', xlim, 'XScale', 'log', 'YTick', [], 'YTickLabel', [], .....
    'Color', 'none', 'Box', 'on', 'Layer', 'top');
set(hc, 'XLabel', text('Parent', hc, 'String', bstring));
set(hc, 'Title', text('Parent', hc, 'String', [])); %% necessary to force xlabel in previous command