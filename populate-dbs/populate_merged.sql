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

-- SELECT 
--     mA.id 
--     FROM banco_merged.Atleta mA
--     JOIN banco_deles.Atletas dA
--     ON mA.nome = dA.nome;

-- SELECT 
--     mT.id,
--     mT.nome
--     FROM banco_merged.Time mT
--     JOIN banco_deles.Times dT
--     ON dT.noc = mT.noc;

-- SELECT 
--     mO.id
--     FROM banco_merged.Olimpiada mO
--     JOIN banco_deles.Olimpiadas dO
--     ON dO.jogos = mO.jogos;

-- SELECT 
--     mM.id
--     FROM banco_merged.Modalidade mM
--     JOIN banco_deles.Modalidades dM
--     ON mM.nome = dM.nome;

-- SELECT DISTINCT
--     dParticip.idade,
--     dParticip.altura,
--     dParticip.peso
-- FROM banco_deles.Participacao dParticip
-- JOIN banco_deles.Atletas dAtleta ON dParticip.atleta_id = dAtleta.id
-- JOIN banco_merged.Atleta mA ON mA.nome = dAtleta.nome;

-- SELECT
--     CASE
--         WHEN dParticip.medalha IS NULL THEN 4
--         WHEN dParticip.medalha = 'gold' THEN 1
--         WHEN dParticip.medalha = 'silver' THEN 2
--         WHEN dParticip.medalha = 'bronze' THEN 3
--         ELSE dParticip.medalha
--     END AS medalha_convertida
-- FROM banco_deles.Participacao dParticip;

-- TRUNCATE TABLE banco_merged.Participacao;

-- participacao deles com o banco merged

INSERT INTO banco_merged.Participacao (idade, altura, peso, atletaId, timeId, olimpiadaId, modalidadeId, medalhaId)
SELECT 
    dParticip.idade,
    dParticip.altura,
    dParticip.peso,
    (
        SELECT mA.id
        FROM banco_merged.Atleta mA
        WHERE mA.nome = dAtleta.nome
        LIMIT 1
    ) AS atletaId,
    (
        SELECT mT.id
        FROM banco_merged.Time mT
        JOIN banco_deles.Times dT ON dT.noc = mT.noc
        WHERE dT.id = dParticip.time_id
        LIMIT 1
    ) AS timeId,
    (
        SELECT mO.id
        FROM banco_merged.Olimpiada mO
        JOIN banco_deles.Olimpiadas dO ON dO.jogos = mO.jogos
        WHERE dO.id = dParticip.olimpiada_id
        LIMIT 1
    ) AS olimpiadaId,
    (
        SELECT mM.id
        FROM banco_merged.Modalidade mM
        JOIN banco_deles.Modalidades dM ON dM.nome = mM.nome
        WHERE dM.id = dParticip.modalidade_id
        LIMIT 1
    ) AS modalidadeId,
    CASE
        WHEN dParticip.medalha IS NULL THEN 4
        WHEN dParticip.medalha = 'gold' THEN 1
        WHEN dParticip.medalha = 'silver' THEN 2
        WHEN dParticip.medalha = 'bronze' THEN 3
        ELSE dParticip.medalha
    END AS medalhaId
FROM banco_deles.Participacao dParticip
LEFT JOIN banco_deles.Atletas dAtleta ON dParticip.atleta_id = dAtleta.id;

-- banco nosso participacao mesclado

-- -- atleta id

-- SELECT 
--     mA.id as atletaId
--     FROM banco_nosso.Atleta nA
--     JOIN banco_merged.Atleta mA
--     ON mA.nome = nA.nome;

-- -- time id
-- SELECT DISTINCT
--     CASE 
--         WHEN nT.id = 2 THEN 1
--         ELSE nT.id
--     END AS timeId
-- FROM banco_nosso.Time nT
-- JOIN banco_nosso.NOC noc ON nT.NOCId = noc.Id;

-- -- olimpiada id 
-- SELECT DISTINCT
--     mergedOlimpiada.id
--     FROM banco_merged.Olimpiada mergedOlimpiada
--     JOIN banco_nosso.Jogos nossosJogos
--     ON mergedOlimpiada.jogos = CONCAT(
--         (SELECT ano 
--         FROM banco_nosso.Ano anoNosso 
--         WHERE nossosJogos.AnoId = anoNosso.id)
--         , ' ',
--         (SELECT descricao
--         FROM banco_nosso.Temporada temporadaNossa
--         WHERE temporadaNossa.id = nossosJogos.TemporadaId)
--     )

-- -- idade peso e altura
-- SELECT
--     nA.idade,
--     nA.altura,
--     nA.peso
--     FROM banco_nosso.Atleta nA
--     JOIN banco_merged.Atleta mA
--     ON mA.nome = nA.nome;

-- -- medalha mergeada
-- SELECT
--     MedalhaId
--     FROM banco_nosso.Participacao nossaParticip
--     JOIN banco_merged.Medalha medalhaMerged
--     ON medalhaMerged.Id = nossaParticip.MedalhaId;
    
--------------- insert usando as subconsultas

INSERT INTO banco_merged.Participacao (idade, altura, peso, atletaId, timeId, olimpiadaId, modalidadeId, medalhaId)
SELECT 
    dParticip.idade,
    dParticip.altura,
    dParticip.peso,
    (
        SELECT mA.id
        FROM banco_merged.Atleta mA
        WHERE mA.nome = dAtleta.nome
        LIMIT 1
    ) AS atletaId,
    (
        SELECT mT.id
        FROM banco_merged.Time mT
        JOIN banco_deles.Times dT ON dT.noc = mT.noc
        WHERE dT.id = dParticip.time_id
        LIMIT 1
    ) AS timeId,
    (
        SELECT mO.id
        FROM banco_merged.Olimpiada mO
        JOIN banco_deles.Olimpiadas dO ON dO.jogos = mO.jogos
        WHERE dO.id = dParticip.olimpiada_id
        LIMIT 1
    ) AS olimpiadaId,
    (
        SELECT mM.id
        FROM banco_merged.Modalidade mM
        JOIN banco_deles.Modalidades dM ON dM.nome = mM.nome
        WHERE dM.id = dParticip.modalidade_id
        LIMIT 1
    ) AS modalidadeId,
    CASE
        WHEN dParticip.medalha IS NULL THEN 4
        WHEN dParticip.medalha = 'gold' THEN 1
        WHEN dParticip.medalha = 'silver' THEN 2
        WHEN dParticip.medalha = 'bronze' THEN 3
        ELSE dParticip.medalha
    END AS medalhaId
FROM banco_deles.Participacao dParticip
LEFT JOIN banco_deles.Atletas dAtleta ON dParticip.atleta_id = dAtleta.id;
