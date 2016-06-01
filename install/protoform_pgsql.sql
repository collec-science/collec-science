-- phpMyAdmin SQL Dump
-- version 2.11.3deb1ubuntu1.1
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Ven 20 Février 2009 à 08:10
-- Version du serveur: 5.0.51
-- Version de PHP: 5.2.4-2ubuntu5.4


--
-- Base de données: protoform
--

-- --------------------------------------------------------

--
-- Structure de la table civilite
--

CREATE SEQUENCE civilite_civilite_id_seq;

CREATE TABLE IF NOT EXISTS civilite (
  id integer NOT NULL default nextval('civilite_civilite_id_seq'),
  libelle varchar NOT NULL,
  ordreTri smallint NOT NULL,
  constraint civilite_pk PRIMARY KEY  (id)
) ;
ALTER SEQUENCE civilite_civilite_id_seq OWNED BY civilite.id;
--
-- Contenu de la table civilite
--

INSERT INTO civilite (id, libelle, ordreTri) VALUES
(1, 'Monsieur', 1),
(2, 'Mademoiselle', 3),
(3, 'Madame', 2);

select setval('civilite_civilite_id_seq', (select max(id) from civilite));

--
-- Structure de la table personnel
--
create sequence personnel_personnel_id_seq;

CREATE TABLE IF NOT EXISTS personnel (
  id integer NOT NULL default nextval('personnel_personnel_id_seq'),
  nom varchar NOT NULL,
  prenom varchar default NULL,
  dateNaissance timestamp default NULL,
  nbreEnfants smallint default '0',
  civilite smallint default NULL,
  constraint personnel_pk PRIMARY KEY  (id)
);

--
-- Contenu de la table personnel
--

INSERT INTO personnel (id, nom, prenom, dateNaissance, nbreEnfants, civilite) VALUES
(1, 'Dupont', 'Jean', '1967-08-14', 0, 1),
(2, 'Martin', 'Evelyne', '1975-07-01', 2, 2),
(3, 'Esteban', 'Laury', '1989-01-25', 0, 3),
(4, 'Duval', 'Patrick', '1956-04-13', 3, 1);

select setval('personnel_personnel_id_seq', (select max(id) from personnel));
