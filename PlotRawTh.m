function PlotRawTh(RawDa,RawR,rho,varargin)

figure,
Dp = scdpArray(RawDa,rho);

% % [Size,Resp]=ThDatGen(0.1,3,100,0.532,n,k);

plot(Dp,RawR,'b.','MarkerSize',5),hold on,

legendstr{1} = 'Raw',

colors={'r-','g-','b-','c-','m-','k-','y-'};

k=2;
for i=1:length(varargin)
    [Size{i},Resp{i}]=ThDatGen(0.1,3,100,0.532,...
        varargin{i}(1),varargin{i}(2));
    plot(Size{i},Resp{i},colors{i},'LineWidth',5), hold on,
    legendstr{k}=sprintf('theory m=%g+%gi',varargin{i});
    k=k+1;
end

% label axes

xlabel('D_{p} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('Intensity (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')

% create annotation with n and rho

legend(legendstr);
% % text(0,0,[sprintf('n = %g ',varargin{i}), '\rho' ,sprintf('= %g',rho)]...
% %     ,'FontSize',18)

