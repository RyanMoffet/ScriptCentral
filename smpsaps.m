
% [apsdndd]=givedndd(APSSize,APSConc)

% [apsdndd]=givedndd(APSSize,APSConc,'volume');
% [smpsdndd]=givedndd(smpssiz/1000,chrsmps);


% semilogx(smpssiz/1000,smpsdndd(:,260),'r.-',APSSize,apsdndd(:,260)/(1000/5),'b.-')

% plot(smpssiz/1000,smpsdndd(:,50),'r.-')


%% To do on the plane
%% Write script to plot area, volume and number distributions - DONE!
%% Join aps and smps data then plot!!

[apsvoldist]=givedndd(APSSize,APSConc,'volume');
[smpsvoldist]=givedndd(smpssiz/1000,chrsmps,'volume');

totvoldist=[smpsvoldist;apsvoldist(3:end,:)];

totalsiz=[smpssiz/1000,APSSize(3:end)];

contourf(thrsmps,log(totalsiz),totvoldist)