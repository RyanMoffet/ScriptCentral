% range1{1}=[.185 0.235];
% range1{2}=[0.295 0.345];
% range1{3}=[0.505 0.555];
% range1{4}=[1.7 1.75];
% range1{5}=[0.975 1.025];
range1{6}=[1.975 2.025];
% 

for i=1:length(clstr)
    [phdA{i},phdB{i}]=plotphdrange(class{i},range1{6},clstr{i})
    save cal051127.mat
end

