% for i = 1:( length(jt_full)-1 )
%     if jt_full(i+1) < jt_full(i)
%         jt_full(i+1)
%         i+1
%     end
% end
% 
% idx = [1:1:length(jt_full)];
% figure,
% plot(jt_full,idx)    

t = [1:100];

for i = 50:length(t)
    t(i) = t(i)+50;
end
sbn = [1:5];

for j = 1:length(sbn)
    z(1,j) = i*j*100;
end
for i = 2:length(t)
    if t(i) > t(i-1)+1
        z(i,:) = 0;
    else
        for j = 1:length(sbn)
            z(i,j) = i*j*100;
        end
    end
end

z = z';
z = log10(z + eps);
zbn = thresholdbar(z, log10(10000), 24);

for i = 1:length(t)
    conc(i) = sum(z(:,i));
end
figure,
subplot(2,1,1)
plot(t,conc)
subplot(2,1,2)
[C1 hcp] = contourf(t, sbn, z, zbn);



