clc; clear; close all;

%% Time series characterisation

Fs = 1000;              % Sampling frequency (Hz)
Ts = 1/Fs;              % Sampling interval (s)
N = 2048;               % Number of samples
T_total = N * Ts;       % Total time (s)

t = (0:N-1) * Ts;

%% Simulated vibration signal (mechanical system)

f_rot = 30;             % Shaft rotation frequency (Hz)
f_fault = 90;           % Fault harmonic (Hz)

A_rot = 1.2;            % Amplitude of rotation
A_fault = 0.6;          % Amplitude of fault

% Set random seed for reproducibility
rng(1);

signal = A_rot*sin(2*pi*f_rot*t) + ...
         A_fault*sin(2*pi*f_fault*t) + ...
         0.2*randn(size(t));     % Noise

signal = signal - mean(signal);  % Remove DC offset

%% Apply window to reduce spectral leakage
window = hann(N)';
signal_windowed = signal .* window;

%% FFT analysis

Y = fft(signal_windowed);

% Correct amplitude scaling for window
P2 = abs(Y / (sum(window)/2));
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(N/2))/N;

%% Plot spectrum

figure;
plot(f, P1, 'LineWidth', 1.5);
grid on;

xlabel('Frequency (Hz)');
ylabel('Amplitude (mm/s)');
title('Frequency Spectrum of Mechanical Vibration Signal');

xlim([0 150]);

%% Find dominant frequencies (top 3 peaks)

[peaks, locs] = findpeaks(P1, f, 'SortStr', 'descend');
num_peaks = min(3, length(peaks));

dominant_freqs = locs(1:num_peaks);
dominant_amps = peaks(1:num_peaks);

%% Display required values

fprintf('Sampling interval Ts = %.5f s\n', Ts);
fprintf('Number of samples N = %d\n', N);
fprintf('Total time = %.3f s\n', T_total);
fprintf('Fundamental frequency = %.1f Hz\n', f_rot);

fprintf('\nTop %d dominant frequencies:\n', num_peaks);
for i = 1:num_peaks
    fprintf('  %.2f Hz (Amplitude = %.2f mm/s)\n', ...
        dominant_freqs(i), dominant_amps(i));
end
