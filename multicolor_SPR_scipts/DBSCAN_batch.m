function [DBSCAN_filtered] = DBSCAN_batch(dataDBS,minLength,maxLength);

% Run DBSCAN on each particle 

k   = 10;                                                               % minimum number of neighbors within Eps
Eps = 15;                                                               % minimum distance between points, nm

if isempty(dataDBS)==1;
    
    DBSCAN_filtered = [];
    
else

[class,type]    = DBSCAN(dataDBS(:,1:2),k,Eps);                         % uses parameters specified at input
class2          = transpose(class);                                     % class - vector specifying assignment of the i-th object to certain cluster (m,1)
type2           = transpose(type);                                      % (core: 1, border: 0, outlier: -1)

coreBorder      = [];
coreBorder      = find(type2 >= 0);

if isempty(coreBorder)==1;
    
    DBSCAN_filtered = [];
    
else

subset          = [];
subset          = dataDBS(coreBorder,1:end);                            % select only core and border points
subset(:,end+1) = class2(coreBorder);                                   % add column with cluster ID 

% Select only the largest cluster(s)

DBSCAN_filtered ={};

for i = 1:max(subset(:,end));                                               % for all clusters        
    
    vx = find(subset(:,end)==i);                                            % find the i-th cluster
    
    selected_Cluster = [];
    selected_Cluster = subset(vx,1:end);
    
    if length(vx)>minLength & length(vx)<maxLength;
        
    DBSCAN_filtered{size(DBSCAN_filtered,1)+1,1} = selected_Cluster; % select the cluster in Channel 1

    % Radius of Gyration equals the sum of the variances of x,y,z divided by
    % the number of locs
    
    DBSCAN_filtered{size(DBSCAN_filtered,1),2}  = sqrt(sum(var(DBSCAN_filtered{size(DBSCAN_filtered,1),1}(:,1:2),1,1))); 

    % Eccentricity 
    % covariance of x and y --> sqrt of min/max(Eigenvalues)
    % Ecc

    DBSCAN_filtered{size(DBSCAN_filtered,1),3}  = sqrt(max(eig(cov(DBSCAN_filtered{size(DBSCAN_filtered,1),1}(:,1:2))))/min(eig(cov(DBSCAN_filtered{size(DBSCAN_filtered,1),1}(:,1:2)))));
    
    else end
   
end

end
end

end


