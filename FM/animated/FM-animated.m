close all; clear all; clc;
pkg load signal;

% Defining the font size for the plots.
set(0, 'DefaultAxesFontSize', 20);

% Defining the amplitudes of the signals
A_modulating = 1;
A_carrier = 1;

% Defining the frequencies of the signals
f_modulating_max = 500; 
f_carrier = 10000;

% Defining the frequency deviation
k_f = 40000;

% Delta variable, correponding to max frequency variation.
d_f = k_f*A_modulating;

% Beta variable, correspondig to percentage of frequency variation about the frequency of the modulating.
b = d_f/f_modulating_max;

% Defining the sampling and period of sampling
fs = 50*f_carrier;
Ts = 1/fs;

% Defining the period of the modulating signal
T = 1/f_modulating_max;

% Defining the time interval
t_inicial = 0;
t_final = 1;

% Defining the time vector
t = [t_inicial:Ts:t_final];

% Modulating Signal for FM modulation
modulating_signal = A_modulating *sin(2*pi*f_modulating_max*t);

% Calculate the number of zeros to be added
num_zeros = length(t) - length(modulating_signal);

% Add the zeros to the end of the modulating_signal vector
modulating_signal = [modulating_signal, zeros(1, num_zeros)];

% Transpose the modulated signal if necessary
modulated_signal = transpose(modulating_signal);

figure;

for i = 1:length(t)

    % Define the current time interval
    t_current = [t_inicial:Ts:t(i)]; 

    % Calculate th current modulating signal  
    modulating_signal_current = modulating_signal(1:i);

    % Calculate the current carrier signal
    carrier_signal_current = A_carrier*cos(2*pi*f_carrier*t_current*4);

    % Calculate the phase argument for FM modulation
    phase_argument = 2*pi*k_f*cumsum(modulating_signal(1:i))*(Ts);

    % Calculate the current modulated signal
    modulated_signal_current = A_carrier * cos(2*pi*f_carrier*t_current + phase_argument);
    
    %  Plot the current modulating signal
    subplot(3,1,1);
    plot(t(1:i), modulating_signal_current, 'b', 'LineWidth', 2);
    grid on;
    xlim([0 T]);
    ylim([-2*A_modulating 2*A_modulating]);
    title('Modulating Signal (Time Domain)');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('Modulating Signal');

    % Plot the current carrier signal
    subplot(3,1,2);
    plot(t_current, carrier_signal_current, 'b', 'LineWidth', 2);
    grid on;
    xlim([0 T]);
    ylim([-2*A_carrier 2*A_carrier]);
    title('Carrier Signal (Time Domain)');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('Carrier Signal'); 

    % Plot the current modulated signal
    subplot(3,1,3);
    plot(t_current, modulated_signal_current, 'b', 'LineWidth', 2);
    grid on;
    xlim([0 T]);
    ylim([-2*A_carrier 2*A_carrier]);
    title('FM Modulated Signal (Time Domain)');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('FM Modulated Signal');  

    % Atualiza o gráfico
    drawnow;
    
    % Pausa para criar a animação
    pause(0.001);
end
