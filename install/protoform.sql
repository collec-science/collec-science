-- phpMyAdmin SQL Dump
-- version 2.11.3deb1ubuntu1.1
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Ven 20 Février 2009 à 08:10
-- Version du serveur: 5.0.51
-- Version de PHP: 5.2.4-2ubuntu5.4


--
-- Base de données: `protoform`
--

-- --------------------------------------------------------

--
-- Structure de la table `civilite`
--

CREATE TABLE IF NOT EXISTS `civilite` (
  `id` int(11) NOT NULL auto_increment,
  `libelle` varchar(32) character set latin1 collate latin1_bin NOT NULL,
  `ordreTri` smallint(6) NOT NULL,
  PRIMARY KEY  (`id`)
) ;

--
-- Contenu de la table `civilite`
--

INSERT INTO `civilite` (`id`, `libelle`, `ordreTri`) VALUES
(1, 'Monsieur', 1),
(2, 'Mademoiselle', 3),
(3, 'Madame', 2);


--
-- Structure de la table `personnel`
--

CREATE TABLE IF NOT EXISTS `personnel` (
  `id` int(11) NOT NULL auto_increment,
  `nom` varchar(32) collate latin1_bin NOT NULL,
  `prenom` varchar(32) collate latin1_bin default NULL,
  `dateNaissance` date default NULL,
  `nbreEnfants` smallint(6) default '0',
  `civilite` smallint(6) default NULL,
  PRIMARY KEY  (`id`)
);

--
-- Contenu de la table `personnel`
--

INSERT INTO `personnel` (`id`, `nom`, `prenom`, `dateNaissance`, `nbreEnfants`, `civilite`) VALUES
(1, 'Dupont', 'Jean', '1967-08-14', 0, 1),
(2, 'Martin', 'Evelyne', '1975-07-01', 2, 2),
(3, 'Esteban', 'Laury', '1989-01-25', 0, 3),
(4, 'Duval', 'Patrick', '1956-04-13', 3, 1);
