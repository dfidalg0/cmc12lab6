function [Kp, Ki] = projetarControladorPIMotor(requisitos, planta)
% [Kp, Ki] projeta um controlador PI para um motor eletrico.
% A struct requisitos eh dada por:
% requisitos.wb: requisito de banda passante.
% requisitos.Mr: requisito de pico de ressonancia (em dB).
% A struct planta tem os seguintes parametros:
% planta.J: inercia.
% planta.b: constante de atrito viscoso.
% planta.Kt: constante de torque.
% planta.R: resistencia.
% planta.L: indutancia.
% As saidas sao:
% Kp: ganho proporcional do controlador.
% Ki: ganho integrativo do controlador.

%% Coletando parametros

J = planta.J;
b = planta.b;
Kt = planta.Kt;
R = planta.R;

%% Convertendo os requisitos para wn e xi

wbReq = requisitos.wb;
MrReq = requisitos.Mr;
MrReq = 10^(MrReq/20); % pois MrReq esta em dB

xiReq = sqrt((1 / 2) * (1 - sqrt(MrReq^2 - 1) / MrReq));
wnReq = wbReq / sqrt(1 - 2 * xiReq^2 + sqrt(2 - 4 * xiReq^2 + 4 * xiReq^4));

%% Resolvendo problema simplificado (chute inicial)

Kp0 = (2 * xiReq * wnReq * J * R - R * b - Kt^2) / Kt;
Ki0 = J * R * wnReq^2 / Kt;

x0 = [Kp0, Ki0];

%% Resolvendo problema de otimizacao

opcoes = optimset('Display', 'iter'); % para imprimir informacoes da iteracao

J = @(x) funcaoCusto(requisitos, planta, x);
% x0 = [40; 40];
xOtimo = fminsearch(J, x0, opcoes);
Kp = xOtimo(1);
Ki = xOtimo(2);

end

function J = funcaoCusto(requisitos, planta, parametros)
% J = funcaoCusto(requisitos, planta, parametros) calcula o custo associado
% a um vetor de parametros [Kp; Ki]. A struct requisitos eh dada por:
% requisitos.wb: requisito de banda passante.
% requisitos.Mr: requisito de pico de ressonancia (em dB).
% A struct planta tem os seguintes parametros:
% planta.J: inercia.
% planta.b: constante de atrito viscoso.
% planta.Kt: constante de torque.
% planta.R: resistencia.
% planta.L: indutancia.

%% Coletando parametros

Kp = parametros(1);
Ki = parametros(2);

J = planta.J;
b = planta.b;
Kt = planta.Kt;
R = planta.R;
L = planta.L;

wbReq = requisitos.wb;
MrReq = requisitos.Mr;

%% Definindo funcao de transferencia de malha fechada

s = tf('s');

Gf = (Kp * Kt * s + Ki * Kt) / (J * L * s^3 + (J * R + L * b) * s^2 + (R * b + Kt^2 + Kp * Kt) * s + Ki * Kt);

w = 1e-2:1e-2:1000;

mag = bode(Gf, w);
mag = mag(:);
magdB = 20 * log10(mag);

wb = interp1(magdB, w, -3);
Mr = 20 * log10(max(mag));

J = (wbReq - wb)^2 + (MrReq - Mr)^2;

end