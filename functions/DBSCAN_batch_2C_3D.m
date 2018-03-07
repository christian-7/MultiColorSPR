function [DBSCAN_filtered] = DBSCAN_batch_2C_3D(dataDBS,minLength_C1,minLength_C2);

% Run DBSCAN on each particle 

k   = 20; % 20, 40                                                               % minimum number of neighbors within Eps
Eps = 20; % 20, 10                                                               % minimum distance between points, nm

Channel_ID = 12;

[class,type]    = DBSCAN(dataDBS(:,1:2),k,Eps);                         % uses parameters specified at input
class2          = transpose(class);                                     % class - vector specifying assignment of the i-th object to certain cluster (m,1)
type2           = transpose(type);                                      % (core: 1, border: 0, outlier: -1)

coreBorder      = [];
coreBorder      = find(type2 >= 0);

subset          = [];
subset          = dataDBS(coreBorder,1:end);                            % select only core and border points
subset(:,end+1) = class2(coreBorder);                                   % add column with cluster ID 

% Select only the largest cluster(s)

DBSCAN_filtered ={};

for i = 1:max(subset(:,end));                                               % for all clusters        
    
    vx = find(subset(:,end)==i);                                            % find the i-th cluster
    
    selected_Cluster = [];                                                  % take out the i-th cluster
    selected_Cluster = subset(vx,1:end);
    
    % Separate the Channels and calculate Rg and Ecc
    % Keep the data only if BOTH Channels have enough locs --> > minLength
    
    if length(selected_Cluster(selected_Cluster(:,Channel_ID)==1))>minLength_C1 & length(selected_Cluster(selected_Cluster(:,Channel_ID)==2))>minLength_C2; % if both channels have enough locs
        
    DBSCAN_filtered{size(DBSCAN_filtered,1)+1,1}    = selected_Cluster(selected_Cluster(:,Channel_ID)==1,1:end);   % select and extract the cluster in Channel 1
    DBSCAN_filtered{size(DBSCAN_filtered,1),2}      = selected_Cluster(selected_Cluster(:,Channel_ID)==2,1:end);   % select and extract the cluster in Channel 2
    
    % Radius of Gyration equals the sum of the variances of x,y,z divided by
    % the number of locs
    
    DBSCAN_filtered{size(DBSCAN_filtered,1),3}  = sqrt(sum(var(DBSCAN_filtered{size(DBSCAN_filtered,1),1}(:,1:2),1,1))); % Rg Channel 1
    DBSCAN_filtered{size(DBSCAN_filtered,1),4}  = sqrt(sum(var(DBSCAN_filtered{size(DBSCAN_filtered,1),2}(:,1:2),1,1))); % Rg Channel 1

    % Eccentricity 
    % covariance of x and y --> sqrt of min/max(Eigenvalues)
    % Ecc

    DBSCAN_filtered{size(DBSCAN_filtered,1),5}  = sqrt(max(eig(cov(DBSCAN_filtered{size(DBSCAN_filtered,1),1}(:,1:2))))/min(eig(cov(DBSCAN_filtered{size(DBSCAN_filtered,1),1}(:,1:2)))));  % Ecc Channel 1
    DBSCAN_filtered{size(DBSCAN_filtered,1),6}  = sqrt(max(eig(cov(DBSCAN_filtered{size(DBSCAN_filtered,1),2}(:,1:2))))/min(eig(cov(DBSCAN_filtered{size(DBSCAN_filtered,1),2}(:,1:2)))));  % Ecc Channel 2
    
    else end
   
end







end


