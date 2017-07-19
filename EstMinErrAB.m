function EstMinErrAB(measA,measB,flag,varargin)
n1=varargin{1}(1);
k1=varargin{1}(2);
n2=varargin{1}(3);
k2=varargin{1}(4);
rho=varargin{1}(5);
CoatFrac=varargin{2};

ncoat=5;
StepSize=CoatFrac/ncoat;

DshStart=min(measA(:,1));
DshStop=max(measA(:,1));

for i=1:length(measA)
    asiz(i)=scdp(measA(i,1),rho);
end

colors={'k-','k','g-','r-','c-','m-','b-','k-.'};

k=1;
if flag==1
    figure,plot(measA(:,1),measA(:,2),'r.-'),hold on,
    plot(measB(:,1),measB(:,2),'b.-');
elseif flag==2
    diff=abs(measA(:,2)-measB(:,2));
    av=(measA(:,2)+measB(:,2))/2;
    figure,errorbar(asiz,av,diff,colors{k}),hold on
    legendstr{k}='measurement';
    k=k+1;
    legendstr{k}='err';
    k=k+1;
    %% Compare to coated spheres
    for i=1:ncoat
        [Size(k,:),Resp(k,:)]=CotThDatGen(CoatFrac,DshStart,DshStop,100,0.532,n1,k1,n2,k2,2);
        plot(Size(k,:),Resp(k,:),colors{k}),hold on,
        legendstr{k}=sprintf('Coated Sphere Vol Frac = %g',CoatFrac);
        CoatFrac=CoatFrac-abs(StepSize);
        k=k+1;
    end
    legend(legendstr,0);
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
