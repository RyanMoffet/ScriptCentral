
CraigsWaves=[880,520,370];
for i=1:length(CraigsWaves)
%     [CraigBsca1(i)]=BscaAngIntForCraig(OPCConcs',OPCSizBins,CraigsWaves(i),1,1.5,0.01,0,0,0,'TotMieSca')*1e6;
%     [CraigBsca2(i,:)]=BscaAngIntForCraig(OPCConcs2,OPCSizBins,CraigsWaves(i),1,1.5,0.01,0,0,0,'TotMieSca')*1e6;
%     [CraigBsca3(i,:)]=BscaAngIntForCraig(OPC_concs_3,OPC_bins_3,CraigsWaves(i),1,1.5,0.01,0,0,0,'TotMieSca')*1e6;
    [CraigBsca4(i,:)]=BscaAngIntForCraig(OPC_concs_3,OPC_bins_4,CraigsWaves(i),1,1.5,0,0.002,0,0,'TotMieSca')*1e6;
end

save CraigsWorkspace.mat