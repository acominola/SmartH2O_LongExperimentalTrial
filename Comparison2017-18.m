% Comparing SmartH2O data with 2018 data

%% LOADING SmartH2O data
allData2017 = readtable('EMIVASA_validationOutput.xlsx','Sheet', 'sH2O users');
allData2018 = readtable('2018_SmartH2O_monitor.csv');

%% Find ID of common users
userID2017 = allData2017.User_ID;
userID2018 = allData2018.User_ID;

[memberUser, position] = ismember(userID2017, userID2018);

% Building final comparison dataset
dataToWrite = table(userID2017(memberUser), allData2017.average_consumption_baseline(memberUser), ...
    allData2017.average_consumption_observation(memberUser), allData2018.average_consumption(position(position>0)), ...
    'VariableNames',{'User_ID', 'average_consumption_baseline', 'average_consumption_observation2017', 'average_consumption_observation2018'});

% Evaluating % of water use change: ALL VALUES ARE KEPT
perc2017 = (allData2017.average_consumption_observation(memberUser) - allData2017.average_consumption_baseline(memberUser))./allData2017.average_consumption_baseline(memberUser).*100;
perc2018 = (allData2018.average_consumption(position(position>0)) - allData2017.average_consumption_baseline(memberUser))./allData2017.average_consumption_baseline(memberUser).*100;
avgPerc2017 = mean(perc2017);
avgPerc2018 = mean(perc2018);

% Evaluating % of water use change: POSSIBLE OUTLIERS ARE DELETED
outliers = perc2018>(prctile(perc2018,75) + 1.5*(prctile(perc2018,75)-prctile(perc2018,25))) ...
| perc2018<(prctile(perc2018,25) - 1.5*(prctile(perc2018,75)-prctile(perc2018,25)));

perc2018noOutliers = perc2018(outliers ==0);
perc2017noOutliers = perc2017(outliers ==0);
avgPerc2017noOutliers = mean(perc2017noOutliers);
avgPerc2018noOutliers = mean(perc2018noOutliers);

%% Representing results
customizedFigureOpen; 
subplot(211); bar(sort(dataToWrite.average_consumption_observation2017 - dataToWrite.average_consumption_baseline));
xlabel('UserID'); ylabel('Average daily water use (m^3/day)');ylim([-0.5 0.5])
title('Pre/post SmartH2O comparison')

subplot(212); bar(sort(dataToWrite.average_consumption_observation2018 - dataToWrite.average_consumption_observation2017));
xlabel('UserID'); ylabel('Average daily water use (m^3/day)');ylim([-0.5 0.5])
title('SmartH2O vs 2018 comparison')

thisFig = gcf;
thisFig.PaperUnits = 'centimeters';
thisFig.PaperSize = thisFig.Position(3:4)./25;
thisFig.PaperPositionMode = 'auto';
print(thisFig, '/Users/ACo/Desktop/Polimi/2017_Post-doc/RESEARCH/SmartH2O_2018evolution/1_VolumetricWaterUse_comparison','-dpdf','-opengl','-r200');


%% Comparing volumes of change
customizedFigureOpen; 
bar([mean(dataToWrite.average_consumption_baseline(outliers ==0)); mean(dataToWrite.average_consumption_observation2017(outliers ==0));...
    mean(dataToWrite.average_consumption_observation2018(outliers ==0))]);
xlabel('Baseline - SmartH2O - 2018'); ylabel('Avg daily water use (m^3/day)');

thisFig = gcf;
thisFig.PaperUnits = 'centimeters';
thisFig.PaperSize = thisFig.Position(3:4)./25;
thisFig.PaperPositionMode = 'auto';
print(thisFig, '/Users/ACo/Desktop/Polimi/2017_Post-doc/RESEARCH/SmartH2O_2018evolution/2_AvgVolumetricWaterUse','-dpdf','-opengl','-r200');

%% Comparing percentages of change
customizedFigureOpen; 
subplot(221); 
bar([avgPerc2017 avgPerc2018]);
xlabel('SmartH2O (left) - 2018 (right)'); ylabel('Avg of % water use change wrt baseline');

subplot(222);
ecdf(perc2017); hold on; ecdf(perc2018)
legend({'SmartH2O', '2018'})
xlabel('Avg of % water use change wrt baseline')

subplot(223); 
bar([avgPerc2017noOutliers avgPerc2018noOutliers]);
xlabel('SmartH2O (left) - 2018 (right)'); ylabel('Avg of % water use change wrt baseline');

subplot(224);
ecdf(perc2017noOutliers); hold on; ecdf(perc2018noOutliers)
legend({'SmartH2O', '2018'})
xlabel('Avg of % water use change wrt baseline')

%%
thisFig = gcf;
thisFig.PaperUnits = 'centimeters';
thisFig.PaperSize = thisFig.Position(3:4)./25;
thisFig.PaperPositionMode = 'auto';
print(thisFig, '/Users/ACo/Desktop/Polimi/2017_Post-doc/RESEARCH/SmartH2O_2018evolution/3_OutlierAnalysis','-dpdf','-opengl','-r200');

%% Monitoring consistency of user behavior
clear temp
temp(1,1)= sum(perc2018noOutliers<0 & perc2017noOutliers <0)/length(perc2017noOutliers);
temp(1,2)= sum(perc2018noOutliers<0 & perc2017noOutliers >0)/length(perc2017noOutliers);
temp(2,1)=sum(perc2018noOutliers>0 & perc2017noOutliers <0)/length(perc2017noOutliers);
temp(2,2)=sum(perc2018noOutliers>0 & perc2017noOutliers >0)/length(perc2017noOutliers);
temp


clear temp
temp(1,1)= sum(perc2018<0 & perc2017 <0)/length(perc2017);
temp(1,2)= sum(perc2018<0 & perc2017 >0)/length(perc2017);
temp(2,1)=sum(perc2018>0 & perc2017 <0)/length(perc2017);
temp(2,2)=sum(perc2018>0 & perc2017 >0)/length(perc2017);
temp