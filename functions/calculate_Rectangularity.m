function [Rectangularity] = calculate_Rectangularity(data);

% C1 = As/Ac = (Area of a shape)/(Area of rectangle)
% where circle has the same perimeter

OuterPoints = convhull(data(:,1),data(:,2));
AreaCH      = polyarea(data(OuterPoints,1),data(OuterPoints,2));

perimeter = 0;

AreaRec = sqrt(max(eig(cov(data(:,1:2))))*min(eig(cov(data(:,1:2)))));

Rectangularity = AreaRec/AreaCH;

end

