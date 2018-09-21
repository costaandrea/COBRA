function [loaded, units, Xarr, Xlabel, varargout] = ncload(filevar,xlims,varargin)%ylims,zlims,tlims) 
%readncfile Reads values of a variable given a domain in
% coordinates like (LAT, LON, DEPTH, TIME) from a netcdf file.
%FILEVAR must be a cell with the nectcdf filename (and maybe path) in first cell and
%the name of the variable in the second cell.
%
%Limitations: (1) time can only be given in date format (but Inf is allowed)
%             (2) coordinate domains must be continous (no Greenwich)
   

%%%check inputs
if nargin>2   
        ylims = varargin{1};
end
if nargin>3
        zlims = varargin{2};
end
if nargin>4
    if numel(varargin{3})==2 %time interval
        tlims(1) = datenum(varargin{3}(1));
        tlims(2) = datenum(varargin{3}(2));
     elseif numel(varargin{3})==1 && ~isinf(datenum(cell2mat({'01JAN2012'}))) %one time point
         tlims = datenum(varargin{3});
     elseif numel(varargin{3})==1 && isinf(datenum(cell2mat({'01JAN2012'}))) %all time points
         tlims = Inf;
    end
end
if nargin>5
  error('Too many input arguments.')
end



%%%find right variable and coordinates
filename = filevar{1};
field = filevar{2};
clear filevar


vinfo = ncinfo(filename,field);
varSize = vinfo.Size; %size of the variable to be loaded
clear vinfo


allinfo = ncinfo(filename);
varIdx = strcmp({allinfo.Variables.Name},'Uvel'); %index of the var in 
                                                  %cell array
mVvar = allinfo.Variables(varIdx).Attributes(2).Value; %missing value of the variable
units = allinfo.Variables(varIdx).Attributes(1).Value; %units of measure

allinfo.Variables(varIdx)=[];

for ii=1:length(allinfo.Variables) %for each dimension of the netcdf's variables 
    
    d = allinfo.Variables(ii).Size(1); %find the coordinate
    
    if d==varSize(1); %that corresponds to X
        X = allinfo.Variables(ii); %infos about X
        
        %%%get indices relative to coordinates' limits
        Xl = ncread(filename,X.Name); %load coordinate
        Xlabel = [X.Name,' [',allinfo.Variables(ii).Attributes(1).Value,']']; %name and units
        Xlength = d; %size of the coordinate
        
            xinds = findinds(xlims,Xl,Xlength); %indices
            Xarr = Xl(xinds); %output coordinate values
            xinds = [xinds(1) xinds(end)]; %useful to load the variable later
            clear xlims X Xl Xlength %not useful anymore

    elseif numel(varSize)>1 && d==varSize(2) && nargin>2; %Y
        Y = allinfo.Variables(ii);
        
        Yl = ncread(filename,Y.Name);
        Ylabel = [Y.Name,' [',allinfo.Variables(ii).Attributes(1).Value,']'];
        Ylength = d;
        
        
            yinds = findinds(ylims,Yl,Ylength);
            varargout{1} = Yl(yinds);
            yinds = [yinds(1) yinds(end)];
            varargout{2} = Ylabel;
            clear ylims Y Yl Ylength Ylabel

    elseif numel(varSize)>2 && d==varSize(3) && nargin>3; %Z
        Z = allinfo.Variables(ii);
        
        Zl = ncread(filename,Z.Name);
        Zlabel = [Z.Name,' [',allinfo.Variables(ii).Attributes(1).Value,']'];
        Zlength = d;
        
            zinds = findinds(zlims,Zl,Zlength);
            varargout{3} = Zl(zinds);
            zinds = [zinds(1) zinds(end)];
            varargout{4} = Zlabel;
            clear zlims Z Zl Zlength Zlabel
            
    elseif numel(varSize)>3 && d==varSize(4) && nargin>4; %T
        T = allinfo.Variables(ii);
        
        Tl = ncread(filename,T.Name);
        Tlabel = [T.Name,' [',allinfo.Variables(ii).Attributes(1).Value,']'];
        Tlength = d;
        
            tinds = findinds(tlims,Tl,Tlength);
            varargout{5} = Tl(tinds);
            tinds = [tinds(1) tinds(end)];
            varargout{6} = Tlabel;
            clear tlims T Tl Tlength Tlabel
            
    end
end
clear varsize allinfo varIdx
        

%%%%%
%%% loading variable
%%%%%
if nargin==2
    if iscell(xinds)
      for ii=1:length(xinds) %in case of non-consecutive xinds
%%%modify here. something like loaded = [loaded loaded]. but hard to
%%%preallocate...
         loaded = squeeze(...
                          ncread(filename, field, [xinds(1) 1 1 1],...
                                            [xinds(2)-xinds(1)+1 1 1 1])... 
                          );
      end
    elseif ~iscell(xinds)
         loaded = squeeze(...
                          ncread(filename, field, [xinds(1) 1 1 1],...
                                            [xinds(2)-xinds(1)+1 1 1 1])... 
                          );
    end

elseif nargin==3
    if iscell(xinds)
      for ii=1:length(xinds) %in case of non-consecutive xinds

         loaded = squeeze(...
                          ncread(filename, field, [xinds(1) yinds(1) 1 1],...
            [xinds(2)-xinds(1)+1 yinds(2)-yinds(1)+1 1 1])... 
                          );
      end
    elseif ~iscell(xinds)
         loaded = squeeze(...
                          ncread(filename, field, [xinds(1) yinds(1) 1 1],...
            [xinds(2)-xinds(1)+1 yinds(2)-yinds(1)+1 1 1])... 
                          );
    end

elseif nargin==4
    if iscell(xinds)
      for ii=1:length(xinds) %in case of non-consecutive xinds

         loaded = squeeze(...
                          ncread(filename, field, [xinds(1) yinds(1) zinds(1) 1],...
            [xinds(2)-xinds(1)+1 yinds(2)-yinds(1)+1 zinds(2)-zinds(1)+1 1])... 
                          );
      end
    elseif ~iscell(xinds)
         loaded = squeeze(...
                          ncread(filename, field, [xinds(1) yinds(1) zinds(1) 1],...
            [xinds(2)-xinds(1)+1 yinds(2)-yinds(1)+1 zinds(2)-zinds(1)+1 1])... 
                          );
    end

elseif nargin==5
    if iscell(xinds)
      for ii=1:length(xinds) %in case of non-consecutive xinds

         loaded = ncread(filename, field, [xinds(1) yinds(1) zinds(1) tinds(1)],...
            [xinds(2)-xinds(1)+1 yinds(2)-yinds(1)+1 zinds(2)-zinds(1)+1 tinds(2)-tinds(1)+1]);
      end
    elseif ~iscell(xinds)
         loaded = ncread(filename, field, [xinds(1) yinds(1) zinds(1) tinds(1)],...
            [xinds(2)-xinds(1)+1 yinds(2)-yinds(1)+1 zinds(2)-zinds(1)+1 tinds(2)-tinds(1)+1]);
    end
end

%%%set to NaN the missing values
loaded(loaded==mVvar) = NaN;

%%%END of FUNCTION