CREATE DOMAIN Status AS VARCHAR(20) CHECK (VALUE IN ('Administrateur', 'Moderateur', 'Lambda', 'UtilisateurSupprime', 'Recruteur'));
CREATE DOMAIN Rang AS VARCHAR(20) CHECK (VALUE IN ('Nooblard', 'Bronzos', 'Kevin'));
CREATE DOMAIN OS AS VARCHAR(20) CHECK (VALUE IN ('Windobe', 'Unix', 'Android'));
CREATE DOMAIN WebBrowser AS VARCHAR(20) CHECK (VALUE IN ('Opera', 'Safari'));

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

CREATE TABLE Rang ( NomRang Rang PRIMARY KEY,
                    PallierAcces FLOAT NOT NULL);

CREATE TABLE Support ( IdSupport INTEGER PRIMARY KEY,
					   SystemeExploitation OS,
					   NavigateurInternet WebBrowser,
					   Pseudo VARCHAR(20) NOT NULL REFERENCES Utilisateur);					   

CREATE TABLE Statistiques 



