create or replace function update_nb_message_delete()
returns trigger
as $$
	begin
	update Utilisateur
	set NbMessage = NbMessage - 1
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
	set NbMessage = NbMessage + 1
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
	returns trigger
	as $$
	declare heure integer;
	declare jour date;
	begin
		select extract(hour from localtime) as heure;
		perform  DateStat from Statistiques where DateStat=current_date and heure = TrancheHoraire;
		if not found then
			insert into Statistiques
				values (current_date,heure,0,0);
		end if;
		update Statistiques
			set NbMsgPostes = NbMsgPostes + 1
			where current_date = DateStat
			and heure = TrancheHoraire;

	return new;
	end;
	$$ language plpgsql;


create trigger update_stat_nb_message_heure
	after insert
	on Message
	for each row
	execute procedure update_stat_nb_message_heure();
