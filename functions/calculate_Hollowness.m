
function [MeanH, StdH, MinH, MaxH] = calculate_Hollowness(data)

CoM = [];
CoM(1,1) = sum(data(:,1))/length(data(:,1));
CoM(1,2) = sum(data(:,2))/length(data(:,2));

for i = 1:length(data);

DistToCoM(i,1) = sqrt((data(i,1)-CoM(1,1))^2 + (data(i,2)-CoM(1,2))^2);

end

MeanH   = mean(DistToCoM);
StdH    = std(DistToCoM);
MinH    = min(DistToCoM);
MaxH    = max(DistToCoM);

end


