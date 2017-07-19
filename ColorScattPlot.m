function ColorScattPlot(D,R,PeakA)

coloredPeak = 100;
clip = 0;

hold on;

colorSteps = 5;

mycmap = hsv(fix(4.5*colorSteps/3));
if nargin < 10
    top = mean(PeakA) + 5*std(PeakA);
end
if nargin < 10
    bottom = min(PeakA);
else % lower lim is specified so we have to look for possible particles below it
    if(clip~=1) %if we clip there is no need looking
        mycolor = mycmap(min(colorSteps+2,size(mycmap,1)),:)
        mysub = find(PeakA < bottom)
        if (length(mysub)>0)
            plot(D(mysub,:),R(mysub,:),'r.','color', mycolor); 
        end
        hold on
    end
end



areaStep = (top-bottom)/colorSteps;
for i = 1:colorSteps
    mycolor = mycmap(colorSteps+2-i,:);
    mysub = find( (PeakA >= bottom+(i-1)*areaStep) & (PeakA <= bottom+i*areaStep) );
    if (i==1) 
        ctitle = [int2str(coloredPeak) ' from ' num2str(bottom+(i-1)*areaStep,3) ' to ' num2str(bottom+i*areaStep,3)];
    else
        ctitle = ['          ' num2str(bottom+(i-1)*areaStep,3) ' to ' num2str(bottom+i*areaStep,3)];
        if((colorSteps>12) & (fix(12*i/colorSteps) ==fix (12*(i-1)/colorSteps)))
            ctitle = '';
        end
    end
    plot(D(mysub,:),R(mysub,:),'r.','color', mycolor);  
    hold on
end

if( (clip==0) & (top<max(PeakA)))
        mycolor = mycmap(1,:);
        mysub = find(PeakA > top);
        if (length(mysub)>0)
            ctitle = ['           above ' num2str(top,3)];
            plot(D(mysub,:),R(mysub,:),'r.','color', mycolor); 
        end
end    
hold off;




