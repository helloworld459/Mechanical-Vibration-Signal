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

signal = A_rot*sin(2*pi*f_rot*t) + ...
         A_fault*sin(2*pi*f_fault*t) + ...
         0.2*randn(size(t));     % Noise

signal = signal - mean(signal);  % Remove DC offset

%% FFT analysis

Y = fft(signal);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(N/2))/N;

%% Plot spectrum

figure;
plot(f, P1, 'LineWidth', 1.5);
grid on;

xlabel('Frequency (Hz)');
ylabel('Amplitude (mm/s)');  % vibration units (velocity)
title('Frequency Spectrum of Mechanical Vibration Signal');

xlim([0 150]); % zoom for clarity

%% Find dominant frequency

[amp_max, idx] = max(P1);
dominant_freq = f(idx);


