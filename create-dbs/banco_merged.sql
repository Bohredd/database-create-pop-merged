CREATE DATABASE banco_merged;

USE banco_merged;

-- atleta + atletas
CREATE TABLE Atleta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    sexo VARCHAR(10)
);

-- time/noc + times
CREATE TABLE Time (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    noc VARCHAR(10)
);

-- tipomedalha/medalha
CREATE TABLE Medalha (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255)
);  

-- ano
CREATE TABLE Ano (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ano INT
);

-- esporte + esportes
CREATE TABLE Esporte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255)
);

-- modalidade + evento
CREATE TABLE Modalidade (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    esporteId INT,
    FOREIGN KEY (esporteId) REFERENCES Esporte(id)
);

CREATE TABLE Temporada (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255)
);

CREATE TABLE CidadeSede (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cidade VARCHAR(255)
);

-- jogos + olimpiadas
CREATE TABLE Olimpiada (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jogos VARCHAR(255),
    anoId INT,
    temporadaId INT,
    cidadeId INT,
    FOREIGN KEY (anoId) REFERENCES Ano(id),
    FOREIGN KEY (temporadaId) REFERENCES Temporada(id),
    FOREIGN KEY (cidadeId) REFERENCES CidadeSede(id)
);

-- participacao + participacao
CREATE TABLE Participacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    atletaId INT,
    timeId INT,
    olimpiadaId INT,
    modalidadeId INT,
    medalhaId INT NULL,
    idade INT,
    altura FLOAT,
    peso FLOAT,
    FOREIGN KEY (atletaId) REFERENCES Atleta(id),
    FOREIGN KEY (timeId) REFERENCES Time(id),
    FOREIGN KEY (olimpiadaId) REFERENCES Olimpiada(id),
    FOREIGN KEY (modalidadeId) REFERENCES Modalidade(id),
    FOREIGN KEY (medalhaId) REFERENCES Medalha(id)
);