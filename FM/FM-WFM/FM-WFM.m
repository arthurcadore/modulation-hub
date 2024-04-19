close all; clear all; clc;

% Defining the font size for the plots.
set(0, 'DefaultAxesFontSize', 20);

% Defining the signals amplitude. 
A_modulating = 1; 
A_carrier = 1; 

% Defining the signals frequency
f_modulating = 10000;
f_carrier = 150000;

% modulator sensibility for frequency variation (Hz/volts)
k_f = 150000;
k0 = 2*pi*k_f;

% Delta variable, correponding to max frequency variation.
d_f = k_f*A_modulating;

% Beta variable, correspondig to percentage of frequency variation about the frequency of the modulating. 
b = d_f/f_modulating;

% Defining the period and frequency of sampling: 
fs = 50*f_carrier;
Ts = 1/fs;
T = 1/f_modulating;

% Defining the sinal period. 
t_inicial = 0;
t_final = 2;

% "t" vector, correspondig to the time period of analysis, on time domain. 
t = [t_inicial:Ts:t_final];

% Defining carrier and modulating signals (for plot purpuses).
carrier_signal = A_carrier * cos(2*pi*f_carrier*t);
modulating_singal = A_modulating *cos(2*pi*f_modulating*t);

% Creating the FM modulated signal: 
phase_argument = 2*pi*k_f*cumsum(modulating_singal)*Ts;
modulated_signal = A_carrier * cos(2*pi*f_carrier*t + phase_argument);

% Plot signals on time domain: 
figure(1)
subplot(311)
plot(t, modulating_singal, 'b', 'LineWidth', 2)
xlim([0 2*T])
xlabel('Time (s)')
ylabel('Amplitude')
title('Modulating Signal - Time Domain')

subplot(312)
plot(t, carrier_signal,'b', 'LineWidth', 2)
xlim([0 2*T])
xlabel('Time (s)')
ylabel('Amplitude')
  title('Carrier Signal (Time Domain)')

subplot(313)
plot(t, modulated_signal, 'b', 'LineWidth', 2)
xlim([0 2*T])
xlabel('Time (s)')
ylabel('Amplitude')
title('FM Modulated Signal (Time Domain)')

% calculating the step of the frequency vector "f" (frequency domain); 
f_step = 1/t_final;

% creating the frequency vector "f" (frequency domain); 
f = [-fs/2:f_step:fs/2];

% calculating the FFT of the modulated signal;
modulated_f = fft(modulated_signal)/length(modulated_signal);
modulated_f = fftshift(modulated_f);

% Plotting the modulated signal on frequency domain;
figure(2)
subplot(211)
plot(f,modulated_f, 'b', 'LineWidth', 2)
xlim([-f_carrier*3 f_carrier*3])
xlabel('Time (s)')
ylabel('Magnitude')
title('FM Modulated Signal - Frequency Domain')

subplot(212)
plot(f,abs(modulated_f), 'b', 'LineWidth', 2)
xlim([-f_carrier*3 f_carrier*3])
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('FM Modulated Signal - Frequency Domain (Absolute)')

%Calculating the total bandwidth of the FM modulated signal.
B_t = 2*d_f + 2*f_modulating

% Calculating the FM demodulation for the modulated signal
demodulated_signal = diff(modulated_signal) * fs / k0;
demodulated_signal = [demodulated_signal, 0];  % Sinal demodulado

% calculating the FFT of the random signal;
demodulated_f = fft(demodulated_signal)/length(demodulated_signal);
demodulated_f = fftshift(demodulated_f);

% Calculating the signal wrap. 
demodulated_wrap = abs(hilbert(demodulated_signal));

% Plotting the modulated and demodulated signals on time domain:
figure(3)
subplot(411)
plot(t, modulated_signal, 'k', 'LineWidth', 2)
xlim([0.00060 0.00080])
xlabel('Tempo (s)')
ylabel('Amplitude')
title('FM Modulated Signal - Time Domain')

subplot(412)
plot(t, demodulated_signal, 'b', 'LineWidth', 2)
xlim([0.00060 0.00080])
xlabel('Tempo (s)')
ylabel('Amplitude')
title('FM Demodulated Signal - Time Domain')

subplot(413)
plot(t, demodulated_wrap, 'r', 'LineWidth', 2)
xlim([0.00060 0.00080])
xlabel('Tempo (s)')
ylabel('Amplitude')
title('FM Signal Wrap - Time Domain')

subplot(414)
plot(t, modulating_singal, 'r', 'LineWidth', 2)
xlim([0.00060 0.00080])
xlabel('Tempo (s)')
ylabel('Amplitude')
title('FM Modulating Signal- Time Domain (For Comparison)')

figure(4)
subplot(211)
plot(f, demodulated_f, 'k', 'LineWidth', 2)
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Demodulated Signal - Frequency Domain')
xlim([-f_carrier*3 f_carrier*3])

subplot(212)
plot(f, abs(demodulated_f), 'k', 'LineWidth', 2)
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Absolute Demodulated Signal - Frequency Domain')
xlim([-f_carrier*3 f_carrier*3])