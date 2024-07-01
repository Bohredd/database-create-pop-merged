USE banco_merged;

-- atleta + atletas
INSERT INTO banco_merged.Atleta (nome, sexo)
SELECT nome, sexo FROM banco_deles.Atletas
UNION SELECT nome, sexo FROM banco_nosso.Atleta;

-- time/noc + times
INSERT INTO banco_merged.Time (nome, noc) 
SELECT nome, noc FROM banco_deles.Times UNION 
SELECT Regiao, Anotacao FROM banco_nosso.NOC;

-- tipomedalha/medalha
INSERT INTO banco_merged.Medalha (nome) SELECT nome FROM banco_nosso.TipoMedalha;

-- ano
INSERT INTO banco_merged.Ano (ano) SELECT ano FROM banco_nosso.Ano;

-- esporte + esportes
INSERT INTO banco_merged.Esporte (nome) 
SELECT nome FROM banco_nosso.Esporte UNION 
SELECT nome FROM banco_deles.Esportes;

SELECT * FROM banco_merged.Esporte;

-- modalidade + evento
INSERT INTO banco_merged.Modalidade (nome, esporteId)
SELECT nome, esporte_id 
FROM banco_deles.Modalidades
UNION
SELECT '', Evento.EsporteId
FROM banco_nosso.Evento
LEFT JOIN banco_merged.Esporte ON Evento.EsporteId = banco_merged.Esporte.id
WHERE banco_merged.Esporte.nome IS NULL OR banco_merged.Esporte.nome = '';

-- temporada
INSERT INTO banco_merged.Temporada (descricao) 
SELECT descricao FROM banco_nosso.Temporada UNION
SELECT estacao FROM banco_deles.Olimpiadas;

-- cidade sede
INSERT INTO banco_merged.CidadeSede (cidade) 
SELECT cidade FROM banco_deles.Olimpiadas;

-- jogos + olimpiadas
-- precisa arrumar esse
INSERT INTO banco_merged.Olimpiada (jogos, anoId, temporadaId, cidadeId)

SELECT CONCAT(A.ano, ' ', T.descricao) as jogo, A.id as ano, T.id as temporada , C.id as cidade
FROM banco_merged.Ano A CROSS JOIN banco_merged.Temporada T
CROSS JOIN banco_merged.CidadeSede C
UNION
SELECT 
    O.jogos, 
    O.ano, 
    O.estacao,
    O.id
FROM 
    banco_deles.Olimpiadas O
JOIN 
    banco_merged.Ano A ON O.ano = A.ano
JOIN 
    banco_merged.Temporada T ON O.estacao = T.descricao
JOIN 
    banco_merged.CidadeSede C ON O.cidade = C.cidade;

-- participacao + participacao
-- fazer esse