function avaliarQuantizacao(controlador, planta)
% avaliarMalhaPosicao(controlador, planta) avalia o efeito da quantizacao 
% do encoder no servomotor de posicao. A struct controlador eh dada por:
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

%% Realizando simulacoes

tf = 0.5;

thetar.time = [0; tf];
thetar.signals.values = [1; 1];
thetar.signals.dimensions = 1;

vetorBitsEncoder = [4, 6, 8, 10];

outs = cell(1, length(vetorBitsEncoder));
for i=1:length(vetorBitsEncoder)
    planta.quantizacaoEncoder = 2 * pi / 2^vetorBitsEncoder(i);
    
    % Configurando as variaveis usadas no Simulink
    assignin('base', 'tf', tf);
    assignin('base', 'thetar', thetar);
    assignin('base', 'controlador', controlador);
    assignin('base', 'planta', planta);

    outs{i} = sim('servomotor_posicao');
end

%% Tracando graficos

figure;
hold on;
legs = cell(1, length(vetorBitsEncoder));
for i=1:length(vetorBitsEncoder)
    out = outs{i};
    plot(out.thetal.time, out.thetal.signals.values, 'LineWidth', 2);
    legs{i} = sprintf('%d bits', vetorBitsEncoder(i));
end
legend(legs, 'FontSize', 14, 'location', 'southeast');
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('\theta_l (rad)', 'FontSize', 14);
set(gca, 'FontSize', 14);
grid on;
print -dpng -r400 quantizacao_thetal.png % para usuarios de Word
% print -depsc2 quantizacao_thetal.eps % para usuarios de LaTeX

figure;
hold on;
legs = cell(1, length(vetorBitsEncoder));
for i=1:length(vetorBitsEncoder)
    out = outs{i};
    plot(out.thetam.time, out.thetam.signals.values, 'LineWidth', 2);
    legs{i} = sprintf('%d bits', vetorBitsEncoder(i));
end
legend(legs, 'FontSize', 14, 'location', 'southeast');
xlabel('Tempo (s)', 'FontSize', 14);
ylabel('\theta_m (rad)', 'FontSize', 14);
set(gca, 'FontSize', 14);
grid on;
print -dpng -r400 quantizacao_thetam.png % para usuarios de Word
% print -depsc2 quantizacao_thetam.eps % para usuarios de LaTeX

end