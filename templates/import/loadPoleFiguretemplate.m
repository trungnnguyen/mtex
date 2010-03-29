%% Import Script for PoleFigure Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any chages to this scrip.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {crystal symmetry};

% specimen symmetry
SS = {specimen symmetry};

% plotting convention
{plotting convention}

%% Specify File Names

% path to files
pname = {path to files};

% which files to be imported
fname = {file names};

% background 
pname = {path to bg files};
fname_bg = {bg file names};

% defocusing
pname = {path to def files};
fname_def = {def file names};

% defocusing background
pname = {path to defbg files};
fname_defbg = {defbg file names};


%% Specify Miller Idice

h = {Miller};

c = {structural coefficients};

%% Import the Data

% create a Pole Figure variable containing the data
pf = loadPoleFigure(fname,h,CS,SS,{structural coefficients},'interface',{interface},{options});

% background
pf_bg = loadPoleFigure(fname_bg,h,CS,SS,{structural coefficients},'interface',{interface},{options});

% defocussing
pf_def = loadPoleFigure(fname_def,h,CS,SS,{structural coefficients},'interface',{interface},{options});

% defocussing background
pf_defbg = loadPoleFigure(fname_defbg,h,CS,SS,{structural coefficients},'interface',{interface},{options});

% correct data
pf = correct(pf,{corrections});
