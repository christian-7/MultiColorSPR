function [Cent_selected]=filterParticles(DBSCAN_filtered,handles);

count           = 0;
Cent_selected   = {}; 
CentForTraining = {};

if handles.useAll == 1;
    
Cent_selected(:,1:2) = DBSCAN_filtered(:,1:2);
 
else
end

% Choose Filtering parameters [Ch1, Ch2]

MinLength   = handles.LengthFilter(1:2);
MaxLength   = handles.LengthFilter(3:4);
MinRg       = handles.RgFilter(1:2); 
MaxRg       = handles.RgFilter(3:4);
MinEcc      = handles.EccFilter(1:2);
MaxEcc      = handles.EccFilter(3:4);
MaxFRC      = handles.FRCFilter(3:4);
MinFRC      = handles.FRCFilter(1:2);

% First filter by length

for i = 1:size(DBSCAN_filtered,1);
    
if length(DBSCAN_filtered{i,1})>MinLength(1)   == 1        & ... % length Ch1
   length(DBSCAN_filtered{i,1})<MaxLength(1)   == 1        & ... % length Ch1
   length(DBSCAN_filtered{i,2})>MinLength(2)   == 1        & ... % length Ch2
   length(DBSCAN_filtered{i,2})<MaxLength(2)   == 1        & ... % length Ch2
   DBSCAN_filtered{i,3}>MinRg(1)               == 1        & ... % Rg Ch1
   DBSCAN_filtered{i,3}<MaxRg(1)               == 1        & ... % Rg Ch1
   DBSCAN_filtered{i,4}>MinRg(2)               == 1        & ... % Rg Ch2
   DBSCAN_filtered{i,4}<MaxRg(2)               == 1        & ... % Rg Ch2
   DBSCAN_filtered{i,5}>MinEcc(1)              == 1        & ... % Ecc Ch1
   DBSCAN_filtered{i,5}<MaxEcc(1)              == 1        & ... % Ecc Ch1
   DBSCAN_filtered{i,6}>MinEcc(2)              == 1        & ... % Ecc Ch2
   DBSCAN_filtered{i,6}<MaxEcc(2)              == 1        & ... % Ecc Ch2
   DBSCAN_filtered{i,7}>MinFRC(1)              == 1        & ... % Ecc Ch2
   DBSCAN_filtered{i,7}>MinFRC(2)              == 1        & ... % Ecc Ch2
   DBSCAN_filtered{i,8}<MaxFRC(1)              == 1        & ... % Ecc Ch2
   DBSCAN_filtered{i,8}<MaxFRC(2)              == 1;

   
count = count+1;    
    
Cent_selected{count,1} = DBSCAN_filtered{i,1}; 
Cent_selected{count,2} = DBSCAN_filtered{i,2};

CentForTraining(count,:) = DBSCAN_filtered(i,1:end);

else end

end
