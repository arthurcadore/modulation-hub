close all; clear all; clc;
pkg load signal;

% Defining the amplitudes of the signals:
A_modulating = 1;
A_carrier = 1;

% Defining the frequencies of the signals:
f_modulating = 50;
f_carrier = 1000;

% Defining the sampling frequency and the sampling period:
fs = 15*f_carrier;
Ts = 1/fs;

% Defining the period of the modulating signal:
T = 1/f_modulating;

% Defining the time interval:
t_initial = 0;
t_final = 2;

% Defining the time vector:
t = [t_initial:Ts:t_final];

% Generating the modulating signal:
modulating_signal = A_modulating *cos(2*pi*f_modulating*t);

% Calculating the number of zeros to be added to the modulating signal:
num_zeros = length(t) - length(modulating_signal);
modulating_signal = [modulating_signal, zeros(1, num_zeros)];

% Plotting the modulating signal:
figure;

for i = 1:length(t)

    % Calculate the current interval of time
    t_current = [t_initial:Ts:t(i)]; 

    % Calculate the current modulated signal
    modulated_signal_current = (A_carrier * cos(2*pi*f_carrier*t_current)) .* modulating_signal(1:length(t_current));
    
    % Calculate the offset to shift the modulating signal to the right
    %offset_modulating = round((i-1) * length(modulating_signal) / length(t));
    % modulating_signal_shifted = circshift(modulating_signal, offset_modulating);

    % Plot the current modulated signal
    subplot(3,1,3);
    plot(t_current, modulated_signal_current, 'b', 'LineWidth', 2);
    grid on;
    xlim([0 T*2]);
    ylim([-2*A_carrier 2*A_carrier]);
    title('AM Modulated Signal (Time Domain)');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Plot the current modulating signal
    subplot(3,1,1);
    plot(t, modulating_signal, 'b', 'LineWidth', 2);
    grid on;
    xlim([0 T*2]);
    ylim([-2*A_modulating 2*A_modulating]);
    title('Modulating Signal (Time Domain)');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Plot the current carrier signal
    subplot(3,1,2);
    plot(t_current, A_carrier * cos(2*pi*f_carrier*t_current), 'b', 'LineWidth', 2);
    grid on;
    xlim([0 T*2]);
    ylim([-2*A_carrier 2*A_carrier]);
    title('Carrier Signal (Time Domain)');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Update the plot
    drawnow;
  
    % Add a small pause to the plot
    pause(0.01);
end
