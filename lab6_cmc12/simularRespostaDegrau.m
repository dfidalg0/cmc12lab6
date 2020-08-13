function simularRespostaDegrau(controlador, planta)
% simularRespostaDegrau(controlador, planta) simula a resposta ao degrau
% unitario do servomotor de posicao. A struct controlador eh dada por:
% controlador.posicao.Kp: ganho proporcional do controlador de posicao.
% controlador.posicao.Kd: ganho derivativo do controlador de posicao.
% controlador.posicao.a: frequencia de corte do filtro do termo derivativo.
% controlador.posicao.T: periodo de amostragem do controlador de posicao.
% controlador.posicao.ftd: funcao de transferencia discreta do controlador
%                          de posicao.
% controlador.corrente.K: ganho proporcional do controlador de corrente.
% controlador.corrente.alpha: parametro alpha da compensacao lead.
% controlador.corrente.Tl: parametro Tl da compensacao lead.
% controlador.corrente.T: tempo de amostragem do controlador de corrente.
% controlador.corrente.ftd: funcao de transferencia discreta do controlador
%                          de corrente.
% A struct planta contem os parametros da planta e pode ser obtida atraves
% de planta = obterPlantaServoPosicao().

tf = 0.5;

thetar.time = [0; tf];
thetar.signals.values = [1; 1];
thetar.signals.dimensions = 1;

% Configurando as variaveis usadas no Simulink
assignin('base', 'tf', tf);
assignin('base', 'thetar', thetar);
assignin('base', 'controlador', controlador);
assignin('base', 'planta', planta);

out = sim('servomotor_posicao');

figure;
plot(out.thetal.time, out.thetal.signals.values, 'LineWidth', 2);
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('\theta_l (rad)', 'FontSize', 14);
set(gca, 'FontSize', 14);
grid on;
print -dpng -r400 degrau_thetal.png % para usuarios de Word
% print -depsc2 degrau_thetal.eps % para usuarios de LaTeX

figure;
plot(out.thetam.time, out.thetam.signals.values, 'LineWidth', 2);
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('\theta_m (rad)', 'FontSize', 14);
set(gca, 'FontSize', 14);
grid on;
print -dpng -r400 degrau_thetam.png % para usuarios de Word
% print -depsc2 degrau_thetam.eps % para usuarios de LaTeX

figure;
plot(out.wl.time, out.wl.signals.values, 'LineWidth', 2);
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('\omega_l (rad/s)', 'FontSize', 14);
set(gca, 'FontSize', 14);
grid on;
print -dpng -r400 degrau_wl.png % para usuarios de Word
% print -depsc2 degrau_wl.eps % para usuarios de LaTeX

figure;
plot(out.ic.time, out.ic.signals.values, 'LineWidth', 2);
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('i_c (A)', 'FontSize', 14);
set(gca, 'FontSize', 14);
grid on;
print -dpng -r400 degrau_ic.png % para usuarios de Word
% print -depsc2 degrau_ic.eps % para usuarios de LaTeX

figure;
plot(out.i.time, out.i.signals.values, 'LineWidth', 2);
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('i (A)', 'FontSize', 14);
set(gca, 'FontSize', 14);
grid on;
print -dpng -r400 degrau_i.png % para usuarios de Word
% print -depsc2 degrau_i.eps % para usuarios de LaTeX

figure;
plot(out.Vc.time, out.Vc.signals.values, 'LineWidth', 2);
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('V_c (V)', 'FontSize', 14);
set(gca, 'FontSize', 14);
grid on;
print -dpng -r400 degrau_Vc.png % para usuarios de Word
% print -depsc2 degrau_Vc.eps % para usuarios de LaTeX

figure;
plot(out.V.time, out.V.signals.values, 'LineWidth', 2);
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('V (V)', 'FontSize', 14);
set(gca, 'FontSize', 14);
grid on;
print -dpng -r400 degrau_V.png % para usuarios de Word
% print -depsc2 degrau_V.eps % para usuarios de LaTeX

end