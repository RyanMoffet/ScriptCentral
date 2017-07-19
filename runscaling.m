
%% Taken from temporals.m_____________________________________________________________________
%% 
% start=datenum('08-Nov-2004 07:00:00')-datenum(0,0,0,8,0,0);
% stop=datenum('19-Nov-2004 08:00:00')-datenum(0,0,0,8,0,0);
% res=datenum('1:00:00');
% nbin=(stop-start)/res;
% 
% hit=run_query(sprintf('InstCode == ELD and Time = [%f %f] and Hit == 1',start,stop));
% miss=run_query(sprintf('InstCode == ELD and Time = [%f %f] and Hit == 0',start,stop));
% hittimes=get_column(hit,'Time');
% misstimes=get_column(miss,'Time');

%% Run scaling_________________________________________________________________

% SizTiGmt=thrsmps-datenum(0,0,0,8,0,0);
% 
% [apsnumdist]=givedndd(APSSize,APSConc'/5000,'number',1);
% [smpsnumdist]=givedndd(smpssiz/1000,chrsmps','number',1);

% totnumdist=[chrsmps',APSConc(3:end,:)']; 
% totalsiz=[smpssiz/1000,APSSize(3:end)];
totaldndd=givedndd(totalsiz,totnumdist,'area',1);
semilogx(totalsiz,totaldndd(55,:))
% plotapstemps(SizTiGmt,totalsiz,totnumdist')
% [sout1,HR_dat,NMissT,NMissR]=Satofms(hit,miss,start,stop...
%     ,SizTiGmt,totalsiz,totnumdist);
% 
% save LumpWorkup.mat

% figure,plotapstemps(thrsmps,totalsiz,sout'*50)

% figure,loglog(totalsiz,sout1(115,:),'b.-')

% lumptype{1}=class{1} % SeaSalt
% for I = [2,3,4,5,6,12,13,14,7,11];
%     lumptype{1} = union(class{I},lumptype{1});
% end
% 
% lumptype{2}=class{8} % Dust
% for I = [9,10,21];
%     lumptype{2} = union(class{I},lumptype{2});
% end
% 
% lumptype{3}=class{22} % Carbon
% for I = [20,17,18,19,25,23,24,15,16];
%     lumptype{3} = union(class{I},lumptype{3});
% end
% 
% lumptype{4}=miss;

% for i=1:length(lumptype)
% [idtimes{i},idsize{i}]=get_column(lumptype{i},'Time','Da');
% end

% lumpconcs1=lumpconcs{1};
% lumpconcs3=lumpconcs{3};
% lumpconcs4=lumpconcs{4};
% [lumpconcs]=ScaleCounts(lumptype,start,stop,res,sout1,totalsiz)
% lumpconcs{4}=NMissT;
% lumpconcs{5}=NMissR;
% save LumpWorkup.mat

% % % 
% % save scaling.mat
% % 
% figure,semilogx(totalsiz(99:end),lumpconcs{5}(55,:)')
% for i=1:length(lumpconcs)
%     [scmaschmdist{i}]=givedndd(totalsiz(99:end),lumpconcs{i}(:,99:end),'mass',1);
% end
% totmassdist=givedndd(totalsiz,totnumdist','mass',1)
% semilogx(totalsiz(99:end),scmaschmdist{1}(200,:),'b.-',...
%     totalsiz(99:end),scmaschmdist{2}(200,:),'r.-',...
%     totalsiz(99:end),scmaschmdist{3}(200,:),'k.-',...
%     totalsiz(99:end),scmaschmdist{4}(200,:),'y.-',...
%     totalsiz(99:end),scmaschmdist{5}(200,:),'g.-',...
%     totalsiz(99:end),totmassdist(200,99:end)','k:')
% legend({'ss','land','Carb','miss type','miss_tot'},-1);
% plottimestack(start,stop,res,scmaschmdist,totalsiz(99:end),thrsmps,datstr)
% plotsizestack(scmaschmdist,totalsiz,datenum('08-Nov-2004 18:30:00'),res,thrsmps,datstr)

% [apsvoldist]=givedndd(APSSize,APSConc/5000,'volume');
% 
% [apsmassdist]=givedndd(APSSize,APSConc/5000,'mass',1);
% [smpsmassdist]=givedndd(smpssiz/1000,chrsmps,'mass',1);
% totmassdist=[smpsmassdist;apsmassdist(3:end,:)]; 
% 
% figure,semilogx(totalsiz,totmassdist(:,260),'b.-')
% for i=1:length(totmassdist(:,1))
%     for j=1:length(totmassdist(1,:))
%         if isnan(totmassdist(i,j))
%             totmassdist(i,j)=0;
%         end
%     end
% end
% trapz(log10(totalsiz),totmassdist(:,260))*1e6

