 function setup = mag_initialize_run
%----------------------------------------------------------------------
% Initialization of model parameters 
% Here, set up variables and parameters that control the run setup
%----------------------------------------------------------------------

 % Run setup
 setup.year_start = 2016;
 setup.year_end = 2016;
 setup.isave_envt = 1; % [1] Keeps structure with environmental forcing;

 % ROMS/Environment input file specifications
 % Input folder:
 setup.in_dir = '/Users/danielebianchi/AOS1/Kelp/code/MAG_0_ucla/datasets/ROMS_BEC_MAG_input';
 % Input file (as matlab structure)
 setup.in_file = 'z_ROMSdata_SCB300_2016.mat';
 % File structure format:
 % ADD HERE SPECIFICATION FOR INPUT FILE FROM ROMS
 
 

