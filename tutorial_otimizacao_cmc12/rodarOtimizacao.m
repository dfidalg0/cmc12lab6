%% Definindo parametros

requisitos.wb = 3;
requisitos.Mr = 0.3546;
planta.J = 0.01;
planta.b = 0.01;
planta.Kt = 0.01;
planta.R = 1;
planta.L = 0.5 * 10^-3;

%% Projetando o controlador por otimizacao

[Kp, Ki] = projetarControladorPIMotor(requisitos, planta);

%% Reconstruindo o sistema para verificacao de atendimento aos requisitos

s = tf('s');

J = planta.J;
b = planta.b;
Kt = planta.Kt;
R = planta.R;
L = planta.L;

Gf = (Kp * Kt * s + Ki * Kt) / (J * L * s^3 + (J * R + L * b) * s^2 + (R * b + Kt^2 + Kp * Kt) * s + Ki * Kt);

%% Tracando graficos

t = 0:1e-2:5;
y = step(Gf, t);
plot(t, y, 'LineWidth', 2);
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('Velocidade (rad/s)', 'FontSize', 14);
set(gca, 'Fontsize', 14)
title('Resposta ao Degrau', 'FontSize', 14);
grid on;
% print -depsc2 degrau_otimizacao.eps

figure;
w = 1e-2:1e-2:10;
mag = bode(Gf, w);
mag = mag(:);
magdB = 20 * log10(mag);
semilogx(w, magdB, 'LineWidth', 2);
wb = interp1(magdB, w, -3);
Mr = 20 * log10(max(mag));
xlabel('Frequencia (rad/s)', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontSize', 14);
title(sprintf('Diagrama de Bode\nBanda = %.2f, Pico de Res. = %.2f', wb, Mr));
set(gca, 'FontSize', 14);
grid on;
% print -depsc2 bode_otimizacao.eps