% % these are the ranges used for generating the ambient phds
% % range1{1}=[.185 0.235];
% % range1{2}=[0.295 0.345];
% % range1{3}=[0.505 0.555];
% % range1{4}=[1.7 1.75];
% % range1{5}=[0.975 1.025];
% % range1{6}=[1.075 2.025];
%% These are the ranges for the psl:
% % range1{1}=[.185 0.235];
% % range1{2}=[0.295 0.345];
% % range1{3}=[0.505 0.555];
% % range1{4}=[0.975 1.025];
% % range1{5}=[1.075 2.025];

clear k i j
classes=[17:20,23,25];
colors={'k','b-','g-','r-','c-','m-','y-'};
pslrange=[1:5];
ambrange=[1:3,5,6];
for i=1:length(pslrange)
    clear legendstr,figure
    k=1;
    legendstr{1}='PSL';
    plot(hitpslphdB{i}(:,1),hitpslphdB{i}(:,2),colors{k}),...
        hold on,
    k=k+1;
    for j=classes
        if isempty(phdB{j}{ambrange(i)})
            continue
        else
            plot(phdA{j}{ambrange(i)}(:,1),phdA{j}{ambrange(i)}(:,2),colors{k}),...
                hold on;
            legendstr{k}=clstr{j};
            k=k+1;
        end
    end
    legend(legendstr,0);
    xlabel('Intensity (arb units)')
    ylabel('Normalized Frequency')
    title(sprintf('PMTB PHDs \n Range = %g - %g\mum'...
        ,range1{ambrange(i)}))
    clear k 
end
clear pslrange ambrange colors classes 


