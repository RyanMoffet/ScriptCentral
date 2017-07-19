function CompScatt(ax,ay,bx,by,legendstr,fig)


hold off,

plot(ax,ay,'b.','MarkerSize',2),hold on,
plot(bx,by,'r.-','MarkerSize',2),

xlim([0.1,3])
ylim([0,5e-8])
set(gca,'FontSize',14)

legend(legendstr,2)
set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')

xlabel('D_{a} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('R (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')

if fig==1
pos = [1,.5,2,1.5];

% set(gca,'Units','inches','Position',pos)
% set(gca,'Position',pos)
orient landscape
set(gcf,'PaperPosition',pos)
end
hold off,
