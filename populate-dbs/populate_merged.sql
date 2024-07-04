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
INSERT INTO banco_merged.Olimpiada (jogos, anoId, temporadaId, cidadeId)
SELECT CONCAT(A.ano, ' ', T.descricao) as jogo, A.id as ano, T.id as temporada , C.id as cidade
FROM banco_merged.Ano A 
CROSS JOIN banco_merged.Temporada T
CROSS JOIN banco_merged.CidadeSede C
UNION
SELECT 
    O.jogos, 
    A.id as anoId, 
    T.id as temporadaId, 
    C.id as cidadeId
FROM 
    banco_deles.Olimpiadas O
JOIN 
    banco_merged.Ano A ON O.ano = A.ano
JOIN 
    banco_merged.Temporada T ON O.estacao = T.descricao
JOIN 
    banco_merged.CidadeSede C ON O.cidade = C.cidade;


-- participacao + participacao

INSERT INTO banco_merged.Participacao (id, atletaId, timeId, olimpiadad, modalidaded, medalhad, idade, altura, peso)

SELECT
    id,
    atleta_id,
    time_id,
    olimpiada_id,
    modalidade_id,
    medalha_id,
    idade,
    altura,
    peso
FROM (
    SELECT
        P.Id AS id,
        P.AtletaId AS atleta_id,
        P.TimeId AS time_id,
        P.JogosId AS olimpiada_id,
        P.EsporteId AS modalidade_id,
        M.id AS medalha_id,
        A.idade,
        A.altura,
        A.peso
    FROM banco_nosso.Participacao P
    JOIN banco_nosso.Atleta A ON P.AtletaId = A.Id
    LEFT JOIN banco_merged.Medalha M ON P.MedalhaId = M.id) AS ParticipacaoMesclada;
    UNION
    
    SELECT
        P.id,
        P.atleta_id,
        P.time_id,
        P.olimpiada_id,
        P.modalidade_id,
        (SELECT id FROM banco_merged.Medalha WHERE nome = COALESCE(P.medalha, "Nenhuma", NULL)) AS medalha_id,
        A.idade,
        A.altura,
        A.peso
    FROM banco_deles.Participacao P
    LEFT JOIN banco_nosso.Atleta A ON P.atleta_id = A.Id
) AS ParticipacaoMesclada;

