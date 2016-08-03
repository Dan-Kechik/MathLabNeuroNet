% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created 27-Jul-2016 16:27:36
%
% This script assumes these variables are defined:
%
%   engineInputs - input data.
%   engineTargets - target data.
%
%��������� ��������� ���-�� ��������. ��� ������ ���������� ���������.

path='D:\Programs\Program Files\Learning_sets\Janry_muzyki\genres';
[Inputs, Targets]=getIT(path);

x = Inputs;
t = Targets;

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Fitting Network
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize,trainFcn);
% Two (or more) layer fitting networks can fit any finite input-output
%    relationship arbitrarily well given enough hidden neurons.
%    fitnet(hiddenSizes,trainFcn) takes a row vector of N hidden layer
%    sizes, and a backpropagation training function, and returns
%    a feed-forward neural network with N+1 layers.
%    Input, output and output layers sizes are set to 0.  These sizes will
%    automatically be configured to match particular data by train. Or the
%    user can manually configure inputs and outputs with configure.

%2-�- ��� ����� ������� ���� ����� ���� ��������� ��� ����� ��������
%��������� ��/���, ����������� ������ ������������ ���-�� ��������.
%fitnet(hiddenSizes,trainFcn) ������. ������-������ N �������� �������
%����, ������������� �-��� ������� ���������������� ������ � �����. ���� � ������ ��������� � N+1 �������� ������.
%������� ��, ���, ��� ���� ���. � 0. �� ������� ���������� �-���� ����� �������������.

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};
%'removeconstantrows' - ������� ������ �-��, �����-��� ��������
%'mapminmax' - �������� ����������� � ������������ �������� � [-1;1]

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);
%���� ���� net, ��. ����. x, ���� t � �����. ���� net � �������������
%������ tr. ����� ������������ ���. ��. ����. � ���. ���� (Xi, Ai), ���� ������ EW.

% Test the Network
y = net(x);
e = gsubtract(t,y);
%���������� ������. gsubtract - ������������ ���������.
performance = perform(net,t,y)
%���������� ������������������ ����

% Recalculate Training, Validation and Test Performance
%tr - ��������� � ����������� ����, �������� � ������������ ��������, ��� �������� �-��� ������ � ��.
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
% See the help for each generation function for more information.
if (false)
    % Generate MATLAB function for neural network for application
    % deployment in MATLAB scripts or with MATLAB Compiler and Builder
    % tools, or simply to examine the calculations your trained neural
    % network performs.
    genFunction(net,'myNeuralNetworkFunction');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end

%������ �-��� ����.
genFunction(net,'NNFun','MatrixOnly','yes');
y = NNFun(x);
%������ ��������� - �������� ���������� ��������
[R,M,B] = regression(t,y)
plotregression(t,y)

exit=false;
inc=-1; %����������, � ���. �-��� �������� ����� ��������: ������� ���������, ����� ��������� �� �����.
R_nes=1; %����������� ����������: �� ��� ���������� ���� �����������. ���� 1, �� ���� ��������.
i=1;
N=hiddenLayerSize;
R=mean(R); %R - ����������� ���-�, ����� ��������� �����. ����� ���-���.
while (~exit)
   hiddenLayerSize=hiddenLayerSize+inc;
   N=[N hiddenLayerSize]; %���������� � ������ ������� ���-�� ����.
   i=i+1;
   net = fitnet(hiddenLayerSize,trainFcn);
   [net,tr] = train(net,x,t);
   [R_cur,M,B] = regression(t,y);
   R_c=mean(R_cur);
   R=[R R_c]; %��������� ���-� � ������
   disp(['���������� �������� ' num2str(hiddenLayerSize) ' ���������� ��������� ' num2str(R_c) ' �������� ' num2str(i)]);

   
   if (R_c>=R_nes)&&(inc==1) exit=true; end %���� �������� ������� �������� - �������.
   if (R_c<=R(i-1))||(hiddenLayerSize==1) %����� �� ��������� ��������� ����� ����. � 0
       %������ 1 ������ ���������� ���-� �� ����, ��� 10.
       if inc==1 exit=true; end %���� inc=-1, �� �� ��������� ���������, ���� inc=1, ������ ����� ������������ ���-�� ����.
       %���� ��������� ���������, ��������� �����������. ���� ����������� �
       %�������� ��������� - �������.
       if (R_c<R(i-1))||(hiddenLayerSize==1)
           %� ������, ����� ��������� ����� ��������, ���� ����������
           %��������� �� ����������. ����� �����������, ���������������, ����� ���-� �������� ����������.
           inc=1;
           hiddenLayerSize=N(1); %������������� �������� ���-�� ����.
       end
   end
end
[mv,mi]=max(R); %���� ���������� � ������ �����������
hiddenLayerSize=N(mi); %���. ����� ��������, mi - ������ ����. ����������.
net = fitnet(hiddenLayerSize,trainFcn);
[net,tr] = train(net,x,t);
figure
plotregression(t,y)