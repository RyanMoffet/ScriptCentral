 %bind_calcofi_2

 
 
%  mixed_ss=union(FineDualMatch_RG_PID {1},FineDualMatch_RG_PID {3},FineDualMatch_RG_PID {12},FineDualMatch_RG_PID {14},FineDualMatch_RG_PID {26}); % added 26
%  pure_ss=union(FineDualMatch_RG_PID {2},FineDualMatch_RG_PID {17}); % changed 14 and 17
%  pure_ss_51=FineDualMatch_RG_PID {51};
%  pure_ss_55=FineDualMatch_RG_PID {55};
%  pos_ss=FineDualMatch_RG_PID {5};
%  aged_ss=union(FineDualMatch_RG_PID {16},FineDualMatch_RG_PID {26}); % removed this class or relabel as mg/ss/ca
%  NaK=FineDualMatch_RG_PID {24};
%  dust_Ca=union(FineDualMatch_RG_PID {9},FineDualMatch_RG_PID {32},FineDualMatch_RG_PID {33},FineDualMatch_RG_PID {56},FineDualMatch_RG_PID {109},FineDualMatch_RG_PID {139});
%  dust_Si=union(FineDualMatch_RG_PID {20},FineDualMatch_RG_PID {76},FineDualMatch_RG_PID {53},FineDualMatch_RG_PID {54},FineDualMatch_RG_PID {64},FineDualMatch_RG_PID {77});
%  dust_Fe=FineDualMatch_RG_PID {47};
%  S_rich=union(FineDualMatch_RG_PID {36},FineDualMatch_RG_PID {44},FineDualMatch_RG_PID {157},FineDualMatch_RG_PID {165});
%  Mg_rich=union(FineDualMatch_RG_PID {19},FineDualMatch_RG_PID {35});
%  MgCl=FineDualMatch_RG_PID {41};
%  MgNOx=FineDualMatch_RG_PID {45};
%  Mg_comb=union(FineDualMatch_RG_PID {70},FineDualMatch_RG_PID {91},FineDualMatch_RG_PID {98},FineDualMatch_RG_PID {133});
%  MgNOx_58=FineDualMatch_RG_PID {58};
%  V_rich=union(FineDualMatch_RG_PID {81},FineDualMatch_RG_PID {117},FineDualMatch_RG_PID {128},FineDualMatch_RG_PID {124});
%  V_97=FineDualMatch_RG_PID {97};
%  C_fresh=union(FineDualMatch_RG_PID {6},FineDualMatch_RG_PID {7},FineDualMatch_RG_PID {37});
%  C_mix=union(FineDualMatch_RG_PID {8}); % class 21
%  ECSOx=union(FineDualMatch_RG_PID {11},FineDualMatch_RG_PID {48});
%  CK=union(FineDualMatch_RG_PID {18},FineDualMatch_RG_PID {21}); % add class21
%  k_only=(FineDualMatch_RG_PID {15},FineDualMatch_RG_PID {28})
%  CKSOx=union(FineDualMatch_RG_PID {13},FineDualMatch_RG_PID {27},FineDualMatch_RG_PID {38});
%  C_ox=union(FineDualMatch_RG_PID {23},FineDualMatch_RG_PID {31},FineDualMatch_RG_PID {34},FineDualMatch_RG_PID {29});%added 29
%  C_52=FineDualMatch_RG_PID {52};
%  EC=union(FineDualMatch_RG_PID {39},FineDualMatch_RG_PID {40},FineDualMatch_RG_PID {105},FineDualMatch_RG_PID {107},FineDualMatch_RG_PID {114});
 
%% Group Clusters together
class{1} = FineDualMatch_RG_PID{1}; % mixed_ss
for I = [3,12,14,26];
    class{1} = union(FineDualMatch_RG_PID{I},class{1});
end
class{2} =  union(FineDualMatch_RG_PID {2},FineDualMatch_RG_PID {17}); % pure_ss. changed 14 and 17 
class{3}=FineDualMatch_RG_PID{51};% pure_ss_51
class{4}=FineDualMatch_RG_PID{55};% pure_ss_55
class{5}=FineDualMatch_RG_PID{5};% pos_ss
class{6}=FineDualMatch_RG_PID{16}; % mg/ss/ca
class{7}= FineDualMatch_RG_PID{24};%NaK
class{8} = FineDualMatch_RG_PID{24} % dust_Ca
for I = [9,32,33,56,109,139];
    class{8} = union(FineDualMatch_RG_PID{I},class{8});
end
class{9}=FineDualMatch_RG_PID{20} % dust_Si
for I = [76,53,54,64,77];
    class{9} = union(FineDualMatch_RG_PID{I},class{9});
end
class{10}=FineDualMatch_RG_PID{47}; % dust_Fe
class{11}=FineDualMatch_RG_PID{36} % S_rich
for I = [44,157,165];
    class{11} = union(FineDualMatch_RG_PID{I},class{11});
end
class{12}=union(FineDualMatch_RG_PID {19},FineDualMatch_RG_PID {35});% Mg_rich
class{13}=FineDualMatch_RG_PID {41};% MgCl
class{14}=FineDualMatch_RG_PID {45};%MgNOx
class{15}=FineDualMatch_RG_PID{81}; % V_rich
for I = [117,128,124];
    class{15} = union(FineDualMatch_RG_PID{I},class{15});
end
class{16}=FineDualMatch_RG_PID {97};%V_97
class{17}=union(FineDualMatch_RG_PID{6},FineDualMatch_RG_PID{7},FineDualMatch_RG_PID{37});%C_fresh
class{18}=union(FineDualMatch_RG_PID{8}); % C_mix removed class 21
class{19}=union(FineDualMatch_RG_PID{11},FineDualMatch_RG_PID{48});% ECSOx
class{20}=union(FineDualMatch_RG_PID{18},FineDualMatch_RG_PID{21}); % CK added class21
class{21}=(FineDualMatch_RG_PID {15},FineDualMatch_RG_PID {28})% k_only
class{22}=union(FineDualMatch_RG_PID {13},FineDualMatch_RG_PID {27},FineDualMatch_RG_PID {38});% CKSOx
class{23}=FineDualMatch_RG_PID{23} % C_ox added 29
for I = [31,34,29];
    class{23} = union(FineDualMatch_RG_PID{I},class{23});
end
class{24}=FineDualMatch_RG_PID {52};% C_52
class{25}=FineDualMatch_RG_PID{39} % EC
for I = [40,105,107,114];
    class{25} = union(FineDualMatch_RG_PID{I},class{25});
end


