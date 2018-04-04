function plotParamSummary(Data_DBSCANed);

% Plot Descriptors in subplots

% Channel 1

figure('Position',[100 100 1000 900],'Name','Channel1')

subplot(3,3,1)
histogram(cell2mat(Data_DBSCANed.Channel1.Rg),40,'FaceColor','black');
% title('Radius of Gyration');
xlabel('Rg [nm]')
box on

subplot(3,3,2)
histogram(cell2mat(Data_DBSCANed.Channel1.Ecc),40,'FaceColor','black');
% title('Eccentricity');
xlabel('Ecc [nm]')
box on

subplot(3,3,3)
scatter(cell2mat(Data_DBSCANed.Channel1.Rg),cell2mat(Data_DBSCANed.Channel1.Ecc),5,'filled','k');
% title('Rg vs Ecc');
xlabel('Rg [nm]')
ylabel('Ecc [nm]')
box on

subplot(3,3,4)
histogram(cell2mat(Data_DBSCANed.Channel1.FRC),30,'FaceColor','black');
title(['Median = ', num2str(median(cell2mat(Data_DBSCANed.Channel1.FRC)))]);
xlabel('FRC [nm]')
box on

subplot(3,3,5)
% hist(cell2mat(Data_DBSCANed.Channel1.MeanHo),30);
scatter(cell2mat(Data_DBSCANed.Channel1.MeanHo),cell2mat(Data_DBSCANed.Channel1.StdHo),5,'filled','k');
% title(['Mean Hollowness']);
xlabel('Mean Hollowness')
ylabel('Std Hollowness')
box on

subplot(3,3,6)
% hist(cell2mat(Data_DBSCANed.Channel1.StdHo),30);
scatter(cell2mat(Data_DBSCANed.Channel1.MeanHo),cell2mat(Data_DBSCANed.Channel1.CircRatio),5,'filled','k');
% title(['Mean Hollowness vs. CircRatio']);
xlabel('Mean Hollowness')
ylabel('Circularity')
box on

subplot(3,3,7)
scatter(cell2mat(Data_DBSCANed.Channel1.RectRatio),cell2mat(Data_DBSCANed.Channel1.CircRatio),5,'filled','k');
% title('RectRatio vs CircRatio');
xlabel('Rectangularity')
ylabel('Circularity')
box on

subplot(3,3,8)
scatter(cell2mat(Data_DBSCANed.Channel1.Circularity),cell2mat(Data_DBSCANed.Channel1.CircRatio),5,'filled','k');
% title('Circularity');
xlabel('Circularity 1 (R)')
ylabel('Circularity 2 (P)')
box on

subplot(3,3,9)
scatter(cell2mat(Data_DBSCANed.Channel1.FA),cell2mat(Data_DBSCANed.Channel1.Symmetry),5,'filled','k');
set(gca,'yscale','log')
% title('FA vs Sym');
xlabel('FA')
ylabel('Symmetry')
box on

% Channel 2

figure('Position',[800 100 1000 900],'Name','Channel 2')


subplot(3,3,1)
histogram(cell2mat(Data_DBSCANed.Channel2.Rg),40,'FaceColor','black');
% title('Radius of Gyration');
xlabel('Rg [nm]')
box on

subplot(3,3,2)
histogram(cell2mat(Data_DBSCANed.Channel2.Ecc),40,'FaceColor','black');
% title('Eccentricity');
xlabel('Ecc [nm]')
box on

subplot(3,3,3)
scatter(cell2mat(Data_DBSCANed.Channel2.Rg),cell2mat(Data_DBSCANed.Channel2.Ecc),5,'filled','k');
% title('Rg vs Ecc');
xlabel('Rg [nm]')
ylabel('Ecc [nm]')
box on

subplot(3,3,4)
histogram(cell2mat(Data_DBSCANed.Channel2.FRC),30,'FaceColor','black');
title(['Median = ', num2str(median(cell2mat(Data_DBSCANed.Channel2.FRC)))]);
xlabel('FRC [nm]')
box on

subplot(3,3,5)
% hist(cell2mat(Data_DBSCANed.Channel1.MeanHo),30);
scatter(cell2mat(Data_DBSCANed.Channel2.MeanHo),cell2mat(Data_DBSCANed.Channel2.StdHo),5,'filled','k');
% title(['Mean Hollowness']);
xlabel('Mean Hollowness')
ylabel('Std Hollowness')
box on

subplot(3,3,6)
% hist(cell2mat(Data_DBSCANed.Channel1.StdHo),30);
scatter(cell2mat(Data_DBSCANed.Channel2.MeanHo),cell2mat(Data_DBSCANed.Channel2.CircRatio),5,'filled','k');
% title(['Mean Hollowness vs. CircRatio']);
xlabel('Mean Hollowness')
ylabel('Circularity')
box on

subplot(3,3,7)
scatter(cell2mat(Data_DBSCANed.Channel2.RectRatio),cell2mat(Data_DBSCANed.Channel2.CircRatio),5,'filled','k');
% title('RectRatio vs CircRatio');
xlabel('Rectangularity')
ylabel('Circularity')
box on

subplot(3,3,8)
scatter(cell2mat(Data_DBSCANed.Channel2.Circularity),cell2mat(Data_DBSCANed.Channel2.CircRatio),5,'filled','k');
% title('Circularity');
xlabel('Circularity 1 (R)')
ylabel('Circularity 2 (P)')
box on

subplot(3,3,9)
scatter(cell2mat(Data_DBSCANed.Channel2.FA),cell2mat(Data_DBSCANed.Channel2.Symmetry),5,'filled','k');
set(gca,'yscale','log')
% title('FA vs Sym');
xlabel('FA')
ylabel('Symmetry')
box on