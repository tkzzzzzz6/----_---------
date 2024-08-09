% �ļ���: run_cigarette_filter_analysis.m

clear; clc;  % ������������������������

% ��ʾ��ǰ����Ŀ¼
disp(['Current directory: ', pwd]);

% �г���ǰĿ¼�е� .m �ļ�
disp('M-files in current directory:');
disp({dir('*.m').name});

% ȷ�������ļ���MATLAB·����
if exist('cigarette_filter_functions.m', 'file') ~= 2
    error('cigarette_filter_functions.m not found in the current directory');
else
    disp('cigarette_filter_functions.m found');
end

% ��ӵ�ǰĿ¼��·���������û�еĻ���
addpath(pwd);

% ����Ĭ�ϲ���
fixed_params.a = 0.5;  % Proportion of toxins entering air
fixed_params.M = 100;  % Total amount of toxins
fixed_params.beta = 0.1;  % Absorption rate of filter
fixed_params.l2 = 2;  % Length of filter
fixed_params.v = 10;  % Speed of smoke through cigarette
fixed_params.b = 0.05;  % Absorption rate of tobacco
fixed_params.l1 = 8;  % Length of tobacco

% ����Q vs l2 (filter length)
l2_range = 0:0.1:5;
try
    cigarette_filter_functions('l2', l2_range, fixed_params);
catch ME
    disp('Error occurred when calling plot_Q_vs_parameter:');
    disp(ME.message);
end

% ����Q vs beta (filter absorption rate)
beta_range = 0:0.01:0.5;
cigarette_filter_functions('beta', beta_range, fixed_params);

% ���㲢���Ʋ�ͬbetaֵ��Q ratio
beta_range = 0.05:0.01:0.2;
Q_ratios = zeros(size(beta_range));
for i = 1:length(beta_range)
    try
        [~, Q_ratios(i)] = cigarette_filter_functions(beta_range(i), fixed_params.b, fixed_params.l2, fixed_params.v);
    catch ME
        disp(['Error occurred while calculating Q ratio for beta = ', num2str(beta_range(i))]);
        disp(ME.message);
    end
end

figure;
plot(beta_range, Q_ratios, 'LineWidth', 1.5);
xlabel('beta');
ylabel('Q1/Q2 ratio');
title('Ratio of toxin intake (with filter / without filter)');
yline(1, '--r', 'Q1 = Q2');
grid on;

% ��ӡһЩ�ض�ֵ
try
    [Q, ~] = cigarette_filter_functions(fixed_params.a, fixed_params.M, fixed_params.beta, fixed_params.l2, fixed_params.v, fixed_params.b, fixed_params.l1);
    [~, Q_ratio] = cigarette_filter_functions(fixed_params.beta, fixed_params.b, fixed_params.l2, fixed_params.v);
    disp(['Q with default parameters: ', num2str(Q)]);
    disp(['Q ratio with default parameters: ', num2str(Q_ratio)]);
catch ME
    disp('Error occurred while calculating specific Q or Q ratio values:');
    disp(ME.message);
end
