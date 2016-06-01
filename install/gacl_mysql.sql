-- phpMyAdmin SQL Dump
-- version 2.11.2.1
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Genere le : Ven 26 Septembre 2008 e 15:25
-- Version du serveur: 5.0.24
-- Version de PHP: 5.1.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Base de donnees: `proto`
--

-- --------------------------------------------------------

--
-- Structure de la table `gaclacl`
--

CREATE TABLE IF NOT EXISTS `gaclacl` (
  `id` int(11) NOT NULL default '0',
  `section_value` varchar(230) NOT NULL default 'system',
  `allow` int(11) NOT NULL default '0',
  `enabled` int(11) NOT NULL default '0',
  `return_value` text,
  `note` text,
  `updated_date` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `gaclenabled_acl` (`enabled`),
  KEY `gaclsection_value_acl` (`section_value`),
  KEY `gaclupdated_date_acl` (`updated_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclacl`
--

INSERT INTO `gaclacl` (`id`, `section_value`, `allow`, `enabled`, `return_value`, `note`, `updated_date`) VALUES
(12, 'user', 1, 1, '', '', 1178872734),
(13, 'user', 1, 1, '', '', 1178872750),
(15, 'user', 1, 1, '', '', 1178889703),
(16, 'user', 1, 1, '', '', 1178889776);

-- --------------------------------------------------------

--
-- Structure de la table `gaclacl_sections`
--

CREATE TABLE IF NOT EXISTS `gaclacl_sections` (
  `id` int(11) NOT NULL default '0',
  `value` varchar(230) NOT NULL,
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(230) NOT NULL,
  `hidden` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `gaclvalue_acl_sections` (`value`),
  KEY `gaclhidden_acl_sections` (`hidden`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclacl_sections`
--

INSERT INTO `gaclacl_sections` (`id`, `value`, `order_value`, `name`, `hidden`) VALUES
(1, 'system', 1, 'System', 0),
(2, 'user', 2, 'User', 0);

-- --------------------------------------------------------

--
-- Structure de la table `gaclacl_seq`
--

CREATE TABLE IF NOT EXISTS `gaclacl_seq` (
  `id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclacl_seq`
--

INSERT INTO `gaclacl_seq` (`id`) VALUES
(16);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaco`
--

CREATE TABLE IF NOT EXISTS `gaclaco` (
  `id` int(11) NOT NULL default '0',
  `section_value` varchar(240) NOT NULL default '0',
  `value` varchar(240) NOT NULL,
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL,
  `hidden` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `gaclsection_value_value_aco` (`section_value`,`value`),
  KEY `gaclhidden_aco` (`hidden`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaco`
--

INSERT INTO `gaclaco` (`id`, `section_value`, `value`, `order_value`, `name`, `hidden`) VALUES
(14, 'proto', 'gestion', 1, 'gestion', 0),
(13, 'proto', 'admin', 1, 'admin', 0),
(16, 'proto', 'gestionValid', 2, 'gestionValid', 0),
(17, 'proto', 'gestionAdmin', 2, 'gestionAdmin', 0);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaco_map`
--

CREATE TABLE IF NOT EXISTS `gaclaco_map` (
  `acl_id` int(11) NOT NULL default '0',
  `section_value` varchar(230) NOT NULL default '0',
  `value` varchar(230) NOT NULL,
  PRIMARY KEY  (`acl_id`,`section_value`,`value`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaco_map`
--

INSERT INTO `gaclaco_map` (`acl_id`, `section_value`, `value`) VALUES
(12, 'proto', 'admin'),
(13, 'proto', 'gestion'),
(15, 'proto', 'gestionAdmin'),
(16, 'proto', 'gestionValid');

-- --------------------------------------------------------

--
-- Structure de la table `gaclaco_sections`
--

CREATE TABLE IF NOT EXISTS `gaclaco_sections` (
  `id` int(11) NOT NULL default '0',
  `value` varchar(230) NOT NULL,
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(230) NOT NULL,
  `hidden` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `gaclvalue_aco_sections` (`value`),
  KEY `gaclhidden_aco_sections` (`hidden`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaco_sections`
--

INSERT INTO `gaclaco_sections` (`id`, `value`, `order_value`, `name`, `hidden`) VALUES
(14, 'proto', 1, 'proto', 0);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaco_sections_seq`
--

CREATE TABLE IF NOT EXISTS `gaclaco_sections_seq` (
  `id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaco_sections_seq`
--

INSERT INTO `gaclaco_sections_seq` (`id`) VALUES
(14);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaco_seq`
--

CREATE TABLE IF NOT EXISTS `gaclaco_seq` (
  `id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaco_seq`
--

INSERT INTO `gaclaco_seq` (`id`) VALUES
(17);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaro`
--

CREATE TABLE IF NOT EXISTS `gaclaro` (
  `id` int(11) NOT NULL default '0',
  `section_value` varchar(240) NOT NULL default '0',
  `value` varchar(240) NOT NULL,
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL,
  `hidden` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `gaclsection_value_value_aro` (`section_value`,`value`),
  KEY `gaclhidden_aro` (`hidden`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaro`
--

INSERT INTO `gaclaro` (`id`, `section_value`, `value`, `order_value`, `name`, `hidden`) VALUES
(11, 'login', 'admin', 1, 'admin', 0),
(12, 'login', 'gestion', 1, 'gestion', 0);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaro_groups`
--

CREATE TABLE IF NOT EXISTS `gaclaro_groups` (
  `id` int(11) NOT NULL default '0',
  `parent_id` int(11) NOT NULL default '0',
  `lft` int(11) NOT NULL default '0',
  `rgt` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`,`value`),
  UNIQUE KEY `gaclvalue_aro_groups` (`value`),
  KEY `gaclparent_id_aro_groups` (`parent_id`),
  KEY `gacllft_rgt_aro_groups` (`lft`,`rgt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaro_groups`
--

INSERT INTO `gaclaro_groups` (`id`, `parent_id`, `lft`, `rgt`, `name`, `value`) VALUES
(11, 0, 1, 14, 'application', 'application'),
(12, 11, 2, 3, 'administration', 'admin'),
(13, 11, 4, 13, 'gestion', 'gestion'),
(18, 15, 10, 11, 'gestionadmin', 'gestionadmin'),
(15, 13, 5, 12, 'gestionvalid', 'gestionvalid');

-- --------------------------------------------------------

--
-- Structure de la table `gaclaro_groups_id_seq`
--

CREATE TABLE IF NOT EXISTS `gaclaro_groups_id_seq` (
  `id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaro_groups_id_seq`
--

INSERT INTO `gaclaro_groups_id_seq` (`id`) VALUES
(18);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaro_groups_map`
--

CREATE TABLE IF NOT EXISTS `gaclaro_groups_map` (
  `acl_id` int(11) NOT NULL default '0',
  `group_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`acl_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaro_groups_map`
--

INSERT INTO `gaclaro_groups_map` (`acl_id`, `group_id`) VALUES
(12, 12),
(13, 13),
(15, 18),
(16, 15);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaro_map`
--

CREATE TABLE IF NOT EXISTS `gaclaro_map` (
  `acl_id` int(11) NOT NULL default '0',
  `section_value` varchar(230) NOT NULL default '0',
  `value` varchar(230) NOT NULL,
  PRIMARY KEY  (`acl_id`,`section_value`,`value`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaro_map`
--


-- --------------------------------------------------------

--
-- Structure de la table `gaclaro_sections`
--

CREATE TABLE IF NOT EXISTS `gaclaro_sections` (
  `id` int(11) NOT NULL default '0',
  `value` varchar(230) NOT NULL,
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(230) NOT NULL,
  `hidden` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `gaclvalue_aro_sections` (`value`),
  KEY `gaclhidden_aro_sections` (`hidden`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaro_sections`
--

INSERT INTO `gaclaro_sections` (`id`, `value`, `order_value`, `name`, `hidden`) VALUES
(11, 'login', 1, 'login', 0);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaro_sections_seq`
--

CREATE TABLE IF NOT EXISTS `gaclaro_sections_seq` (
  `id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaro_sections_seq`
--

INSERT INTO `gaclaro_sections_seq` (`id`) VALUES
(11);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaro_seq`
--

CREATE TABLE IF NOT EXISTS `gaclaro_seq` (
  `id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaro_seq`
--

INSERT INTO `gaclaro_seq` (`id`) VALUES
(12);

-- --------------------------------------------------------

--
-- Structure de la table `gaclaxo`
--

CREATE TABLE IF NOT EXISTS `gaclaxo` (
  `id` int(11) NOT NULL default '0',
  `section_value` varchar(240) NOT NULL default '0',
  `value` varchar(240) NOT NULL,
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL,
  `hidden` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `gaclsection_value_value_axo` (`section_value`,`value`),
  KEY `gaclhidden_axo` (`hidden`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaxo`
--


-- --------------------------------------------------------

--
-- Structure de la table `gaclaxo_groups`
--

CREATE TABLE IF NOT EXISTS `gaclaxo_groups` (
  `id` int(11) NOT NULL default '0',
  `parent_id` int(11) NOT NULL default '0',
  `lft` int(11) NOT NULL default '0',
  `rgt` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`,`value`),
  UNIQUE KEY `gaclvalue_axo_groups` (`value`),
  KEY `gaclparent_id_axo_groups` (`parent_id`),
  KEY `gacllft_rgt_axo_groups` (`lft`,`rgt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaxo_groups`
--


-- --------------------------------------------------------

--
-- Structure de la table `gaclaxo_groups_map`
--

CREATE TABLE IF NOT EXISTS `gaclaxo_groups_map` (
  `acl_id` int(11) NOT NULL default '0',
  `group_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`acl_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaxo_groups_map`
--


-- --------------------------------------------------------

--
-- Structure de la table `gaclaxo_map`
--

CREATE TABLE IF NOT EXISTS `gaclaxo_map` (
  `acl_id` int(11) NOT NULL default '0',
  `section_value` varchar(230) NOT NULL default '0',
  `value` varchar(230) NOT NULL,
  PRIMARY KEY  (`acl_id`,`section_value`,`value`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaxo_map`
--


-- --------------------------------------------------------

--
-- Structure de la table `gaclaxo_sections`
--

CREATE TABLE IF NOT EXISTS `gaclaxo_sections` (
  `id` int(11) NOT NULL default '0',
  `value` varchar(230) NOT NULL,
  `order_value` int(11) NOT NULL default '0',
  `name` varchar(230) NOT NULL,
  `hidden` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `gaclvalue_axo_sections` (`value`),
  KEY `gaclhidden_axo_sections` (`hidden`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclaxo_sections`
--


-- --------------------------------------------------------

--
-- Structure de la table `gaclgroups_aro_map`
--

CREATE TABLE IF NOT EXISTS `gaclgroups_aro_map` (
  `group_id` int(11) NOT NULL default '0',
  `aro_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`group_id`,`aro_id`),
  KEY `gaclaro_id` (`aro_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclgroups_aro_map`
--

INSERT INTO `gaclgroups_aro_map` (`group_id`, `aro_id`) VALUES
(12, 11),
(15, 12),
(18, 11);

-- --------------------------------------------------------

--
-- Structure de la table `gaclgroups_axo_map`
--

CREATE TABLE IF NOT EXISTS `gaclgroups_axo_map` (
  `group_id` int(11) NOT NULL default '0',
  `axo_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`group_id`,`axo_id`),
  KEY `gaclaxo_id` (`axo_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclgroups_axo_map`
--


-- --------------------------------------------------------

--
-- Structure de la table `gaclphpgacl`
--

CREATE TABLE IF NOT EXISTS `gaclphpgacl` (
  `name` varchar(230) NOT NULL,
  `value` varchar(230) NOT NULL,
  PRIMARY KEY  (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gaclphpgacl`
--

INSERT INTO `gaclphpgacl` (`name`, `value`) VALUES
('version', '3.3.7'),
('schema_version', '2.1');

-- --------------------------------------------------------

--
-- Structure de la table `LoginGestion`
--

CREATE TABLE IF NOT EXISTS `LoginGestion` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(32) NOT NULL,
  `password` char(64) default NULL,
  `nom` varchar(32) default NULL,
  `prenom` varchar(32) default NULL,
  `mail` varchar(255) default NULL,
  `datemodif` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `login` (`login`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Contenu de la table `LoginGestion`
--

INSERT INTO `LoginGestion` (`id`, `login`, `password`, `nom`, `prenom`, `mail`, `datemodif`) VALUES
(1, 'admin', 'cd916028a2d8a1b901e831246dd5b9b4d3832786ddc63bbf5af4b50d9fc98f50', 'Administrateur', NULL, NULL, NULL),
(5, 'gestion', '2a0bede1d20bbb79cd11759361cbd3f6012aea5acfb4972a208a724fb57a5fe4', 'Gestionnaire', NULL, NULL, NULL);
