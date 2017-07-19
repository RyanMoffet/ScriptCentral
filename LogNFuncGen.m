function [Out]=LogNFuncGen(sizerange,params,distype)

% % mu1=params(1)
% % mu2=params(2)
% % std1=params(3)
% % std2=params(4)
% % dn1=params(5)
% % dn2=params(6)

switch distype
    case 'monomod'
        for i=1:length(sizerange)
            distval(i)=params(3)*lognpdf(sizerange(i),params(1),params(2));
        end
    case 'bimodal'
        for i=1:length(sizerange)
            distval(i)=params(5)*lognpdf(sizerange(i),params(1),params(3))+...
                (params(6)*lognpdf(sizerange(i),params(2),params(4)));
        end
    case 'trimodal'
        for i=1:length(sizerange)
            distval(i)=params(7)*lognpdf(sizerange(i),params(1),params(4))+...
                (params(8)*lognpdf(sizerange(i),params(2),params(5))+...
                (params(9)*lognpdf(sizerange(i),params(3),params(6))));
        end
end
Out=[distval'];