function [locs_Ch2_corr] = RigidTrans(Fid_Ch1,Fid_Ch2,locs_Ch2,handles)

center_Ch1 = [];center_Ch2 = [];


for i = handles.selectedFid;
    
    center_Ch1(i+1,1) = median(Fid_Ch1(Fid_Ch1(:,handles.RegionID)==i,handles.xCol));
    center_Ch1(i+1,2) = median(Fid_Ch1(Fid_Ch1(:,handles.RegionID)==i,handles.yCol));
    
end

for i = handles.selectedFid;;
    
    center_Ch2(i+1,1) = median(Fid_Ch2(Fid_Ch2(:,handles.RegionID)==i,handles.xCol));
    center_Ch2(i+1,2) = median(Fid_Ch2(Fid_Ch2(:,handles.RegionID)==i,handles.yCol));
    
end


% Delete NaNs

center_Ch1_noNan = [];
center_Ch2_noNan = [];

for i = 1:size(center_Ch1,1);
    
    if isnan(center_Ch1(i,1))==1;
        
    else
    center_Ch1_noNan(i,1) = center_Ch1(i,1);
    center_Ch1_noNan(i,2) = center_Ch1(i,2);

    end
    
end

center_Ch1 = [];
center_Ch1(:,1) = nonzeros(center_Ch1_noNan(:,1));
center_Ch1(:,2) = nonzeros(center_Ch1_noNan(:,2));


for i = 1:size(center_Ch2,1);
    
    if isnan(center_Ch2(i,1))==1;
        
    else
    center_Ch2_noNan(i,1) = center_Ch2(i,1);
    center_Ch2_noNan(i,2) = center_Ch2(i,2);

    end
    
end

center_Ch2 = [];
center_Ch2(:,1) = nonzeros(center_Ch2_noNan(:,1));
center_Ch2(:,2) = nonzeros(center_Ch2_noNan(:,2));

fprintf('\n -- CoM identified --\n')

% Extract and Save linear Transformation

deltaXY = [];

for i = 1:size(center_Ch1,1);
    
    deltaXY(i,1) = center_Ch1(i,1) - center_Ch2(i,1);
    deltaXY(i,2) = center_Ch1(i,2) - center_Ch2(i,2);
    
end

% Correct the CoM

center_Ch2_corr = [];
center_Ch2_corr(:,1) = center_Ch2(:,1) + mean(deltaXY(:,1));
center_Ch2_corr(:,2) = center_Ch2(:,2) + mean(deltaXY(:,2));

TRE = [];

for i = 1:size(center_Ch1,1);
    
TRE(:,i) = sqrt((center_Ch1(i,1)-center_Ch2_corr(i,1))^2 + (center_Ch1(i,2)-center_Ch2_corr(i,2))^2);

end

% Plotting 

figure('Position',[200 200 600 300],'NumberTitle', 'off', 'Name', 'Rigid Translation Ch2>Ch1');

subplot(1,2,1)
scatter(Fid_Ch1(:,handles.xCol),Fid_Ch1(:,handles.yCol),10,'g','filled');hold on;
scatter(Fid_Ch2(:,handles.xCol),Fid_Ch2(:,handles.yCol),10,'r','filled');
scatter(center_Ch1(:,1),center_Ch1(:,2),20,'bo');hold on;
scatter(center_Ch2(:,1),center_Ch2(:,2),20,'bx');hold on;
legend('locs Ch1','locs Ch1','CoM Ch1','CoM Ch2')
box on; axis square;
title('Indentified Fiducial Centers');

subplot(1,2,2)
scatter(center_Ch1(:,1),center_Ch1(:,2),20,'g','filled');hold on;
scatter(center_Ch2(:,1) + mean(deltaXY(:,1)),center_Ch2(:,2) + mean(deltaXY(:,2)),20,'r','filled');  
box on; axis square;
legend('CoM Ch1','CoM Ch2')
title(['Fid After 2nd trans TRE = ' num2str(mean(TRE)) ' nm']);

% Correct the loc_Ch2 dataset

locs_Ch2_corr = locs_Ch2;

locs_Ch2_corr(:,handles.xCol) = locs_Ch2(:,handles.xCol) + mean(deltaXY(:,1));
locs_Ch2_corr(:,handles.yCol) = locs_Ch2(:,handles.yCol) + mean(deltaXY(:,2));

fprintf('\n -- Linear Transformation applied to Ch2 localizations --\n')

end