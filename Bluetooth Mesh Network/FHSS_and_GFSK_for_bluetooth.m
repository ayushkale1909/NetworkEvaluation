fs = 1e6; % Sampling frequency (1 MHz)
T = 1/fs; % Sampling period
fc = 2.4e9; % Carrier frequency (2.4 GHz)
N = 10000; % Number of bits
Ts = 1e-3; % Symbol period (1 ms)
alpha = 0.5; % GFSK modulation
SNR_dB = 10; % Signal-to-Noise Ratio

%% Frequency Hopping Spread Spectrum (FHSS)
% Generate random bits
bits = randi([0 1], 1, N);

hopPattern = [2.402e9 2.416e9 2.420e9 2.432e9 2.452e9];

hopSeq = hopPattern(randi([1 numel(hopPattern)], 1, N));

% Frequency hopping modulation
txSignal_fhss = zeros(1, N*fs*Ts);
for i = 1:N
    t = (i-1)*Ts: T :i*Ts-T;
    txSignal_fhss((i-1)*fs*Ts+1:i*fs*Ts) = sqrt(2/Ts)*cos(2*pi*hopSeq(i)*(t-Ts/2));
end

%% Gaussian Frequency Shift Keying (GFSK)
% Convert bits to symbols
symbols = 2*bits - 1;

% GFSK modulation
txSignal_gfsk = zeros(1, N*fs*Ts);
for i = 1:N
    t = (i-1)*Ts: T :i*Ts-T;
    phi = cumsum(2*pi*fc*Ts + 2*pi*alpha*symbols(i)*(t-Ts/2));
    txSignal_gfsk((i-1)*fs*Ts+1:i*fs*Ts) = sqrt(2/Ts)*cos(phi);
end

%% Add noise
SNR = 10^(SNR_dB/10); % Convert dB to linear scale
rxSignal_fhss = awgn(txSignal_fhss, SNR, 'measured');
rxSignal_gfsk = awgn(txSignal_gfsk, SNR, 'measured');

%% Plot
t_fhss = linspace(0, N*Ts, N*fs*Ts);
t_gfsk = linspace(0, N*Ts, N*fs*Ts);

figure;
subplot(2,1,1);
plot(t_fhss, txSignal_fhss);
title('FHSS Modulated Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(t_fhss, rxSignal_fhss);
title('FHSS Modulated Signal with Noise');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

figure;
subplot(2,1,1);
plot(t_gfsk, txSignal_gfsk);
title('GFSK Modulated Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(t_gfsk, rxSignal_gfsk);
title('GFSK Modulated Signal with Noise');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
