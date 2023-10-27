function [Bm_out] = make_Bm(Hp,param,farm) 
%----------------------------------------------------------------------
% Create analytical form of biomass per meter (Bm)
% that are normalized so they integrate to 1
% Bm(z) depends on kelp height and a canopy threshold
% Hp : height of the plant (m)
%----------------------------------------------------------------------

 % Declare an empty b_per_m array
 Bm = NaN(farm.nz,1);
 alpha = 1; % set this in param_macrocystis.m
 
 % Depth array starting at the base of the plant and ending 
 % at ocean surface
 zloc = farm.z_cult + farm.z_arr;
 % Top of water column starting from z_cult
 ztop = farm.z_cult;
 % Thickness scale for canopy (m)
 Hc = abs(param.z_canopy);

 % Define depth normalized by plant height
 zz = zloc/Hp;

 % Plant mask: 1 if plant; 0 if water
 zmask = ones(size(zz));
 zmask(zz>1) = 0;

 Bm_out = 1 .* zmask;
 
 % Final step of normalization; this is technically not needed analytically
 % but in practice it corrects errors due to numerical approximations 
 Bm_out = Bm_out ./ sum(Bm_out .* farm.dz); 



