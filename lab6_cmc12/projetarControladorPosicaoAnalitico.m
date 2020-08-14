function controlador = projetarControladorPosicaoAnalitico(requisitos, planta)
% controlador = projetarControladorPosicaoAnalitico(requisitos, planta)
% projeta o controlador de posicao atraves de um metodo analitico. A
% struct requisitos eh:
% requisitos.wb: requisito de banda passante.
% requisitos.GM: requisito de margem de ganho.
% requisitos.PM: requisito de margem de fase.
% requisitos.fs: requisito de taxa de amostragem.
% A struct planta contem os parametros da planta e pode ser obtida atraves
% de planta = obterPlantaServoPosicao().
% A saida da funcao eh a struct controlador:
% controlador.Kp: ganho proporcional do controlador de posicao.
% controlador.Kd: ganho derivativo do controlador de posicao.
% controlador.a: frequencia de corte do filtro do termo derivativo.
% controlador.T: periodo de amostragem do controlador de posicao.

controlador.T = 1.0 / requisitos.fs;

xi = requisitos.PM/100;

wn = requisitos.wb/(sqrt(1 - 2*xi^2 + sqrt(4*xi^4 - 4*xi^2 + 2)));

controlador.Kp = wn^2 * planta.Jeq/planta.Kt/planta.N/planta.eta;

controlador.Kd = (2*xi*wn * planta.Jeq - planta.Beq)/planta.Kt/planta.N/planta.eta;

controlador.a = 10 * requisitos.wb;

end