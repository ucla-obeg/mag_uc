 load ../mag1-mp-volume-averaged/b_per_m.mat
 addpath addpath other_code/ additional_functions/ functions/ biology/
 Bm_obs = flipud(b_per_m);

 % Copy here parametes for farm 
 farm.z_cult = -20;
 farm.nz = 20;
 tmp_z_arr_bound = linspace(farm.z_cult,0,farm.nz+1);
 tmp_z_arr_bound = tmp_z_arr_bound(:);
 farm.z_arr_bound = [tmp_z_arr_bound(1:end-1) tmp_z_arr_bound(2:end)];
 farm.dz = farm.z_arr_bound(:,2) - farm.z_arr_bound(:,1);
 farm.z_arr =  mean(farm.z_arr_bound,2);
 zd = farm.z_arr;

 % Copy here parametes for plant 
 param.Hmax =  30;
%param.Bmmode = 'original';
 param.Bmmode = 'powerlaw';
%param.Bmmode = 'ddauhajre';
%param.Bmmode = 'inverse_linear';
 param.Bmmode = 'inverse_linear_plus';
 param.amass = 0;
 param.z_canopy =  -0.5;
 param.cmax =  0.5;
 param.Hc = 0.5;

 titname = [param.Bmmode];
 if strcmp(param.Bmmode,'powerlaw')
    titname = [titname ' : '  num2str(param.amass,3)];
 end

 Hp = [1:1:30];
 nHp = length(Hp);
 Bm_model = nan(farm.nz,nHp);
 
 for indh=1:nHp

    Bm_out = make_Bm(Hp(indh),param,farm);
    Bm_model(:,indh) = Bm_out; 

 end

 Bm_model(Bm_model<=0) = nan;

 Bm_diff = Bm_model - Bm_obs;

 %-------------------------------
 % Makes a figure to compare empirical and 
 % model Bm functions
 ff = figure;
 tt = tiledlayout(3,5);

 % Uses power law to stretch color range
 cpl = 0.5;
 ctick = [0:0.2:1];
 ctickp = ctick.^cpl;

 ax1 = nexttile(1,[1 4]);
 sanePColor(Hp,zd,Bm_obs.^cpl);
 shading flat;
 ctmp = cmocean('thermal',20);
 ctmp = ctmp(2:end-1,:);
 colormap(ax1,ctmp);
 cb = colorbar;
 cb.Label.String = 'fraction (1/m)';
 cb.Label.FontSize = 15;
 cb.Ticks = ctickp;
 xtk1 = mat2cell(ctick,1,ones(size(ctick)))';
 xlb = cellfun(@(x) num2str(x,2),xtk1,'UniformOutput',0);
 cb.TickLabels = xlb;
 caxis([0 1]);
 xlabel('plant height (m)');
 ylabel('depth (m)');
 t1 = title('Observed shape','fontsize',15);
 
 ax2 = nexttile(6,[1 4]);
 sanePColor(Hp,zd,Bm_model.^cpl);
 shading flat;
 colormap(ax2,ctmp);
 cb = colorbar;
 cb.Label.String = 'fraction (1/m)';
 cb.Label.FontSize = 15;
 cb.Ticks = ctickp;
 xtk1 = mat2cell(ctick,1,ones(size(ctick)))';
 xlb = cellfun(@(x) num2str(x,2),xtk1,'UniformOutput',0);
 cb.TickLabels = xlb;
 caxis([0 1]);
 xlabel('plant height (m)');
 ylabel('depth (m)');
 t2 = title(titname,'fontsize',15,'interpreter','none');

 ax3 = nexttile(11,[1 4]);
 sanePColor(Hp,zd,Bm_diff);
 shading flat;
 colormap(ax3,cmocean('balance'));
 cb = colorbar;
 cb.Label.String = 'fraction (1/m)';
 cb.Label.FontSize = 15;
 bmaxv = max(abs(Bm_diff(:)));
 caxis([-bmaxv bmaxv]);
 xlabel('plant height (m)');
 ylabel('depth (m)');
 t3 = title('Difference','fontsize',15);

 set([ax1 ax2 ax3],'fontsize',15);

 fname = ['fig_Bm_' param.Bmmode];
 if strcmp(param.Bmmode,'powerlaw')
    fname = [fname num2str(param.amass,3)];
 end
 fname = [fname '.jpeg'];
 
 set(gcf,'PaperPosition',[0.0 0.0 7.0 14.0]);
 print(fname,'-djpeg');
 
