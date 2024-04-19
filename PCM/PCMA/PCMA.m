close all; clear all; clc;
pkg load signal;

% Change the font size in the plots to 15
set(0, 'DefaultAxesFontSize', 20);

% Defining the base signal amplitude.
A_signal = 1;

% Defining the frequency for the base signal
f_signal = 80000;

% Defining the period and frequency of sampling:
fs = 40*f_signal;
Ts = 1/fs;
T = 1/f_signal;

% Defining the signal period.
t_initial = 0;
t_final = 0.01;

% "t" vector, corresponding to the time period of analysis, in the time domain.
t = [t_initial:Ts:t_final];

signal = A_signal*cos(2*pi*f_signal*t);

% Creating an impulse train with a period of 2T
impulse_train = zeros(size(t));
impulse_train(mod(t, 1/fs) == 0) = 1;

signal_sampled = signal .* impulse_train;

figure(1)
subplot(311)
plot(t,signal, 'LineWidth', 2)
grid on;
xlim([0 3*T])
title('Sine Wave Signal - Time Domain')

subplot(312)
stem(t,impulse_train, 'MarkerFaceColor', 'b')
grid on;
xlim([0 3*T])
title('Impulse Train - Time Domain')

subplot(313)
stem(t,signal_sampled, 'LineStyle','none', 'MarkerFaceColor', 'b')
grid on;
xlim([0 3*T])
title('Sampled Sine Wave Signal - Time Domain')

% Desired number of levels (excluding 0)
n=2;
num_levels = 2^n;

% Generating quantization levels automatically
levels = linspace(-1, 1, num_levels+1);
levels = levels(2:end); % Remove the first element (zero)

% Quantization
quantized_signal = zeros(size(signal_sampled));
for i = 1:length(signal_sampled)
    for j = 1:length(levels)
        if signal_sampled(i) <= levels(j)
            quantized_signal(i) = levels(j);
            break;
        end
    end
end

figure(2)
subplot(211)
stem(t,signal_sampled, 'LineStyle','none', 'MarkerFaceColor', 'b')
grid on;
xlim([0 3*T])
title('Sampled Sine Wave Signal - Time Domain')

subplot(212)
stem(t,quantized_signal, 'LineStyle','none', 'MarkerFaceColor', 'b')
xlim([0 3*T])
hold on; 
plot(t,signal, 'r')
xlim([0 3*T])
grid on;
title('Sampled and Quantized Sine Wave Signal - Time Domain')

% Converting quantized values to binary:
binary_signal = dec2bin((quantized_signal + 1) * (2^(n-1)), n);

% Defining amplitudes for each binary value
amplitudes = linspace(-1, 1, 2^n + 1);

% Mapping binary values to amplitudes
pcm_signal = zeros(size(binary_signal, 1), 1);
for i = 1:size(binary_signal, 1)
    bin_str = binary_signal(i, :);
    bin_value = bin2dec(bin_str);
    pcm_signal(i) = amplitudes(bin_value + 1); % Add 1 to compensate for MATLAB's 0-based indexing
end

% Defining the time vector for the PCM signal
t_pcm = [t_initial:Ts:t_final];

figure(3)
subplot(211)
stem(t,quantized_signal, 'LineStyle','none', 'MarkerFaceColor', 'b')
xlim([0 3*T])
hold on; 
plot(t,signal, 'r')
xlim([0 3*T])
grid on;
title('Sampled and Quantized Sine Wave Signal - Time Domain')

subplot(212)
stairs(t_pcm, pcm_signal, 'b', 'LineWidth', 2);
xlim([0 3*T])
xlabel('Time (s)');
ylabel('Amplitude');
title('PCM Signal with Multilevel Amplitude - Time Domain');
grid on;
