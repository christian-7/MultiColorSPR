function [Fid_Ch1,Fid_Ch2] = selectFiducial(locs_Ch1,locs_Ch2,handles);

%% Combine Channels and select fiducials from Image

allLocs = vertcat(locs_Ch1,locs_Ch2);

heigth  = round((max(allLocs(:,handles.yCol))-min(allLocs(:,handles.yCol)))/handles.pxlSizeFid);
width   = round((max(allLocs(:,handles.xCol))-min(allLocs(:,handles.xCol)))/handles.pxlSizeFid);
im      = hist3([allLocs(:,handles.xCol),allLocs(:,handles.yCol)],[width heigth]); % heigth x width

% Select rectangles

rect = []; rect2 = [];

figure('Position',[100 200 400 400])
f = imagesc(imrotate(im,90),[(max(locs_Ch1(:,handles.frameCol))+max(locs_Ch2(:,handles.frameCol)))*0.6 max(locs_Ch1(:,handles.frameCol))+max(locs_Ch2(:,handles.frameCol))]);
colormap('parula'); colorbar;

while isvalid(f)

  try  rect = getrect;

       rect2 = vertcat(rect2,rect); 
       
  catch continue
  end

end

fprintf('\n -- ROIs selected --\n')

% Plot fiducials and average curve rectangles

% Select ROI for both channels

Fid_Ch1 = []; Fid_Ch2 = [];

for i = 1:size(rect2,1);
    
xmin = min(allLocs(:,handles.xCol))+ rect2(i,1)*handles.pxlSizeFid;
ymin = max(allLocs(:,handles.yCol))- rect2(i,2)*handles.pxlSizeFid - (rect2(i,4)*handles.pxlSizeFid) ;
xmax = xmin + (rect2(i,3)* handles.pxlSizeFid);
ymax = ymin + rect2(i,4) * handles.pxlSizeFid;

vx      = find(allLocs(:,handles.xCol)>xmin & allLocs(:,handles.xCol)<xmax);
subset1 = allLocs(vx,1:end);

vy      = find(subset1(:,handles.yCol)>ymin & subset1(:,handles.yCol)<ymax);
subset2 = subset1(vy,1:end);

subset2(:,handles.RegionID)=i; % Region ID

Fid_Ch1 = vertcat(Fid_Ch1,subset2(subset2(:,end-1)==1,1:end));
Fid_Ch2 = vertcat(Fid_Ch2,subset2(subset2(:,end-1)==2,1:end));

size(Fid_Ch1(:,end))

end

fprintf('\n -- Fiducials Extracted --\n')

% Plot the fiducials

for i = 1:max(Fid_Ch1(:,end));
    
    figure('Position',[100 200 400 400])
    
    scatter(Fid_Ch1(Fid_Ch1(:,handles.RegionID)==i,handles.frameCol),Fid_Ch1(Fid_Ch1(:,handles.RegionID)==i,handles.yCol),1,'green');hold on;
    scatter(Fid_Ch2(Fid_Ch2(:,handles.RegionID)==i,handles.frameCol),Fid_Ch2(Fid_Ch2(:,handles.RegionID)==i,handles.yCol),1,'red');
    
    legend('Ch1','Ch2');
    
end

end
