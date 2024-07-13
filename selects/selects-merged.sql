USE banco_merged;


-- quero listar todos os atletas que ganharam ao menos 2 medalhas de ouro

SELECT A.nome, COUNT(M.id) as medalhas
FROM Atleta A
JOIN Participacao P ON A.id = P.atletaId
JOIN Medalha M ON P.medalhaId = M.id
WHERE M.nome = 'Ouro'
GROUP BY A.id
HAVING COUNT(M.id) >= 2;

-- quero ver as cidades sedes onde houveram jogos de inverno

SELECT DISTINCT C.cidade
FROM CidadeSede C
INNER JOIN Olimpiada O
ON O.cidadeId = C.id
WHERE O.temporadaId = (
    SELECT id FROM Temporada temporada
    WHERE temporada.descricao = 'Winter'
);

-- quero ver as cidades sedes onde houveram jogos de verão

SELECT DISTINCT C.cidade, O.temporadaId
FROM CidadeSede C
INNER JOIN Olimpiada O
ON O.cidadeId = C.id
WHERE O.temporadaId = (
    SELECT id FROM Temporada temporada
    WHERE temporada.descricao = 'Summer'
);


-- quero ver o atleta mais velho que participou de uma olimpiada

SELECT A.nome, P.idade
FROM Atleta A
JOIN Participacao P ON A.id = P.atletaId
WHERE P.idade = (
    SELECT MAX(idade)
    FROM Participacao
);


-- quero ver o atleta mais velho que ganhou MAIS medalhas de ouro

SELECT A.nome, COUNT(M.id) as medalhas
FROM Atleta A
JOIN Participacao P ON A.id = P.atletaId
JOIN Medalha M ON P.medalhaId = M.id
WHERE M.nome = 'Ouro'
GROUP BY A.id
HAVING COUNT(M.id) = (
    SELECT MAX(medalhas)
    FROM (
        SELECT COUNT(M.id) as medalhas
        FROM Atleta A
        JOIN Participacao P ON A.id = P.atletaId
        JOIN Medalha M ON P.medalhaId = M.id
        WHERE M.nome = 'Ouro'
        GROUP BY A.id
    ) as medalhas
);

-- quero ver o atleta que mais ganhou medalhas de bronze kkkk

SELECT A.nome, COUNT(M.id) as medalhas
FROM Atleta A
JOIN Participacao P ON A.id = P.atletaId
JOIN Medalha M ON P.medalhaId = M.id
WHERE M.nome = 'Bronze'
GROUP BY A.id
HAVING COUNT(M.id) = (
    SELECT MAX(medalhas)
    FROM (
        SELECT COUNT(M.id) as medalhas
        FROM Atleta A
        JOIN Participacao P ON A.id = P.atletaId
        JOIN Medalha M ON P.medalhaId = M.id
        WHERE M.nome = 'Bronze'
        GROUP BY A.id
    ) as medalhas
) LIMIT 1; -- para ver só o primeiro


-- quero ver a temporada que mais teve olimpiadas

SELECT T.descricao, COUNT(O.id) as olimpiadas
FROM Temporada T
JOIN Olimpiada O ON T.id = O.temporadaId
GROUP BY T.id
HAVING COUNT(O.id) = (
    SELECT MAX(olimpiadas)
    FROM (
        SELECT COUNT(O.id) as olimpiadas
        FROM Temporada T
        JOIN Olimpiada O ON T.id = O.temporadaId
        GROUP BY T.id
    ) as olimpiadas
) LIMIT 1; -- para ver só o primeiro

-- quero ver o esporte que mais teve jogos nas olimpiadas

SELECT E.nome, COUNT(M.id) as medalhas
FROM Esporte E
JOIN Modalidade M ON E.id = M.esporteId
JOIN Participacao P ON M.id = P.modalidadeId
GROUP BY E.id
HAVING COUNT(M.id) = (
    SELECT MAX(medalhas)
    FROM (
        SELECT COUNT(M.id) as medalhas
        FROM Esporte E
        JOIN Modalidade M ON E.id = M.esporteId
        JOIN Participacao P ON M.id = P.modalidadeId
        GROUP BY E.id
    ) as medalhas
) LIMIT 1; -- para ver só o primeiro

-- quero ver quantos atletas participaram das olimpiadas desde 1900 até 1945

-- arrumar, resultado ta estranho
SELECT COUNT(A.id) AS Quantidade
FROM Atleta A 
JOIN Participacao P ON A.id = P.atletaId
JOIN Olimpiada O ON P.olimpiadaId = O.id
WHERE O.anoId IN (
    SELECT id
    FROM Ano
    WHERE ano BETWEEN 1900 AND 1945
);

-- quero ver quantas olimpiadas tiveram desde 1900

SELECT COUNT(O.id)
FROM Olimpiada O
WHERE O.anoId IN (
    SELECT id
    FROM Ano
    WHERE ano BETWEEN 1900 AND 2010
);

-- quuero ver quantas participacoes tiveram nas olimpiadas

SELECT COUNT(P.id)
FROM Participacao P;