 function farm = mag_setup_farm(param,farm)
%----------------------------------------------------------------------
% Sets up arrays and other properties of farm from inputs
% Farm grid (N layers):
% z_cult: base of plant (negative, depth below the surface)
% z_arr : Nx1 center of vertical layers (negative, depth below the surface)
% dz : Nx1 thickness of vertical layers (positive, layer thickness)
% z_arr_bound : Nx2 boundaries of vertical layers (negative, depth below the surface)
%----------------------------------------------------------------------

 switch farm.grid_mode
 case 1
    % Equally spaced grid, with nz vertical levels between z_cult and 0 (surface)
    tmp_z_arr_bound = linspace(farm.z_cult,0,farm.nz+1);
    tmp_z_arr_bound = tmp_z_arr_bound(:);
    farm.z_arr_bound = [tmp_z_arr_bound(1:end-1) tmp_z_arr_bound(2:end)];
    farm.dz = farm.z_arr_bound(:,2) - farm.z_arr_bound(:,1); 
    farm.z_arr =  mean(farm.z_arr_bound,2);
 case 2
    % Add new case here and remove following line
    error(['[mag_setup_farm.m] grid_mode not defined']);
 case 3
    % Add new case here and remove following line
    error(['[mag_setup_farm.m] grid_mode not defined']);
 otherwise
    error(['[mag_setup_farm.m] grid_mode not defined']);
 end

 % Defines layer in farm array at which canopy starts
 tmp = find(farm.z_arr>param.z_canopy);
 if isempty(tmp)
    error('[mag_setup_farm.m] WARNING: Could not find canopy start; set as the surface layer');
    tmp = length(farm.z_arr); 
 end
 farm.icanopy = tmp(1);

