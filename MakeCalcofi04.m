% MAKE_DEMO creates YAADA data from demonstration data in PK2 files

% YAADA - Software Toolkit to Analyze Single-Particle Mass Spectral Data
%
% Copyright (C) 1999-2000 California Institute of Technology
% Copyright (C) 2001-2002 Arizona State University

% Jonathan O. Allen  09 Jun 00

Pk2Dir = 'C:\yaada\user\LightScattering\Calcofi\pk2'; % pk2 data file directory (Pk2Dir)

% To import raw data from TasWare or TSI data acquisition software,
% these data must first be converted to PK2 files.  Insert original
% data directory name and uncomment next lines 

OrigDataDir = 'C:\yaada\user\LightScattering\Calcofi\raw'; % this is where the pkls OR AKA PklDir
% digest_tw04(OrigDataDir,Pk2Dir);

% digest pk2 files
digest_pk2(Pk2Dir);

check_all;

clear Pk2Dir

return
