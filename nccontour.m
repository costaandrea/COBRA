function nccontour(filevar,xlims,ylims,varargin)%cblabel)


%loading
[field,x,~,y,~] = ncload(filevar,xlims,ylims);


%plotting
set(0,'DefaultFigureRenderer','zbuffer') %'painters' screws up the colorbar
                                         %probably because of
                                         %diverging_map.m used to define
                                         %the colormap

% hf = figure; hold on
hold on

set(gcf, 'Position', [0 0 1000 1000])


m_proj('lambert','lon',[min(min(x)) max(max(x))],'lat',[min(min(y)) max(max(y))]);

m_contour(x,y,field); 
shading flat

m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_coast('linewidth',0.5,'color','k');

m_grid('linewi',2,' tickdir','out');
% m_grid('box','fancy','tickdir','in');


hcb=colorbar;

if nargin==1 %cblabel specified
    set(get(hcb,'ylabel'),'String',cblabel,'interpreter','latex', 'fontsize',16)
end

set(gca, 'fontsize',16)


%set(0,'DefaultFigureRenderer','auto')