function ncpcolor(filevar,xlims,ylims,varargin)%cblabel)
%ncpcolor make a pcolor of a 2D variable loaded from a netcdf file.
%   
% Use: ncpcolor(filevar,xlims,ylims,varargin)
%
%   FILEVAR is a cell array. The first element is the netcdf file name
%           (possibly also including its path). The second element is the
%           name of the variable to be plotted.
%   XLIMS is the interval in physical space of the first coordinate over
%         which the plot will be made. NB The domain should be continous.
%
%   YLIMS is the interval in physical space of the second coordinate over
%         which the plot will be made. 
%        label interpreter is set to 'latex' and the fontsize to 16.
%   VARARGIN's first argument is be the legend's label.
%
%This work is licensed under the Creative Commons Attribution-NonCommercial 
%3.0 Unported License. See the disclaimer at the end of this file for details.


if numel(varargin)>0
  cblabel = varargin{1}; %define colorbar's label
end


%%%loading
[field,units,x,xlab,y,ylab] = ncload(filevar,xlims,ylims);
clear filevar xlims ylims


%%%plotting

% hf = figure;
%set(gcf, 'Position', [0 0 1000 1000])

hold on

pcolor(x,y,field'); 
shading flat


hcb=colorbar;

if nargin==4 %cblabel specified
    set(get(hcb,'ylabel'),'String',[cblabel,' $[',units,']$'],...
        'interpreter','latex', 'fontsize',16)
end

xlabel(xlab, 'fontsize',16)
ylabel(ylab, 'fontsize',16)
set(gca, 'fontsize',16)

