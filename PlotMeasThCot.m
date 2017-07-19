function PlotMeasThCot(Meas,dens,n1,k1,n2,k2,DcorStart,DcorStop,DshStart,DshStop,flag)


StepD=DcorStart;
NumStep=3;
colors={'y-','g-','r-','c-','m-','k-','b-','k-.'};
figure,
plot(scdp(Meas(:,1),dens),Meas(:,2),'k.','MarkerSize',5),hold on;
legendstr{1} = 'Measurement'
for k=1:NumStep
    CorSiz(k)=StepD;
    [Size(k,:),Resp(k,:)]=CotThDatGen(CorSiz(k),DshStart,DshStop,100,0.532,n1,k1,n2,k2);
    StepD=StepD+((DcorStop-DcorStart)/(NumStep-1));
    plot(Size(k,:),Resp(k,:),colors{k},'LineWidth',3),hold on,
    legendstr{k+1}=sprintf('Core Size = %g',CorSiz(k))
end
k=k+2;
[Size(k,:),Resp(k,:)]=ThDatGen(DshStart,DshStop,100,0.532,n2,k2);
plot(Size(k,:),Resp(k,:),colors{k},'LineWidth',3)
legendstr{k}='Pure Shell';
legend(legendstr,0);
k=k+1;
[Size(k,:),Resp(k,:)]=ThDatGen(DshStart,DshStop,100,0.532,n1,k1);
plot(Size(k,:),Resp(k,:),colors{k},'LineWidth',3),hold on,
legendstr{k}='Pure EC';
legend(legendstr,0);

xlabel('D_{p} (\mum)','FontSize',14)
ylabel('R (cm^{2}/particle)','FontSize',14)


% % % k=k+1;
% % % [Size(k,:),Resp(k,:)]=ThDatGenVolApprox(CorSiz(3),DshStart,DshStop,100,0.532,n1,k1,n2,k2,1);
% % % plot(Size(k,:),Resp(k,:),colors{k}),hold on,
% % % legendstr{k}=sprintf('VolApprox D_{core}=%g',CorSiz(3));
% % % legend(legendstr,0);

hold off