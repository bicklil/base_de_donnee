CREATE SCHEMA Eforum;
SET search_path TO Eforum, public;


CREATE DOMAIN Status AS VARCHAR(20) CHECK (VALUE IN ('Administrateur', 'Moderateur', 'Lambda', 'UtilisateurSupprime', 'Recruteur'));
CREATE DOMAIN DomRang AS VARCHAR(20) CHECK (VALUE IN ('Nooblard', 'Bronzos', 'Kevin'));
CREATE DOMAIN OS AS VARCHAR(20) CHECK (VALUE IN ('Windobe', 'Unix', 'Android'));
CREATE DOMAIN WebBrowser AS VARCHAR(20) CHECK (VALUE IN ('Opera', 'Safari'));
CREATE DOMAIN Heures AS VARCHAR(20) CHECK (VALUE IN ('0h-1h', '...'));
CREATE DOMAIN Annonce AS VARCHAR(20) CHECK (VALUE IN (' '));
CREATE DOMAIN Contrat AS VARCHAR(20) CHECK (VALUE IN ('CDD', 'CDI', 'STAGE'));
CREATE DOMAIN Langage AS VARCHAR(20) CHECK (VALUE IN ('Py', 'C', '...'));
CREATE DOMAIN Niveau AS VARCHAR(20) CHECK (VALUE IN ('Pas bon', 'Bon', 'Trop bon'));

CREATE TABLE Utilisateur ( Pseudo VARCHAR(20) PRIMARY KEY,
						   AdresseMail VARCHAR(50) PRIMARY KEY,
						   DateNaissance DATE NOT NULL,
						   Sexe VARCHAR(1) NOT NULL,
						   Ville VARCHAR(10),
						   Etude VARCHAR(30),
						   NbMessage INTEGER NOT NULL,
						   MoyQualiteMsg FLOAT NOT NULL,
						   DateDernierCo DATE,
						   IntituléStatus Status,
						   NomRang VARCHAR(20) NOT NULL REFERENCES Rang );

CREATE TABLE Message ( IdMessage INTEGER PRIMARY KEY,
					   DateMessage Date NOT NULL,
					   Contenu VARCHAR(1000) NOT NULL,
					   QualiteMsg FLOAT NOT NULL,
				       Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur,
					   IdSujet INTEGER NOT NULL REFERENCES Sujet);

CREATE TABLE Sujet ( IdSujet INTEGER PRIMARY KEY,
					 NomSujet VARCHAR(50) NOT NULL,
					 DateCreationSujet DATE NOT NULL,
					 PopulariteSujet FLOAT NOT NULL,
                     NomCategorie VARCHAR(30) NOT NULL REFERENCES Categorie,
				     Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur );

CREATE TABLE Categorie ( NomCategorie VARCHAR(30) PRIMARY KEY,
						 PopulariteCategorie FLOAT NOT NULL,
						 NomSection VARCHAR(30) NOT NULL REFERENCES Section);

CREATE TABLE Section ( NomSection VARCHAR(30) PRIMARY KEY,
					   PopulariteSection FLOAT NOT NULL,
					   Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur);

CREATE TABLE Rang ( NomRang DomRang PRIMARY KEY,
                    PallierAcces FLOAT NOT NULL);

CREATE TABLE Support ( IdSupport INTEGER PRIMARY KEY,
					   SystemeExploitation OS,
					   NavigateurInternet WebBrowser,
					   Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur);					   

CREATE TABLE Statistiques ( DateStat DATE PRIMARY KEY,
                            TrancheHoraire Heures PRIMARY KEY,
                            NbConnec INTEGER,
                            NbMsgPoste INTEGER);

CREATE TABLE OffreRecrutement ( IdAnnonce INTEGER PRIMARY KEY,
                                DateAnnonce DATE NOT NULL,
                                DateButoire DATE NOT NULL,
                                TypeAnnonce Annonce,
                                TypeContrat Contrat,
                                MsgAnnonce VARCHAR(1000) NOT NULL,
                                Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur,
                                AdresseMail VARCHAR(50) NOT NULL REFERENCES Utilisateur);

CREATE TABLE MsgPrive ( IdMP INTEGER PRIMARY KEY,
                        DateMP DATE NOT NULL,
                        ContenuMP VARCHAR(1000) NOT NULL,
                        EtatMP BOOLEAN NOT NULL,
                        PseudoEnvoi VARCHAR(20) NOT NULL REFERENCES Utilisateur.Pseudo,
                        PseudoRecoit VARCHAR(20) NOT NULL REFERENCES Utilisateur.Pseudo);

CREATE TABLE Programmation ( LangageProg Langage PRIMARY KEY);

CREATE TABLE UtilisateurProgrammation ( Pseudo VARCHAR(20) PRIMARY KEY REFERENCES Utilisateur,
                                        LangageProg Langage PRIMARY KEY REFERENCES Programmation,
                                        NiveauProg Niveau,
                                        DispoRct BOOLEAN);

CREATE TABLE OffreRecrutementProgrammation( IdAnnonce INTEGER PRIMARY KEY REFERENCES OffreRecrutement,
                                            LangageProg Langage PRIMARY KEY REFERENCES Programmation,
                                            NiveauDemande Niveau);

