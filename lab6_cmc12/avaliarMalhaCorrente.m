function avaliarMalhaCorrente(controlador, planta)
% avaliarMalhaCorrente(controlador, planta) avalia a malha de corrente
% para verificar atendimento aos requisitos. A struct controlador eh:
% controlador.K: ganho proporcional do controlador de corrente.
% controlador.alpha: parametro alpha da compensacao lead.
% controlador.Tl: parametro Tl da compensacao lead.
% controlador.T: periodo de amostragem do controlador de corrente.
% A struct planta contem os parametros da planta e pode ser obtida atraves
% de planta = obterPlantaServoPosicao().

[Ga, Gf] = obterMalhaCorrente(controlador, planta);

%% Tracando graficos

figure;
step(Gf);
grid on;
print -depsc2 -r400 corrente_degrau.eps % para usuarios de LaTeX

figure;
bode(Gf);
title(sprintf('Bode Diagram\nBandwidth = %g rad/s', bandwidth(Gf)));
grid on;
print -depsc2 -r400 corrente_Gf.eps % para usuarios de LaTeX

figure;
margin(Ga);
grid on;
print -depsc2 -r400 corrente_Ga.eps % para usuarios de LaTeX

end