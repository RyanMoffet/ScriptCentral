function PlotCrossSections(n,k,siz)

Dp = linspace(siz(1),siz(end),500);
colors={'b-','g-','r-','c-','m-','k-','y-'};

for j = 1:length(n)
    for i = 1:length(Dp)   
        [qsca(j,i),qext(j,i)]=MatBHC(1,0.532,n(j),k(j),n(j),k(j),Dp(i),Dp(i));
    end
    plot(Dp,qsca(j,:).*(pi.*(Dp./2).^2),colors{j},'LineWidth',3),hold on,
    legendstr{j}=sprintf('Theory m=%g+%gi',n(j),k(j));
end
hold off,
%%.*(pi.*(Dp./2).^2)
legend(legendstr,0)

% Set axis properties

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')

% ylim([min(procin(:,2)) max(procin(:,2))]) 

% label axes

xlabel('D_{p} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('C_{sca} (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')
