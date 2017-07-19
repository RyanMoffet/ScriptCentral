function PlotABErrComp(measA,measB,flag,varargin)
if flag == 1
    n1 = varargin{1}(1);
    k1 = varargin{1}(2);
    rho = varargin{1}(3);
elseif flag == 2
    n1=varargin{1}(1);
    k1=varargin{1}(2);
    n2=varargin{1}(3);
    k2=varargin{1}(4);
    rho=varargin{1}(5);
end

DshStart=0.1;
DshStop=max(measA(:,1));

for i=1:length(measA)
    asiz(i)=scdp(measA(i,1),rho);
end

colors={'k-','k','r-','c-','m-','b-','k-.','g-'};

k=1
if flag==1
    figure,plot(measA(:,1),measA(:,2),'r.-'),hold on,
    diff=abs(measA(:,2)-measB(:,2));
    av=(measA(:,2)+ measB(:,2))/2;
    figure,errorbar(asiz,av,diff,colors{k}),hold on
    legendstr{k}='measurement';
    k=k+1
    legendstr{k}='err';
    k=k+1;
    %% Compare to Mie
    [Size(k,:),Resp(k,:)]=ThDatGen(0.3,3,100,0.532,n1,k1);
    plot(Size(k,:),Resp(k,:),colors{k}),hold on,
elseif flag==2
    CorP=varargin{2};
    flag1=varargin{3};
    diff=abs(measA(:,2)-measB(:,2));
    av=(measA(:,2)+ measB(:,2))/2;
    figure,errorbar(asiz,av,diff,colors{k}),hold on
    legendstr{k}='measurement';
    k=k+1
    legendstr{k}='err';
    k=k+1;
    %% Compare to coated spheres
    [Size(k,:),Resp(k,:)]=CotThDatGen(CorP,DshStart,DshStop,100,0.532,n1,k1,n2,k2,flag1);
    plot(Size(k,:),Resp(k,:),colors{k}),hold on,
    if flag1==1
        legendstr{k}=sprintf('Coated Sphere Core Size = %g',CorP);
    elseif flag1==2
        legendstr{k}=sprintf('Coated Sphere Vol Frac = %g',CorP);
    end
    k=k+1
    %     %% Compare to volume approx
    %     [Size(k,:),Resp(k,:)]=ThDatGenVolApprox(CorP,DshStart,DshStop,100,0.532,n1,k1,n2,k2,2);
    %     plot(Size(k,:),Resp(k,:),colors{k}),hold on,
    %     legendstr{k}='Volume Mixing, 10%';
    %     legend(legendstr,0);
end

set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')
ymax=max(measA(:,2))+max(diff);
ylim([0,ymax]);

% label axes

xlabel('D_{p} (\mum)','FontSize',24,...
    'FontName','Times New Roman')

ylabel('R_{atofms} (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')
