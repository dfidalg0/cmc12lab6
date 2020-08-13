function planta = obterPlantaServoPosicao()
% planta = obterPlantaServoPosicao()
% Obtem os parametros da planta do servomotor de posicao.
% Parametros do motor determinados a partir do datasheet do motor
% Maxon EC-45 30 W 200  142: 
% http://edge.rit.edu/edge/P13021/public/DDR/Maxon%20Generator%2030W.pdf

rpmParaRad = 2.0 * pi / 60.0;
tensaoNominal = 12;
iSemCarga = 146.0 * 10^-3;
omegaSemCarga = 4380.0 * rpmParaRad;
planta.Vmax = tensaoNominal;
planta.R = 1.2;
planta.L = 0.56 * 10^-3;
planta.Kt = 25.5 * 10^-3;
planta.Jm = 92.5 * 10^-3 * (10^-2)^2;
planta.Jw = 16396.23 * 10^-3 * (10^-3)^2; % por Arthur Azevedo, determinado a partir do CAD
planta.Jl = planta.Jw; % caso em que o robo nao esta em contato com o solo
planta.Bm = planta.Kt * iSemCarga / omegaSemCarga;
planta.N = 3;
% Para eta, estamos usando o valor minimo de eficiencia para engrenagens de dente reto
% de acordo com a tabela em:
% http://www.meadinfo.org/2008/11/gear-efficiency-spur-helical-bevel-worm.html
planta.eta = 0.94;
% Para Bl, estou linearizando a formula por Dani Vacarini: 2.5e-7*w^(2/3)
% Para linearizar, estou considerando uma linha que conecta w = 0 ate w =
% omegaSemCarga / planta.N (a velocidade sem carga na saida)
planta.Bl = 2.5e-7 * (omegaSemCarga / planta.N)^(-1/3);
% Jeq e Beq calculados do lado da carga
planta.Jeq = planta.N^2 * planta.eta * planta.Jm + planta.Jl;
planta.Beq = planta.N^2 * planta.eta * planta.Bm + planta.Bl;
bitsEncoder = 10;
planta.quantizacaoEncoder = 2 * pi / 2^(bitsEncoder); % quantizacao do encoder

end