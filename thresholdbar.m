%%%% bin sorting for contour plots

function bins = thresholdbar(Z, th, c);

minZ = min(min(Z)');  %% minimum values for data matrix
maxZ = max(max(Z)');  %% maximum values for data matrix
if length(th) == 2
    if minZ < min(th); minZ = min(th); end;  %% apply threshold to data
    if maxZ > max(th); maxZ = max(th); end;  %% apply threshold to data
end;
bins = [minZ:(maxZ-minZ)/c:maxZ];