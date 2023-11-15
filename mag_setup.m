 function setup = mag_initialize_run
%----------------------------------------------------------------------
% Initialization of model parameters 
% Here, set up variables and parameters that control the run setup
%----------------------------------------------------------------------

 % Run setup
% For ROMS SCB-300 data use this:
%setup.year_start = 2016;
%setup.year_end = 2016;
% For LTER data use this:
 setup.year_start = 2005;
 setup.year_end = 2005;
 setup.isave_envt = 1; % [1] Keeps structure with environmental forcing;

 % ROMS/Environment input file specifications
 % Input folder:
 setup.in_dir = '/Users/danielebianchi/AOS1/Kelp/code/mag_uc/datasets/ROMS_BEC_MAG_input';
 % Input file (as matlab structure)
%setup.in_file = 'z_ROMSdata_SCB300_2016.mat';
 setup.in_file = 'z_LTERdata_2005.mat';
 % File structure format:
 % ADD HERE SPECIFICATION FOR INPUT FILE FROM ROMS
 
 

