import os
import psycopg2
import flask

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


@app.teardown_appcontext
def close_db(error):
    """Closes the database again at the end of the request."""
    if hasattr(flask.g, 'psql_db'):
        flask.g.psql_db.close()


@app.route('/')
def show_section():
    tab_donne = {}
    db = get_db()
    cur = db.cursor()
    cur.execute("SET search_path TO Eforum;")
    cur.execute("SELECT NomSection FROM Section")
    entries = cur.fetchall()
    for entry in entries:
        cur.execute("SELECT NomCategorie FROM Categorie\
                    WHERE NomSection ='"+entry[0]+"'")
        tab_donne[entry[0]] = cur.fetchall()
    return flask.render_template('show_section.html', entries=tab_donne.keys(), tab_donne=tab_donne)


@app.route('/<section>')
def show_categorie(section):
    db = get_db()
    cur = db.cursor()
    cur.execute("SET search_path TO Eforum;")
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


@app.route('/<section>/<categorie>')
def show_sujet(section, categorie):
    db = get_db()
    cur = db.cursor()
    cur.execute("SET search_path TO Eforum;")
    cur.execute("SELECT NomCategorie FROM Categorie\
                WHERE NomSection='"+section+"'\
                AND NomCategorie='"+categorie+"'")
    existe = cur.fetchall()
    if len(existe) != 0:
        cur.execute("SELECT idsujet, NomSujet FROM Sujet\
                    WHERE NomCategorie='"+categorie+"'")
        tab_donne = cur.fetchall()
        return flask.render_template('show_sujet.html', categorie=categorie,
                                     tab_donne=tab_donne)
    else:
        return flask.render_template('erreur.html', type_erreur="nexists",
                                     pages=(section, categorie))


@app.route('/<section>/<categorie>/<sujet>/<int:page>')
def show_message(section, categorie, sujet, page):
    db = get_db()
    cur = db.cursor()
    cur.execute("SET search_path TO Eforum;")
    cur.execute("SELECT Idsujet FROM sujet S, Categorie C \
                WHERE C.NomSection='"+section+"'\
                AND S.NomCategorie='"+categorie+"'\
                AND S.NomCategorie=C.NomCategorie\
                AND S.Idsujet='"+sujet+"'")
    existe = cur.fetchall()
    if len(existe) != 0:
        cur.execute("SELECT * FROM message\
                    WHERE Idsujet='"+sujet+"'\
                    order by datemessage desc\
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
                                     precedent=precedent)
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
        if flask.request.form['username'] != app.config['USERNAME']:
            error = 'Invalid username'
        elif flask.request.form['password'] != app.config['PASSWORD']:
            error = 'Invalid password'
        else:
            flask.session['logged_in'] = True
            flask.flash('You were logged in')
            return flask.redirect(flask.url_for('show_section'))
    return flask.render_template('login.html', error=error)


@app.route('/logout')
def logout():
    flask.session.pop('logged_in', None)
    flask.flash('You were logged out')
    return flask.redirect(flask.url_for('show_section'))
app.run()
