function testDBSCAN(Cent_filt_2C,m, k, Eps, minLength);

%  Test DBSCAN particle size Filter


m = 49; % Cent ID

fprintf('\n -- DBSCAN started --\n')
DBSCAN_filtered = {};

% Find out if the data was processed in bstore or TS

dataDBS      = [];
dataDBS(:,1) = Cent_filt_2C{m,1}(:,1); % x in mum
dataDBS(:,2) = Cent_filt_2C{m,1}(:,2); % y in mum

% Run DBSCAN 

k   = 20; % 40                                                    % minimum number of neighbors within Eps
Eps = 20; % 10                                                   % minimum distance between points, nm

[class,type]=DBSCAN(dataDBS,k,Eps);                         % uses parameters specified at input
class2=transpose(class);                                    % class - vector specifying assignment of the i-th object to certain cluster (m,1)
type2=transpose(type);                                      % (core: 1, border: 0, outlier: -1)

coreBorder = [];
coreBorder = find(type2 >= 0);

subset          = [];
subset          = Cent_filt_2C{m,1}(coreBorder,1:end);
subset(:,end+1) = class2(coreBorder);

subsetP = [];
subsetP(:,1)    = dataDBS(coreBorder,1);
subsetP(:,2)    = dataDBS(coreBorder,2);
subsetP(:,3)    = class2(coreBorder);

figure('Position',[100 600 300 300]) % all data from both channels
scatter(dataDBS(:,1)/1e3,dataDBS(:,2)/1e3,1);
box on

figure('Position',[700 600 1000 300]) % all data from both channels
subplot(1,3,1)
scatter(Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==1,1),Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==1,2),1,'black'); hold on;
scatter(Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==2,1),Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==2,2),1,'red'); hold on;
title('Raw Data')
axis on
box on

subplot(1,3,2)
scatter(subsetP(:,1),subsetP(:,2),1,mod(subsetP(:,3),10))
title('identified Clusters')
axis on
axis([min(dataDBS(:,1)) max(dataDBS(:,1)) min(dataDBS(:,2)) max(dataDBS(:,2))])
box on

% Select only the largest cluster(s)

if isempty(subset);
else

ClusterLength = [];

for i = 1:max(subset(:,end));                                               % find the i-th cluster
    
    vx = find(subset(:,end)==i);
    
    if length(vx)>minLength;
        
    DBSCAN_filtered{length(DBSCAN_filtered)+1,1} = subset(vx,1:end);        % Put the cluster ID in the last column 
    
    subplot(1,3,3)
    scatter(DBSCAN_filtered{length(DBSCAN_filtered),1}(:,1),DBSCAN_filtered{length(DBSCAN_filtered),1}(:,2),1);hold on;
    title('selected Clusters')
    axis on
    axis([min(dataDBS(:,1)) max(dataDBS(:,1)) min(dataDBS(:,2)) max(dataDBS(:,2))])
    box on
    
    else end
   
end
end

figure('Position',[700 600 500 500])

for i = 1:length(DBSCAN_filtered);
    
scatter(DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==1,1),DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==1,2),1,'black');hold on;
scatter(DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==2,1),DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==2,2),1,'red');hold on;

title('Found Particles');
legend('Channel 1', 'Channel 2');
box on; axis square;

end

fprintf(' -- DBSCAN computed in %f sec -- \n',toc)