function plotABscatt(measA,measB)

figure,plot(measA(:,1),measA(:,2),'r.-'),hold on,
plot(measB(:,1),measB(:,2),'b.-');

legend({'PMT A','PMT B'},0)

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')

% label axes

xlabel('D_{p} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('Intensity (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')
