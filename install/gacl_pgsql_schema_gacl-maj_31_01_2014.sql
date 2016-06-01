set search_path = gacl;

CREATE SEQUENCE login_oldpassword_login_oldpassword_id_seq;

CREATE TABLE login_oldpassword (
                login_oldpassword_id INTEGER NOT NULL DEFAULT nextval('login_oldpassword_login_oldpassword_id_seq'),
                id INTEGER DEFAULT nextval('seq_logingestion_id'::regclass) NOT NULL,
                password VARCHAR(255),
                CONSTRAINT login_oldpassword_pk PRIMARY KEY (login_oldpassword_id)
);
COMMENT ON TABLE login_oldpassword IS 'Table contenant les anciens mots de passe';


ALTER SEQUENCE login_oldpassword_login_oldpassword_id_seq OWNED BY login_oldpassword.login_oldpassword_id;

ALTER TABLE login_oldpassword ADD CONSTRAINT logingestion_login_oldpassword_fk
FOREIGN KEY (id)
REFERENCES logingestion (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE log_log_id_seq;

CREATE TABLE log (
                log_id INTEGER NOT NULL DEFAULT nextval('log_log_id_seq'),
                login VARCHAR(32) NOT NULL,
                nom_module VARCHAR,
                log_date TIMESTAMP NOT NULL,
                commentaire VARCHAR,
                CONSTRAINT log_pk PRIMARY KEY (log_id)
);
COMMENT ON TABLE log IS 'Liste des connexions ou des actions enregistrées';
COMMENT ON COLUMN log.log_date IS 'Heure de connexion';
COMMENT ON COLUMN log.commentaire IS 'Donnees complementaires enregistrees';


ALTER SEQUENCE log_log_id_seq OWNED BY log.log_id;

CREATE INDEX log_date_idx
 ON log
 ( log_date );

CREATE INDEX log_login_idx
 ON log
 ( login );


