%% Generate test table from filtered Centrioles to train the Classifier

line = {'Rg', 'Ecc', 'FRC', 'MeanH', 'StdH', 'MinH', 'MaxH', 'CircRatio','RectRatio','FA','Sym','Circ','response'};

Rg          = cell2mat(CentForTraining(:,2));
Ecc         = cell2mat(CentForTraining(:,3));
FRC         = cell2mat(CentForTraining(:,4));
MeanH       = cell2mat(CentForTraining(:,5));
StdH        = cell2mat(CentForTraining(:,6));
MinH        = cell2mat(CentForTraining(:,7));
MaxH        = cell2mat(CentForTraining(:,8));
CircRatio   = cell2mat(CentForTraining(:,9));
RectRatio   = cell2mat(CentForTraining(:,10));
FA          = cell2mat(CentForTraining(:,11));
Sym         = cell2mat(CentForTraining(:,12));
Circ        = cell2mat(CentForTraining(:,13));

% clear Rg Ecc FRC MeanH StdH MinH MaxH CircRatio

test_data = table(Rg,Ecc,FRC,MeanH,StdH,MinH,MaxH,CircRatio,RectRatio,FA,Sym,Circ,response_Top,...
    'VariableNames',line);


%% Generate Input

inputTable      = test_data;
predictorNames  = {'Rg', 'Ecc', 'FRC', 'MeanH', 'StdH', 'MinH', 'MaxH', 'CircRatio', 'RectRatio', 'FA', 'Sym', 'Circ'};
predictors      = inputTable(:, predictorNames);
response        = inputTable.response;

response        = inputTable.response;
response        = response-1;
L               = logical(response);
response        = L;

%% Perform Classification

% mdlSVM = fitcsvm(predictors,response,'Standardize',true,'KernelFunction','rbf',...
%     'KernelScale','auto');

 mdlSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 2, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);

mdlSVM = fitPosterior(mdlSVM);
[~,score_svm] = resubPredict(mdlSVM);


%%  Calculate ROC

[Xsvm,Ysvm,Tsvm,AUCsvm,OPTROCPT] = perfcurve(response,score_svm(:,mdlSVM.ClassNames),'true');

figure
plot(Xsvm,Ysvm,'LineWidth',2,'Color','b');hold on;
plot(OPTROCPT(1),OPTROCPT(2),'ro')

text(0.5,0.6, ['FPR    = ', num2str(round(OPTROCPT(1),2))],'FontSize',12);
text(0.5,0.7, ['TPR    = ', num2str(round(OPTROCPT(2),2))],'FontSize',12);
text(0.5,0.8, ['Thresh = ', num2str(round(Tsvm((Xsvm==OPTROCPT(1))&(Ysvm==OPTROCPT(2))),2))],'FontSize',12);
text(0.5,0.5, ['AUC    = ', num2str(round((AUCsvm),2))],'FontSize',12);


xlabel('False positive rate')
ylabel('True positive rate')
title('ROC Curve for Classification by SVN')
hold off

Tsvm((Xsvm==OPTROCPT(1))&(Ysvm==OPTROCPT(2)))


%% Predict

Class_Result = predict(mdlSVM,test_data);

% Class_Result = trainedClassifier.predictFcn(test_data);

disp([' -- Particles Classified -- ']);

%%  Export the Classified Top Views

Predicted_Top = {};

count = 1;

for i = 1:length(Class_Result);

    if Class_Result(i,1)==1;

%     Predicted_Top{count,1} = DBSCAN_filtered{i,1}; % Channel 1

    Predicted_Top{count,1} = CentForTraining{i,1}; % Channel 1

    count = count+1;

    else end

end

count
%%

% Show overview of selection

close all;

pxlsize = 10; xCol = 1; yCol = 2;

for i = 1:length(Predicted_Top);

        heigth      = round((max(Predicted_Top{i,1}(:,yCol)) - min(Predicted_Top{i,1}(:,yCol)))/pxlsize);
        width       = round((max(Predicted_Top{i,1}(:,xCol)) - min(Predicted_Top{i,1}(:,xCol)))/pxlsize);

        rendered    = hist3([Predicted_Top{i,1}(:,yCol),Predicted_Top{i,1}(:,xCol)],[heigth width]);

        Predicted_Top{i,2} = hist3([Predicted_Top{i,1}(:,yCol),Predicted_Top{i,1}(:,xCol)],[heigth width]);

end

% Make a Gallery of both channels

NbrOfSubplots = round(sqrt(length(Predicted_Top)))+1;

figure('Position',[100 100 800 800]);

for i = 1:length(Predicted_Top);

    subplot(NbrOfSubplots,NbrOfSubplots,i);
    imagesc(imgaussfilt(Predicted_Top{i,2},1));
    title(['ID = ' num2str(i)]);
    set(gca,'YTickLabel',[],'XTickLabel',[]);
    colormap hot
    axis equal

end