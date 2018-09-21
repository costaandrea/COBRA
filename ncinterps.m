function fieldINT = ncinterps(filevars1,filevars2,xlims,varargin)
%%%limitation: variables must be given in the order x y z t
%%%             Giving x t would probably cause some error (to test)


p=inputParser;
%%%set value outside domain
addOptional(p,'pad',NaN); %handle,name,default
%%%set interpolation method
addOptional(p,'meth','linear');

parse(p)

pad = p.Results.pad;
method = p.Results.meth;


% %%%define netcdf filenames and variables' names
% filevar1 = filevars([1 2]);
% 
% filevar2 = filevars([1 3]);
% clear filevar
filevar1 = filevars1;
filevar2 = filevars2;
clear filevar

%%%loading and interpolating
if numel(size(a))==1

    %%%loading
    [field1,~,x1] = ncload(filevar1,xlims); %load first variable and its coords
    clear filevar1

    [~,~,x2] = ncload(filevar2,xlims); %load coords of second variable
    clear filevar2 xlims

    %%%iterpolating
    X1 = ndgrid(x1);
    X2 = ndgrid(x2);
    fieldINT = interpn(X1, field1, X2, method,pad); %interpolate first variable
                                                    %on coords of the
                                                    %second one

elseif numel(size(a))==2
    
    ylims = varagin(1);
    
    %%%loading
    [field1,~,x1,~,y1] = ncload(filevar1,xlims,ylims);
    clear filevar1

    [~,~,x2,~,y2] = ncload(filevar2,xlims,ylims);
    clear filevar2 xlims ylims

    %%%iterpolating
    [X1,Y1]=ndgrid(x1,y1);
    [X2,Y2]=ndgrid(x2,y2);
    
    fieldINT = interpn(X1,Y1, field1, X2,Y2, method,pad);

elseif numel(size(a))==3
    
    ylims = varagin(1);
    zlims = varargin(2);
    
    %%%loading
    [field1,~,x1,~,y1,~,z1] = ncload(filevar1,xlims,ylims,zlims);
    clear filevar1

    [~,~,x2,~,y2,~,z2] = ncload(filevar2,xlims,ylims,zlims);
    clear filevar2 xlims ylims zlims

    %%%iterpolating
    [X1,Y1,Z1]=ndgrid(x1,y1,z1);
    [X2,Y2,Z2]=ndgrid(x2,y2,z2);
    
    fieldINT = interpn(X1,Y1,Z1, field1, X2,Y2,Z2, method,pad);

elseif numel(size(a))==4
    
    ylims = varagin(1);
    zlims = varargin(2);
    tlims = varargin(3);
    
    %%%loading
    [field1,~,x1,~,y1,~,z1,~,t1] = ncload(filevar1,xlims,ylims,zlims,tlims);
    clear filevar1

    [~,~,x2,~,y2,~,z2,~,t2] = ncload(filevar2,xlims,ylims,zlims,tlims);
    clear filevar2 xlims ylims zlims tlims

    %%%iterpolating
    [X1,Y1,Z1,T1]=ndgrid(x1,y1,z1,t1);
    [X2,Y2,Z2,T2]=ndgrid(x2,y2,z2,t2);

    fieldINT = interpn(X1,Y1,Z1,T1, field1, X2,Y2,Z2,T2, method,pad);

else
    error('something with the dimensions of the variable')
end