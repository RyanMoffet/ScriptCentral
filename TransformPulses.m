function [outdat] = TransformPulses(indat,slpe,int)

outdat = indat.*slpe + int;

zidx = find(outdat < 0);
outdat(zidx) = 0;