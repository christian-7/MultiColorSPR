function [T_lwm, TRE, corrected_moving,fixed, moving] = calculateAffineTrans(pxlsize,searchRadius,locsCh1,locsCh2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find the bead pairs  %%%%%%%%%%%%%%%%%%%

fixed  = locsCh1(:,1:2); % 106 nm / pxl
moving = locsCh2(:,1:2); % 106 nm / pxl

moving_1 = []; fixed_1 = [];

[IDX] = rangesearch(moving,fixed,searchRadius); % find the point in moving that is closest to the point in fixed

for i = 1:length(IDX);
    
    if isempty(IDX{i,1}) == 1;
       
       fixed_1(i,1) = 0;
       fixed_1(i,2) = 0;
    
    elseif length(IDX{i,1}) > 1;
            
       fixed_1(i,1) = 0;
       fixed_1(i,2) = 0;
       
    else

    moving_1(i,1) = moving(IDX{i,1}(:,1),1);
    moving_1(i,2) = moving(IDX{i,1}(:,1),2);
    
    fixed_1(i,1) = fixed(i,1);
    fixed_1(i,2) = fixed(i,2);
    end
    
end

moving = [];
moving(:,1) = nonzeros(moving_1(:,1));
moving(:,2) = nonzeros(moving_1(:,2));

fixed = [];
fixed(:,1) = nonzeros(fixed_1(:,1));
fixed(:,2) = nonzeros(fixed_1(:,2));

%%%%

moving_1 = []; fixed_1 = [];

[IDX] = rangesearch(fixed,moving,searchRadius); % find the point in moving that is closest to the point in fixed

for i = 1:length(IDX);
    
    if isempty(IDX{i,1}) == 1;
       
       moving_1(i,1) = 0;
       moving_1(i,2) = 0;
    
    elseif length(IDX{i,1}) > 1;
            
       moving_1(i,1) = 0;
       moving_1(i,2) = 0;
       
    else

    fixed_1(i,1) = fixed(IDX{i,1}(:,1),1);
    fixed_1(i,2) = fixed(IDX{i,1}(:,1),2);
    
    moving_1(i,1) = moving(i,1);
    moving_1(i,2) = moving(i,2);
    end
    
end

moving = [];
moving(:,1) = nonzeros(moving_1(:,1))*pxlsize;
moving(:,2) = nonzeros(moving_1(:,2))*pxlsize;

fixed = [];
fixed(:,1) = nonzeros(fixed_1(:,1))*pxlsize;
fixed(:,2) = nonzeros(fixed_1(:,2))*pxlsize;

MBD = [];
for i = 1:length(fixed);
    
    MBD(:,i) = sqrt((fixed(i,1)-moving(i,1))^2 + (fixed(i,2)-moving(i,2))^2);

end

% figure('Position',[200 100 500 500])
% scatter(moving(:,1),moving(:,2),'ro');hold on;
% scatter(fixed(:,1),fixed(:,2),'g*');hold on;
% box on;axis equal;
% legend('Ch1','Ch2')
% title(['Mean Bead distance = ' num2str(mean(MBD)) ' nm']);
% xlabel('nm');
% ylabel('nm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculate the transformation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T_lwm = fitgeotrans(fixed,moving,'lwm',10);

% T_lwm_old = cp2tform(fixed,moving,'lwm',10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Tranform the Points and calculate TRE  %%%%%%%%%%%%%%%%%%%

corrected_moving = transformPointsInverse(T_lwm,moving); % correct the 750 channel

% corrected_moving = tforminv(T_lwm_old,moving(:,1),moving(:,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


TRE = [];
for i = 1:length(fixed);
    
    TRE(:,i) = sqrt((fixed(i,1)-corrected_moving(i,1))^2 + (fixed(i,2)-corrected_moving(i,2))^2);

end
% 
% figure('Position',[200 300 500 500])
% scatter(fixed(:,1),fixed(:,2),'gx');hold on;
% scatter(moving(:,1),moving(:,2),'ro');hold on;
% scatter(corrected_moving(:,1),corrected_moving(:,2),'rx');hold on;
% legend('Ch1','Ch2','Ch2 corr')
% title(['TRE = ' num2str(mean(TRE)) ' nm']);
% box on; axis equal;
% xlabel('nm');
% ylabel('nm');
% 
% figure('Position',[700 300 700 500])
% scatter(fixed(:,1),fixed(:,2),30,transpose(TRE),'filled');hold on;
% box on; axis equal;
% colorbar
% title('Color --> TRE');
% xlabel('nm');
% ylabel('nm');

end