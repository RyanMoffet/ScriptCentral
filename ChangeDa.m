function ChangeDa(DaCalParams)
% Changing_Da is used to change the DaCalibParam variable
% useful for changing Da scale from nm to um
% also runs update_da script
% John Holecek 20040729
global INST
test = INST(1).DaCalibParam;
test2 = test{1};

test2(1) = DaCalParams(1);
test2(2) = DaCalParams(2);
test2(3) = DaCalParams(3);
test2(4) = DaCalParams(4);
test2(5) = 0;
test2(6) = 0;
test2(7) = 0;
test2(8) = 0;
test2(9) = DaCalParams(5);
test2(10) = DaCalParams(6);

test3{1} = test2;
INST(1,'DaCalibParam') = test3;
test3{1}'

clear test test2 test3;

update_da