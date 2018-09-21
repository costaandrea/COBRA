%transect of a variable along a curve

% arbitrary section %
xs1=41;  %make sure that these are in the domain!!
xs2=69;
ys1=-79;
ys2=-62;
N=20; %how many points on the section

xq=linspace(xs1,xs2,N); %from origin to end of the section
yq=linspace(ys1,ys2,N);

%interpolate over the section
for ttt=1:numel(time)
    Utr_sec(:,ttt) = interpn(lonMAP,latMAP,intUtr(:,:,ttt),xq,yq,'linear',NaN);
end

dq=sqrt((xq-xs1).^2 + (yq-ys1).^2); %axis along section

figure
pcolor(dq,time,Utr_sec')
shading flat;
colormap(cm);
colorbar
xlabel('Along-section axis')
ylabel('Time')
