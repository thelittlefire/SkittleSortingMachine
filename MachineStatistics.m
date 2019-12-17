%% Color Sorter Project - Descriptive Statistics (p.1) | Sid Hillwig, Nate Goff, Isadora Shamah
%{
Descriptive statistics for the machine-sorted Skittles.
%}
%% Housekeeping
clear all; clc
%% Sorted Skittles by Machine
%Sample size N = 50 skittles

R = [4  5  8  3  7  10]; %Red skittles across each population
O = [13 10 12 13 11 9 ]; %Orange skittles across each population
Y = [12 14 8  15 10 13]; %Yellow skittles across each population 
G = [8  9  10 9  7  8]; %Green skittles across each population
P = [11 10 11 7  13 9]; %Purple skittles across each population
U = [2  2  1  3  2  1 ]; %Unknown skittles across each population that Sorter could not sort
numPop = length(R);

%Check if the size of each population is actually 50 skittles
for i = 1:numPop
    pop = R(i)+O(i)+Y(i)+G(i)+P(i)+U(i);
    if pop ~= 50
        fprintf('Population size not correct for population %.3f \n',i)
    end
end
%Sample mean
meanR = mean(R);
meanO = mean(O);
meanY = mean(Y);
meanG = mean(G);
meanP = mean(P);
meanU = mean(U);

% Sample Variance s^2
varR = var(R);
varO = var(O);
varY = var(Y);
varG = var(G);
varP = var(P);
varU = var(U);

%Sample Standard Deviation (denoted with Sigma)
sigR = sqrt(varR);
sigO = sqrt(varO);
sigY = sqrt(varY);
sigG = sqrt(varG);
sigP = sqrt(varP);
sigU = sqrt(varU);

%Coefficient of Variance (CV)
cvR = sigR/meanR;
cvO = sigO/meanO;
cvY = sigY/meanY;
cvG = sigG/meanG;
cvP = sigP/meanP;
cvU = sigU/meanU;

p = norminv(0.95);

% Standard Error Calculations
seR = p*sigR/sqrt(6);
seO = p*sigO/sqrt(6);
seY = p*sigY/sqrt(6);
seG = p*sigG/sqrt(6);
seP = p*sigP/sqrt(6);
seU = p*sigU/sqrt(6);

% Confidence Intervals = Mean +/- p*SE
[~,~,IntervalR,~] = ttest(R,0,'Alpha',0.05);
[~,~,IntervalO,~] = ttest(O,0,'Alpha',0.05);
[~,~,IntervalY,~] = ttest(Y,0,'Alpha',0.05);
[~,~,IntervalG,~] = ttest(G,0,'Alpha',0.05);
[~,~,IntervalP,~] = ttest(P,0,'Alpha',0.05);
[~,~,IntervalU,~] = ttest(U,0,'Alpha',0.05);


figure 

subplot(2,3,1)
bar(R,'r')
title('Red')
ylim([0 15])

subplot(2,3,2)
bar(O,'m')
title('Orange')

subplot(2,3,3)
bar(Y,'y')
title('Yellow')

subplot(2,3,4)
bar(G,'g')
title('Green')
ylim([0 15])

subplot(2,3,5)
bar(P,'b')
title('Purple')

subplot(2,3,6)
bar(U,'k')
title('Unknown Skittles')
ylim([0 15])

figure
subplot(2,2,1)
plot(1,meanR,'ro','LineWidth',3)
title('Means')
hold on
plot(2,meanO,'mo','LineWidth',3)
plot(3,meanY,'yo','LineWidth',3)
plot(4,meanG,'go','LineWidth',3)
plot(5,meanP,'bo','LineWidth',3)
plot(6,meanU,'ko','LineWidth',3)
hold off
legend('Red','Orange','Yellow','Green','Purple','Unknown','Location','WestOutside')
ylim([0 12.5])
xlim([1 6])

subplot(2,2,2)
plot(1,cvR,'ro','LineWidth',3)
title('Coefficient of Variation')
hold on
plot(2,cvO,'mo','LineWidth',3)
plot(3,cvY,'yo','LineWidth',3)
plot(4,cvG,'go','LineWidth',3)
plot(5,cvP,'bo','LineWidth',3)
plot(6,cvU,'ko','LineWidth',3)
ylim([0 0.6])
xlim([1 6])

subplot(2,2,3)
plot(1,varR,'ro','LineWidth',3)
title('Sample Variance (s^2)')
hold on
plot(2,varO,'mo','LineWidth',3)
plot(3,varY,'yo','LineWidth',3)
plot(4,varG,'go','LineWidth',3)
plot(5,varP,'bo','LineWidth',3)
plot(6,varU,'ko','LineWidth',3)
ylim([0 10])
xlim([1 6])

subplot(2,2,4)
plot(1,IntervalR,'ro','LineWidth',3)
title('95% Confidence intervals')
hold on
plot(2,IntervalO,'mo','LineWidth',3)
plot(3,IntervalY,'yo','LineWidth',3)
plot(4,IntervalG,'go','LineWidth',3)
plot(5,IntervalP,'bo','LineWidth',3)
plot(6,IntervalU,'ko','LineWidth',3)
ylim([0 15])
xlim([1 6])


%% Correctness Statistics
%Statistics on how correct the sorting is

numSorted =  [48 48 49 47 48 49]; %Number of total skittles sorted total, excluding the ones that could not be sorted
numCorrect = [29 30 35 31 34 26]; %Number of skittles sorted correctly from the total number sorted, excluding those that could not be sorted 

Correctness = numCorrect./numSorted.*100;
avgCorrect = mean(Correctness);

wrongR = [3 2 3 2 2 4]; %Number of Red skittles put into different buckets
wrongO = [4 5 4 6 4 5]; %Number of Orange skittles put into different buckets
wrongY = [5 4 2 2 3 3]; %Number of Yellow skittles put into different buckets
wrongG = [2 3 3 2 2 4]; %Number of Green skittles put into different buckets
wrongP = [5 4 2 4 3 7]; %Number of Purple skittles put into different buckets

wrongmeans = [mean(wrongR) mean(wrongO) mean(wrongY) mean(wrongG) mean(wrongP)];

figure
subplot(1,2,1)
plot(Correctness,'ko')
title('Percent Correctness Through Trials')
ylim([0 100])
xlim([1 6])

subplot(1,2,2)
plot(1,wrongmeans(1),'ro','LineWidth',3)
title('Average Number Wrong Per Color')
hold on
plot(2,wrongmeans(2),'mo','LineWidth',3)
plot(3,wrongmeans(3),'yo','LineWidth',3)
plot(4,wrongmeans(4),'go','LineWidth',3)
plot(5,wrongmeans(5),'bo','LineWidth',3)
legend('Red','Orange','Yellow','Green','Purple','Location','Northeast')
ylim([0 6])

%% ANOVA Analysis

cou = 1; cou1 = 1;
for i = 1:6
    for j=1:6
        sampleNum(cou1)= i;
        cou1 = cou1+1;
    end
    cou=cou+1;
end

M_all=[R'; O'; Y'; G'; P'; U'];

[p1,tbl1,stats1] = anova1(M_all,sampleNum');
figure(5);
c = multcompare(stats1);






