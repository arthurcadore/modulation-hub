clc; clear all; close all

% Defining the signals amplitude. 
A_modulating = 1;
A_carrier = 1;
A_dc = 2; 

% Defining the modulation index.
m = A_modulating/A_dc;

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

% defining the time vector; 
t = [t_inicial:Ts:t_final];

% calculating the time step;
f_step = 1/t_final;

% defining the frequency vector; 
f = [-fs/2:f_step:fs/2];

% defining the modulating and carrier signals;
modulating_signal = A_modulating*cos(2*pi*f_modulating*t);
carrier_signal = A_carrier*cos(2*pi*f_carrier*t);

% creating the modulated signal by multiplying the modulating and carrier: 
final_signal = (A_dc + modulating_signal) .* carrier_signal; 

% creating the modulated signal by multiplying the modulating and carrier (option 2): 
%final_signal = A_dc .* (1 + m * cos(2*pi*f_modulating)) .* A_carrier*cos(2*pi*f_carrier*t);

% creating the modulated signal by multiplying the modulating and carrier (option 3): 
%final_signal = A_dc .* carrier_signal + ((A_dc * A_carrier * m)/2) * (cos(2*pi*f_carrier - 2*pi*f_modulating)*t + cos(2*pi*f_carrier + 2*pi*f_modulating)*t);

% calculating the FFT of the signals
modulating_F = fft(modulating_signal)/length(modulating_signal);
modulating_F = fftshift(modulating_F);

carrier_F = fft(carrier_signal)/length(carrier_signal);
carrier_F = fftshift(carrier_F);

% calculating the FFT of the modulated signal
final_F = fft(final_signal)/length(final_signal);
final_F = fftshift(final_F);

% Plotting the signals
figure(1)
subplot(321)
plot(t,modulating_signal,'b', 'LineWidth', 2)
xlim([0 3*T])
ylim([-1.2*A_modulating 1.2*A_modulating])
title('modulating signal (Time domain)')

subplot(323)
plot(t,carrier_signal, 'b', 'LineWidth', 2)
xlim([0 3*T])
ylim([-1.2*A_carrier 1.2*A_carrier])
title('carrier signal (Time domain)')

subplot(325), 'LineWidth', 2
plot(t,final_signal, 'b', 'LineWidth', 2)
xlim([0 3*T])
hold on
plot(t,modulating_signal, 'r', 'LineWidth', 2)
xlim([0 3*T])
ylim([-1.6*A_dc 1.6*A_dc])
title('final signal (Time domain)')

subplot(322)
plot(f,abs(modulating_F), 'b', 'LineWidth', 2)
xlim([-3*f_carrier 3*f_carrier])
ylim([0 1.2*A_modulating])
title('modulating signal (Frequency domain)')

subplot(324)
plot(f,abs(carrier_F), 'b', 'LineWidth', 2)
xlim([-3*f_carrier 3*f_carrier])
ylim([0 0.8*A_carrier])
title('carrier signal (Frequency domain)')

subplot(326)
plot(f,abs(final_F), 'b', 'LineWidth', 2)
xlim([-3*f_carrier 3*f_carrier])
ylim([0 0.5*A_modulating])
title('final signal (Frequency domain)')

% Demodulating the signal:
demulated_signal = final_signal .* carrier_signal; 

% calculating the FFT of the demulated signal
demulated_F = fft(demulated_signal)/length(demulated_signal);
demulated_F = fftshift(demulated_F);

% plotting the demulated signal
figure(2)
subplot(311)
plot(t,demulated_signal,'b', 'LineWidth', 2)
xlim([0 3*T])
title('demulated signal (Time domain)')

subplot(312)
plot(t,demulated_signal,'b', 'LineWidth', 2)
xlim([0 3*T])
hold on; 
plot(t,modulating_signal+max(modulating_signal),'r', 'LineWidth', 2)
xlim([0 3*T])
title('demulated wrap (Time domain)')

subplot(313)
plot(f,abs(demulated_F), 'b', 'LineWidth', 2)
xlim([5*-f_carrier f_carrier*5])
title('demulated signal (Frequency domain)')