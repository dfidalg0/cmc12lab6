function ftd = discretizarControladorPosicao(controlador)
% ftd = discretizarControladorPosicao(controlador) discretiza o controlador
% de posicao. A struct controlador eh dada por:
% controlador.Kp: ganho proporcional do controlador de posicao.
% controlador.Kd: ganho derivativo do controlador de posicao.
% controlador.a: frequencia de corte do filtro do termo derivativo.
% controlador.T: periodo de amostragem do controlador de posicao.
% A saida ftd eh a funcao de transferencia discreta (no dominio z) do
% controlador de posicao.

Kp = controlador.Kp;
Kd = controlador.Kd;
T = controlador.T;
a = controlador.a;

% Implementar
s = tf('s');
Cp = Kp + Kd*s*a/(s+a);
ftd = c2d(Cp,T,'Tustin');
end