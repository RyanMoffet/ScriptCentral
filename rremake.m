function [X,Y,Z] = remake(result)
X=[];
Y=[];
Z=[];
N = size(result,1);
x = sort(result(:,1));
duplicates(1) = 1;
duplicates(2:N) = x(2:end) - x(1:end-1);
X = x(find(duplicates~=0));
y = sort(result(:,2));
duplicates(1) = 1;
duplicates(2:N) = y(2:end) - y(1:end-1);
Y = y(find(duplicates~=0));
if(length(X)>length(Y))
    Y(end+1:length(X)) = 0;
else
    X(end+1:length(Y)) = 0;
end
Z = zeros(length(X), length(Y));
Z = Z./Z;
for i=1:N
%     if(result(i,2)~=0)
	x = find(X==result(i,1));
	y = find(Y==result(i,2));
	Z(x,y) = result(i,3);
%     end
end
% if ( size(X,2)>size(Y,2) )
%     toremove = size(X,2)-size(Y,2);
%     X(1:toremove) = [];
%     Z(1:toremove,:) = [];
% end
% if ( size(X,2)<size(Y,2) )
%     toremove = -size(X,2)+size(Y,2);
%     Y(1:toremove) = [];
%     Z(:,1:toremove) = [];
% end
return