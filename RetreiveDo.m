function [rho]=RetriveDo(InDat,MinD,MaxD,N,name,varargin)

% % InDat = [Size,CS,Err]
% % MinD = Minimum geometric diameter
% % MaxD = Maximum geometric diameter
% % N = Order of polynomial fit used to retretive the optical density
% % varargin = refractive indices to be used in optical diameter retrevial:
% %            [n,k]
% %
% % rho = matrix whos columns contain the mean, upper bound, and lower
% %       bound of the retreived density (in that order). The rows correspond 
% %       to the different optical sizes.
% % 
% % Ryan Moffet 12/06
% % Updated RCM 1/07

%%% Truncate InDat according to MinD and MaxD

outidx=find(InDat(:,1) > MinD & InDat(:,1) < MaxD);
TruncDat=InDat(outidx,:);

%%% initiate plotting parameters

k=1;
NumStep=100;
colors={'b-','g-','r-','c-','m-','k-','y-'};

%%% Generate Theoretical Curves
figure,
for i=1:length(varargin)
    [Size{i},Resp{i}]=ThDatGen(MinD,MaxD,NumStep,0.532,...
        varargin{i}(1),varargin{i}(2));
    RespMat(:,i)=Resp{i}(:);
    plot(Size{i},Resp{i},colors{i}),hold on,
    legendstr{k}=sprintf('theory m=%g+%gi',varargin{i});
    k=k+1;
end

%%% Now average the theoretical curves and fit them to a polynomial
%%% model: D = C + C1*I + C2*I^2 ... + CN*I^N

meandat=mean(RespMat')';
plot(Size{1},meandat,colors{i+1}),hold on,
i=i+1;
[p,s]=polyfit(Size{1}',meandat,N);

%%% Plot the fit 

xdat=linspace(Size{1}(1),Size{1}(end));
ydat=polyval(p,xdat);
plot(xdat,ydat,colors{i});
legendstr{k}='best fit to mean';
k=k+1;  
legendstr{k}='average';
legend(legendstr,0)
set(gca, 'FontSize', 18,...
    'FontName','Times New Roman')
xlabel('D_{a} (\mum)','FontSize',24,...
    'FontName','Times New Roman')
ylabel('R (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman')

%%% Now evaluate the polynomials and plot them (again!)

[p1,s1]=polyfit(meandat,Size{1}',N);
[p2,s2]=polyfit(RespMat(:,1),Size{1}',N);
[p3,s3]=polyfit(RespMat(:,end),Size{1}',N);

figure, 
plot(meandat,Size{1},'k-'),hold on,
plot(meandat,polyval(p1,meandat),'r-')
xlabel('R (cm^{2}/particle)','FontSize',24,...
    'FontName','Times New Roman');
ylabel('D_{a} (\mum)','FontSize',24,...
    'FontName','Times New Roman')
legend('Average Scattering','Fit to Average')

%%% Now retreive the optical diameter and calculate the density based on
%%% the relationship between aerodynamic diameter and optical (geometric)
%%% diameter. An upper and lower bound are the results given by the low and
%%% high refractive indices.

Do=polyval(p1,TruncDat(:,2));       
Dolow=polyval(p2,TruncDat(:,2));     
DoHi=polyval(p3,TruncDat(:,2));  
rho(:,1)=Do;
rho(:,2)=SlipRatio(TruncDat(:,1),Do).*(TruncDat(:,1)./Do).^2;
rho(:,3)=SlipRatio(TruncDat(:,1),Dolow).*(TruncDat(:,1)./DoHi).^2;
rho(:,4)=SlipRatio(TruncDat(:,1),DoHi).*(TruncDat(:,1)./Dolow).^2;

%%% Plot density vs. optical diamter
figure,
plot(Do,rho(:,2),'r-'),hold on,
plot(Do,rho(:,3),'b-'),hold on,
plot(Do,rho(:,4),'k-'),
xlabel('D_{a} (\mum)','FontSize',24,...
    'FontName','Times New Roman')
ylabel('Effective Density (g/cm^{3})','FontSize',24,...
    'FontName','Times New Roman')
legend('average density','upper bound','lower bound'); 
title(sprintf('%s',name))
