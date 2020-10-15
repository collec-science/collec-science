
CREATE TABLE col.country (
	country_id integer NOT NULL,
	country_name varchar NOT NULL,
	country_code2 varchar(2) NOT NULL,
	country_code3 varchar(3),
	CONSTRAINT country_pk PRIMARY KEY (country_id)

);
-- ddl-end --
COMMENT ON TABLE col.country IS E'List of the countries';
-- ddl-end --
COMMENT ON COLUMN col.country.country_id IS E'Numeric ISO code of the country';
-- ddl-end --
COMMENT ON COLUMN col.country.country_name IS E'Name of the country';
-- ddl-end --
COMMENT ON COLUMN col.country.country_code2 IS E'Code of the country, on 2 positions';
-- ddl-end --
COMMENT ON COLUMN col.country.country_code3 IS E'Code of the country, on 3 positions';
-- ddl-end --
ALTER TABLE col.country OWNER TO collec;
-- ddl-end --

INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'4', E'Afghanistan', E'AF', E'AFG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'248', E'Îles Åland', E'AX', E'ALA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'8', E'Albanie', E'AL', E'ALB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'12', E'Algérie', E'DZ', E'DZA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'16', E'Samoa américaines', E'AS', E'ASM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'20', E'Andorre', E'AD', E'AND');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'24', E'Angola', E'AO', E'AGO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'660', E'Anguilla', E'AI', E'AIA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'10', E'Antarctique', E'AQ', E'ATA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'28', E'Antigua-et-Barbuda', E'AG', E'ATG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'32', E'Argentine', E'AR', E'ARG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'51', E'Arménie', E'AM', E'ARM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'533', E'Aruba', E'AW', E'ABW');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'36', E'Australie', E'AU', E'AUS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'40', E'Autriche', E'AT', E'AUT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'31', E'Azerbaïdjan', E'AZ', E'AZE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'44', E'Bahamas', E'BS', E'BHS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'48', E'Bahreïn', E'BH', E'BHR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'50', E'Bangladesh', E'BD', E'BGD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'52', E'Barbade', E'BB', E'BRB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'112', E'Biélorussie', E'BY', E'BLR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'56', E'Belgique', E'BE', E'BEL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'84', E'Belize', E'BZ', E'BLZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'204', E'Bénin', E'BJ', E'BEN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'60', E'Bermudes', E'BM', E'BMU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'64', E'Bhoutan', E'BT', E'BTN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'68', E'Bolivie', E'BO', E'BOL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'70', E'Bosnie-Herzégovine', E'BA', E'BIH');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'72', E'Botswana', E'BW', E'BWA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'74', E'Île Bouvet', E'BV', E'BVT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'76', E'Brésil', E'BR', E'BRA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'92', E'British Virgin Islands', E'VG', E'VGB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'86', E'Territoire britannique de l’Océan Indien', E'IO', E'IOT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'96', E'Brunei Darussalam', E'BN', E'BRN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'100', E'Bulgarie', E'BG', E'BGR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'854', E'Burkina Faso', E'BF', E'BFA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'108', E'Burundi', E'BI', E'BDI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'116', E'Cambodge', E'KH', E'KHM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'120', E'Cameroun', E'CM', E'CMR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'124', E'Canada', E'CA', E'CAN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'132', E'Cap-Vert', E'CV', E'CPV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'136', E'Iles Cayman', E'KY', E'CYM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'140', E'République centrafricaine', E'CF', E'CAF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'148', E'Tchad', E'TD', E'TCD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'152', E'Chili', E'CL', E'CHL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'156', E'Chine', E'CN', E'CHN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'344', E'Hong Kong', E'HK', E'HKG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'446', E'Macao', E'MO', E'MAC');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'162', E'Île Christmas', E'CX', E'CXR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'166', E'Îles Cocos', E'CC', E'CCK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'170', E'Colombie', E'CO', E'COL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'174', E'Comores', E'KM', E'COM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'178', E'République du Congo', E'CG', E'COG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'180', E'République démocratique du Congo', E'CD', E'COD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'184', E'Îles Cook', E'CK', E'COK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'188', E'Costa Rica', E'CR', E'CRI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'384', E'Côte d’Ivoire', E'CI', E'CIV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'191', E'Croatie', E'HR', E'HRV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'192', E'Cuba', E'CU', E'CUB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'196', E'Chypre', E'CY', E'CYP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'203', E'République tchèque', E'CZ', E'CZE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'208', E'Danemark', E'DK', E'DNK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'262', E'Djibouti', E'DJ', E'DJI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'212', E'Dominique', E'DM', E'DMA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'214', E'République dominicaine', E'DO', E'DOM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'218', E'Équateur', E'EC', E'ECU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'818', E'Égypte', E'EG', E'EGY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'222', E'Salvador', E'SV', E'SLV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'226', E'Guinée équatoriale', E'GQ', E'GNQ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'232', E'Érythrée', E'ER', E'ERI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'233', E'Estonie', E'EE', E'EST');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'231', E'Éthiopie', E'ET', E'ETH');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'238', E'Îles Falkland', E'FK', E'FLK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'234', E'Îles Féroé', E'FO', E'FRO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'242', E'Fidji', E'FJ', E'FJI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'246', E'Finlande', E'FI', E'FIN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'250', E'France', E'FR', E'FRA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'254', E'Guyane française', E'GF', E'GUF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'258', E'Polynésie française', E'PF', E'PYF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'260', E'Terres australes et antarctiques françaises', E'TF', E'ATF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'266', E'Gabon', E'GA', E'GAB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'270', E'Gambie', E'GM', E'GMB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'268', E'Géorgie', E'GE', E'GEO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'276', E'Allemagne', E'DE', E'DEU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'288', E'Ghana', E'GH', E'GHA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'292', E'Gibraltar', E'GI', E'GIB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'300', E'Grèce', E'GR', E'GRC');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'304', E'Groenland', E'GL', E'GRL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'308', E'Grenade', E'GD', E'GRD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'312', E'Guadeloupe', E'GP', E'GLP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'316', E'Guam', E'GU', E'GUM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'320', E'Guatemala', E'GT', E'GTM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'831', E'Guernesey', E'GG', E'GGY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'324', E'Guinée', E'GN', E'GIN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'624', E'Guinée-Bissau', E'GW', E'GNB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'328', E'Guyane', E'GY', E'GUY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'332', E'Haïti', E'HT', E'HTI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'334', E'Îles Heard-et-MacDonald', E'HM', E'HMD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'336', E'Saint-Siège (Vatican)', E'VA', E'VAT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'340', E'Honduras', E'HN', E'HND');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'348', E'Hongrie', E'HU', E'HUN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'352', E'Islande', E'IS', E'ISL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'356', E'Inde', E'IN', E'IND');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'360', E'Indonésie', E'ID', E'IDN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'364', E'Iran', E'IR', E'IRN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'368', E'Irak', E'IQ', E'IRQ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'372', E'Irlande', E'IE', E'IRL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'833', E'Ile de Man', E'IM', E'IMN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'376', E'Israël', E'IL', E'ISR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'380', E'Italie', E'IT', E'ITA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'388', E'Jamaïque', E'JM', E'JAM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'392', E'Japon', E'JP', E'JPN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'832', E'Jersey', E'JE', E'JEY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'400', E'Jordanie', E'JO', E'JOR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'398', E'Kazakhstan', E'KZ', E'KAZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'404', E'Kenya', E'KE', E'KEN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'296', E'Kiribati', E'KI', E'KIR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'408', E'Corée du Nord', E'KP', E'PRK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'410', E'Corée du Sud', E'KR', E'KOR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'414', E'Koweït', E'KW', E'KWT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'417', E'Kirghizistan', E'KG', E'KGZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'418', E'Laos', E'LA', E'LAO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'428', E'Lettonie', E'LV', E'LVA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'422', E'Liban', E'LB', E'LBN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'426', E'Lesotho', E'LS', E'LSO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'430', E'Libéria', E'LR', E'LBR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'434', E'Libye', E'LY', E'LBY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'438', E'Liechtenstein', E'LI', E'LIE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'440', E'Lituanie', E'LT', E'LTU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'442', E'Luxembourg', E'LU', E'LUX');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'807', E'Macédoine', E'MK', E'MKD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'450', E'Madagascar', E'MG', E'MDG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'454', E'Malawi', E'MW', E'MWI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'458', E'Malaisie', E'MY', E'MYS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'462', E'Maldives', E'MV', E'MDV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'466', E'Mali', E'ML', E'MLI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'470', E'Malte', E'MT', E'MLT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'584', E'Îles Marshall', E'MH', E'MHL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'474', E'Martinique', E'MQ', E'MTQ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'478', E'Mauritanie', E'MR', E'MRT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'480', E'Maurice', E'MU', E'MUS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'175', E'Mayotte', E'YT', E'MYT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'484', E'Mexique', E'MX', E'MEX');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'583', E'Micronésie', E'FM', E'FSM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'498', E'Moldavie', E'MD', E'MDA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'492', E'Monaco', E'MC', E'MCO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'496', E'Mongolie', E'MN', E'MNG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'499', E'Monténégro', E'ME', E'MNE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'500', E'Montserrat', E'MS', E'MSR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'504', E'Maroc', E'MA', E'MAR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'508', E'Mozambique', E'MZ', E'MOZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'104', E'Myanmar', E'MM', E'MMR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'516', E'Namibie', E'NA', E'NAM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'520', E'Nauru', E'NR', E'NRU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'524', E'Népal', E'NP', E'NPL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'528', E'Pays-Bas', E'NL', E'NLD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'540', E'Nouvelle-Calédonie', E'NC', E'NCL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'554', E'Nouvelle-Zélande', E'NZ', E'NZL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'558', E'Nicaragua', E'NI', E'NIC');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'562', E'Niger', E'NE', E'NER');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'566', E'Nigeria', E'NG', E'NGA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'570', E'Niue', E'NU', E'NIU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'574', E'Île Norfolk', E'NF', E'NFK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'580', E'Îles Mariannes du Nord', E'MP', E'MNP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'578', E'Norvège', E'NO', E'NOR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'512', E'Oman', E'OM', E'OMN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'586', E'Pakistan', E'PK', E'PAK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'585', E'Palau', E'PW', E'PLW');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'275', E'Palestine', E'PS', E'PSE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'591', E'Panama', E'PA', E'PAN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'598', E'Papouasie-Nouvelle-Guinée', E'PG', E'PNG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'600', E'Paraguay', E'PY', E'PRY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'604', E'Pérou', E'PE', E'PER');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'608', E'Philippines', E'PH', E'PHL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'612', E'Pitcairn', E'PN', E'PCN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'616', E'Pologne', E'PL', E'POL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'620', E'Portugal', E'PT', E'PRT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'630', E'Puerto Rico', E'PR', E'PRI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'634', E'Qatar', E'QA', E'QAT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'638', E'Réunion', E'RE', E'REU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'642', E'Roumanie', E'RO', E'ROU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'643', E'Russie', E'RU', E'RUS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'646', E'Rwanda', E'RW', E'RWA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'652', E'Saint-Barthélemy', E'BL', E'BLM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'654', E'Sainte-Hélène', E'SH', E'SHN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'659', E'Saint-Kitts-et-Nevis', E'KN', E'KNA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'662', E'Sainte-Lucie', E'LC', E'LCA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'663', E'Saint-Martin (partie française)', E'MF', E'MAF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'534', E'Saint-Martin (partie néerlandaise)', E'SX', E'SXM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'666', E'Saint-Pierre-et-Miquelon', E'PM', E'SPM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'670', E'Saint-Vincent-et-les Grenadines', E'VC', E'VCT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'882', E'Samoa', E'WS', E'WSM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'674', E'Saint-Marin', E'SM', E'SMR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'678', E'Sao Tomé-et-Principe', E'ST', E'STP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'682', E'Arabie Saoudite', E'SA', E'SAU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'686', E'Sénégal', E'SN', E'SEN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'688', E'Serbie', E'RS', E'SRB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'690', E'Seychelles', E'SC', E'SYC');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'694', E'Sierra Leone', E'SL', E'SLE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'702', E'Singapour', E'SG', E'SGP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'703', E'Slovaquie', E'SK', E'SVK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'705', E'Slovénie', E'SI', E'SVN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'90', E'Îles Salomon', E'SB', E'SLB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'706', E'Somalie', E'SO', E'SOM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'710', E'Afrique du Sud', E'ZA', E'ZAF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'239', E'Géorgie du Sud et les îles Sandwich du Sud', E'GS', E'SGS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'728', E'Sud-Soudan', E'SS', E'SSD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'724', E'Espagne', E'ES', E'ESP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'144', E'Sri Lanka', E'LK', E'LKA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'736', E'Soudan', E'SD', E'SDN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'740', E'Suriname', E'SR', E'SUR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'744', E'Svalbard et Jan Mayen', E'SJ', E'SJM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'748', E'Eswatini', E'SZ', E'SWZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'752', E'Suède', E'SE', E'SWE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'756', E'Suisse', E'CH', E'CHE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'760', E'Syrie', E'SY', E'SYR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'158', E'Taiwan', E'TW', E'TWN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'762', E'Tadjikistan', E'TJ', E'TJK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'834', E'Tanzanie', E'TZ', E'TZA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'764', E'Thaïlande', E'TH', E'THA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'626', E'Timor-Leste', E'TL', E'TLS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'768', E'Togo', E'TG', E'TGO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'772', E'Tokelau', E'TK', E'TKL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'776', E'Tonga', E'TO', E'TON');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'780', E'Trinité-et-Tobago', E'TT', E'TTO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'788', E'Tunisie', E'TN', E'TUN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'792', E'Turquie', E'TR', E'TUR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'795', E'Turkménistan', E'TM', E'TKM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'796', E'Îles Turques-et-Caïques', E'TC', E'TCA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'798', E'Tuvalu', E'TV', E'TUV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'800', E'Ouganda', E'UG', E'UGA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'804', E'Ukraine', E'UA', E'UKR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'784', E'Émirats Arabes Unis', E'AE', E'ARE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'826', E'Royaume-Uni', E'GB', E'GBR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'840', E'États-Unis', E'US', E'USA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'581', E'Îles mineures éloignées des États-Unis', E'UM', E'UMI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'858', E'Uruguay', E'UY', E'URY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'860', E'Ouzbékistan', E'UZ', E'UZB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'548', E'Vanuatu', E'VU', E'VUT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'862', E'Venezuela', E'VE', E'VEN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'704', E'Viêt Nam', E'VN', E'VNM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'850', E'Îles Vierges américaines', E'VI', E'VIR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'876', E'Wallis-et-Futuna', E'WF', E'WLF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'732', E'Sahara occidental', E'EH', E'ESH');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'887', E'Yémen', E'YE', E'YEM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'894', E'Zambie', E'ZM', E'ZMB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'716', E'Zimbabwe', E'ZW', E'ZWE');
-- ddl-end --

-- object: country_code2_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.country_code2_idx CASCADE;
CREATE INDEX country_code2_idx ON col.country
	USING btree
	(
	  country_code2
	);

alter table col.sample add column country_id integer;
alter table col.sampling_place add column country_id integer;

ALTER TABLE col.sample ADD CONSTRAINT country_fk FOREIGN KEY (country_id)
REFERENCES col.country (country_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE col.sampling_place ADD CONSTRAINT country_fk FOREIGN KEY (country_id)
REFERENCES col.country (country_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
CREATE INDEX country_id_idx ON col.sample
	USING btree
	(
	  country_id
	);

alter table col.identifier_type alter column identifier_type_code drop not null;

CREATE OR REPLACE VIEW col.v_object_identifier
(
  uid,
  identifiers
)
AS 
 SELECT object_identifier.uid,
    array_to_string(array_agg((
    case when identifier_type_code is not null then identifier_type.identifier_type_code else identifier_type_name end ::text || ':'::text) || object_identifier.object_identifier_value::text 
    ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM col.object_identifier
     JOIN col.identifier_type USING (identifier_type_id)
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;
  
alter table col.campaign_regulation 
drop constraint campaign_regulation_pk,
add column campaign_regulation_id serial,
add column authorization_number varchar,
add column authorization_date timestamp,
add constraint campaign_regulation_pk primary key (campaign_regulation_id)
;
COMMENT ON COLUMN col.campaign_regulation.authorization_number IS E'Number of the authorization';
-- ddl-end --
COMMENT ON COLUMN col.campaign_regulation.authorization_date IS E'Date of the authorization';
CREATE INDEX authorization_number_idx ON col.campaign_regulation
	USING gin
	(
	  authorization_number
	);
	
