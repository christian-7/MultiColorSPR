function [CircRatio] = calculate_Cicularity(data);

% C1 = As/Ac = (Area of a shape)/(Area of circle)
% where circle has the same perimeter

OuterPoints = convhull(data(:,1),data(:,2));
AreaCH      = polyarea(data(OuterPoints,1),data(OuterPoints,2));

perimeter = 0;

for i = 1:length(OuterPoints)-1;

perimeter = perimeter + norm(data(OuterPoints(i),1:2) - data(OuterPoints(i+1),1:2));

end

AreaCirc = (perimeter^2)/(4*pi);
CircRatio = AreaCH/AreaCirc;

end


