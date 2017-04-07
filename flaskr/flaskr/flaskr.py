import os
import psycopg2
import flask
import datetime
import re
#datetime.datetime.strptime('2012-07-22 16:19:00.539570', '%Y-%m-%d %H:%M:%S.%f')
app = flask.Flask(__name__)
app.config.from_object(__name__)

# Load default config and override config from an environment variable
app.config.update(dict(
    DATABASE=os.path.join(app.root_path, 'flaskr.db'),
    SECRET_KEY='development key',
    USERNAME='admin',
    PASSWORD='admin123'
))
app.config.from_envvar('FLASKR_SETTINGS', silent=True)


def validate_date(date_text):
    try:
        datetime.datetime.strptime(date_text, '%Y-%m-%d')
        return True
    except ValueError:
        return False


def connect_db():
    """Connects to the specific database."""
    rv = psycopg2.connect(host="sinfo1")
    # curseur = rv.cursor()
    # curseur.execute("SET search_path TO Eforum;")
    return rv


def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(flask.g, 'psql_db'):
        flask.g.psql_db = connect_db()
    return flask.g.psql_db


def get_cur():
    db = get_db()
    db.autocommit = True
    cur = db.cursor()
    cur.execute("SET search_path TO Eforum;")
    return cur


@app.teardown_appcontext
def close_db(error):
    """Closes the database again at the end of the request."""
    if hasattr(flask.g, 'psql_db'):
        flask.g.psql_db.close()


@app.route('/')
def show_section():
    tab_donne = {}
    cur = get_cur()
    cur.execute("SELECT NomSection FROM Section")
    entries = cur.fetchall()
    for entry in entries:
        cur.execute("SELECT NomCategorie FROM Categorie\
                    WHERE NomSection ='"+entry[0]+"'")
        tab_donne[entry[0]] = cur.fetchall()
    return flask.render_template('show_section.html', entries=tab_donne.keys(), tab_donne=tab_donne)


@app.route('/<section>')
def show_categorie(section):
    cur = get_cur()
    cur.execute("SELECT NomSection FROM Section WHERE\
                NomSection='"+section+"'")
    existe = cur.fetchall()
    if len(existe) != 0:
        cur.execute("SELECT NomCategorie FROM Categorie\
                    WHERE NomSection='"+section+"'")
        tab_donne = cur.fetchall()
        return flask.render_template('show_categorie.html', section=section, tab_donne=tab_donne)
    else:
        return flask.render_template('erreur.html', type_erreur="nexists",
                                     pages=(section))


@app.route('/<section>/<categorie>', methods=['GET', 'POST'])
def show_sujet(section, categorie):
    cur = get_cur()
    cur.execute("SELECT NomCategorie FROM Categorie\
                WHERE NomSection='"+section+"'\
                AND NomCategorie='"+categorie+"'")
    existe = cur.fetchall()
    if len(existe) != 0:
        if flask.request.method == 'POST':
            contenu = flask.request.form['sujet_input']
            date_post = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            pseudal = flask.session['pseudo']
            cur.execute("INSERT INTO sujet (Idsujet, nomsujet, DateCreationSujet,\
                         PopulariteSujet, NomCategorie, pseudo) values\
                        (DEFAULT,'"+contenu+"','"+date_post+"'\
                        ,0,'"+categorie+"','"+pseudal+"')")
        cur.execute("SELECT idsujet, NomSujet FROM Sujet\
                    WHERE NomCategorie='"+categorie+"'")
        tab_donne = cur.fetchall()
        return flask.render_template('show_sujet.html', categorie=categorie,
                                     tab_donne=tab_donne, section=section)
    else:
        return flask.render_template('erreur.html', type_erreur="nexists",
                                     pages=(section, categorie))


@app.route('/<section>/<categorie>/<sujet>/<int:page>', methods=['GET', 'POST'])
def show_message(section, categorie, sujet, page):
    cur = get_cur()
    cur.execute("SELECT Idsujet FROM sujet S, Categorie C \
                WHERE C.NomSection='"+section+"'\
                AND S.NomCategorie='"+categorie+"'\
                AND S.NomCategorie=C.NomCategorie\
                AND S.Idsujet='"+sujet+"'")
    existe = cur.fetchall()
    if len(existe) != 0:
        if flask.request.method == 'POST':
            contenu = flask.request.form['message_input']
            date_post = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            pseudal = flask.session['pseudo']
            cur.execute("INSERT INTO Message (IdMessage, DateMessage, Contenu,\
                         QualiteMsg, Pseudo, IdSujet) values\
                        (DEFAULT,'"+date_post+"','"+contenu+"'\
                        ,0,'"+pseudal+"','"+sujet+"')")
        cur.execute("SELECT * FROM message\
                    WHERE Idsujet='"+sujet+"'\
                    order by datemessage\
                    limit 10 offset "+str((page-1)*10))
        tab_donne = cur.fetchall()
        if page > 1:
            precedent = page - 1
        else:
            precedent = 0
        if len(tab_donne) == 10:
            suivant = page + 1
        else:
            suivant = 0
        return flask.render_template('show_message.html', sujet=sujet,
                                     section=section, categorie=categorie,
                                     messages=tab_donne, suivant=suivant,
                                     precedent=precedent, page=page)

    else:
        return flask.render_template('erreur.html', type_erreur="nexists",
                                     pages=(section, categorie))


@app.route('/add', methods=['POST'])
def add_entry():
    if not flask.session.get('logged_in'):
        flask.abort(401)
    """db = get_db()
    cur = db.cursor()
    cur.execute("SET search_path TO Eforum;")
    cur.execute('insert into entries (title, text) values (?, ?)',
                [flask.request.form['title'], flask.request.form['text']])
    cur.commit()"""
    flask.flash('New entry was successfully posted')
    return flask.redirect(flask.url_for('show_section'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if flask.request.method == 'POST':
        liste_pseudo = []
        cur = get_cur()
        cur.execute("SELECT pseudo from utilisateur")
        liste_pseudo_temp = cur.fetchall()
        for temp in liste_pseudo_temp:
            liste_pseudo.append(temp[0])

        if flask.request.form['username'] not in liste_pseudo:
            error = 'Invalid username'
        else:
            flask.session['logged_in'] = True
            flask.flash('You were logged in')
            flask.session['pseudo'] = flask.request.form['username']
            return flask.redirect(flask.url_for('show_section'))
    return flask.render_template('login.html', error=error)


@app.route('/create_account', methods=['GET', 'POST'])
def create_account():
    error = None
    if flask.request.method == 'POST':
        flask.session['pseudo'] = flask.request.form['pseudo']
        flask.session['mail'] = flask.request.form['mail']
        flask.session['sexe'] = flask.request.form['sexe']
        flask.session['age'] = flask.request.form['age']
        flask.session['ville'] = flask.request.form['ville']
        flask.session['etude'] = flask.request.form['etude']
        liste_pseudo = []
        liste_mail = []
        cur = get_cur()
        cur.execute("SELECT pseudo,adressemail from utilisateur")
        liste_pseudo_temp = cur.fetchall()
        for temp in liste_pseudo_temp:
            liste_pseudo.append(temp[0])
            liste_mail.append(temp[1])

        if flask.request.form['pseudo'] in liste_pseudo:
            error = 'pseudo deja pris'
        elif flask.request.form['mail'] in liste_mail:
            error = 'mail deja pris'
        elif flask.request.form['mail'] == "":
            error = "mail ne peut pas etre vide"
        elif not re.match(r"[^@]+@[^@]+\.[^@]+", flask.request.form['mail']):
            error = "mail non valide"
        elif not validate_date(flask.session['age']):
            error = 'date incorect'
        elif flask.request.form['sexe'] not in ['M', 'm', 'f', 'F']:
            error = 'invalid format '
        else:
            cur.execute("insert into utilisateur values\
            ('"+flask.session['pseudo']+"',\
            '"+flask.session['mail']+"',\
            '"+flask.session['age']+"',\
            '"+flask.session['sexe']+"',\
            '"+flask.session['ville']+"',\
            '"+flask.session['etude']+"',\
            0,0,'1960-01-01 00:00:00','Lambda','Nooblard')")
            flask.session['logged_in'] = True
            flask.flash('Compte cree')
            return flask.redirect(flask.url_for('show_section'))
    else:
        flask.session['pseudo'] = ""
        flask.session['mail'] = ""
        flask.session['sexe'] = "M/F"
        flask.session['age'] = "AAAA-MM-JJ"
        flask.session['ville'] = ""
        flask.session['etude'] = ""
    return flask.render_template('create_account.html', error=error, )


@app.route('/logout')
def logout():
    flask.session.pop('logged_in', None)
    flask.flash('You were logged out')
    return flask.redirect(flask.url_for('show_section'))
app.run()
