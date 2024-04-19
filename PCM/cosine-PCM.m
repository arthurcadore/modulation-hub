close all; clear all; clc;
pkg load signal;

% Altera o tamanho da fonte nos plots para 15
set(0, 'DefaultAxesFontSize', 20);

% Defining the base signal amplitude.
A_signal = 1;

% Defining the frequency for the base signal 
f_signal = 80000;

% Defining the period and frequency of sampling:
fs = 40*f_signal;
Ts = 1/fs;
T = 1/f_signal;

% Defining the sinal period.
t_inicial = 0;
t_final = 0.01;

% "t" vector, correspondig to the time period of analysis, on time domain.
t = [t_inicial:Ts:t_final];

signal = A_signal*cos(2*pi*f_signal*t);

% Criando um trem de impulsos com período de 2T
impulse_train = zeros(size(t));
impulse_train(mod(t, 1/fs) == 0) = 1;

signal_sampled = signal .* impulse_train;

% Quantidade de níveis desejada (tirando o 0)
n=2;
num_levels = 2^n;

% Gerando os níveis de quantização automaticamente
levels = linspace(-1, 1, num_levels+1);
levels = levels(2:end); % Remove o primeiro elemento (zero)

% Quantização
quantized_signal = zeros(size(signal_sampled));
for i = 1:length(signal_sampled)
    for j = 1:length(levels)
        if signal_sampled(i) <= levels(j)
            quantized_signal(i) = levels(j);
            break;
        end
    end
end

figure(1)
subplot(411)
plot(t,signal)
grid on;
xlim([0 3*T])
title('Sinal Senoidal (Dominio do tempo)')

subplot(412)
stem(t,impulse_train, 'MarkerFaceColor', 'b')
grid on;
xlim([0 3*T])
title('Trem de impulsos (Dominio do tempo)')

subplot(413)
stem(t,signal_sampled, 'LineStyle','none', 'MarkerFaceColor', 'b')
grid on;
xlim([0 3*T])
title('Sinal Senoidal Amostrado (Dominio do tempo)')

subplot(414)
stem(t,quantized_signal, 'LineStyle','none', 'MarkerFaceColor', 'b')
xlim([0 3*T])
hold on; 
plot(t,signal, 'r')
xlim([0 3*T])
grid on;
title('Sinal Senoidal Amostrado e Quantizado (Dominio do tempo)')

% convertendo valores quantizados para binário: 
binary_signal = dec2bin((quantized_signal + 1) * (2^(n-1)), n)