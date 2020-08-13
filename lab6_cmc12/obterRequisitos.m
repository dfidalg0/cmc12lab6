function requisitos = obterRequisitos()
% requistos = obterRequisitos() obtem os requisitos das malhas de posicao e
% de corrente do servomotor de posicao.

requisitos.posicao.wb = 2 * pi * 10;
requisitos.posicao.GM = 11;
requisitos.posicao.PM = 60;
requisitos.posicao.fs = 1000;

requisitos.corrente.wb = 2 * pi * 1000;
requisitos.corrente.GM = 11;
requisitos.corrente.PM = 60;
requisitos.corrente.fs = 20 * 10^3;

end