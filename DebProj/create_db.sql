CREATE SCHEMA Eforum;
SET search_path TO Eforum, public;


CREATE DOMAIN Status AS VARCHAR(20) CHECK (VALUE IN ('Administrateur', 'Moderateur', 'Lambda', 'UtilisateurSupprime', 'Recruteur'));
CREATE DOMAIN DomRang AS VARCHAR(20) CHECK (VALUE IN ('Nooblard', 'Bronzos', 'Kevin'));
CREATE DOMAIN OS AS VARCHAR(20) CHECK (VALUE IN ('Windobe', 'Unix', 'Android'));
CREATE DOMAIN WebBrowser AS VARCHAR(20) CHECK (VALUE IN ('Opera', 'Safari'));
CREATE DOMAIN Heures AS INTEGER CHECK (VALUE IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23));
CREATE DOMAIN Annonce AS VARCHAR(20) CHECK (VALUE IN (' '));
CREATE DOMAIN Contrat AS VARCHAR(20) CHECK (VALUE IN ('CDD', 'CDI', 'STAGE'));
CREATE DOMAIN Langage AS VARCHAR(20) CHECK (VALUE IN ('Py', 'C', '...'));
CREATE DOMAIN Niveau AS VARCHAR(20) CHECK (VALUE IN ('Pas bon', 'Bon', 'Trop bon'));

CREATE TABLE Rang ( NomRang DomRang PRIMARY KEY,
                    PallierAcces FLOAT NOT NULL);

CREATE TABLE Utilisateur ( Pseudo VARCHAR(20) PRIMARY KEY,
						   AdresseMail VARCHAR(50) NOT NULL UNIQUE,
						   DateNaissance DATE NOT NULL,
						   Sexe VARCHAR(1) NOT NULL,
						   Ville VARCHAR(10),
						   Etude VARCHAR(30),
						   NbMessage INTEGER NOT NULL,
						   MoyQualiteMsg FLOAT NOT NULL,
						   DateDernierCo DATE,
						   IntituléStatus Status,
						   NomRang VARCHAR(20) NOT NULL REFERENCES Rang on DELETE cascade);

CREATE TABLE Section ( NomSection VARCHAR(30) PRIMARY KEY,
					   PopulariteSection FLOAT NOT NULL,
					   Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur on DELETE cascade);

CREATE TABLE Categorie ( NomCategorie VARCHAR(30) PRIMARY KEY,
						 PopulariteCategorie FLOAT NOT NULL,
						 NomSection VARCHAR(30) NOT NULL REFERENCES Section on DELETE cascade);

CREATE TABLE Sujet ( IdSujet INTEGER PRIMARY KEY,
					 NomSujet VARCHAR(50) NOT NULL,
					 DateCreationSujet DATE NOT NULL,
					 PopulariteSujet FLOAT NOT NULL,
                     NomCategorie VARCHAR(30) NOT NULL REFERENCES Categorie on DELETE cascade,
				     Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur on DELETE cascade);

CREATE TABLE Message ( IdMessage INTEGER PRIMARY KEY,
					   DateMessage Date NOT NULL,
					   Contenu VARCHAR(1000) NOT NULL,
					   QualiteMsg FLOAT NOT NULL,
				       Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur on DELETE cascade,
					   IdSujet INTEGER NOT NULL REFERENCES Sujet on DELETE cascade);

CREATE TABLE Support ( IdSupport INTEGER PRIMARY KEY,
					   SystemeExploitation OS,
					   NavigateurInternet WebBrowser,
					   Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur on DELETE cascade);					   

CREATE TABLE Statistiques ( DateStat DATE,
                            TrancheHoraire Heures,
                            NbConnec INTEGER,
                            NbMsgPoste INTEGER,
                            CONSTRAINT PK_Statistiques PRIMARY KEY (DateStat, TrancheHoraire));

CREATE TABLE OffreRecrutement ( IdAnnonce INTEGER PRIMARY KEY,
                                DateAnnonce DATE NOT NULL,
                                DateButoire DATE NOT NULL,
                                TypeAnnonce Annonce,
                                TypeContrat Contrat,
                                MsgAnnonce VARCHAR(1000) NOT NULL,
                                Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur on DELETE cascade,
                                AdresseMail VARCHAR(50) NOT NULL REFERENCES Utilisateur on DELETE cascade);

CREATE TABLE MsgPrive ( IdMP INTEGER PRIMARY KEY,
                        DateMP DATE NOT NULL,
                        ContenuMP VARCHAR(1000) NOT NULL,
                        EtatMP BOOLEAN NOT NULL,
                        PseudoEnvoi VARCHAR(20) NOT NULL REFERENCES Utilisateur on DELETE cascade,
                        PseudoRecoit VARCHAR(20) NOT NULL REFERENCES Utilisateur on DELETE cascade);

CREATE TABLE Programmation ( LangageProg Langage PRIMARY KEY);

CREATE TABLE UtilisateurProgrammation ( Pseudo VARCHAR(20) REFERENCES Utilisateur on DELETE cascade,
                                        LangageProg Langage REFERENCES Programmation on DELETE cascade,
                                        NiveauProg Niveau,
                                        DispoRct BOOLEAN,
                                        CONSTRAINT PK_UtilisateurProgrammation PRIMARY KEY (Pseudo, LangageProg));

CREATE TABLE OffreRecrutementProgrammation( IdAnnonce INTEGER REFERENCES OffreRecrutement on DELETE cascade,
                                            LangageProg Langage REFERENCES Programmation on DELETE cascade,
                                            NiveauDemande Niveau,
                                            CONSTRAINT PK_OffreRecrutementProgrammation PRIMARY KEY (IdAnnonce, LangageProg));

