

--CREATE USER 'hackrod_user'@'localhost' IDENTIFIED BY 'HR78GG42';
--GRANT SELECT,INSERT,UPDATE,DELETE ON hackrod.* TO 'hackrod_user'@'localhost';



DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


LOCK TABLES `categories` WRITE;
INSERT INTO `categories` VALUES (1,'Distribution'),(2,'Math');
UNLOCK TABLES;



DROP TABLE IF EXISTS `packages`;
CREATE TABLE `packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `pkgfilename` varchar(255) DEFAULT NULL,
  `babelfilename` varchar(255) DEFAULT NULL,
  `synopsis` varchar(255) DEFAULT NULL,
  `description` text,
  `author` varchar(255) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `copyright` varchar(255) DEFAULT NULL,
  `maintainer` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `depend` varchar(255) DEFAULT NULL,
  `exposes` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_packages_on_name_and_version` (`name`,`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


LOCK TABLES `packages` WRITE;
INSERT INTO `packages` VALUES (1,'babel','0.1.0','babel-0.1.0.tar.gz','babel.babel',NULL,'Babel framework: Specifies a common interface for programmers to more easily build their applications in portable way.','Dominik Picheta',NULL,NULL,NULL,1,NULL,NULL,'2011-02-20 17:42:42','2011-02-20 17:42:42');
UNLOCK TABLES;




DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(128) NOT NULL DEFAULT '',
  `password_salt` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

