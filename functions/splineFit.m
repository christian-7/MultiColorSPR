function [splineRes, AvgCurve, p] = splineFit(xData,yData,NbrBins,radius,smoothingFactor);

% xData             = Avg_Ch1_new(:,1);
% yData             = Avg_Ch1_new(:,2);
% NbrBins           = 200;
% smoothingFactor   = 500;
% radius            = 100;

binwidth = ((max(xData)-min(xData))/NbrBins)/2;

count = 1; AvgCurve = [];

for i = min(xData):2*binwidth:max(xData);
    
    target  = find(xData>i-binwidth & xData<i+binwidth);
    yData_temp = yData(target,1);
    target2 = find(yData_temp<mean(yData_temp)+radius & yData_temp>mean(yData_temp)-radius);
    
    AvgCurve(count,2) = mean(yData_temp(target2,1));
    AvgCurve(count,1) = i;
    
    count = count + 1;
    
end

% figure  
% scatter(xData,yData), hold on;
% plot(AvgCurve(:,1),AvgCurve(:,2),'r')
% legend('Raw','Averaged'), hold off
% box on;

[scs,p] = csaps(AvgCurve(:,1),AvgCurve(:,2));

% figure
% plot(AvgCurve(:,1),AvgCurve(:,2),'o'); hold on;
% fnplt(csaps(AvgCurve(:,1),AvgCurve(:,2),p/smoothingFactor),'--')
% legend('noisy data','smoothing spline'), hold off

splineRes(:,1) = xData;
splineRes(:,2) = csaps(AvgCurve(:,1),AvgCurve(:,2),p/100, splineRes(:,1));

end
