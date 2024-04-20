% IQ transmission of two different audio signals.
% IQ - In-Phase and Quadrature Modulation

clc; clear all; close all
pkg load signal

% Change font size in plots to 15
set(0, 'DefaultAxesFontSize', 15);

% Definition of the parameters of the IQ signal carrier:
carrier_amplitude = 1;
carrier_frequency = 40000;

% Collecting the signals for transmission:
[short_signal, Fs] = audioread('short-signal.wav');
[long_signal, Fs2] = audioread('long-signal.wav');

% Transposing the input signal (row/column):
short_signal = transpose(short_signal);
long_signal = transpose(long_signal);

% Getting the transmission duration from the shortest signal;
duration = length(short_signal)/Fs;

% Calculating the time domain vector "t";
Ts = 1/Fs;
t=[0:Ts:duration-Ts];

% Matching the length of the signals to the time vector
signal_cos = short_signal(1:length(t));
signal_sin = long_signal(1:length(t));

% Calculating the frequency domain step;
f_step = 1/duration;

% Vector "f" corresponding to the analysis period (frequency domain);
f = [-Fs/2:f_step:Fs/2];
f = [1:length(signal_cos)];

% Calculating the FFT of the input signal (to be used in cosine);
signal_cos_F = fft(signal_cos)/length(signal_cos);
signal_cos_F = fftshift(signal_cos_F);

% Calculating the FFT of the input signal (to be used in sine);
signal_sin_F = fft(signal_sin)/length(signal_sin);
signal_sin_F = fftshift(signal_sin_F);

% Plot of the input signals (time and frequency domains):
figure(1)
subplot(221)
plot(t,signal_cos,'r')
xlim([(duration*0.3) (duration*0.7)])
title('Carrier Cosine Modulating Signal (Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(223)
plot(t,signal_sin,'k')
xlim([(duration*0.3) (duration*0.7)])
title('Carrier Sine Modulating Signal (Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(222)
plot(f,abs(signal_cos_F), 'r')
title('Carrier Cosine Modulating Signal (Frequency domain)')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(224)
plot(f,abs(signal_sin_F), 'k')
title('Carrier Sine Modulating Signal (Frequency domain)')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

% Creating the carrier signals for orthogonal transmission (one with sine and the other with cosine):
carrier_cos = carrier_amplitude*cos(2*pi*carrier_frequency*t);
carrier_sin = carrier_amplitude*sin(2*pi*carrier_frequency*t);

% Performing AM modulation of the audio signal on the corresponding carrier for each signal:
modulated_cos = signal_cos .* carrier_cos;
modulated_sin = signal_sin .* carrier_sin;

% Performing the signal multiplexing (using the orthogonality principle):
multiplexed_signal = modulated_cos + modulated_sin;

% Calculating the FFT of the signal to sample its state in the frequency domain:
multiplexed_signal_F = fft(multiplexed_signal)/length(multiplexed_signal);
multiplexed_signal_F = fftshift(multiplexed_signal_F);

figure(2)
subplot(221)
plot(f,carrier_cos,'r', 'LineWidth', 2)
xlim([0 100*f_step])
title('Cosine Carrier')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(223)
plot(f,carrier_sin,'k', 'LineWidth', 2)
xlim([0 100*f_step])
title('Sine Carrier')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(222)
plot(t,modulated_cos,'r')
xlim([(duration*0.3) (duration*0.7)])
title('Modulated Cosine Signal (Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(224)
plot(t,modulated_sin,'k')
xlim([(duration*0.3) (duration*0.7)])
title('Modulated Sine Signal (Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

% Checking the multiplexed signal:
figure(3)
subplot(211)
plot(t,multiplexed_signal,'b')
xlim([(duration*0.3) (duration*0.7)])
title('Multiplexed Signal')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(212)
plot(f,abs(multiplexed_signal_F), 'b')
title('Multiplexed Signal (Frequency domain)')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

% Performing signal demodulation at the receiver:
demodulated_cos = multiplexed_signal .* carrier_cos;
demodulated_sin = multiplexed_signal .* carrier_sin;

% FIR filter order
filter_order = 100;

% FIR filter cutoff frequency
% Since it is an audio signal, the cutoff frequency can be set at 20kHz
cutoff_frequency = 20000;

% FIR filter coefficients for each demodulated signal
filter_coefficients = fir1(filter_order, cutoff_frequency/(Fs/2));

% Frequency response of the FIR filter for each demodulated signal
[H_cos, f_cos] = freqz(filter_coefficients, 1, length(t), Fs);
[H_sin, f_sin] = freqz(filter_coefficients, 1, length(t), Fs);

% Plotting the frequency response of the filters:
figure(5)
subplot(211)
plot(f_cos, abs(H_cos), 'r', 'LineWidth', 3)
xlim([0 cutoff_frequency*1.1])
title('Frequency Response of the Cosine FIR Filter')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(212)
plot(f_sin, abs(H_sin), 'k', 'LineWidth', 3)
xlim([0 cutoff_frequency*1.1])
title('Frequency Response of the Sine FIR Filter')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

% Filtering the demodulated signals
demodulated_cos_filtered = filter(filter_coefficients, 1, demodulated_cos);
demodulated_sin_filtered = filter(filter_coefficients, 1, demodulated_sin);

% Calculating the FFT of the demodulated signals to sample their state in the frequency domain:
demodulated_sin_F = fft(demodulated_sin_filtered)/length(demodulated_sin_filtered);
demodulated_sin_F = fftshift(demodulated_sin_F);

demodulated_cos_F = fft(demodulated_cos_filtered)/length(demodulated_cos_filtered);
demodulated_cos_F = fftshift(demodulated_cos_F);

% Plotting the demodulated signals
figure(4)
subplot(221)
plot(t, demodulated_cos_filtered, 'r')
xlim([(duration*0.3) (duration*0.7)])
title('Modulating Signal (Cosine Carrier) Demodulated (Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(223)
plot(t, demodulated_sin_filtered, 'k')
xlim([(duration*0.3) (duration*0.7)])
title('Modulating Signal (Sine Carrier) Demodulated Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(222)
plot(f,abs(demodulated_cos_F), 'r')
title('Modulating Signal (Cosine Carrier) Demodulated (Frequency domain)')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(224)
plot(f,abs(demodulated_sin_F), 'k')
title('Modulating Signal (Sine Carrier) Demodulated (Frequency domain)')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

% Comparing transmitted signal with received signal:
figure(4)
subplot(221)
plot(t, demodulated_cos_filtered, 'r')
xlim([(duration*0.3) (duration*0.7)])
title('Modulating Signal (Cosine Carrier) Demodulated (Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(223)
plot(t, demodulated_sin_filtered, 'k')
xlim([(duration*0.3) (duration*0.7)])
title('Modulating Signal (Sine Carrier) Demodulated Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(222)
plot(t,signal_cos,'r')
xlim([(duration*0.3) (duration*0.7)])
title('Carrier Cosine Modulating Signal (Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(224)
plot(t,signal_sin,'k')
xlim([(duration*0.3) (duration*0.7)])
title('Carrier Sine Modulating Signal (Time domain)')
xlabel('Time (s)')
ylabel('Amplitude')

% Calculating/Plotting the spectral density of the modulated signal:
figure(7)
subplot(221)
plot(pwelch(signal_cos), 'r', 'LineWidth', 3);
xlim([0 200])
title('Spectral Density of the Modulating Signal (Carrier Cosine)')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
xlim([0 100])

subplot(222)
plot(pwelch(signal_sin), 'k', 'LineWidth', 3);
xlim([0 200])
title('Spectral Density of the Modulating Signal (Carrier Sine)')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
xlim([0 100])

subplot(2, 2, [3 4])
plot(pwelch(multiplexed_signal), 'b', 'LineWidth', 3);
xlim([0 100])
title('Spectral Density of the Multiplexed Signal')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
