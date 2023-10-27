 function mag = mag_init_output(mag);
%----------------------------------------------------------------------
% Initialization of model output structure
%----------------------------------------------------------------------
 
 % Simulation Output; preallocate space
 mag.out = struct;
 mag.out.kelp_b = NaN(1,length(mag.time.timevec_Gr)); % integrated biomass (g-dry/m^2) per growth time step
 mag.out.kelp_h = NaN(1,length(mag.time.timevec_Gr)); % integrated biomass (g-dry/m^2) per growth time step
 mag.out.Nf = NaN(mag.farm.nz,length(mag.time.timevec_Gr));
 mag.out.Ns = NaN(mag.farm.nz,length(mag.time.timevec_Gr));
 mag.out.Bm = NaN(mag.farm.nz,length(mag.time.timevec_Gr));

