close all; clear all; clc;
pkg load signal;
pkg load communications;

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
n=5;
num_levels = 2^n;

% Gerando os níveis de quantização automaticamente
levels = linspace(-1, 1, num_levels);

% Verifica se o vetor possui algum elemento com "0"
for i = 1:length(levels)
    if levels(i) == 0
        levels(i) = [];
        break; 
    end
end


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

% Desloca o vetor quantizado para 0 ou mais
min_value = min(quantized_signal);
quantized_signal = quantized_signal - min_value;

figure;
stem(t, quantized_signal, 'LineStyle', 'none', 'MarkerFaceColor', 'b');
grid on;
title('Sinal Quantizado Deslocado (Domínio do Tempo)');
xlabel('Tempo (s)');
xlim([0 3*T])
ylabel('Amplitude');

% Multiplica os valores quantizados para que sejam números inteiros
num_intervals = num_levels - 1; % Número de intervalos entre os níveis
quantized_signal_int = quantized_signal * num_intervals;

% Convertendo valores quantizados inteiros para binário
binary_signal = de2bi(quantized_signal_int, n);

% Concatenando os valores binários em um único vetor
binary_signal_concatenated = reshape(binary_signal.', 1, []);

% Vetor de tempo
t = linspace(0, 1, length(binary_signal_concatenated) * 2);

% Mapeamento dos valores binários para amplitudes
amplitudes = [-5, 5];
mapped_signal = amplitudes(binary_signal_concatenated + 1);

% Repetindo cada valor do sinal
repeated_signal = reshape(repmat(mapped_signal, 2, 1), 1, []);

% Plotando o sinal
plot(t, repeated_signal, 'LineWidth', 2);
ylim([-6, 6]); % Definindo o limite do eixo y
xlabel('Tempo');
xlim([0 10*T])
ylabel('Amplitude');
title('Sinal Binário como Onda Quadrada');
grid on;

