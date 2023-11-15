function farm = farmdesign
%-------------------------------------------------------------------------
% Structure with farm properties
%
% Output: farm.()
%   z_cult; depth of cultivation, [m]
%   x,y,z; dimension of farm [m]
%   dx,dy,dz; bin size [m] 
%   seeding; initial seeding biomass
%-------------------------------------------------------------------------

% Farm dimensions and grid

 farm.z_cult = -10; % [m] Depth at which farm is seeded (negative below the surface)
 farm.nz = 100;
 farm.grid_mode = 1; % (1) for equally spaced grid, with nz levels
                     % (2,...) for other grids defined in mag_setup_farm.m 
 
 % initial B/Q conditions
 farm.seedingB = 0.3 * 1e3; % seeding biomass [g-dry m-2] 
%farm.seedingB = 3 * 1e3; % seeding biomass [g-dry m-2] 
 % %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% 
 % ## CHECK UNITS ### (it said per meter)
 % I think this should be g-dry/m^2 
 % b/c you multiply it by a b_per_m which should have units of g-dry/m; 
 % the multiplication to get kelp.Nf in seedfarm.m should give you a mg N / m^3
 % %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% 
 farm.seedingQ = 15; % seeding Q
 
end
