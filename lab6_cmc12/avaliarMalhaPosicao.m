function avaliarMalhaPosicao(controladorPosicao, controladorCorrente, planta)
% avaliarMalhaPosicao(controladorPosicao, controladorCorrente, planta)
% avalia a malha de posicao para verificar atendimento aos requisitos.
% A struct controladorPosicao eh dada por:
% controladorPosicao.Kp: ganho proporcional do controlador de posicao.
% controladorPosicao.Kd: ganho derivativo do controlador de posicao.
% controladorPosicao.a: frequencia de corte do filtro do termo derivativo.
% controladorPosicao.T: periodo de amostragem do controlador de posicao.
% A struct controladorCorrente eh dada por:
% controladorCorrente.K: ganho proporcional do controlador de corrente.
% controladorCorrente.alpha: parametro alpha da compensacao lead.
% controladorCorrente.Tl: parametro Tl da compensacao lead.
% controladorCorrente.T: tempo de amostragem do controlador de corrente.
% A struct planta contem os parametros da planta e pode ser obtida atraves
% de planta = obterPlantaServoPosicao().

[Ga, Gf] = obterMalhaPosicao(controladorPosicao, controladorCorrente, planta);

%% Tracando graficos

figure;
step(Gf);
grid on;
print -dpng -r400 posicao_degrau.png % para usuarios de Word
% print -depsc2 posicao_degrau.eps % para usuarios de LaTeX

figure;
bode(Gf);
title(sprintf('Bode Diagram\nBandwidth = %g rad/s', bandwidth(Gf)));
grid on;
print -dpng -r400 posicao_Gf.png % para usuarios de Word
% print -depsc2 posicao_Gf.eps % para usuarios de LaTeX

figure;
margin(Ga);
grid on;
print -dpng -r400 posicao_Ga.png % para usuarios de Word
% print -depsc2 posicao_Ga.eps % para usuarios de LaTeX

end