# base_de_donnee

Projet

Le projet de base de données doit permettre de mettre en œuvre les connaissances acquises en cours et les compétences techniques développées lors des premières séances de TP. Chaque étudiant devra être capable de mener à bien le développement d’une application web reposant sur une base de données relationnelle. Le sujet du projet peut être libre (soumis à certaines contraintes) ou proposé. Le sujet libre demande plus d'investissement mais il est plus formateur et sera donc valorisé.
Contraintes

- Base de données : PostgreSQL 9.x

- Application Web : technologies FLASK (Python 3) / HTML / CSS conseillées. Vous pouvez utilisez d'autres technologies en sachant que : 

    Le rendu devra être une interface WEB ; 
    Aucune aide n'est garantie pour des technologies autres que FLASK / HTML / CSS ;
    Quelque soit l'investissement et la performance de l'étudiant sur une technonologie, la notation se fera majoritairement sur les aspects BD.

Planning

Ci-dessous le planning : 

    Décembre 2016 : MEA à envoyer à murisasco@univ-tln.fr

    22 mars 2017 : Envoyer le rapport de conception à emilien.royer@univ-tln.fr . Celui-ci devra contenir les éléments suivants :

        La description de votre projet (par exemple une présentation générale et les objectifs de votre application)

        Les éléments de conception que vous jugerez utiles d'indiquer : dictionnaire de données, MEA + règles de gestion, schéma relationnel, contraintes du modèles, types de données, ...

        Les fonctionnalités proposées au niveau de la BD (fonctions pl/pgsql), les déclencheurs, les éventuelles vues et rôles 

        Les fonctionnalités envisagées offertes par l'application Web

    Du 20 mars au 7 avril : Implantation de la base sous PostgreSQL (scripts SQL de création des tables), fonctions pl/pgsql, triggers, vues, ...

    Courant avril : Application Web 

Pour construire votre MEA : DIA ou https://launchpad.net/analysesi

Evaluation

Rapport complet et codes (scripts SQL + application Web) à envoyer à emilien.royer@univ-tln.fr le 28 avril 2017.

Soutenance orale d'une durée de 8 minutes pendant lesquelles vous présenterez le rendu de votre projet en insistant sur les aspects BD le 28 avril 2017.

En dépit de la constitution de binômes pour ce projet, une attention particulière sera portée à la répartition équitable du travail pour chaque groupe.

Resources

Le tutoriel officiel de Flask est relativement complet et bien réalisé : http://flask.pocoo.org/docs/0.12/tutorial/ (Attention, celui-ci utilise SQLlite comme référence de SGBDR mais c'est bien postgreSQL que nous utilisons pour le projet)

Toutefois une séance sera bien entendu consacrée à la découverte de cet outil.
