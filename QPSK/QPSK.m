close all; clear all; clc;
pkg load communications;

% Changes the font size in the plots to 15
set(0, 'DefaultAxesFontSize', 20);

% Defining the base signal amplitude.
A_signal = 1;

% Defining the frequency for the base signal 
f_signal = 8000;

% Defining the period and frequency of sampling:
fs = 40 * f_signal;
Ts = 1 / fs;
T = 1/ f_signal;

% Defining the signal period.
t_initial = 0;
t_final = 0.01;

% "t" vector, corresponding to the time period of analysis, in time domain.
t = t_initial:Ts:t_final;

signal = A_signal * cos(2 * pi * f_signal * t);

% Creating an impulse train with period 2T
impulse_train = zeros(size(t));
impulse_train(mod(t, 1 / fs) == 0) = 1;

signal_sampled = signal .* impulse_train;

% Desired number of levels (excluding 0)
n = 2;
num_levels = 2 ^ n;

levels = 2 / num_levels;

quantized_signal = round((signal_sampled + 1) / levels);

% Ensures that quantized_signal values are between 0 and num_levels - 1
quantized_signal = min(quantized_signal, num_levels - 1);

% Converting integer quantized values to binary
binary_signal = de2bi(quantized_signal, n);

% Concatenating the binary values into a single vector
bits = reshape(binary_signal.', 1, []);
t_bits = linspace(0, 1, length(bits));

f_carrier = 50000;
A_carrier = 1;
Tc = 1/f_carrier;
Ts = Tc / 10;

numBits = length(bits);
symbols = 2*bits - 1;

% Tempo total da simulação
tempoTotal = numBits * Tc;

% Tempo de amostragem com superamostragem
superamostragem = 200;
tempoSuperamostrado = 0:Ts/superamostragem:tempoTotal;

% Modulação QPSK
symbols_I = symbols(1:2:end);
symbols_Q = symbols(2:2:end);
sinalModulado_I = sqrt(2/Tc) * symbols_I .* cos(2*pi*f_carrier*tempoSuperamostrado(1:length(symbols_I)));
sinalModulado_Q = sqrt(2/Tc) * symbols_Q .* sin(2*pi*f_carrier*tempoSuperamostrado(1:length(symbols_Q)));
sinalModulado = sinalModulado_I + sinalModulado_Q;

% Filtro para complementar os pontos
filtro = ones(1, superamostragem) / superamostragem;
sinalModuladoFiltrado = conv(sinalModulado, filtro, 'same');

% Plot do sinal modulado no domínio do tempo
figure;
subplot(311)
stem(t, quantized_signal, 'LineStyle', 'none', 'MarkerFaceColor', 'b')
hold on; 
plot(t, signal * n + A_signal, 'r')
xlim([0 2 * T])
grid on;
title('Sampled and Quantized Sine Wave Signal - Time Domain')

subplot(312)
stem(t_bits, bits);
xlim([0 300 * T])
title('Bit Array - Time Domain')

subplot(313)
plot(tempoSuperamostrado(1:length(sinalModuladoFiltrado)), sinalModuladoFiltrado);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Sinal Modulado QPSK no Domínio do Tempo');
xlim([0 Tc])
grid on;

