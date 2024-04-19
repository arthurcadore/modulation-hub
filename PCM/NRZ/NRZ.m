close all; clear all; clc;
pkg load signal;
pkg load communications;

% Changes the font size in the plots to 15
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

% "t" vector, corresponding to the time period of analysis, in time domain.
t = [t_initial:Ts:t_final];

signal = A_signal*cos(2*pi*f_signal*t);

% Creating an impulse train with period 2T
impulse_train = zeros(size(t));
impulse_train(mod(t, 1/fs) == 0) = 1;

signal_sampled = signal .* impulse_train;

% Desired number of levels (excluding 0)
n=4;
num_levels = 2^n;

levels = 2/num_levels;

quantized_signal = round((signal_sampled+1)/levels);

% Checks the vector for any element at the maximum of the vector, if so, sets it to the maximum - 1:

for i = 1:length(quantized_signal)
    if quantized_signal(i) == num_levels
        quantized_signal(i) = num_levels - 1;
    end
end


figure(1)
subplot(411)
plot(t,signal, 'LineWidth', 2)
grid on;
xlim([0 3*T])
title('Sine Wave Signal - Time Domain')

subplot(412)
stem(t,impulse_train, 'MarkerFaceColor', 'b')
grid on;
xlim([0 3*T])
title('Impulse Train - Time Domain')

subplot(413)
stem(t,signal_sampled, 'LineStyle','none', 'MarkerFaceColor', 'b')
grid on;
xlim([0 3*T])
title('Sampled Sine Wave Signal - Time Domain')

subplot(414)
stem(t,quantized_signal, 'LineStyle','none', 'MarkerFaceColor', 'b')
xlim([0 3*T])
hold on; 
plot(t,signal*n+A_signal, 'r')
xlim([0 3*T])
grid on;
title('Sampled and Quantized Sine Wave Signal - Time Domain')

% Converting integer quantized values to binary
binary_signal = de2bi(quantized_signal, n);

% Concatenating the binary values into a single vector
binary_signal_concatenated = reshape(binary_signal.', 1, []);

% Time vector
t = linspace(0, 1, length(binary_signal_concatenated) * 2);

% Repeating each value of the signal
repeated_signal = reshape(repmat(binary_signal_concatenated, 2, 1), 1, []);


% Oversampling
n = 3*n;
amplitude = 5;
repeated_signal_up = upsample(repeated_signal, n);

filter_tx = ones(1, n);
filtered_signal = filter(filter_tx, 1, repeated_signal_up)*2*amplitude-amplitude;

% Creating a new t vector for the filtered signal
t_super = linspace(0, 1, length(filtered_signal));

var_noise = 0.1; 
transmission_noise = sqrt(var_noise)*randn(1,length(filtered_signal)); 

transmitted_signal = filtered_signal + transmission_noise; 

% Plotting the signal
figure(2)
subplot(311)
plot(t,repeated_signal, 'LineWidth', 2);
ylim([-0.2, 1.2]);
xlim([0, 150*T]);
xlabel('Time');
ylabel('Amplitude');
title('Coded Quantized Signal - Time Domain');
grid on;

subplot(312)
plot(t_super,filtered_signal, 'LineWidth', 2);
xlim([0, 150*T]);
ylim([-amplitude*1.2 , amplitude*1.2]);
xlabel('Time');
ylabel('Amplitude');
title('Coded Quantized Signal (SuperSampled) - Time Domain');
grid on;

subplot(313)
plot(t_super,transmitted_signal, 'LineWidth', 2);
xlim([0, 150*T]);
ylim([-amplitude*1.2 , amplitude*1.2]);
xlabel('Time');
ylabel('Amplitude');
title('Coded Quantized Signal (SuperSampled + WhiteNoise) - Time Domain');
grid on;

% Reception: 

% Setting the threshold (value that will decide if the signal is 0 or 1)
threshold = 0;

% Sampling the received signal
received_signal = transmitted_signal(n/2:n:end);
received_binary = received_signal > threshold; 

t_received = linspace(0, 1, length(t_super)/n);

% Plotting the signal
figure(3)

subplot(411)
plot(t_received, received_signal,  'LineWidth', 2);
xlim([0, 150*T]);
title('Coded Signal (on RX) - Time Domain');
grid on;

subplot(412)
stem(t_received, received_binary,  'LineWidth', 2);
xlim([0, 150*T]);
title('Coded Signal (Sampled on RX) - Time Domain');
grid on;

subplot(413)
plot(t_received, received_binary,  'LineWidth', 2);
xlim([0, 150*T]);
ylim([-0.1 1.2*max(received_binary)]);
title('Signal Reconstruction - Time Domain');
grid on;

subplot(414)
plot(t,repeated_signal, 'LineWidth', 2);
ylim([-0.2, 1.2]);
xlim([0, 150*T]);
xlabel('Time');
ylabel('Amplitude');
title('Coded Quantized Signal - Time Domain (For Comparison)');
grid on;
