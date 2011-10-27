# Sequel Pro dump
# Version 2492
# http://code.google.com/p/sequel-pro
#
# Host: localhost (MySQL 5.5.11)
# Database: development
# Generation Time: 2011-07-13 16:20:33 +0100
# ************************************************************

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table acos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `acos`;

CREATE TABLE `acos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `lft` int(10) unsigned DEFAULT NULL,
  `rght` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `acos_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `acos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table address
# ------------------------------------------------------------

DROP TABLE IF EXISTS `address`;

CREATE TABLE `address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `street` varchar(255) DEFAULT NULL,
  `street2` varchar(255) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `postcode` varchar(255) DEFAULT NULL,
  `country_id` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `country_id` (`country_id`),
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `country` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table address_company
# ------------------------------------------------------------

DROP TABLE IF EXISTS `address_company`;

CREATE TABLE `address_company` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address_id` int(10) unsigned NOT NULL,
  `company_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `address_id` (`address_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `address_company_ibfk_1` FOREIGN KEY (`address_id`) REFERENCES `address` (`id`),
  CONSTRAINT `address_company_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table address_person
# ------------------------------------------------------------

DROP TABLE IF EXISTS `address_person`;

CREATE TABLE `address_person` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address_id` int(10) unsigned NOT NULL,
  `person_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `address_id` (`address_id`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `address_person_ibfk_1` FOREIGN KEY (`address_id`) REFERENCES `address` (`id`),
  CONSTRAINT `address_person_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table alert
# ------------------------------------------------------------

DROP TABLE IF EXISTS `alert`;

CREATE TABLE `alert` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `alert_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table aros
# ------------------------------------------------------------

DROP TABLE IF EXISTS `aros`;

CREATE TABLE `aros` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `foreign_key` int(10) unsigned DEFAULT NULL,
  `lft` int(10) unsigned DEFAULT NULL,
  `rght` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `aros_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `aros` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table aros_acos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `aros_acos`;

CREATE TABLE `aros_acos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aro_id` int(10) unsigned NOT NULL,
  `aco_id` int(10) unsigned NOT NULL,
  `_create` char(2) NOT NULL DEFAULT '0',
  `_read` char(2) NOT NULL DEFAULT '0',
  `_update` char(2) NOT NULL DEFAULT '0',
  `_delete` char(2) NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aro_id` (`aro_id`),
  KEY `aco_id` (`aco_id`),
  CONSTRAINT `aros_acos_ibfk_1` FOREIGN KEY (`aro_id`) REFERENCES `aros` (`id`),
  CONSTRAINT `aros_acos_ibfk_2` FOREIGN KEY (`aco_id`) REFERENCES `acos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table article
# ------------------------------------------------------------

DROP TABLE IF EXISTS `article`;

CREATE TABLE `article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `content` longtext,
  `excerpt` text,
  `order` int(10) unsigned DEFAULT NULL,
  `comment_count` int(10) unsigned DEFAULT NULL,
  `enable_comments` tinyint(1) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `cms_state_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `cms_state_id` (`cms_state_id`),
  CONSTRAINT `article_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `article_ibfk_2` FOREIGN KEY (`cms_state_id`) REFERENCES `cms_state` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table article_category
# ------------------------------------------------------------

DROP TABLE IF EXISTS `article_category`;

CREATE TABLE `article_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(10) unsigned DEFAULT NULL,
  `category_id` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `article_id` (`article_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `article_category_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`),
  CONSTRAINT `article_category_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table article_tag
# ------------------------------------------------------------

DROP TABLE IF EXISTS `article_tag`;

CREATE TABLE `article_tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(10) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `article_tag_ibfk_1` FOREIGN KEY (`id`) REFERENCES `article` (`id`),
  CONSTRAINT `article_tag_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table asset
# ------------------------------------------------------------

DROP TABLE IF EXISTS `asset`;

CREATE TABLE `asset` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `mime` varchar(40) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `viewed` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `asset_ibfk_1` FOREIGN KEY (`id`) REFERENCES `client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table audit
# ------------------------------------------------------------

DROP TABLE IF EXISTS `audit`;

CREATE TABLE `audit` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `model` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `params` varchar(255) DEFAULT NULL,
  `ip` int(10) unsigned DEFAULT NULL,
  `browser` varchar(255) DEFAULT NULL,
  `referrer` varchar(100) DEFAULT NULL,
  `method` varchar(10) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `audit_type_id` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table audit_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `audit_type`;

CREATE TABLE `audit_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table band
# ------------------------------------------------------------

DROP TABLE IF EXISTS `band`;

CREATE TABLE `band` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table category
# ------------------------------------------------------------

DROP TABLE IF EXISTS `category`;

CREATE TABLE `category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `description` text,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `lft` int(10) unsigned DEFAULT NULL,
  `rght` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `category_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table client
# ------------------------------------------------------------

DROP TABLE IF EXISTS `client`;

CREATE TABLE `client` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cms_state
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cms_state`;

CREATE TABLE `cms_state` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table comment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `comment`;

CREATE TABLE `comment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(10) unsigned DEFAULT NULL,
  `content` text,
  `order` int(10) unsigned DEFAULT NULL,
  `altered` tinyint(1) DEFAULT NULL,
  `lft` int(10) unsigned DEFAULT NULL,
  `rght` int(10) unsigned DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `cms_state_id` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `article_id` (`article_id`),
  KEY `user_id` (`user_id`),
  KEY `parent_id` (`parent_id`),
  KEY `cms_state_id` (`cms_state_id`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`),
  CONSTRAINT `comment_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `comment_ibfk_4` FOREIGN KEY (`parent_id`) REFERENCES `comment` (`id`),
  CONSTRAINT `comment_ibfk_5` FOREIGN KEY (`cms_state_id`) REFERENCES `cms_state` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table company
# ------------------------------------------------------------

DROP TABLE IF EXISTS `company`;

CREATE TABLE `company` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table company_customer
# ------------------------------------------------------------

DROP TABLE IF EXISTS `company_customer`;

CREATE TABLE `company_customer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `company_customer_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`),
  CONSTRAINT `company_customer_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table continent
# ------------------------------------------------------------

DROP TABLE IF EXISTS `continent`;

CREATE TABLE `continent` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(24) NOT NULL,
  `code` char(2) NOT NULL,
  `latitude` float(10,6) DEFAULT NULL,
  `longitude` float(10,6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

LOCK TABLES `continent` WRITE;
/*!40000 ALTER TABLE `continent` DISABLE KEYS */;
INSERT INTO `continent` (`id`,`name`,`code`,`latitude`,`longitude`)
VALUES
	(1,'Africa','AF',-8.783195,34.508522),
	(2,'Antarctica','AN',-75.250977,-0.071389),
	(3,'Asia','AS',34.047863,100.619652),
	(4,'Europe','EU',54.525963,15.255119),
	(5,'North America','NA',54.525963,-105.255119),
	(6,'Oceania','OC',-29.532804,145.491470),
	(7,'South America','SA',-8.783195,-55.491478);

/*!40000 ALTER TABLE `continent` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table contract
# ------------------------------------------------------------

DROP TABLE IF EXISTS `contract`;

CREATE TABLE `contract` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table contract_employee
# ------------------------------------------------------------

DROP TABLE IF EXISTS `contract_employee`;

CREATE TABLE `contract_employee` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(10) unsigned NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contract_id` (`contract_id`),
  CONSTRAINT `contract_employee_ibfk_1` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`id`),
  CONSTRAINT `contract_employee_ibfk_2` FOREIGN KEY (`id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table country
# ------------------------------------------------------------

DROP TABLE IF EXISTS `country`;

CREATE TABLE `country` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `code` char(2) NOT NULL,
  `continent_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `continent_id` (`continent_id`),
  CONSTRAINT `country_ibfk_1` FOREIGN KEY (`continent_id`) REFERENCES `continent` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table customer
# ------------------------------------------------------------

DROP TABLE IF EXISTS `customer`;

CREATE TABLE `customer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table customer_person
# ------------------------------------------------------------

DROP TABLE IF EXISTS `customer_person`;

CREATE TABLE `customer_person` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL,
  `person_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `customer_person_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`),
  CONSTRAINT `customer_person_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table department
# ------------------------------------------------------------

DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table department_employee
# ------------------------------------------------------------

DROP TABLE IF EXISTS `department_employee`;

CREATE TABLE `department_employee` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` int(10) unsigned NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `from` date DEFAULT NULL,
  `to` date DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `department_employee_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`),
  CONSTRAINT `department_employee_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table email
# ------------------------------------------------------------

DROP TABLE IF EXISTS `email`;

CREATE TABLE `email` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(96) NOT NULL,
  `email_type_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email_type_id` (`email_type_id`),
  CONSTRAINT `email_ibfk_1` FOREIGN KEY (`email_type_id`) REFERENCES `email_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table email_person
# ------------------------------------------------------------

DROP TABLE IF EXISTS `email_person`;

CREATE TABLE `email_person` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email_id` int(10) unsigned NOT NULL,
  `person_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email_id` (`email_id`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `email_person_ibfk_1` FOREIGN KEY (`email_id`) REFERENCES `email` (`id`),
  CONSTRAINT `email_person_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table email_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `email_type`;

CREATE TABLE `email_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` char(3) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table employee
# ------------------------------------------------------------

DROP TABLE IF EXISTS `employee`;

CREATE TABLE `employee` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `person_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table employee_location
# ------------------------------------------------------------

DROP TABLE IF EXISTS `employee_location`;

CREATE TABLE `employee_location` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(10) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `location_id` (`location_id`),
  CONSTRAINT `employee_location_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`),
  CONSTRAINT `employee_location_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table employee_position
# ------------------------------------------------------------

DROP TABLE IF EXISTS `employee_position`;

CREATE TABLE `employee_position` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(10) unsigned NOT NULL,
  `position_id` int(10) unsigned NOT NULL,
  `from` date DEFAULT NULL,
  `to` date DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `position_id` (`position_id`),
  CONSTRAINT `employee_position_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`),
  CONSTRAINT `employee_position_ibfk_2` FOREIGN KEY (`position_id`) REFERENCES `position` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table employee_shift
# ------------------------------------------------------------

DROP TABLE IF EXISTS `employee_shift`;

CREATE TABLE `employee_shift` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(10) unsigned NOT NULL,
  `shift_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `shift_id` (`shift_id`),
  CONSTRAINT `employee_shift_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`),
  CONSTRAINT `employee_shift_ibfk_2` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `item`;

CREATE TABLE `item` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `order` int(10) unsigned DEFAULT NULL,
  `navigation_id` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `navigation_id` (`navigation_id`),
  CONSTRAINT `item_ibfk_1` FOREIGN KEY (`navigation_id`) REFERENCES `navigation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table language
# ------------------------------------------------------------

DROP TABLE IF EXISTS `language`;

CREATE TABLE `language` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(64) DEFAULT NULL,
  `language_type_id` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `language_type_id` (`language_type_id`),
  CONSTRAINT `language_ibfk_1` FOREIGN KEY (`language_type_id`) REFERENCES `language_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table language_person
# ------------------------------------------------------------

DROP TABLE IF EXISTS `language_person`;

CREATE TABLE `language_person` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `language_id` int(10) unsigned NOT NULL,
  `person_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `language_id` (`language_id`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `language_person_ibfk_1` FOREIGN KEY (`language_id`) REFERENCES `language` (`id`),
  CONSTRAINT `language_person_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table language_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `language_type`;

CREATE TABLE `language_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table link
# ------------------------------------------------------------

DROP TABLE IF EXISTS `link`;

CREATE TABLE `link` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `url` text NOT NULL,
  `description` text,
  `image` varchar(255) DEFAULT NULL,
  `order` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table link_person
# ------------------------------------------------------------

DROP TABLE IF EXISTS `link_person`;

CREATE TABLE `link_person` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `link_id` int(10) unsigned NOT NULL,
  `person_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `person_id` (`person_id`),
  KEY `link_id` (`link_id`),
  CONSTRAINT `link_person_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`),
  CONSTRAINT `link_person_ibfk_3` FOREIGN KEY (`link_id`) REFERENCES `link` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table location
# ------------------------------------------------------------

DROP TABLE IF EXISTS `location`;

CREATE TABLE `location` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table message
# ------------------------------------------------------------

DROP TABLE IF EXISTS `message`;

CREATE TABLE `message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `state_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `state_id` (`state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table navigation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `navigation`;

CREATE TABLE `navigation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `order` int(10) unsigned DEFAULT NULL,
  `state_id` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `state_id` (`state_id`),
  CONSTRAINT `navigation_ibfk_1` FOREIGN KEY (`state_id`) REFERENCES `cms_state` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table person
# ------------------------------------------------------------

DROP TABLE IF EXISTS `person`;

CREATE TABLE `person` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` int(10) unsigned NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `other_names` varchar(255) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('Male','Female') DEFAULT NULL,
  `gov_num` varchar(255) DEFAULT NULL,
  `ip` int(10) unsigned DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `driving_licence` tinyint(1) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table phone
# ------------------------------------------------------------

DROP TABLE IF EXISTS `phone`;

CREATE TABLE `phone` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `number` varchar(50) DEFAULT NULL,
  `phone_type_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `phone_type_id` (`phone_type_id`),
  CONSTRAINT `phone_ibfk_1` FOREIGN KEY (`phone_type_id`) REFERENCES `phone_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table phone_person
# ------------------------------------------------------------

DROP TABLE IF EXISTS `phone_person`;

CREATE TABLE `phone_person` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone_id` int(10) unsigned NOT NULL,
  `person_id` int(10) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `phone_id` (`phone_id`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `phone_person_ibfk_1` FOREIGN KEY (`phone_id`) REFERENCES `phone` (`id`),
  CONSTRAINT `phone_person_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table phone_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `phone_type`;

CREATE TABLE `phone_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` char(2) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table position
# ------------------------------------------------------------

DROP TABLE IF EXISTS `position`;

CREATE TABLE `position` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `band_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `band_id` (`band_id`),
  CONSTRAINT `position_ibfk_1` FOREIGN KEY (`band_id`) REFERENCES `band` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table request
# ------------------------------------------------------------

DROP TABLE IF EXISTS `request`;

CREATE TABLE `request` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table schedule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `schedule`;

CREATE TABLE `schedule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table SEQUENCE
# ------------------------------------------------------------

DROP TABLE IF EXISTS `SEQUENCE`;

CREATE TABLE `SEQUENCE` (
  `SEQ_NAME` varchar(50) NOT NULL,
  `SEQ_COUNT` decimal(38,0) DEFAULT NULL,
  PRIMARY KEY (`SEQ_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `SEQUENCE` WRITE;
/*!40000 ALTER TABLE `SEQUENCE` DISABLE KEYS */;
INSERT INTO `SEQUENCE` (`SEQ_NAME`,`SEQ_COUNT`)
VALUES
	('SEQ_GEN',450);

/*!40000 ALTER TABLE `SEQUENCE` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table setting
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting`;

CREATE TABLE `setting` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(64) DEFAULT NULL,
  `value` longtext,
  `name` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table setting_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting_user`;

CREATE TABLE `setting_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `setting_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `setting_id` (`setting_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `setting_user_ibfk_1` FOREIGN KEY (`setting_id`) REFERENCES `setting` (`id`),
  CONSTRAINT `setting_user_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table shift
# ------------------------------------------------------------

DROP TABLE IF EXISTS `shift`;

CREATE TABLE `shift` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `time_period_id` int(10) unsigned NOT NULL,
  `shift_type_id` int(10) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `time_period_id` (`time_period_id`),
  KEY `shift_type_id` (`shift_type_id`),
  CONSTRAINT `shift_ibfk_1` FOREIGN KEY (`time_period_id`) REFERENCES `time_period` (`id`),
  CONSTRAINT `shift_ibfk_2` FOREIGN KEY (`shift_type_id`) REFERENCES `shift_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table shift_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `shift_type`;

CREATE TABLE `shift_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` char(3) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table state
# ------------------------------------------------------------

DROP TABLE IF EXISTS `state`;

CREATE TABLE `state` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table tag
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tag`;

CREATE TABLE `tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table test
# ------------------------------------------------------------

DROP TABLE IF EXISTS `test`;

CREATE TABLE `test` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table time_period
# ------------------------------------------------------------

DROP TABLE IF EXISTS `time_period`;

CREATE TABLE `time_period` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `start` time DEFAULT NULL,
  `end` time DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table timezone
# ------------------------------------------------------------

DROP TABLE IF EXISTS `timezone`;

CREATE TABLE `timezone` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `gmt` float(4,2) DEFAULT NULL,
  `dst` float(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=411 DEFAULT CHARSET=utf8;

LOCK TABLES `timezone` WRITE;
/*!40000 ALTER TABLE `timezone` DISABLE KEYS */;
INSERT INTO `timezone` (`id`,`name`,`gmt`,`dst`)
VALUES
	(1,'Africa/Abidjan',0.00,0.00),
	(2,'Africa/Accra',0.00,0.00),
	(3,'Africa/Addis_Ababa',3.00,3.00),
	(4,'Africa/Algiers',1.00,1.00),
	(5,'Africa/Asmara',3.00,3.00),
	(6,'Africa/Bamako',0.00,0.00),
	(7,'Africa/Bangui',1.00,1.00),
	(8,'Africa/Banjul',0.00,0.00),
	(9,'Africa/Bissau',0.00,0.00),
	(10,'Africa/Blantyre',2.00,2.00),
	(11,'Africa/Brazzaville',1.00,1.00),
	(12,'Africa/Bujumbura',2.00,2.00),
	(13,'Africa/Cairo',2.00,3.00),
	(14,'Africa/Casablanca',0.00,0.00),
	(15,'Africa/Ceuta',1.00,2.00),
	(16,'Africa/Conakry',0.00,0.00),
	(17,'Africa/Dakar',0.00,0.00),
	(18,'Africa/Dar_es_Salaam',3.00,3.00),
	(19,'Africa/Djibouti',3.00,3.00),
	(20,'Africa/Douala',1.00,1.00),
	(21,'Africa/El_Aaiun',0.00,0.00),
	(22,'Africa/Freetown',0.00,0.00),
	(23,'Africa/Gaborone',2.00,2.00),
	(24,'Africa/Harare',2.00,2.00),
	(25,'Africa/Johannesburg',2.00,2.00),
	(26,'Africa/Kampala',3.00,3.00),
	(27,'Africa/Khartoum',3.00,3.00),
	(28,'Africa/Kigali',2.00,2.00),
	(29,'Africa/Kinshasa',1.00,1.00),
	(30,'Africa/Lagos',1.00,1.00),
	(31,'Africa/Libreville',1.00,1.00),
	(32,'Africa/Lome',0.00,0.00),
	(33,'Africa/Luanda',1.00,1.00),
	(34,'Africa/Lubumbashi',2.00,2.00),
	(35,'Africa/Lusaka',2.00,2.00),
	(36,'Africa/Malabo',1.00,1.00),
	(37,'Africa/Maputo',2.00,2.00),
	(38,'Africa/Maseru',2.00,2.00),
	(39,'Africa/Mbabane',2.00,2.00),
	(40,'Africa/Mogadishu',3.00,3.00),
	(41,'Africa/Monrovia',0.00,0.00),
	(42,'Africa/Nairobi',3.00,3.00),
	(43,'Africa/Ndjamena',1.00,1.00),
	(44,'Africa/Niamey',1.00,1.00),
	(45,'Africa/Nouakchott',0.00,0.00),
	(46,'Africa/Ouagadougou',0.00,0.00),
	(47,'Africa/Porto-Novo',1.00,1.00),
	(48,'Africa/Sao_Tome',0.00,0.00),
	(49,'Africa/Tripoli',2.00,2.00),
	(50,'Africa/Tunis',1.00,1.00),
	(51,'Africa/Windhoek',2.00,1.00),
	(52,'America/Adak',-10.00,-9.00),
	(53,'America/Anchorage',-9.00,-8.00),
	(54,'America/Anguilla',-4.00,-4.00),
	(55,'America/Antigua',-4.00,-4.00),
	(56,'America/Araguaina',-3.00,-3.00),
	(57,'America/Argentina/Buenos_Aires',-3.00,-3.00),
	(58,'America/Argentina/Catamarca',-3.00,-3.00),
	(59,'America/Argentina/Cordoba',-3.00,-3.00),
	(60,'America/Argentina/Jujuy',-3.00,-3.00),
	(61,'America/Argentina/La_Rioja',-3.00,-3.00),
	(62,'America/Argentina/Mendoza',-3.00,-3.00),
	(63,'America/Argentina/Rio_Gallegos',-3.00,-3.00),
	(64,'America/Argentina/Salta',-3.00,-3.00),
	(65,'America/Argentina/San_Juan',-3.00,-3.00),
	(66,'America/Argentina/San_Luis',-3.00,-3.00),
	(67,'America/Argentina/Tucuman',-3.00,-3.00),
	(68,'America/Argentina/Ushuaia',-3.00,-3.00),
	(69,'America/Aruba',-4.00,-4.00),
	(70,'America/Asuncion',-3.00,-4.00),
	(71,'America/Atikokan',-5.00,-5.00),
	(72,'America/Bahia',-3.00,-3.00),
	(73,'America/Bahia_Banderas',-6.00,-5.00),
	(74,'America/Barbados',-4.00,-4.00),
	(75,'America/Belem',-3.00,-3.00),
	(76,'America/Belize',-6.00,-6.00),
	(77,'America/Blanc-Sablon',-4.00,-4.00),
	(78,'America/Boa_Vista',-4.00,-4.00),
	(79,'America/Bogota',-5.00,-5.00),
	(80,'America/Boise',-7.00,-6.00),
	(81,'America/Cambridge_Bay',-7.00,-6.00),
	(82,'America/Campo_Grande',-3.00,-4.00),
	(83,'America/Cancun',-6.00,-5.00),
	(84,'America/Caracas',-4.50,-4.50),
	(85,'America/Cayenne',-3.00,-3.00),
	(86,'America/Cayman',-5.00,-5.00),
	(87,'America/Chicago',-6.00,-5.00),
	(88,'America/Chihuahua',-7.00,-6.00),
	(89,'America/Costa_Rica',-6.00,-6.00),
	(90,'America/Cuiaba',-3.00,-4.00),
	(91,'America/Curacao',-4.00,-4.00),
	(92,'America/Danmarkshavn',0.00,0.00),
	(93,'America/Dawson',-8.00,-7.00),
	(94,'America/Dawson_Creek',-7.00,-7.00),
	(95,'America/Denver',-7.00,-6.00),
	(96,'America/Detroit',-5.00,-4.00),
	(97,'America/Dominica',-4.00,-4.00),
	(98,'America/Edmonton',-7.00,-6.00),
	(99,'America/Eirunepe',-4.00,-4.00),
	(100,'America/El_Salvador',-6.00,-6.00),
	(101,'America/Fortaleza',-3.00,-3.00),
	(102,'America/Glace_Bay',-4.00,-3.00),
	(103,'America/Godthab',-3.00,-2.00),
	(104,'America/Goose_Bay',-4.00,-3.00),
	(105,'America/Grand_Turk',-5.00,-4.00),
	(106,'America/Grenada',-4.00,-4.00),
	(107,'America/Guadeloupe',-4.00,-4.00),
	(108,'America/Guatemala',-6.00,-6.00),
	(109,'America/Guayaquil',-5.00,-5.00),
	(110,'America/Guyana',-4.00,-4.00),
	(111,'America/Halifax',-4.00,-3.00),
	(112,'America/Havana',-5.00,-4.00),
	(113,'America/Hermosillo',-7.00,-7.00),
	(114,'America/Indiana/Indianapolis',-5.00,-4.00),
	(115,'America/Indiana/Knox',-6.00,-5.00),
	(116,'America/Indiana/Marengo',-5.00,-4.00),
	(117,'America/Indiana/Petersburg',-5.00,-4.00),
	(118,'America/Indiana/Tell_City',-6.00,-5.00),
	(119,'America/Indiana/Vevay',-5.00,-4.00),
	(120,'America/Indiana/Vincennes',-5.00,-4.00),
	(121,'America/Indiana/Winamac',-5.00,-4.00),
	(122,'America/Inuvik',-7.00,-6.00),
	(123,'America/Iqaluit',-5.00,-4.00),
	(124,'America/Jamaica',-5.00,-5.00),
	(125,'America/Juneau',-9.00,-8.00),
	(126,'America/Kentucky/Louisville',-5.00,-4.00),
	(127,'America/Kentucky/Monticello',-5.00,-4.00),
	(128,'America/La_Paz',-4.00,-4.00),
	(129,'America/Lima',-5.00,-5.00),
	(130,'America/Los_Angeles',-8.00,-7.00),
	(131,'America/Maceio',-3.00,-3.00),
	(132,'America/Managua',-6.00,-6.00),
	(133,'America/Manaus',-4.00,-4.00),
	(134,'America/Marigot',-4.00,-4.00),
	(135,'America/Martinique',-4.00,-4.00),
	(136,'America/Matamoros',-6.00,-5.00),
	(137,'America/Mazatlan',-7.00,-6.00),
	(138,'America/Menominee',-6.00,-5.00),
	(139,'America/Merida',-6.00,-5.00),
	(140,'America/Metlakatla',0.00,0.00),
	(141,'America/Mexico_City',-6.00,-5.00),
	(142,'America/Miquelon',-3.00,-2.00),
	(143,'America/Moncton',-4.00,-3.00),
	(144,'America/Monterrey',-6.00,-5.00),
	(145,'America/Montevideo',-2.00,-3.00),
	(146,'America/Montreal',-5.00,-4.00),
	(147,'America/Montserrat',-4.00,-4.00),
	(148,'America/Nassau',-5.00,-4.00),
	(149,'America/New_York',-5.00,-4.00),
	(150,'America/Nipigon',-5.00,-4.00),
	(151,'America/Nome',-9.00,-8.00),
	(152,'America/Noronha',-2.00,-2.00),
	(153,'America/North_Dakota/Beulah',-6.00,-5.00),
	(154,'America/North_Dakota/Center',-6.00,-5.00),
	(155,'America/North_Dakota/New_Salem',-6.00,-5.00),
	(156,'America/Ojinaga',-7.00,-6.00),
	(157,'America/Panama',-5.00,-5.00),
	(158,'America/Pangnirtung',-5.00,-4.00),
	(159,'America/Paramaribo',-3.00,-3.00),
	(160,'America/Phoenix',-7.00,-7.00),
	(161,'America/Port-au-Prince',-5.00,-5.00),
	(162,'America/Port_of_Spain',-4.00,-4.00),
	(163,'America/Porto_Velho',-4.00,-4.00),
	(164,'America/Puerto_Rico',-4.00,-4.00),
	(165,'America/Rainy_River',-6.00,-5.00),
	(166,'America/Rankin_Inlet',-6.00,-5.00),
	(167,'America/Recife',-3.00,-3.00),
	(168,'America/Regina',-6.00,-6.00),
	(169,'America/Resolute',-5.00,-5.00),
	(170,'America/Rio_Branco',-4.00,-4.00),
	(171,'America/Santa_Isabel',-8.00,-7.00),
	(172,'America/Santarem',-3.00,-3.00),
	(173,'America/Santiago',-3.00,-4.00),
	(174,'America/Santo_Domingo',-4.00,-4.00),
	(175,'America/Sao_Paulo',-2.00,-3.00),
	(176,'America/Scoresbysund',-1.00,0.00),
	(177,'America/Shiprock',-7.00,-6.00),
	(178,'America/Sitka',0.00,0.00),
	(179,'America/St_Barthelemy',-4.00,-4.00),
	(180,'America/St_Johns',-3.50,-2.50),
	(181,'America/St_Kitts',-4.00,-4.00),
	(182,'America/St_Lucia',-4.00,-4.00),
	(183,'America/St_Thomas',-4.00,-4.00),
	(184,'America/St_Vincent',-4.00,-4.00),
	(185,'America/Swift_Current',-6.00,-6.00),
	(186,'America/Tegucigalpa',-6.00,-6.00),
	(187,'America/Thule',-4.00,-3.00),
	(188,'America/Thunder_Bay',-5.00,-4.00),
	(189,'America/Tijuana',-8.00,-7.00),
	(190,'America/Toronto',-5.00,-4.00),
	(191,'America/Tortola',-4.00,-4.00),
	(192,'America/Vancouver',-8.00,-7.00),
	(193,'America/Whitehorse',-8.00,-7.00),
	(194,'America/Winnipeg',-6.00,-5.00),
	(195,'America/Yakutat',-9.00,-8.00),
	(196,'America/Yellowknife',-7.00,-6.00),
	(197,'Antarctica/Casey',8.00,8.00),
	(198,'Antarctica/Davis',7.00,7.00),
	(199,'Antarctica/DumontDUrville',10.00,10.00),
	(200,'Antarctica/Macquarie',11.00,11.00),
	(201,'Antarctica/Mawson',5.00,5.00),
	(202,'Antarctica/McMurdo',13.00,12.00),
	(203,'Antarctica/Palmer',-3.00,-4.00),
	(204,'Antarctica/Rothera',-3.00,-3.00),
	(205,'Antarctica/South_Pole',13.00,12.00),
	(206,'Antarctica/Syowa',3.00,3.00),
	(207,'Antarctica/Vostok',6.00,6.00),
	(208,'Arctic/Longyearbyen',1.00,2.00),
	(209,'Asia/Aden',3.00,3.00),
	(210,'Asia/Almaty',6.00,6.00),
	(211,'Asia/Amman',2.00,3.00),
	(212,'Asia/Anadyr',11.00,12.00),
	(213,'Asia/Aqtau',5.00,5.00),
	(214,'Asia/Aqtobe',5.00,5.00),
	(215,'Asia/Ashgabat',5.00,5.00),
	(216,'Asia/Baghdad',3.00,3.00),
	(217,'Asia/Bahrain',3.00,3.00),
	(218,'Asia/Baku',4.00,5.00),
	(219,'Asia/Bangkok',7.00,7.00),
	(220,'Asia/Beirut',2.00,3.00),
	(221,'Asia/Bishkek',6.00,6.00),
	(222,'Asia/Brunei',8.00,8.00),
	(223,'Asia/Choibalsan',8.00,8.00),
	(224,'Asia/Chongqing',8.00,8.00),
	(225,'Asia/Colombo',5.50,5.50),
	(226,'Asia/Damascus',2.00,3.00),
	(227,'Asia/Dhaka',6.00,6.00),
	(228,'Asia/Dili',9.00,9.00),
	(229,'Asia/Dubai',4.00,4.00),
	(230,'Asia/Dushanbe',5.00,5.00),
	(231,'Asia/Gaza',2.00,3.00),
	(232,'Asia/Harbin',8.00,8.00),
	(233,'Asia/Ho_Chi_Minh',7.00,7.00),
	(234,'Asia/Hong_Kong',8.00,8.00),
	(235,'Asia/Hovd',7.00,7.00),
	(236,'Asia/Irkutsk',8.00,9.00),
	(237,'Asia/Jakarta',7.00,7.00),
	(238,'Asia/Jayapura',9.00,9.00),
	(239,'Asia/Jerusalem',2.00,3.00),
	(240,'Asia/Kabul',4.50,4.50),
	(241,'Asia/Kamchatka',11.00,12.00),
	(242,'Asia/Karachi',5.00,5.00),
	(243,'Asia/Kashgar',8.00,8.00),
	(244,'Asia/Kathmandu',5.75,5.75),
	(245,'Asia/Kolkata',5.50,5.50),
	(246,'Asia/Krasnoyarsk',7.00,8.00),
	(247,'Asia/Kuala_Lumpur',8.00,8.00),
	(248,'Asia/Kuching',8.00,8.00),
	(249,'Asia/Kuwait',3.00,3.00),
	(250,'Asia/Macau',8.00,8.00),
	(251,'Asia/Magadan',11.00,12.00),
	(252,'Asia/Makassar',8.00,8.00),
	(253,'Asia/Manila',8.00,8.00),
	(254,'Asia/Muscat',4.00,4.00),
	(255,'Asia/Nicosia',2.00,3.00),
	(256,'Asia/Novokuznetsk',6.00,7.00),
	(257,'Asia/Novosibirsk',6.00,7.00),
	(258,'Asia/Omsk',6.00,7.00),
	(259,'Asia/Oral',5.00,5.00),
	(260,'Asia/Phnom_Penh',7.00,7.00),
	(261,'Asia/Pontianak',7.00,7.00),
	(262,'Asia/Pyongyang',9.00,9.00),
	(263,'Asia/Qatar',3.00,3.00),
	(264,'Asia/Qyzylorda',6.00,6.00),
	(265,'Asia/Rangoon',6.50,6.50),
	(266,'Asia/Riyadh',3.00,3.00),
	(267,'Asia/Sakhalin',10.00,11.00),
	(268,'Asia/Samarkand',5.00,5.00),
	(269,'Asia/Seoul',9.00,9.00),
	(270,'Asia/Shanghai',8.00,8.00),
	(271,'Asia/Singapore',8.00,8.00),
	(272,'Asia/Taipei',8.00,8.00),
	(273,'Asia/Tashkent',5.00,5.00),
	(274,'Asia/Tbilisi',4.00,4.00),
	(275,'Asia/Tehran',3.50,4.50),
	(276,'Asia/Thimphu',6.00,6.00),
	(277,'Asia/Tokyo',9.00,9.00),
	(278,'Asia/Ulaanbaatar',8.00,8.00),
	(279,'Asia/Urumqi',8.00,8.00),
	(280,'Asia/Vientiane',7.00,7.00),
	(281,'Asia/Vladivostok',10.00,11.00),
	(282,'Asia/Yakutsk',9.00,10.00),
	(283,'Asia/Yekaterinburg',5.00,6.00),
	(284,'Asia/Yerevan',4.00,5.00),
	(285,'Atlantic/Azores',-1.00,0.00),
	(286,'Atlantic/Bermuda',-4.00,-3.00),
	(287,'Atlantic/Canary',0.00,1.00),
	(288,'Atlantic/Cape_Verde',-1.00,-1.00),
	(289,'Atlantic/Faroe',0.00,1.00),
	(290,'Atlantic/Madeira',0.00,1.00),
	(291,'Atlantic/Reykjavik',0.00,0.00),
	(292,'Atlantic/South_Georgia',-2.00,-2.00),
	(293,'Atlantic/St_Helena',0.00,0.00),
	(294,'Atlantic/Stanley',-3.00,-4.00),
	(295,'Australia/Adelaide',10.50,9.50),
	(296,'Australia/Brisbane',10.00,10.00),
	(297,'Australia/Broken_Hill',10.50,9.50),
	(298,'Australia/Currie',11.00,10.00),
	(299,'Australia/Darwin',9.50,9.50),
	(300,'Australia/Eucla',8.75,8.75),
	(301,'Australia/Hobart',11.00,10.00),
	(302,'Australia/Lindeman',10.00,10.00),
	(303,'Australia/Lord_Howe',11.00,10.50),
	(304,'Australia/Melbourne',11.00,10.00),
	(305,'Australia/Perth',8.00,8.00),
	(306,'Australia/Sydney',11.00,10.00),
	(307,'Europe/Amsterdam',1.00,2.00),
	(308,'Europe/Andorra',1.00,2.00),
	(309,'Europe/Athens',2.00,3.00),
	(310,'Europe/Belgrade',1.00,2.00),
	(311,'Europe/Berlin',1.00,2.00),
	(312,'Europe/Bratislava',1.00,2.00),
	(313,'Europe/Brussels',1.00,2.00),
	(314,'Europe/Bucharest',2.00,3.00),
	(315,'Europe/Budapest',1.00,2.00),
	(316,'Europe/Chisinau',2.00,3.00),
	(317,'Europe/Copenhagen',1.00,2.00),
	(318,'Europe/Dublin',0.00,1.00),
	(319,'Europe/Gibraltar',1.00,2.00),
	(320,'Europe/Guernsey',0.00,1.00),
	(321,'Europe/Helsinki',2.00,3.00),
	(322,'Europe/Isle_of_Man',0.00,1.00),
	(323,'Europe/Istanbul',2.00,3.00),
	(324,'Europe/Jersey',0.00,1.00),
	(325,'Europe/Kaliningrad',2.00,3.00),
	(326,'Europe/Kiev',2.00,3.00),
	(327,'Europe/Lisbon',0.00,1.00),
	(328,'Europe/Ljubljana',1.00,2.00),
	(329,'Europe/London',0.00,1.00),
	(330,'Europe/Luxembourg',1.00,2.00),
	(331,'Europe/Madrid',1.00,2.00),
	(332,'Europe/Malta',1.00,2.00),
	(333,'Europe/Mariehamn',2.00,3.00),
	(334,'Europe/Minsk',2.00,3.00),
	(335,'Europe/Monaco',1.00,2.00),
	(336,'Europe/Moscow',3.00,4.00),
	(337,'Europe/Oslo',1.00,2.00),
	(338,'Europe/Paris',1.00,2.00),
	(339,'Europe/Podgorica',1.00,2.00),
	(340,'Europe/Prague',1.00,2.00),
	(341,'Europe/Riga',2.00,3.00),
	(342,'Europe/Rome',1.00,2.00),
	(343,'Europe/Samara',3.00,4.00),
	(344,'Europe/San_Marino',1.00,2.00),
	(345,'Europe/Sarajevo',1.00,2.00),
	(346,'Europe/Simferopol',2.00,3.00),
	(347,'Europe/Skopje',1.00,2.00),
	(348,'Europe/Sofia',2.00,3.00),
	(349,'Europe/Stockholm',1.00,2.00),
	(350,'Europe/Tallinn',2.00,3.00),
	(351,'Europe/Tirane',1.00,2.00),
	(352,'Europe/Uzhgorod',2.00,3.00),
	(353,'Europe/Vaduz',1.00,2.00),
	(354,'Europe/Vatican',1.00,2.00),
	(355,'Europe/Vienna',1.00,2.00),
	(356,'Europe/Vilnius',2.00,3.00),
	(357,'Europe/Volgograd',3.00,4.00),
	(358,'Europe/Warsaw',1.00,2.00),
	(359,'Europe/Zagreb',1.00,2.00),
	(360,'Europe/Zaporozhye',2.00,3.00),
	(361,'Europe/Zurich',1.00,2.00),
	(362,'Indian/Antananarivo',3.00,3.00),
	(363,'Indian/Chagos',6.00,6.00),
	(364,'Indian/Christmas',7.00,7.00),
	(365,'Indian/Cocos',6.50,6.50),
	(366,'Indian/Comoro',3.00,3.00),
	(367,'Indian/Kerguelen',5.00,5.00),
	(368,'Indian/Mahe',4.00,4.00),
	(369,'Indian/Maldives',5.00,5.00),
	(370,'Indian/Mauritius',4.00,4.00),
	(371,'Indian/Mayotte',3.00,3.00),
	(372,'Indian/Reunion',4.00,4.00),
	(373,'Pacific/Apia',-10.00,-11.00),
	(374,'Pacific/Auckland',13.00,12.00),
	(375,'Pacific/Chatham',13.75,12.75),
	(376,'Pacific/Chuuk',10.00,10.00),
	(377,'Pacific/Easter',-5.00,-6.00),
	(378,'Pacific/Efate',11.00,11.00),
	(379,'Pacific/Enderbury',13.00,13.00),
	(380,'Pacific/Fakaofo',-10.00,-10.00),
	(381,'Pacific/Fiji',13.00,12.00),
	(382,'Pacific/Funafuti',12.00,12.00),
	(383,'Pacific/Galapagos',-6.00,-6.00),
	(384,'Pacific/Gambier',-9.00,-9.00),
	(385,'Pacific/Guadalcanal',11.00,11.00),
	(386,'Pacific/Guam',10.00,10.00),
	(387,'Pacific/Honolulu',-10.00,-10.00),
	(388,'Pacific/Johnston',-10.00,-10.00),
	(389,'Pacific/Kiritimati',14.00,14.00),
	(390,'Pacific/Kosrae',11.00,11.00),
	(391,'Pacific/Kwajalein',12.00,12.00),
	(392,'Pacific/Majuro',12.00,12.00),
	(393,'Pacific/Marquesas',-9.50,-9.50),
	(394,'Pacific/Midway',-11.00,-11.00),
	(395,'Pacific/Nauru',12.00,12.00),
	(396,'Pacific/Niue',-11.00,-11.00),
	(397,'Pacific/Norfolk',11.50,11.50),
	(398,'Pacific/Noumea',11.00,11.00),
	(399,'Pacific/Pago_Pago',-11.00,-11.00),
	(400,'Pacific/Palau',9.00,9.00),
	(401,'Pacific/Pitcairn',-8.00,-8.00),
	(402,'Pacific/Pohnpei',11.00,11.00),
	(403,'Pacific/Port_Moresby',10.00,10.00),
	(404,'Pacific/Rarotonga',-10.00,-10.00),
	(405,'Pacific/Saipan',10.00,10.00),
	(406,'Pacific/Tahiti',-10.00,-10.00),
	(407,'Pacific/Tarawa',12.00,12.00),
	(408,'Pacific/Tongatapu',13.00,13.00),
	(409,'Pacific/Wake',12.00,12.00),
	(410,'Pacific/Wallis',12.00,12.00);

/*!40000 ALTER TABLE `timezone` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `password` char(40) NOT NULL,
  `cookie` varchar(64) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `person_id` int(10) DEFAULT NULL,
  `user_state_id` int(10) unsigned NOT NULL DEFAULT '1',
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_state_id` (`user_state_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`user_state_id`) REFERENCES `user_state` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table user_state
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_state`;

CREATE TABLE `user_state` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `code` char(3) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;






/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
