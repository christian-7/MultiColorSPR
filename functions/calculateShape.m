function [DBSCAN_filtered,Data_DBSCANed] = calculateShape(DBSCAN_filtered);

% Compute FRC for all particles

% Download FRCresolution_software from http://www.diplib.org/add-ons

% rmpath('/Users/christian/Documents/Arbeit/MatLab/SPARTAN_gui/functions/FRCresolutionfunctions');
% addpath('/Users/christian/Documents/Arbeit/MatLab/SPARTAN_gui/functions/FRCresolutionfunctions');

% rmpath('/Users/christian/Documents/Arbeit/MatLab/FRCresolution_software/matlabdistribution');
% addpath('/Users/christian/Documents/Arbeit/MatLab/FRCresolution_software/matlabdistribution');

pixelsize = 106; superzoom = 10; tic;

% Channel 1

for i = 1:size(DBSCAN_filtered,1);  

coords_C1      = [];
coords_C1(:,1) = (DBSCAN_filtered{i,1}(:,1) - min(DBSCAN_filtered{i,1}(:,1)))/pixelsize;
coords_C1(:,2) = (DBSCAN_filtered{i,1}(:,2) - min(DBSCAN_filtered{i,1}(:,2)))/pixelsize;
coords_C1(:,3) =  DBSCAN_filtered{i,1}(:,4) - min(DBSCAN_filtered{i,1}(:,4));

szx_C1 = superzoom * round(max(coords_C1(:,1))-min(coords_C1(:,1)))*1.5;
szy_C1 = superzoom * round(max(coords_C1(:,2))-min(coords_C1(:,2)))*1.5;

try
    
[res_value_C1, ~, resH_C1, resL_C1] = postoresolution(coords_C1, szx_C1, superzoom, 500,[], 5); % in super-resolution pixels

catch
    
 DBSCAN_filtered{i,7} = NaN;

continue
end

DBSCAN_filtered{i,7} = res_value_C1*pixelsize/superzoom; 

clc; 
X = [' Channel 1: Calculated ',num2str(i),' of ',num2str(length(DBSCAN_filtered)),];
clc;disp(X)

end

% Channel 2

for i = 1:size(DBSCAN_filtered,1);  

coords_C2      = [];
coords_C2(:,1) = (DBSCAN_filtered{i,2}(:,1) - min(DBSCAN_filtered{i,2}(:,1)))/pixelsize;
coords_C2(:,2) = (DBSCAN_filtered{i,2}(:,2) - min(DBSCAN_filtered{i,2}(:,2)))/pixelsize;
coords_C2(:,3) =  DBSCAN_filtered{i,2}(:,4) - min(DBSCAN_filtered{i,2}(:,4));

szx_C2 = superzoom * round(max(coords_C2(:,1))-min(coords_C2(:,1)))*1.5;
szy_C2 = superzoom * round(max(coords_C2(:,2))-min(coords_C2(:,2)))*1.5;

try
    
[res_value_C2, ~, resH_C2, resL_C2] = postoresolution(coords_C2, szx_C2, superzoom, 500,[], 5); % in super-resolution pixels

catch
    
    DBSCAN_filtered{i,8} = NaN;

continue
end

DBSCAN_filtered{i,8} = res_value_C2*pixelsize/superzoom; 

clc; 
X = [' Channel 2: Calculated ',num2str(i),' of ',num2str(length(DBSCAN_filtered)),];
clc;disp(X)

end

clc;
fprintf(' \n -- FRC computed in %f sec -- \n',toc)

%% Filter out NaN rows

Temp = [];
RowsToDelete = [];

for i = 1:size(DBSCAN_filtered,1);
    
    if or(isnan(DBSCAN_filtered{i,7}) == 1, isnan(DBSCAN_filtered{i,8})==1);
    
    RowsToDelete = vertcat(RowsToDelete,i);    
               
    elseif or(isempty(DBSCAN_filtered{i,7}) == 1, isempty(DBSCAN_filtered{i,8})==1);
    
    RowsToDelete = vertcat(RowsToDelete,i);     
        
    end
    
end

[Temp,ps] = removerows(DBSCAN_filtered,'ind',[RowsToDelete]);


DBSCAN_filtered = Temp;

clear Temp

fprintf([' \n  -- Cleaned DBSCAN filtered  ' num2str(length(RowsToDelete)) ' Particles were filtered out --  \n ']);



%% Compute Hollowness 

% DBSCAN_filtered=Cep152_all_filtered;

tic

for i = 1:size(DBSCAN_filtered,1);
    
    try

[MeanH, StdH, MinH, MaxH] = calculate_Hollowness(DBSCAN_filtered{i,1});

    catch
        
DBSCAN_filtered{i,9} = 0;
DBSCAN_filtered{i,10} = 0;
DBSCAN_filtered{i,11} = 0;
DBSCAN_filtered{i,12} = 0;

        continue
    end

DBSCAN_filtered{i,9} = MeanH;
DBSCAN_filtered{i,10} = StdH;
DBSCAN_filtered{i,11} = MinH;
DBSCAN_filtered{i,12} = MaxH;

end

for i = 1:size(DBSCAN_filtered,1);

    try
    
[MeanH, StdH, MinH, MaxH] = calculate_Hollowness(DBSCAN_filtered{i,2});

    catch
        
DBSCAN_filtered{i,13} = 0;
DBSCAN_filtered{i,14} = 0;
DBSCAN_filtered{i,15} = 0;
DBSCAN_filtered{i,16} = 0;

        continue
    end
    

DBSCAN_filtered{i,13} = MeanH;
DBSCAN_filtered{i,14} = StdH;
DBSCAN_filtered{i,15} = MinH;
DBSCAN_filtered{i,16} = MaxH;

end

fprintf([' \n  -- Calculated Hollowness in ', num2str(toc),' sec --  \n ']);

%% Compute Circularity Ratio 

tic

for i = 1:size(DBSCAN_filtered,1);
    
    try

[CircRatio] = calculate_Cicularity(DBSCAN_filtered{i,1});

    catch
        
   CircRatio = 0;
   continue
    end

DBSCAN_filtered{i,17} = CircRatio;

end

for i = 1:size(DBSCAN_filtered,1);

[CircRatio] = calculate_Cicularity(DBSCAN_filtered{i,2});

DBSCAN_filtered{i,18} = CircRatio;

end

fprintf([' \n  -- Calculated Circularity Ratio in ', num2str(toc),' sec --  \n ']);

%% Compute Rectangularity

tic

for i = 1:size(DBSCAN_filtered,1);
    
    try

[Rectangularity] = calculate_Rectangularity(DBSCAN_filtered{i,1});

    catch
        
        Rectangularity = 0;
        
        continue
    end

DBSCAN_filtered{i,19} = Rectangularity;

end

for i = 1:size(DBSCAN_filtered,1);

[Rectangularity] = calculate_Rectangularity(DBSCAN_filtered{i,2});

DBSCAN_filtered{i,20} = Rectangularity;

end

fprintf([' \n  -- Calculated Rectangularity Ratio in ', num2str(toc),' sec --  \n ']);

%% Fractional Anisotropy

tic

for i = 1:size(DBSCAN_filtered,1);
    
    try

[FA] = calculate_FA(DBSCAN_filtered{i,1}(:,1),DBSCAN_filtered{i,1}(:,2));

    catch
            FA = 0;
            
            continue
    end


DBSCAN_filtered{i,21} = FA;

end

for i = 1:size(DBSCAN_filtered,1);

[FA] = calculate_FA(DBSCAN_filtered{i,2}(:,1),DBSCAN_filtered{i,2}(:,2));;

DBSCAN_filtered{i,22} = FA;

end

fprintf([' \n  -- Calculated FA in ', num2str(toc),' sec --  \n ']);

%% Estimate symmetry along the long axis

tic

for i = 1:size(DBSCAN_filtered,1);
    
    try

[Sym] = Estimate_Symmetry(DBSCAN_filtered{i,1}(:,1),DBSCAN_filtered{i,1}(:,2));

    catch
            Sym = 0;
            
            continue
    end
    
if isempty(Sym)==1;
    Sym = 0;
else end

DBSCAN_filtered{i,23} = Sym;

end

for i = 1:size(DBSCAN_filtered,1);
    
    try

[Sym] = Estimate_Symmetry(DBSCAN_filtered{i,2}(:,1),DBSCAN_filtered{i,2}(:,2));

    catch
            Sym = 0;
            
            continue
    end
    
if isempty(Sym)==1;
    Sym = 0;
else end

DBSCAN_filtered{i,24} = Sym;

end

% clean columns

for i = 1:size(DBSCAN_filtered,1);
    
  if isempty(DBSCAN_filtered{i,23})==1;
    DBSCAN_filtered{i,23} = 0;
  else end  
  
  if isempty(DBSCAN_filtered{i,24})==1;
    DBSCAN_filtered{i,24} = 0;
  else end 

end

fprintf(['\n -- Calculated Symmetry in ', num2str(toc),' sec --  \n ']);

%% 2nd Circularity Estimation

tic

for i = 1:size(DBSCAN_filtered,1);
    
    try

CircEst = Estimate_circularity(DBSCAN_filtered{i,1}(:,1),DBSCAN_filtered{i,1}(:,2));

    catch 
        
        CircEst = 0;
        continue
    end

DBSCAN_filtered{i,25} = CircEst;

end

for i = 1:size(DBSCAN_filtered,1);

CircEst = Estimate_circularity(DBSCAN_filtered{i,2}(:,1),DBSCAN_filtered{i,2}(:,2));;

DBSCAN_filtered{i,26} = CircEst;

end

fprintf([' \n  -- Calculated 2nd Circularity Estimate in ', num2str(toc),' sec --  \n ']);

%% Put the data into a new nested structure for clarity

for i = 1:size(DBSCAN_filtered,1);

Data_DBSCANed.Channel1.locs{i,1} = DBSCAN_filtered{i,1};
Data_DBSCANed.Channel2.locs{i,1} = DBSCAN_filtered{i,2};

Data_DBSCANed.Channel1.Rg{i,1} = DBSCAN_filtered{i,3};
Data_DBSCANed.Channel2.Rg{i,1} = DBSCAN_filtered{i,4};

Data_DBSCANed.Channel1.Ecc{i,1} = DBSCAN_filtered{i,5};
Data_DBSCANed.Channel2.Ecc{i,1} = DBSCAN_filtered{i,6};

Data_DBSCANed.Channel1.FRC{i,1} = DBSCAN_filtered{i,7};
Data_DBSCANed.Channel2.FRC{i,1} = DBSCAN_filtered{i,8};

Data_DBSCANed.Channel1.MeanHo{i,1} = DBSCAN_filtered{i,9};
Data_DBSCANed.Channel1.StdHo{i,1} = DBSCAN_filtered{i,10};
Data_DBSCANed.Channel1.MinHo{i,1} = DBSCAN_filtered{i,11};
Data_DBSCANed.Channel1.MaxHo{i,1} = DBSCAN_filtered{i,12};

Data_DBSCANed.Channel2.MeanHo{i,1} = DBSCAN_filtered{i,13};
Data_DBSCANed.Channel2.StdHo{i,1} = DBSCAN_filtered{i,14};
Data_DBSCANed.Channel2.MinHo{i,1} = DBSCAN_filtered{i,15};
Data_DBSCANed.Channel2.MaxHo{i,1} = DBSCAN_filtered{i,16};

Data_DBSCANed.Channel1.CircRatio{i,1} = DBSCAN_filtered{i,17};
Data_DBSCANed.Channel2.CircRatio{i,1} = DBSCAN_filtered{i,18};

Data_DBSCANed.Channel1.RectRatio{i,1} = DBSCAN_filtered{i,19};
Data_DBSCANed.Channel2.RectRatio{i,1} = DBSCAN_filtered{i,20};

Data_DBSCANed.Channel1.FA{i,1} = DBSCAN_filtered{i,21};
Data_DBSCANed.Channel2.FA{i,1} = DBSCAN_filtered{i,22};

Data_DBSCANed.Channel1.Symmetry{i,1} = DBSCAN_filtered{i,23};
Data_DBSCANed.Channel2.Symmetry{i,1} = DBSCAN_filtered{i,24};

Data_DBSCANed.Channel1.Circularity{i,1} = DBSCAN_filtered{i,25};
Data_DBSCANed.Channel2.Circularity{i,1} = DBSCAN_filtered{i,26};

end
