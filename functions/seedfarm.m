function kelp = seedfarm(param,farm)
%----------------------------------------------------------------------
% Kelp, pre-allocation of MAG variables; Initialize farm biomass
% Output: 
%   kelp with structured variables
%       Nf (fixed nitrogen) mg N/m3
%       Ns (stored nitrogen) mg N/m3   
%----------------------------------------------------------------------

% Initialize kelp state variables and characteristics
 kelp.Ns = NaN(farm.nz,1);
 kelp.Nf = NaN(farm.nz,1);
     
% Seed the farm
% Nf, Ns (initial biomass set by farm.seeding)
% height_seed : height of the initial (seed) plants
%               calculated from seed biomass and mass-to-length relationship
 
% Converts seeding biomass from grams to mg by dividing by 1e3
 % DB :  Turn this "biomass-to-height" calculation into a biology/ function
 %       Also, use SI to avoid awkward unit conversions within main code
 height_seed = ceil((param.Hmax .* farm.seedingB./1e3 )./ (param.Kh + farm.seedingB./1e3));
 
% DPD edit
% Calculate b_per_m
% DB : Note, for unit consistency, b_per_m should have unites of 1/m2? 
 b_per_m = make_Bm(height_seed,param,farm); 
 kelp.Nf = farm.seedingB .* param.Qmin .* b_per_m; % equivalent to a single 1 m frond; [mg N]
 kelp.Ns = (farm.seedingQ - param.Qmin)/param.Qmin * farm.seedingB .* param.Qmin .* b_per_m; % corresponds to a Q of 20
 
 end
