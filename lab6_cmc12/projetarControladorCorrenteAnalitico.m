function controlador = projetarControladorCorrenteAnalitico(requisitos, planta)
% controlador = projetarControladorCorrenteAnalitico(requisitos, planta)
% projeta o controlador de corrente atraves de um metodo analitico. A
% struct requisitos eh:
wb = requisitos.wb;
GM = requisitos.GM;
PMmin = requisitos.PM;
fs = requisitos.fs;
% A struct planta contem os parametros da planta e pode ser obtida atraves
% de planta = obterPlantaServoPosicao().
% A saida da funcao eh a struct controlador:
% controlador.K: ganho proporcional do controlador de corrente.
% controlador.alpha: parametro alpha da compensacao lead.
% controlador.Tl: parametro Tl da compensacao lead.
% controlador.T: periodo de amostragem do controlador de corrente.

controlador.T = 1.0 / requisitos.fs;

% Implementar

L = planta.L;
R = planta.R;

G = tf(1,[L R 0]);

K = roots([1 2*L*wb^2 -L^2*wb^4-R^2*wb^2]);
if K(1)>0
    controlador.K = K(1);
else
    controlador.K = K(2);
end

w = roots([L^2 R^2 -controlador.K^2]);
if w(1)>0
    wcp = sqrt(w(1));
else
    wcp = sqrt(w(2));
end

PM = angle(evalfr(controlador.K*G,1j*wcp))*180/pi + 180;

phi = PMmin - PM;

controlador.alpha = (1 - sind(phi))/(1 + sind(phi));
controlador.Tl = 1/wcp/sqrt(controlador.alpha);

end