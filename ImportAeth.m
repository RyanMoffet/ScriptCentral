% cd('C:\yaada\user\LightScattering\Calcofi\raw\Calcofi\aethalometer')
% cd('1')
% files1 = dir('BC*.csv');
% matcnt=0
% for i=1:length(files1)
%     matcnt=matcnt+1;
%     aethmat{matcnt}=getaethmat(files1(i).name);
% end
% 
% cd('..');cd('2');
% files2=dir('BC*.csv');
% for i=1:length(files2)
%     matcnt=matcnt+1;
%     aethmat{matcnt}=getaethmat(files2(i).name);
% end
% 
% cd('..');cd('3');
% files3=dir('BC*.csv');
% for i=1:length(files3)
%     matcnt=matcnt+1;
%     aethmat{matcnt}=getaethmat(files3(i).name);
% end
% 
% aeth=aethmat{1};
% for i=1:(length(aethmat)-1)
%     aeth=[aeth;aethmat{i+1}];
% end
% 
% aeth=sortrows(aeth,1);

%% NEPH DATA ___________________________________________________________________________________________________________________
% 
% cd('C:\yaada\user\LightScattering\Calcofi\raw\Calcofi\nephelometer');
% nephfile=dir('neph*.txt');
% for i=1:length(nephfile)
%     nephcell{i}=getnephmat(nephfile(i).name);
% end
% neph=[nephcell{1};nephcell{2}];
% 
% neph=sortrows(neph,1);
% 
% [hrneph,avneph]=averageneph(neph(:,1)+datenum([0,0,0,8,0,0]),neph(:,2)*10^6,'08-Nov-2004 07:00:00','19-Nov-2004 08:00:00','1:00:00')
% 
% figure,plot(hrneph,nephcorr,'b.-',thrsmps,bsca,'r.-')
% legend('measured','calculated from size',2)
% set(gca,'XTick',[datenum(datstr)]')
% datetick('x','mm/dd','keeplimits','keepticks')
% 
% 
% hl1 = line(neph(:,1),neph(:,2),'Color','r');
% ax1 = gca;
% set(ax1,'YColor','r')
% 
% ax2 = axes('Position',get(ax1,'Position'),...
%            'YAxisLocation','right',...
%            'Color','none',...
%            'YColor','k');
%        
% set(ax1,'YLim',[min(neph(:,2)),max(neph(:,2))]);
% set(ax2,'YLim',[min(aeth(:,4)),max(aeth(:,4))]);
%        
% hl2 = line(aeth(:,1),aeth(:,4),'Color','k','Parent',ax2);


%% Start importation of APS Data_________________________________________________________________________________________________

% cd('C:\yaada\user\LightScattering\Calcofi\raw\Calcofi\APS_export')
% apsfile=dir('aps*.txt')
% for i=1:length(apsfile)
%     [Xtmp,Ytmp,Ztmp] = getAPSmatrixRyan(apsfile(i).name);
%     X{i}=Xtmp;Y{i}={Ytmp};Z{i}=Ztmp;
%     clear Xtmp Ytmp Ztmp
% end
% clear Xfin Yfin Zfin
% Xfin=X{1};Yfin=Y{1};Zfin=Z{1};
% for i=1:length(apsfile)
%     Xfin=[Xfin;X{i}];
% %     Yfin=[Yfin,Y{i}];
%     Zfin=[Zfin,Z{i}];
% end

% plotapstemps(Xfin,Yfin{1},Zfin)

% [APSTime,APSSize,APSConc]=averageaps(Xfin,Yfin{1},Zfin,'08-Nov-2004 07:00:00','19-Nov-2004 08:00:00','1:00:00')
% plotapstemps(APSTime,APSSize,APSConc)

%%%% Now start importing the SMPS data_______________________________________________________________________________________________
% cd('C:\yaada\user\LightScattering\Calcofi\raw\Calcofi\SMPSTextExp\DN_Combined\DN_30min_res')
% [smpsout{1}] = CalSMPS('Comb_30min_P1.txt');
% [smpsout{2}] = CalSMPS('Comb_30min_P2.txt');
% [smpsout{3}] = CalSMPS('Comb_30min_P3.txt');
% 
% smpsbin{1}=SizeBin_SMPS_P1';
% smpsbin{2}=SizeBin_SMPS_P2';  %% Should only need to focus on smpsbin(1 and 2) due to  neph problems
% smpsbin{3}=SizeBin_SMPS_P3';


%% Need to truncate data to keep size bins and do all kinds of shit to compensate for changing size
%% bins
% smpsconc=zeros(length(smpsout{2}(:,1))+length(smpsout{3}(:,1)),length(smpsbin{3}));
% 
% smpsconc(1:111,1:103)=smpsout{2}(:,3:end);
% smpsconc(112:end,1:110)=smpsout{3};

% for i=1:length(smpsconc(:,1))
%     for j=1:length(smpsconc(1,:))
%         if smpsconc(i,j)==0
%             smpsconc(i,j)=NaN;
%         else
%             continue
%         end
%     end
% end


% smpstime{1}=DateTime_30min_P2;
% smpstime{2}=DateTime_30min_P3;
% smpsin{1}=smpsout{2};smpsin{2}=smpsout{3};
% smpssiz=smpsbin{3};

%% This stiches all of the smps data together.
% [thrsmps,chrsmps]=makesmpstimes(smpstime,smpsin,'08-Nov-2004 07:00:00','19-Nov-2004 08:00:00','1:00:00')
% 
% 
% 
% [apsdndd]=givedndd(APSSize,APSConc,'volume')
% [smpsdndd]=givedndd(smpssiz/1000,chrsmps,'volume');
% plotapstemps(thrsmps,smpssiz,smpsdndd)

%% trapz is what we want to use to perform the integrations!!

% [crap]=IntNephResp(450,600,300)