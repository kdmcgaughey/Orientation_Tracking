
% Make fake impulse response function with Gamma function (gammapdf)

fake_IRF = gampdf(0:60,12,0.5);
plot((0:60)/60,fake_IRF)

%%

% Data path

dataPath = '/Users/karamcgaughey/Documents/GoldLab/Orientation_Tracking/Behavior/Pliot/';
cd(dataPath)

% Load in .mat file

load('05_05_2023_13_17_KDM_SD_2_joystick.mat')


%%

% Convolve IRF with each stimulus "trial" to get matrices of responses

for t = 1:size(stim,1)
    response(t,:) = conv(stim(t,:), flip(fake_IRF), 'same');
end

% Wrap stimulus and response

stim_wrap = wrapTo360(stim(:,:).*2);
resp_wrap = wrapTo360(response(:,:).*2);

stim_wrap = stim_wrap./2;
resp_wrap = resp_wrap./2;

% Take diff

stim_diff = diff(stim_wrap,1,2);
resp_diff = diff(resp_wrap,1,2);

%%

% Cross correlate with tracking stimulus

% Johannes impulse response function code
% BurgeLabToolbox: xcorrEasy

trim_vals = 59;                                 % Values to trim off beginning of each "trial"
t = 1:1:size(stim_diff,2) - trim_vals;      % Values at which time series are sampled
tMaxLag = 120;                                  % Maximum lag (in units of smpVal)
bPLOT = 0;                                      % Plot or not
bPLOTall = 0;                                   % Plot or not                  

num_cond = size(stim_diff,3);

for s = 1:num_cond

    [rMU,trho,rALL,rSD] = xcorrCircEasy(stim_diff(:,trim_vals+1:end,s)',resp_diff(:,trim_vals+1:end,s)', t', tMaxLag, [], [], bPLOT, bPLOTall);

    % Save values

    cross_cors(s,:) = rMU;
    cross_cors_all(:,:,s) = rALL;
    cross_cors_std(s,:) = rSD;
    resp_lags(s,:) = trho;
end

figure 

plot(resp_lags(s,1:tMaxLag)/60,cross_cors(s,1:tMaxLag))
xticks([0, 0.5, 1, 1.5, 2])
hold on;


% Should recover impulse response function


% Try adding small sinusoid to the stimulus and see how that affects things






%%
signal = normrnd(0, 1, [1, 100]);
plot(signal);

%%
irf = zeros([1, 10]);
irf(3) = 1;

plot(irf);

%% 
axis = 0 : 0.2 : 2;
irf_filter = normpdf(axis, 0, 2);
plot(irf_filter)

%%
output = conv(signal, flip(irf), 'same');

figure();
plot(signal); hold on;
plot(output);

%%
output = conv(signal, flip(irf_filter), 'same');
figure();
plot(signal); hold on;
plot(output);
