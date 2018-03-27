function [Cent_filt, Cent_filt_2C]=applyFirstFilter(Cent,handles);

% Filter for length

count       = 0;
Cent_filt   = {};
 
for i = 1:length(Cent.particles);
    
    if isempty(Cent.particles{i,1}) | isempty(Cent.particles{i,5});
    
    else
        
NbrOfLocs(i,1) = length(Cent.particles{i,1}); % Channel 1
NbrOfLocs(i,2) = length(Cent.particles{i,5}); % Channel 2

if length(Cent.particles{i,1})>handles.minInt_Ch1 & length(Cent.particles{i,1})<handles.maxInt_Ch1 & ... 
   length(Cent.particles{i,5})>handles.minInt_Ch2 & length(Cent.particles{i,5})<handles.maxInt_Ch2 ;
   
count = count+1;    
    
Cent_filt{count,1} = Cent.particles{i,1}; 
Cent_filt{count,2} = Cent.particles{i,2};
Cent_filt{count,3} = Cent.particles{i,3};
Cent_filt{count,4} = Cent.particles{i,4};
Cent_filt{count,5} = Cent.particles{i,5};
Cent_filt{count,6} = Cent.particles{i,6};
Cent_filt{count,7} = Cent.particles{i,7};
Cent_filt{count,8} = Cent.particles{i,8};

else end

    end
end

% Filter locs

minFrame            = [handles.minFrame_Ch1,handles.minFrame_Ch2];
MinPhotons          = [handles.minPhot_Ch1, handles.minPhot_Ch2];
Maxuncertainty      = [handles.maxUnc_Ch1, handles.maxUnc_Ch2];
MaxSigma            = [handles.maxSigma_Ch1, handles.maxSigma_Ch2];
MinSigma            = [handles.minSigma_Ch1, handles.minSigma_Ch2];

xCol = 1; yCol = 2; frameCol = 3; uncCol = 4; photonCol = 5; sigmaCol = 8;

Cent_filt_2C = {}; % New variable combining both datasets for each ROI

for i = 1:length(Cent_filt)
        
Cent_filt{i,1}(:,size(Cent_filt{1,1},2)+1) = 1; % new channel ID variable

filter_Ch1              = [];

filter_Ch1              = find(Cent_filt{i,1}(:,photonCol) > MinPhotons(1) & ... 
                               Cent_filt{i,1}(:,uncCol)    < Maxuncertainty(1) & ... 
                               Cent_filt{i,1}(:,frameCol)  > minFrame(1) & ...
                               Cent_filt{i,1}(:,sigmaCol)  < MaxSigma(1) & ... 
                               Cent_filt{i,1}(:,sigmaCol)  > MinSigma(1));
                           
Cent_filt{i,5}(:,size(Cent_filt{1,5},2)+1) = 2; % new channel ID variable
filter_Ch2              = [];

filter_Ch2              = find(Cent_filt{i,5}(:,photonCol) > MinPhotons(2) & ... 
                               Cent_filt{i,5}(:,uncCol)    < Maxuncertainty(2) & ... 
                               Cent_filt{i,5}(:,frameCol)  > minFrame(2) & ...
                               Cent_filt{i,5}(:,sigmaCol)  < MaxSigma(2) & ... 
                               Cent_filt{i,5}(:,sigmaCol)  > MinSigma(2));
                                                                     
Cent_filt_2C{i,1}       = vertcat(Cent_filt{i,1}(filter_Ch1,1:end),Cent_filt{i,5}(filter_Ch2,1:end));

end