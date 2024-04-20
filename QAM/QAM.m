close all; clear all; clc; 
pkg load signal;

% Number of bits to transmit
N = 512; 

% QAM modulation level
QAM_level = 16; 

% SNR step (for annimation)
snr_step=1; 

% Min/Max SNR values
snr_mim=0;
snr_lim=50;

% QAM modulation level
tx_bits = randi([0 1], N, 1);

% Calculate bits per symbol
bits_per_symbol = log2(QAM_level); 

% Convert bits to symbols
xsym = bi2de(reshape(tx_bits, bits_per_symbol, length(tx_bits)/bits_per_symbol).', 'left-msb'); 

% Modulate symbols to QAM signal
Tx_x = qammod(xsym, QAM_level);

% Create a new figure window
figure(1); 
for SNR = snr_mim:snr_step/2:snr_lim % Iterate over SNR values
  
    % Add AWGN (Additive White Gaussian Noise) to the transmitted signal
    % This noise is added to simulate a real communication channel
    Rx_x = awgn(Tx_x, SNR); 

    % Plot transmitted QAM signal
    subplot(1,2,1); 
    plot(real(Tx_x), imag(Tx_x), 'kx', 'MarkerFaceColor', 'r', 'LineWidth', 2);
    grid on;
    axis([-QAM_level/2 QAM_level/2 -QAM_level/2 QAM_level/2]);
    title(sprintf('Transmitted QAM with %d levels', QAM_level));

    % Draw lines to divide the QAM signal area into squares
    hold on;
    for i = -QAM_level/2+2:2:QAM_level/2-2
        plot([-QAM_level/4, QAM_level/4], [i, i], 'b', 'LineWidth', 2); 
        plot([i, i], [-QAM_level/4, QAM_level/4], 'b', 'LineWidth', 2);
    end
    hold off;

    subplot(1,2,2); 
    plot(real(Rx_x), imag(Rx_x), 'ro', 'MarkerFaceColor', 'r');
    grid on;
    axis([-QAM_level/2 QAM_level/2 -QAM_level/2 QAM_level/2]);
    title(sprintf('Received QAM, SNR = %d dB', SNR));
    hold on;
        plot(real(Tx_x), imag(Tx_x), 'kx', 'MarkerFaceColor', 'r', 'LineWidth', 2);
    hold off;

    % Draw lines to divide the received QAM signal area into squares
    hold on;
    for i = -QAM_level/2+2:2:QAM_level/2-2
        plot([-QAM_level/4, QAM_level/4], [i, i], 'b', 'LineWidth', 2); 
        plot([i, i], [-QAM_level/4, QAM_level/4], 'b', 'LineWidth', 2);
    end
    hold off;

    pause(1); % Pause for 1 second
end
