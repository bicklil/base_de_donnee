insert into rang values ('Nooblard',0),('Bronzos',2),('Kevin',5);
insert into utilisateur values ('kiki','lol@lol1.com','2003-07-01','M','toulon','kikou',0,0,'2003-07-01 00:00:00','Lambda','Kevin');
insert into utilisateur values ('kou','lol@loazeazel.com','2003-07-01','M','toulon','kikou',0,0,'2003-07-01 00:00:00','Recruteur','Kevin');
insert into utilisateur values ('kevin','lol@lol.com','1996-09-26','M','Hyeres','god',0,0,'2003-07-01 00:00:00','Administrateur','Kevin');
insert into section values ('section1',0,null),('section2',0,null);
insert into categorie values ('categorie1',0,'section1'),('categorie2',0,'section1'),
                             ('categorie3',0,'section2'),('categorie4',0,'section2');
insert into sujet values (DEFAULT,'hihi','2003-05-05 00:00:00',0,'categorie1','kiki');
insert into Message values(DEFAULT,'2003-05-05 00:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 01:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 02:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 03:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 04:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 05:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 06:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 07:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 08:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 09:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 10:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 11:01:00','hihi',0,'kiki',1);
insert into Message values(DEFAULT,'2003-05-05 11:01:00','hihi',0,'kiki',1);
insert into OffreRecrutement values (DEFAULT, '2017-03-30', '2017-05-30', 'web', 'CDI', 'rct dj cm lvl 150 min passe vite', 'kou');
insert into OffreRecrutement values (DEFAULT, '2017-03-15', '2017-05-30', 'web', 'CDD', 'rct de sexe f et m pour tue le karalamoure', 'kou');
insert into UtilisateurOffreRecrutement values (1,'kiki'), (2,'kiki');
insert into Statistiques values ('2017-05-05',8,100,100),
  ('2017-05-03',15,500,50),
  ('2017-05-03',12,300,200),
  ('2017-05-02',8,150,800),
  ('2017-05-01',8,200,100),
  ('2017-05-05',3,100,100),
  ('2017-05-05',10,0,50),
  ('2017-05-05',13,20,100),
  ('2017-05-05',18,10,1300),
  ('2017-05-05',22,100,300),
  ('2017-05-05',4,200,100);
