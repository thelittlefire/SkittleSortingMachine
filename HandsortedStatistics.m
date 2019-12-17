%% Color Sorter Project - Descriptive Statistics (p.2) | Sid Hillwig, Nate Goff, Isadora Shamah
%{
Descriptive statistics for the hand-sorted Skittles.
%}
%% Housekeeping
clear all; clc
%% Known Comparison sorted Skittles
%Sample size N = 100 skittles

R = [16 15 16 13 15 20]; %Red skittles across each population
O = [20 22 28 24 23 16]; %Orange skittles across each population
Y = [22 25 13 26 18 28]; %Yellow skittles across each population 
G = [19 22 18 23 17 21]; %Green skittles across each population
P = [23 16 25 14 27 15]; %Purple skittles across each population

numPop = length(R);

%Check if the size of each population is actually 100 skittles
for i = 1:numPop
    pop = R(i)+O(i)+Y(i)+G(i)+P(i);
    if pop ~= 100
        fprintf('Population size not correct for population %.3f \n',i)
    end
end
%Sample mean
meanR = mean(R);
meanO = mean(O);
meanY = mean(Y);
meanG = mean(G);
meanP = mean(P);

% Sample Variance s^2
varR = var(R);
varO = var(O);
varY = var(Y);
varG = var(G);
varP = var(P);

%Sample Standard Deviation (denoted with Sigma)
sigR = sqrt(varR);
sigO = sqrt(varO);
sigY = sqrt(varY);
sigG = sqrt(varG);
sigP = sqrt(varP);

%Coefficient of Variance (CV)
cvR = sigR/meanR;
cvO = sigO/meanO;
cvY = sigY/meanY;
cvG = sigG/meanG;
cvP = sigP/meanP;

p = norminv(0.95);

% Standard Error Calculations
seR = p*sigR/sqrt(6);
seO = p*sigO/sqrt(6);
seY = p*sigY/sqrt(6);
seG = p*sigG/sqrt(6);
seP = p*sigP/sqrt(6);

% Confidence Intervals = Mean +/- p*SE
[~,~,IntervalR,~] = ttest(R,0,'Alpha',0.05);
[~,~,IntervalO,~] = ttest(O,0,'Alpha',0.05);
[~,~,IntervalY,~] = ttest(Y,0,'Alpha',0.05);
[~,~,IntervalG,~] = ttest(G,0,'Alpha',0.05);
[~,~,IntervalP,~] = ttest(P,0,'Alpha',0.05);

figure 

subplot(2,3,1)
bar(R,'r')
title('Red')
ylim([0 30])

subplot(2,3,2)
bar(O,'m')
title('Orange')

subplot(2,3,3)
bar(Y,'y')
title('Yellow')

subplot(2,3,4)
bar(G,'g')
title('Green')
ylim([0 30])

subplot(2,3,5)
bar(P,'b')
title('Purple')

figure
subplot(2,2,1)
plot(1,meanR,'ro','LineWidth',3)
title('Means')
hold on
plot(2,meanO,'mo','LineWidth',3)
plot(3,meanY,'yo','LineWidth',3)
plot(4,meanG,'go','LineWidth',3)
plot(5,meanP,'bo','LineWidth',3)
hold off
legend('Red','Orange','Yellow','Green','Purple','Location','WestOutside')
ylim([0 25])
xlim([1 5])

subplot(2,2,2)
plot(1,cvR,'ro','LineWidth',3)
title('Coefficient of Variation')
hold on
plot(2,cvO,'mo','LineWidth',3)
plot(3,cvY,'yo','LineWidth',3)
plot(4,cvG,'go','LineWidth',3)
plot(5,cvP,'bo','LineWidth',3)
ylim([0 0.3])
xlim([1 5])

subplot(2,2,3)
plot(1,varR,'ro','LineWidth',3)
title('Sample Variance (s^2)')
hold on
plot(2,varO,'mo','LineWidth',3)
plot(3,varY,'yo','LineWidth',3)
plot(4,varG,'go','LineWidth',3)
plot(5,varP,'bo','LineWidth',3)
xlim([1 5])

subplot(2,2,4)
plot(1,IntervalR,'ro','LineWidth',3)
title('95% Confidence intervals')
hold on
plot(2,IntervalO,'mo','LineWidth',3)
plot(3,IntervalY,'yo','LineWidth',3)
plot(4,IntervalG,'go','LineWidth',3)
plot(5,IntervalP,'bo','LineWidth',3)
ylim([0 30])
xlim([1 5])

%% ANOVA Analysis

cou = 1; cou1 = 1;
for i = 1:5
    for j=1:6
        sampleNum(cou1)= i;
        cou1 = cou1+1;
    end
    cou=cou+1;
end

M_all=[R'; O'; Y'; G'; P'];

[p1,tbl1,stats1] = anova1(M_all,sampleNum');
figure(5);
c = multcompare(stats1);



