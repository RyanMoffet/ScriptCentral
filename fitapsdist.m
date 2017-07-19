
% APSSize(2:end) APSConc(2:51,1)

% meas=[APSSize(2:30)',APSConc(2:30,100)];
% 
% par=[0.1,0.4,4000];
% 
% [sqerr,finalpar]=apslognfit(meas,par)
% 
% [errout,testpar]=apslognfit(meas,par);
% 
% tstdp=logspace(log(meas(1,1)),log(meas(29,1)),100);
% 
% [Conc1]=testpar(3)*lognpdf(tstdp,1,.5);
% 
% [Conc2]=testpar(3)*lognpdf(meas(:,1),testpar(1),testpar(2));
% 
% plot(meas(:,1),Conc2,'k-',meas(:,1),meas(:,2),'b.'), hold on, 
% 
% plot(tstdp,Conc1,'r-')

%% _______________________________________

% [apsdndd]=givedndd(APSSize,APSConc)

% meas=[APSSize(2:end)',apsdndd(2:end,200)];
% 
% plot(APSSize(2:end)',apsdndd(2:end,200))
% 
% par=[3,3,4000];
% 
% [sqerr,finalpar]=apslognfit(meas,par)
% 
% [errout,testpar]=apslognfit(meas,par);
% 
% tstdp=logspace(log(0.001),log(meas(29,1)),100);
% 
% [Conc1]=testpar(3)*lognpdf(tstdp,testpar(1),testpar(2));

[Conc2]=5e4*lognpdf(meas(:,1),testpar(1),testpar(2))+testpar(3)*lognpdf(meas(:,1),testpar(1)/3,testpar(2));

plot(meas(:,1),Conc2,'k-',meas(:,1),meas(:,2),'b.-'), hold on, 

% plot(tstdp,Conc1,'r-')
