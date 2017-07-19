function PlotThCot(n1,k1,n2,k2,DcorStart,DcorStop,DshStart,DshStop)


StepD=DcorStart;
NumStep=5;
colors={'y-','g-','r-','c-','m-','k-','b-','k-.'};
figure,
for k=1:NumStep
    CorSiz(k)=StepD;
    [Size(k,:),Resp(k,:)]=CotThDatGen(CorSiz(k),DshStart,DshStop,100,0.532,n1,k1,n2,k2);
    StepD=StepD+((DcorStop-DcorStart)/NumStep);
    plot(Size(k,:),Resp(k,:),colors{k}),hold on,
    legendstr{k}=sprintf('Core Size = %g',CorSiz(k))
end
k=k+1;
[Size(k,:),Resp(k,:)]=ThDatGen(DshStart,DshStop,100,0.532,n2,k2);
plot(Size(k,:),Resp(k,:),colors{k})
legendstr{k}='Pure Shell';
legend(legendstr,0);
k=k+1;
[Size(k,:),Resp(k,:)]=ThDatGen(DshStart,DshStop,100,0.532,n1,k1);
plot(Size(k,:),Resp(k,:),colors{k}),hold on,
legendstr{k}='Pure Coating';
legend(legendstr,0);
k=k+1;
[Size(k,:),Resp(k,:)]=ThDatGenVolApprox(CorSiz(3),DshStart,DshStop,100,0.532,n1,k1,n2,k2,1);
plot(Size(k,:),Resp(k,:),colors{k}),hold on,
legendstr{k}=sprintf('VolApprox D_{core}=%g',CorSiz(3));
legend(legendstr,0);

