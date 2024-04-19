clc; clear all; close all

% Defining the font size for the plots.
set(0, 'DefaultAxesFontSize', 20);

% Defining the signals amplitude. 
A_modulating = 1;
A_carrier = 1;

% Defining the signals frequency
f_modulating = 1000;
f_carrier = 10000;

% Defining the period and frequency of sampling: 
fs = 50*f_carrier;
Ts = 1/fs;
T = 1/f_modulating;

% Defining the sinal period. 
t_inicial = 0;
t_final = 2;

% "t" vector: corresponds to the time interval of the signal. 
t = [t_inicial:Ts:t_final];

% Defining the signals in the time domain:

modulating_signal = A_modulating*cos(2*pi*f_modulating*t);
carrier_signal = A_carrier*cos(2*pi*f_carrier*t);

% Plotting the signals in the time domain.
figure(1)
subplot(211)
plot(t,modulating_signal,'b', 'LineWidth', 2)
xlim([0 3*T])
ylim([-1.2*A_modulating 1.2*A_modulating])
xlabel('Time (s)')
ylabel('Amplitude')
title('Modulating - Time Domain')

subplot(212)
plot(t,carrier_signal, 'b', 'LineWidth', 2)
xlim([0 3*T])
ylim([-1.2*A_carrier 1.2*A_carrier])
xlabel('Time (s)')
ylabel('Amplitude')
title('Carrier - Time Domain')

% calculating the FFT step.
f_step = 1/t_final;

% calculating the frequency vector.
f = [-fs/2:f_step:fs/2];

% calculating the FFT of the modulating and carrier signals.
modulating_F = fft(modulating_signal)/length(modulating_signal);
modulating_F = fftshift(modulating_F);

carrier_F = fft(carrier_signal)/length(carrier_signal);
carrier_F = fftshift(carrier_F);

% Plotting the signals in the frequency domain.
figure(2)
subplot(211)
plot(f,abs(modulating_F), 'b', 'LineWidth', 2)
xlim([-5*f_carrier 5*f_carrier])
ylim([-1.2*A_modulating 1.2*A_modulating])
title('Modulating - Frequency Domain')
xlabel('Frequency (Hz)')
ylabel('Amplitude')

subplot(212)
plot(f,abs(carrier_F), 'b', 'LineWidth', 2)
xlim([-5*f_carrier 5*f_carrier])
ylim([-0.8*A_carrier 0.8*A_carrier])
title('Modulating - Frequency Domain')
xlabel('Frequency (Hz)')
ylabel('Amplitude')

% Modulating the signals.
% The modulated signal is the product of the modulating and carrier signals.
final_signal = modulating_signal .* carrier_signal;
final_F = fft(final_signal)/length(final_signal);
final_F = fftshift(final_F);

figure(3)
subplot(211)
plot(t,final_signal, 'b', 'LineWidth', 2)
xlim([0 3*T])
hold on

plot(t,modulating_signal, 'r')
xlim([0 3*T])
ylim([-1.2*A_modulating 1.2*A_modulating])
title('Modulated - Time Domain')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(212)
plot(f,abs(final_F), 'b', 'LineWidth', 2)
xlim([-5*f_carrier 5*f_carrier])
ylim([-0.5*A_modulating 0.5*A_modulating])
title('Modulated - Frequency Domain')
xlabel('Frequency (Hz)')
ylabel('Amplitude')

% Demodulating the signal.
demulated_signal = final_signal .* carrier_signal; 

figure(4)
subplot(211)
plot(t,demulated_signal,'b', 'LineWidth', 2)
xlim([0 3*T])
ylim([-1.2*A_modulating 1.2*A_modulating])
title('Demodulated - Time Domain')
xlabel('Time (s)')
ylabel('Amplitude')
subplot(212)
plot(t,modulating_signal,'b')
hold on;
plot(t,demulated_signal,'r', 'LineWidth', 2)
xlim([0 3*T])
ylim([-1.2*A_modulating 1.2*A_modulating])
title('Demodulated - Wrap Comparison')