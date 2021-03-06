-- MySQL dump 10.14  Distrib 5.5.68-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: dnsmon
-- ------------------------------------------------------
-- Server version       5.5.68-MariaDB-cll-lve

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `updates`
--

DROP TABLE IF EXISTS `updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `updates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(253) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1424 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `updates`
--

LOCK TABLES `updates` WRITE;
/*!40000 ALTER TABLE `updates` DISABLE KEYS */;
/*!40000 ALTER TABLE `updates` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;



--
-- Table structure for table `updates_web`
--

DROP TABLE IF EXISTS `updates_web`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `updates_web` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(253) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1424 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `updates_web`
--

LOCK TABLES `updates_web` WRITE;
/*!40000 ALTER TABLE `updates_web` DISABLE KEYS */;
/*!40000 ALTER TABLE `updates_web` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


--
-- Table structure for table `webdomain_options`
--

DROP TABLE IF EXISTS `webdomain_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webdomain_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(253) NOT NULL,
  `botguard` char(3) NOT NULL DEFAULT 'off',
  `l7filter` char(3) NOT NULL DEFAULT 'off',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1424 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webdomain_options`
--

LOCK TABLES `webdomain_options` WRITE;
/*!40000 ALTER TABLE `webdomain_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `webdomain_options` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-28 16:24:14

DELIMITER //

CREATE TRIGGER `powerdns`.`insert_record` AFTER INSERT ON `powerdns`.`records`
FOR EACH ROW
BEGIN
   SELECT `name` INTO @domain FROM `powerdns`.`domains` WHERE id = NEW.domain_id;
   INSERT INTO `dnsmon`.`updates` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   DELETE FROM `dnsmon`.`updates` WHERE domain = 'tech.adman.website';
   DELETE FROM `dnsmon`.`updates_web` WHERE domain = 'tech.adman.website';
END//

CREATE TRIGGER `powerdns`.`update_record` AFTER UPDATE ON `powerdns`.`records`
FOR EACH ROW
BEGIN
   SELECT `name` INTO @domain FROM `powerdns`.`domains` WHERE id = NEW.domain_id;
   INSERT INTO `dnsmon`.`updates` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   DELETE FROM `dnsmon`.`updates` WHERE domain = 'tech.adman.website';
   DELETE FROM `dnsmon`.`updates_web` WHERE domain = 'tech.adman.website';
END//

CREATE TRIGGER `powerdns`.`delete_record` AFTER DELETE ON `powerdns`.`records`
FOR EACH ROW
BEGIN
   SELECT `name` INTO @domain FROM `powerdns`.`domains` WHERE id = OLD.domain_id;
   INSERT INTO `dnsmon`.`updates` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   DELETE FROM `dnsmon`.`updates` WHERE domain = 'tech.adman.website';
   DELETE FROM `dnsmon`.`updates_web` WHERE domain = 'tech.adman.website';
END//

CREATE TRIGGER `ispmgr`.`update_record` AFTER UPDATE ON `ispmgr`.`webdomain`
FOR EACH ROW
BEGIN
   IF !(NEW.active <=> OLD.active) THEN
      SELECT `name` INTO @domain FROM `ispmgr`.`webdomain` WHERE id = NEW.id;
      INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   END IF;
   IF !(NEW.secure <=> OLD.secure) THEN
      SELECT `name` INTO @domain FROM `ispmgr`.`webdomain` WHERE id = NEW.id;
      INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   END IF;
   IF !(NEW.ssl_cert <=> OLD.ssl_cert) THEN
      SELECT `name` INTO @domain FROM `ispmgr`.`webdomain` WHERE id = NEW.id;
      INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   END IF;
   IF !(NEW.redirect_http <=> OLD.redirect_http) THEN
      SELECT `name` INTO @domain FROM `ispmgr`.`webdomain` WHERE id = NEW.id;
      INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   END IF;
      IF !(NEW.techdomain <=> OLD.techdomain) THEN
      SELECT `name` INTO @domain FROM `ispmgr`.`webdomain` WHERE id = NEW.id;
      INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   END IF;
END//

CREATE TRIGGER `ispmgr`.`update_sslcert` AFTER UPDATE ON `ispmgr`.`sslcert`
FOR EACH ROW
BEGIN
   IF !(NEW.valid_after <=> OLD.valid_after) THEN
      SELECT `name` INTO @domain FROM `ispmgr`.`webdomain` WHERE `webdomain`.`ssl_cert` = NEW.name;
      INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   END IF;
   IF !(NEW.type <=> OLD.type) THEN
      SELECT `name` INTO @domain FROM `ispmgr`.`webdomain` WHERE `webdomain`.`ssl_cert` = NEW.name;
      INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   END IF;
END//

-- CREATE TRIGGER `ispmgr`.`insert_webdomain` AFTER INSERT ON `ispmgr`.`webdomain`
-- FOR EACH ROW
-- BEGIN
--    SELECT `name` INTO @domain FROM `ispmgr`.`webdomain` WHERE `webdomain`.`id` = NEW.id;
--    INSERT INTO `dnsmon`.`webdomain_options` Set domain = @domain;
-- END//


CREATE TRIGGER `ispmgr`.`delete_webdomain` BEFORE DELETE ON `ispmgr`.`webdomain`
FOR EACH ROW
BEGIN
   SELECT `name` INTO @domain FROM `ispmgr`.`webdomain` WHERE `webdomain`.`id` = OLD.id;
   DELETE FROM `dnsmon`.`webdomain_options` where domain = @domain;
END//



CREATE TRIGGER `ispmgr`.`insert_ipaddr` AFTER INSERT ON `ispmgr`.`ipaddr`
FOR EACH ROW
BEGIN
   -- SELECT `name` INTO @ipaddr FROM `ispmgr`.`ipaddr` WHERE `ipaddr`.`id` = NEW.id;
   INSERT INTO `dnsmon`.`ipaddr_table` SET ipaddr = NEW.name;
END//

CREATE TRIGGER `dnsmon`.`update_webdomain_options` AFTER UPDATE ON `dnsmon`.`webdomain_options`
FOR EACH ROW
BEGIN
   IF !(NEW.botguard <=> OLD.botguard) THEN
      SELECT `domain` INTO @domain FROM `dnsmon`.`webdomain_options` WHERE id = NEW.id;
      INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   END IF;
   IF !(NEW.l7filter <=> OLD.l7filter) THEN
      SELECT `domain` INTO @domain FROM `dnsmon`.`webdomain_options` WHERE id = NEW.id;
      INSERT INTO `dnsmon`.`updates_web` Set domain = @domain, updated_at = UNIX_TIMESTAMP();
   END IF;
END//


DELIMITER ;
