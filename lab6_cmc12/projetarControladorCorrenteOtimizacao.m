function controlador = projetarControladorCorrenteOtimizacao(requisitos, planta)
% controlador = projetarControladorCorrenteOtimizacao(requisitos, planta)
% projeta o controlador de corrente atraves de otimizacao. A
% struct requisitos eh:
% requisitos.wb: requisito de banda passante.
% requisitos.GM: requisito de margem de ganho.
% requisitos.PM: requisito de margem de fase.
% requisitos.fs: requisito de taxa de amostragem.
% A struct planta contem os parametros da planta e pode ser obtida atraves
% de planta = obterPlantaServoPosicao().
% A saida da funcao eh a struct controlador:
% controlador.K: ganho proporcional do controlador de corrente.
% controlador.alpha: parametro alpha da compensacao lead.
% controlador.Tl: parametro Tl da compensacao lead.
% controlador.T: periodo de amostragem do controlador de corrente.

controlador = projetarControladorCorrenteAnalitico( ...
    requisitos, planta ...
);

J = @(x) custoControladorCorrente(requisitos, planta, x);

p0 = [controlador.K, controlador.alpha, controlador.Tl];

popt = fminsearch(J, p0);

controlador.K = popt(1);
controlador.alpha = popt(2);
controlador.Tl = popt(3);

end

function J = custoControladorCorrente(requisitos, planta, parametros)
% J = custoControladorCorrente(requisitos, planta, parametros)
% calcula o custo do controlador de corrente J(K, alpha, Tl) para guiar o
% processo de otimizacao. A struct requisitos eh:
% requisitos.wb: requisito de banda passante.
% requisitos.GM: requisito de margem de ganho.
% requisitos.PM: requisito de margem de fase.
% requisitos.fs: requisito de taxa de amostragem.
% A struct planta contem os parametros da planta e pode ser obtida atraves
% de planta = obterPlantaServoPosicao().
% O vetor parametros eh dado por [K; alpha; Tl].

controlador.K = parametros(1);
controlador.alpha = parametros(2);
controlador.Tl = parametros(3);
controlador.T = 1.0 / requisitos.fs;

[Ga, Gf] = obterMalhaCorrente(controlador, planta);

wb = bandwidth(Gf);
[~, PM] = margin(Ga);

J = (wb - requisitos.wb)^2 + (PM - requisitos.PM)^2;

end