function CompareTemporals(inx1,iny1,inx2,iny2,label1,label2)

%% Compare Temporals 

j=1;
for i=1:length(inx1)
    if iny1(i) <= 0 | iny2(i) <= 0 | isnan(iny1(i)) | isnan(iny2(i))
        finy1(i)=NaN;
        finy2(i)=NaN;
        finx1(i)=inx1(i);
        finx2(i)=inx2(i);
    else
        finy1(i)=iny1(i);
        finy2(i)=iny2(i);
        finx1(i)=inx1(i);
        finx2(i)=inx2(i);
        f2iny1(j)=iny1(i);
        f2iny2(j)=iny2(i);
        f2inx1(j)=inx1(i);
        f2inx2(j)=inx2(i);
        j=j+1;
    end
end

figure,plot(finx1,finy1,'b.-')
hold on 
plot(finx2,finy2,'g.-') 
legend(label1,label2)
% datstr = {'11/08/04','11/09/04','11/10/04','11/11/04','11/12/04','11/13/04','11/14/04','11/15/04','11/16/04'...
%     '11/17/04','11/18/04','11/19/04'}
% set(gca,'XTick',[datenum(datstr)]')
datetick('x','mm/dd','keeplimits','keepticks')

x=linspace(min([min(f2iny1),min(f2iny2)]),max([max(f2iny1),max(f2iny2)]),100);
y=linspace(min(f2iny1(1)),max(f2iny1(end)),100);
pout=polyfit(f2iny1,f2iny2,1);
pdat=polyval(pout,x);
figure,plot(f2iny1,f2iny2,'ko',x,y,'k--',x,pdat,'k-');
r=corrcoef(f2iny1,f2iny2);
r2=r(1,2)^2;
text((max(x)-min(x))/3,pout(1)*(max(y)-min(y))/3+pout(2)...
        ,sprintf('y=%g*X+%g r^{2}=%g',pout,r2),'FontSize',10)
xlabel(label1);
ylabel(label2);