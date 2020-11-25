%% Tutorial for adaboost Package (AdaBoost_samme with two_level_decision_tree)
% *By Jarek Tuszynski*
% 
% Adaboost package consists of two multi-class adaboost classifiers:
%
% * AdaBoost_samme - multi-class extension to classic adaboost.M1 algorithm 
%   (which was for two-class problems) which was first described in a paper 
%    by Ji Zhu, Saharon Rosset, Hui Zou and Trevor Hastie, “Multi-class 
%    AdaBoost”, January 12, 2006. 
%    https://web.stanford.edu/~hastie/Papers/samme.pdf
% * AdaBoost_mult - solves same problem using a bank of two-class adaboost 
%   classifiers. A three class problem will use three 2-class classifiers
%   solving class 1 vs. 2 & 3, class 2 vs. 1 & 3 and class 3 vs. 1 and 2
%   problems, than each sample is tested with each of the three classifiers
%   and class is assigned based on the one with the maximum score.
%
% Boosting classifiers work by using a multiple "weak-learner" classifiers.
% In this package we provide two weak-learner classifiers:
% 
% * decision_stump - a single node decision "tree". For two-class problems 
%   decision_stump class calls "train_stump_2" function which performs
%   exhaustive search of all possible thresholds for all features and picks
%   the optimal one. For multi-class problems "train_stump_N" function is 
%   called which calls "train_stump_2" for all pairs of classes to pick the
%   optimal one.
% * two_level_decision_tree - three nodes in two layers decision "tree"
%  class. 
% 
% *This demo concentrates on AdaBoost_samme class with two_level_decision_tree weak 
%  learner*
%
%% Change History


%% Licence
% The package is distributed under BSD License
format compact; % viewing preference
clear variables;
close all
type('license.txt')

%% Read in test file
% Cardiotocography (CTG) Data Set has measurements of fetal heart rate (FHR) 
% and uterine contraction (UC) features on cardiotocograms classified by 
% expert obstetricians as: normal, suspect and pathologic
% Paper: Ayres de Campos et al. (2000) SisPorto 2.0 A Program for Automated 
%        Analysis of Cardiotocograms. J Matern Fetal Med 5:311-318 
% URL: https://archive.ics.uci.edu/ml/datasets/Cardiotocography
% [~, ~, ctg] = xlsread('CTG-1.xlsx', 'Raw Data'); 
% X = cell2mat(ctg(3:end, 4:end-2));
% y = cell2mat(ctg(3:end, end));
% colLabel = ctg(1, 4:end-2);
[~, ~, ctg] = xlsread('Training_Data1','Train_Feat'); 
X = cell2mat(ctg(1:end, 1:end-1));
y = cell2mat(ctg(1:end, end));

verbose = true;
classifier = AdaBoost_samme(two_level_decision_tree, verbose); % blank classifier
nTree = 20;
C = classifier.train(X, y, [], nTree);

% %% Track performance per iteration using calc_accuracy metchod
% [accuracy, tpr] = C.calc_accuracy( X, y, nTree);
% hold on
% plot(tpr)
% plot(accuracy, 'LineWidth',2)
% xlabel('Number of iterations')
% legend({'true positive rate of normal patients', 'true positive rate of suspect patients', ...
%   'true positive rate of Pathologic patients', 'overall accuracy'},'Location','southeast')

%% Check which features are being used
[hx, hy] = C.feature_hist();
hy = 100*hy/sum(hy);  % normalize and convert to percent
hx(hy==0) = [];       % delete unused features
hy(hy==0) = [];
[hy, idx] = sort(hy); % sort
hx = hx(idx);
clf
barh(hy);
axis tight
xlabel('Percent used')
ylabel('Feature name')
ax = gca;
ax.YTick = 1:length(hx);
%ax.YTickLabel = colLabel(hx);

%% Test export_model and import_model functions
[strList, labels, header] = C.export_model();
CC = classifier.import_model(strList, labels); % initialize new model
Y  = C .predict(X);
YY = CC.predict(X);
fprintf('Number of mismatches between models: %i\n', nnz(Y~=YY));

%% Test save_adaboost_model and load_adaboost_model functions
save_adaboost_model(C, 'classifier.csv');
CC = load_adaboost_model(classifier, 'classifier.csv');
Y  = C .predict(X);
YY = CC.predict(X);
fprintf('Number of mismatches between models: %i\n', nnz(Y~=YY));
type('classifier.csv')

%% Use cross validation to prevent training and testing on the same data
fprintf('Classification is %i%% accurate when training and testing on the same data.\n', ...
  round(100*mean(y==Y)));
classifier = AdaBoost_samme(two_level_decision_tree);
nFold = 10; % ten-fold validation
Y = cross_validation( classifier, X, y, nTree, nFold);
fprintf('Classification is %i%% accurate when using 10-fold cross validation\n', ...
  round(100*mean(y==Y)));

%% Test classifier on 2-class "donut" problem
nSamp = 1000;
[Xb,Yb] = pol2cart((1:nSamp)*2*pi/nSamp,3);
X = 2*[randn(nSamp,2); randn(nSamp,2)+ [Xb' ,Yb'] ];
y = [1+zeros(nSamp,1); 2+zeros(nSamp,1)];
nTree   = 10;   % number of trees
C = classifier.train(X, y, [], nTree);
AdaBoost_demo_plot(C, X, y);

%% Test classifier on 3-class "donut" problem
nSamp = 1000;
[Xb,Yb] = pol2cart((1:nSamp)*2*pi/nSamp,3);
[Xc,Yc] = pol2cart((1:nSamp)*2*pi/nSamp,6);
X= 1.25*[randn(nSamp,2); randn(nSamp,2)+[Xb',Yb']; randn(nSamp,2)+[Xc',Yc'] ];
y = [1+zeros(nSamp,1); 2+zeros(nSamp,1); 3+zeros(nSamp,1)];
nTree = 20;   % number of trees
C = classifier.train(X, y, [], nTree);
Y = C.predict(X);
AdaBoost_demo_plot(C, X, y);

%% Test classifier on 2-class "diagonals" problem
nSamp = 1000;
Xa = (1:nSamp)*10/nSamp;
d = 6;
s = sign(randn(nSamp,1));
X = [randn(nSamp,2)+[Xa',Xa']; randn(nSamp,2)+[Xa',Xa'+s.*d]]-5;
y = [1+zeros(nSamp,1); 2+zeros(nSamp,1)];
nTree   = 20;   % number of trees
C = classifier.train(X, y, [], nTree);
AdaBoost_demo_plot(C, X, y);

%% Test classifier on 3-class "diagonals" problem
nSamp = 1000;
Xa = (1:nSamp)*10/nSamp;
d = 4;
X = [randn(nSamp,2)+[Xa',Xa']; randn(nSamp,2)+[Xa',Xa'+d]-1; randn(nSamp,2)+[Xa',Xa'-d]+1]-5;
y = [1+zeros(nSamp,1); 2+zeros(nSamp,1); 3+zeros(nSamp,1)];
nTree = 20;   % number of trees
C = classifier.train(X, y, [], nTree);
AdaBoost_demo_plot(C, X, y);

