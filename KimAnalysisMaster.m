% %% Kim analysis
% KimSizBins=linspace(0.1,5,30);
% [PulseBscaA,ScPulseA] = PulseBsca(lumptype,SmClDists,SmClSiz,thrsmps,KimSizBins,[SaaSlope,SaaInt],'saarea')
% save LumpWorkup.mat
% 
% for i=1:length(ScPulseA)
%     for j=1:length(ScPulseA{i}(:,1))
%         BscaFromPulse{i}(j)=nansum(ScPulseA{i}(j,:));
%     end
% end
% 
% for i=1:length(ScPulseA)
%     for j=1:length(ScPulseA{i}(:,1))
%         TotPulseBsca(j)=nansum([BscaFromPulse{1}(1,j),BscaFromPulse{2}(1,j),BscaFromPulse{3}(1,j)]);
%         if TotPulseBsca(j)==0
%             TotPulseBsca(j)=NaN;
%         end
%     end
% end
% figure,plot(thrsmps,TotPulseBsca*1e6,'r-',thrsmps,CorrectedNeph,'k-')
% CompareTemporals(thrsmps,TotPulseBsca*1e6,thrsmps,CorrectedNeph,'Atofms','Neph')
% CompareTemporals(thrsmps,TotPulseBsca*1e6,thrsmps,CalcBabs2,'Atofms','Calculated')

%%% Doing for total distribution...______________________________________________________________________________

TotType{1}=union(lumptype{1},lumptype{2});
TotType{1}=union(TotType{1},lumptype{3});
SmTotDists{1}=SmClDists{1}+SmClDists{2}+SmClDists{3};
SmTotdists{2}=SmClDists{1};
[PulseBscaTot,ScPulseTot] = PulseBsca(TotType,SmTotDists,SmClSiz,thrsmps,KimSizBins,[SaaSlope,SaaInt],'saarea');

for j=1:length(ScPulseTot{1}(:,1))
    TotBscaFromPulse(j)=nansum(ScPulseTot{1}(j,:));
end

CompareTemporals(thrsmps,TotBscaFromPulse*1e6,thrsmps,CorrectedNeph,'Atofms','Neph')
CompareTemporals(thrsmps,TotBscaFromPulse*1e6,thrsmps,CalcBabs2,'Atofms','Calculated')
