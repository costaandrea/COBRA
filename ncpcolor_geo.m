function ncpcolor_geo(filevar,xlims,ylims,varargin)%cblabel)
%ncpcolor make a pcolor of a lon/lat or lat/lon variable loaded from a 
% netcdf file.
%   
% Use: ncpcolor(filevar,xlims,ylims,varargin)
%
%   FILEVAR is a cell array. The first element is the netcdf file name
%           (possibly also including its path). The second element is the
%           name of the variable to be plotted.
%   XLIMS is the iterval in physical space of the first coordinate over
%         which the plot will be made. NB The domain should be continous.
%         This unfortunately means that there are problems for domains of
%         longitude that crosses Greenwich.
%   YLIMS is the iterval in physical space of the second coordinate over
%         which the plot will be made. 
%        label interpreter is set to 'latex' and the fontsize to 16.
%   VARARGIN's first argument is be the legend's label.
%
%   This script uses the m_map package.
%   The default projection is 'lambert'. 
%   Shading is set to 'flat'.
%   I use m_coast and m_grid (no m_gssh).
%
%   N.B. I will mess with the FigureRenderer
%
%This work is licensed under the Creative Commons Attribution-NonCommercial 
%3.0 Unported License. See the disclaimer at the end of this file for details.


%renderer = FIND THE RENDERER TO THEN RESET IT AT THE END

if numel(varargin)>0
  cblabel = varargin{1}; %define colorbar's label
end


%%%loading
[field,units,x,xlab,y,ylab] = ncload(filevar,xlims,ylims);
clear filevar xlims ylims


%%%plotting
set(0,'DefaultFigureRenderer','zbuffer') %this does not screw up with m_grid
                                         %another option is 'painters'. But
                                         %this may screw up the colorbar when
                                         %the colormap is diverging

% hf = figure;
%set(gcf, 'Position', [0 0 1000 1000])

hold on

m_proj('lambert','lon',[min(min(x)) max(max(x))],'lat',[min(min(y)) max(max(y))]);
%NB 'lon' and 'lat' does not need to actually be longitudes and latitudes

m_pcolor(x,y,field'); 
shading flat

m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_coast('linewidth',0.5,'color','k');

m_grid('linewi',2,' tickdir','out');
% m_grid('box','fancy','tickdir','in');


hcb=colorbar;

if nargin==4 %cblabel specified
    set(get(hcb,'ylabel'),'String',[cblabel,' $[',units,']$'],...
        'interpreter','latex', 'fontsize',16)
end

xlabel(xlab, 'fontsize',16)
ylabel(ylab, 'fontsize',16)
set(gca, 'fontsize',16)


%set(0,'DefaultFigureRenderer','auto') %try to reset the renderer...