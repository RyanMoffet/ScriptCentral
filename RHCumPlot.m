function RHCumPlot(RHVal)

bins=10:5:100;

linestr={'k-','k-.','b'}

figure,
for i = 1:length(RHVal)
    for j=1:length(bins)-1
        idx=find(RHVal{i}<bins(j));
        dat{i}(j,:)=[bins(j),length(idx)/length(RHVal{i})];
        clear idx
    end
    plot(dat{i}(:,1),dat{i}(:,2),linestr{i},'LineWidth',3),hold on,
end
legend('Soar','Milagro',2);
set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')
xlabel('RH (%)','FontSize',24,...
    'FontName','Times New Roman');
ylabel('Fraction of Time Below RH','FontSize',24,...
    'FontName','Times New Roman');
