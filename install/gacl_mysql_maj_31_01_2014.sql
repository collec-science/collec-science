CREATE TABLE IF NOT EXISTS login_oldpassword (
                login_oldpassword_id int(11) NOT NULL auto_increment,
                password VARCHAR(255),
		id int(11) not null,
                PRIMARY KEY (login_oldpassword_id)
)
ENGINE=MyISAM  
DEFAULT CHARSET=latin1
comment 'Table contenant les anciens mots de passe'
;

CREATE TABLE log (
                log_id int(11) NOT NULL auto_increment,
                login VARCHAR(32) NOT NULL,
                nom_module VARCHAR(255),
                log_date TIMESTAMP NOT NULL comment 'Heure de connexion',
                commentaire VARCHAR(255) comment 'Donnees complementaires enregistrees',
                PRIMARY KEY (log_id)
)
ENGINE=MyISAM  
DEFAULT CHARSET=latin1
comment 'Liste des connexions ou des actions enregistrées';

alter table LoginGestion add column actif int(11) not null default 1;
