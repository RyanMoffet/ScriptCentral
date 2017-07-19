function [stdev, method] = plotMDS(Area, myAxes, group1, color1, color2, updateRating, clusterNum, PIDlen, rating1good, rating1neutral, rating1bad)
% PlotMedSpec is part of parseTree, draws the median relative area of given
% area matrix into the given axes.
% it also shows the 25% and 75% quartiles on top of/below the peak
% YAADA - an object-oriented toolkit to manage and analyze 
%         single particle mass spectral data
%
% Copyright (C) 1999-2000 California Institute of Technology, 
% all rights reserved.
%
% Thomas Rebotier Sep, 2005
if nargin < 5
  error('Call as stdev = plotMDS(Area, myAxes, group1, color1, color2)');
end
if nargin < 10
    updateRating = 0;
end

clutter = get(myAxes, 'Children');
delete(clutter);
N = size(Area,1);
if (N>1)
    if exist('group1','var')
        index2 = (ones(N,1)-sparse(group1,[1],ones(length(group1),1),N,1));
        group2 = find(index2);
        group1 = group1(find(group1<=2000));
        group2 = group2(find(group2<=2000));
    end
    dist700d = pdist(Area);
    % Random repartition between the 3 methods NO IN FACT TEST ONLY KRUSKAL
%    tic;
    if(updateRating==0 | rand<=-1.3333333333333333333333333)
        method = 'linear';
        [PC,SCORE,latent,tsquare] = princomp(Area);
        Z = SCORE(:,1:2);
    else if(rand<=0.5)
            method = 'kruskal';
            [PC,SCORE,latent,tsquare] = princomp(Area);
		
            % 1-D variable Z = [X Y]
            % sum of square error = f(distances)= f(distances(Z))= f(Z)
            Z = SCORE(:,1:2);
            Z = adjustZ(Z, fix(10+sqrt(N)), dist700d, ones(1,N), 5);
        else
            method = 'rebotier';
            global clusterAreas;
            global HTree;
            global subSizes;
            Z = 0.01*rand(2,2);;
            currentNodes(1) = HTree(PIDlen-clusterNum, 1);
            currentNodes(2) = HTree(PIDlen-clusterNum, 2);
            ingroup = [1 2];
            clear Area;
            clear Weights;
            Area(1,:) = clusterAreas{currentNodes(1)};
            Area(2,:) = clusterAreas{currentNodes(2)};
            Weights(1) = subSizes(currentNodes(1));
            Weights(2) = subSizes(currentNodes(2));
            readjust = 0;
            for step = 2:N-1
            %for step = 2:10
                % explode node
                [split,where] = max(currentNodes);
                Area(where,:)=[];
                Weights(where)=[];
                currentNodes(where)=[];
                thegroup = ingroup(where);
                ingroup(where)=[];
                new = size(Area,1)+1;
                currentNodes(new) = HTree(split-PIDlen, 1);
                currentNodes(new+1) = HTree(split-PIDlen, 2);
                ingroup(new) = thegroup;
                ingroup(new+1) = thegroup;
                Area(new,:) = clusterAreas{currentNodes(new)};
                Area(new+1,:) = clusterAreas{currentNodes(new+1)};
                Weigths(new) = subSizes(currentNodes(new));
                Weights(new+1) = subSizes(currentNodes(new+1));
                group1 = find(ingroup==1);
                group2 = find(ingroup==2);
                oldZ = Z(where,:);
                Z(where,:) = [];
                Z(new,:) = oldZ+0.01*rand(1,2);
                Z(new+1,:) = oldZ+0.01*rand(1,2);
                % calcule dist700d
				dist700d = pdist(Area);
                % adjust result
                if(readjust == 0)
                    Z = adjustZ(Z, 5, dist700d, Weights, 4);
                    readjust = step-2 ;
                else
                    readjust = readjust-1;
                end
%                 if(mod(step,5)==0)
%                     figure
%                     color1='r';
%                     color2='b';
%                     group1
%                     group2
%                     Z
%                     q = plot(Z(group1,1), Z(group1,2),'r.','color',color1);
%                     hold on
%                     r = plot(Z(group2,1), Z(group2,2),'r.','color',color2);
%                 end
            end
            Z = adjustZ(Z, fix(5+sqrt(N/4)), dist700d, ones(1,N), 5);
        end
    end
%    toc;
    axes(myAxes);
    if exist('group1','var')
%         color1='r';
%         color2='b';
        q = plot(Z(group1,1), Z(group1,2),'r.','color',color1);
        hold on
        r = plot(Z(group2,1), Z(group2,2),'r.','color',color2);
    else
    % Axes for linear MDS
        q = plot(Z(:,1), Z(:,2),'r.','color','r');
    end
    % give an estimate of the scale
    ssd = sum(dist700d .* dist700d);
    n = size(Z,1);
    stdev = sqrt(ssd/ (n*(n+1)/2));                
 
else % N==1
    q = plot(0.5, 0.5,'r.','color','k');    
    stdev = 0.0;
end
if(exist('updateRating','var'))
    if(updateRating==1)
        set(rating1good,'Callback', ['mdsRating(''' method ''', 1,' int2str(clusterNum) ',' int2str(N) ')']);
        set(rating1neutral,'Callback', ['mdsRating(''' method ''', 0,' int2str(clusterNum) ',' int2str(N) ')']);
        set(rating1bad,'Callback', ['mdsRating(''' method ''', -1,' int2str(clusterNum) ',' int2str(N) ')']);
    end
end
return 

function Z = adjustZ(Z, iterations, dist700d, w, kmax )
    %learningRate = size(w,1) / (sqrt(iterations)*size(Z,1)*sum(w));
    epsilon = size(w,1) / (size(Z,1)*sum(w));
    g = .38197;
    for(iter=1:iterations)
        dist2d = pdist(Z);
        rawStress = norm(dist2d-dist700d);
        pregradient = squareform((dist700d-dist2d)./(dist2d+.1));
        xdiffs = Z(:,1)*w;
        xdiffs = xdiffs - xdiffs';
        xgradient = sum(pregradient .* xdiffs , 2);
        ydiffs = Z(:,2)*ones(1,length(Z(:,1)));
        ydiffs = ydiffs - ydiffs';
        ygradient = sum(pregradient .* ydiffs , 2);
        dx = epsilon * xgradient;
        dy = epsilon * ygradient;
        Z1(:,1) = Z(:,1) + dx;
        Z1(:,2) = Z(:,2) + dy;
        dist2d1 = pdist(Z1);
        rawStress1 = norm(dist2d1-dist700d);
        Z0 = Z;
        rawStress0 = rawStress;
        toofar = 40*epsilon;
        rawStress2 = rawStress1-1;
        %up by octaves, 
        while(rawStress2<rawStress1)
            toofar = 2*toofar;
            Z2(:,1) = Z(:,1) + toofar * xgradient;
            Z2(:,2) = Z(:,2) + toofar * ygradient;       
            dist2d2 = pdist(Z2);
            rawStress2 = norm(dist2d2-dist700d);
        end
        % down by, well not quite fifths, but its pythagorean anyways
        larger =2;
        step0 = 0;
        step1 = epsilon;
        step2 = toofar;
        newZ = Z;
        for k=1:kmax
            if(larger==1)
                newStep = (1-g)*step1 + g*step0;
            else
                newStep = (1-g)*step1 + g*step2;
            end
            newZ(:,1) = Z(:,1) + newStep * xgradient;
            newZ(:,2) = Z(:,2) + newStep * ygradient;
            dist2d = pdist(newZ);
            newStress = norm(dist2d-dist700d);
            if(larger==1)                % New point cutting first segment
                if(newStress<rawStress1) % Keep 0, new, 1
                    step2 = step1;
                    Z2 = Z1;
                    rawStress2 = rawStress1;
                    step1 = newStep;
                    Z1 = newZ;
                    rawStress1 = newStress;
                else                     % Keep new, 1, 2
                    step0 = newStep;
                    Z0 = newZ;
                    rawStress0 = newStress;                   
                end
            else                         % New point cutting second segment
                if(newStress<rawStress1) % Keep 1, new, 2
                    step0 = step1;
                    Z0 = Z1;
                    rawStress0 = rawStress1;
                    step1 = newStep;
                    Z1 = newZ;
                    rawStress1 = newStress;                   
                else                     % Keep 0, 1, new
                    step2 = newStep;
                    Z2 = newZ;
                    rawStress2 = newStress;                   
                end
            end
            % what is the new larger segment now?
            if( (step1-step0)>(step2-step1) )
                larger =1;
            else
                larger = 2;
            end
        end % k loop of golden mean sections
        Z = newZ;
    end % iterations
return