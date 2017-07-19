function CompareWithTheoryCoat(meas,rho,flag1,varargin)

%% meas = [Dp;err;cs]
%% CorP = either volume fraction or the core size
%% flag1 = flag for call to CotThDatGen == 1 for constant core size
%%                                      == 2 for constant volume frac
%% varargin{i} = [n1,k1,n2,k2,corP]

DshStart=0.15;
DshStop=max(meas(:,1));

for i=1:length(meas)
    asiz(i)=scdp(meas(i,1),rho);
end

colors={'k-','k','r-','c-','m-','b-','k-.','g-'};

%% Plot measured data
k=1
figure,plot(asiz,meas(:,2),'r.-'),hold on,
legendstr{k}='measurement';
k=k+1;

%% Compare to coated spheres
for i=1:length(varargin)
    CorP=varargin{i}(end);
    [Size(k,:),Resp(k,:)]=CotThDatGen(CorP,DshStart,DshStop,100,0.532,varargin{i}(1)...
        ,varargin{i}(2),varargin{i}(3),varargin{i}(4),flag1);
    plot(Size(k,:),Resp(k,:),colors{k}),hold on,
    if flag1==1
        legendstr{k}=sprintf('Core Size = %g, m_{s}=%g+%gi'...
            ,CorP,varargin{i}(3),varargin{i}(4));
    elseif flag1==2
        legendstr{k}=sprintf('Vol Frac = %g, m_{s}=%g+%gi'...
            ,CorP,varargin{i}(3),varargin{i}(4));
    end
    k=k+1;
end
%     %% Compare to volume approx
%     [Size(k,:),Resp(k,:)]=ThDatGenVolApprox(CorP,DshStart,DshStop,100,0.532,n1,k1,n2,k2,2);
%     plot(Size(k,:),Resp(k,:),colors{k}),hold on,
%     legendstr{k}='Volume Mixing, 10%';
legend(legendstr,0);   

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')
ymax=max(meas(:,2));
ylim([0,ymax]);

% label axes

xlabel('D_{p} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('R_{atofms} (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')
