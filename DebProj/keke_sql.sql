CREATE OR REPLACE function is_there_a_moderator_already()
RETURNS TRIGGER
AS $$
	BEGIN 
    if old.Pseudo is not null then
        RETURN old;
    else
        UPDATE Utilisateur
        SET IntituleStatus = 'Moderateur';
        RETURN new;
    END IF;
    END;
$$ language plpgsql;

CREATE TRIGGER is_there_a_moderator_already
    BEFORE UPDATE
    ON SECTION
    FOR EACH ROW
    execute procedure is_there_a_moderator_already();


CREATE OR REPLACE function date_offre_valide()
RETURNS TRIGGER
AS $$
    BEGIN
    if new.DateButoire > new.DateAnnonce then
        return new;
    else
        return old;
    END IF;
    END;
$$ language plpgsql;

CREATE TRIGGER date_offre_valide
    BEFORE INSERT
    ON OffreRecrutement
    FOR EACH ROW
    execute procedure date_offre_valide();


CREATE OR REPLACE function are_you_a_recrutor()
RETURNS TRIGGER
AS $$
    declare stat Status;
    BEGIN
        stat := (SELECT IntituleStatus
        FROM Utilisateur U
        WHERE U.Pseudo = new.Pseudo);
        if stat = 'Recruteur' then
            return new;
        else
            return old;
        END IF;
    END;
$$ language plpgsql;

CREATE TRIGGER are_you_a_recrutor
    BEFORE INSERT
    ON OffreRecrutement
    FOR EACH ROW
    execute procedure are_you_a_recrutor();


CREATE OR REPLACE function demande_rct_valide()
RETURNS TRIGGER
AS $$
    DECLARE Date_limite date := (SELECT DateButoire FROM OffreRecrutement O WHERE O.IdAnnonce = new.IdAnnonce);
    BEGIN
        if current_date > Date_limite then
            return old;
        else
            return new;
        END IF;
    END;
$$ language plpgsql;

CREATE TRIGGER demande_rct_valide
    BEFORE INSERT
    ON UtilisateurOffreRecrutement
    FOR EACH ROW
    execute procedure demande_rct_valide();








