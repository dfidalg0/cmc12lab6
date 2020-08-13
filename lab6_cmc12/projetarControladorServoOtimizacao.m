function controlador = projetarControladorServoOtimizacao(requisitos, planta)
% controlador = projetarControladorServoOtimizacao(requisitos, planta)
% um sistema de controle discreto completo para o servomotor de posicao.
% A struct requisitos eh:
% requisitos.posicao.wb: requisito de banda passante da malha de posicao.
% requisitos.posicao.GM: requisito de margem de ganho da malha de posicao.
% requisitos.posicao.PM: requisito de margem de fase da malha de posicao.
% requisitos.posicao.fs: taxa de amostragem da malha de posicao.
% requisitos.corrente.wb: requisito de banda passante da malha de corrente.
% requisitos.corrente.GM: requisito de margem de ganho da malha de corrente.
% requisitos.corrente.PM: requisito de margem de fase da malha de corrente.
% requisitos.corrente.fs: taxa de amostragem da malha de corrente.
% A struct planta contem os parametros da planta e pode ser obtida atraves
% de planta = obterPlantaServoPosicao().
% A saida da funcao eh a struct controlador:
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

controlador.corrente = projetarControladorCorrenteOtimizacao(requisitos.corrente,...
    planta);

controlador.posicao = projetarControladorPosicaoOtimizacao(requisitos.posicao,...
    controlador.corrente, planta);

controlador.corrente.ftd = discretizarControladorCorrente(controlador.corrente);

controlador.posicao.ftd = discretizarControladorPosicao(controlador.posicao);

save('controlador.mat');

end