function ploterrspace(result)

[X,Y,Z]=rremake(result);

figure,mesh(Y,X,Z);