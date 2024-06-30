CREATE DATABASE banco_nosso;
USE banco_nosso;

CREATE TABLE Atleta (
    Id INTEGER PRIMARY KEY,
    Nome VARCHAR(255),
    Idade INTEGER,
    Altura DECIMAL(5,2),
    Peso DECIMAL(5,2),
    Sexo CHAR(1)
);

CREATE TABLE Temporada (
    Id INTEGER PRIMARY KEY,
  	descricao VARCHAR(255)
);

CREATE TABLE Ano (
    Id INTEGER PRIMARY KEY,
  	ano INTEGER
);

CREATE TABLE Jogos (
    Id INTEGER PRIMARY KEY,
    TemporadaId INTEGER,
    AnoId INTEGER,
    FOREIGN KEY (TemporadaId) REFERENCES Temporada(Id),
    FOREIGN KEY (AnoId) REFERENCES Ano(Id)
);

CREATE TABLE Esporte (
    Id INTEGER PRIMARY KEY,
  	nome VARCHAR(255)
);

CREATE TABLE Evento (
    Id INTEGER PRIMARY KEY,
    EsporteId INTEGER,
    FOREIGN KEY (EsporteId) REFERENCES Esporte(Id)
);

CREATE TABLE TipoMedalha (
  	id INTEGER PRIMARY KEY,
  	nome VARCHAR(255)
 );

CREATE TABLE Medalha (
    Id INTEGER PRIMARY KEY,
  	medalhaTipo INTEGER,
  	FOREIGN KEY (medalhaTipo) REFERENCES TipoMedalha(Id)
);

CREATE TABLE NOC (
    Id INTEGER PRIMARY KEY,
    Regiao VARCHAR(255),
    Anotacao TEXT
);

CREATE TABLE Time (
    Id INTEGER PRIMARY KEY,
    NOCId INTEGER,
    FOREIGN KEY (NOCId) REFERENCES NOC(Id)
);

CREATE TABLE Participacao (
    Id INTEGER PRIMARY KEY,
    AtletaId INTEGER,
    JogosId INTEGER,
    EsporteId INTEGER,
    EventoId INTEGER,
    MedalhaId INTEGER,
    TimeId INTEGER,
    FOREIGN KEY (AtletaId) REFERENCES Atleta(Id),
    FOREIGN KEY (JogosId) REFERENCES Jogos(Id),
    FOREIGN KEY (EsporteId) REFERENCES Esporte(Id),
    FOREIGN KEY (EventoId) REFERENCES Evento(Id),
    FOREIGN KEY (MedalhaId) REFERENCES Medalha(Id),
    FOREIGN KEY (TimeId) REFERENCES Time(Id)
);