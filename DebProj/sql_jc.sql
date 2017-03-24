create or replace function update_nb_message_delete()
returns trigger
as $$
	begin
	update Utilisateur
	set NbMessage -= 1
	where pseudo = old.pseudo;
	return old;
	end;
$$ language plpgsql;


create trigger update_nb_message_delete
	after delete
	on Message
	for each row
	execute procedure update_nb_message_delete();

create or replace function update_nb_message_insert()
returns trigger
as $$
	begin
	update Utilisateur
	set NbMessage += 1
	where pseudo = new.pseudo;
	return new;
	end;
$$ language plpgsql;


create trigger update_nb_message_insert
	after insert
	on Message
	for each row
	execute procedure update_nb_message_insert();

create or replace function update_stat_nb_message_heure()
	declare heure Integer;
	declare jour date;
	return trigger
	as $$
		heure = select extract(hour from localtime);
		jour = select current_date;
		if (select DateStat from Statistiques where DateStat=jour and heure = TrancheHoraire; = NULL)then
			insert into Statistiques
				values (jour,heure,0,0);
		endif;
		update Statistiques
			set NbConnec += 1
			where jour = DateStat
			and heure = TrancheHoraire;

	return new;
	end;
	$$ language plpgsql;


	create trigger update_stat_nb_message_heure
		after insert
		on Message
		for each row
		execute procedure update_stat_nb_message_heure();
