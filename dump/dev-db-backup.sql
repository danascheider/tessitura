-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: development
-- ------------------------------------------------------
-- Server version	5.5.38-0+wheezy1

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
-- Current Database: `development`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `development` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `development`;

--
-- Table structure for table `auditions`
--

DROP TABLE IF EXISTS `auditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `pianist_provided` tinyint(1) DEFAULT NULL,
  `can_bring_own_pianist` tinyint(1) DEFAULT NULL,
  `pianist_fee` double DEFAULT NULL,
  `fee` double DEFAULT NULL,
  `season_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `season_id` (`season_id`),
  CONSTRAINT `auditions_ibfk_1` FOREIGN KEY (`season_id`) REFERENCES `seasons` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditions`
--

LOCK TABLES `auditions` WRITE;
/*!40000 ALTER TABLE `auditions` DISABLE KEYS */;
INSERT INTO `auditions` VALUES (1,'USA','Texas','Austin','2015-03-14',NULL,NULL,'2015-03-14',1,1,15,0,1),(2,'USA','Texas','Austin','2015-04-04',NULL,NULL,'2014-04-04',1,1,15,0,1),(3,'USA','New York','New York City','2014-12-07',NULL,NULL,'2014-12-01',NULL,NULL,NULL,NULL,2),(4,'USA','Florida','Miami','2015-01-18',NULL,NULL,'2015-01-08',NULL,NULL,NULL,NULL,2),(5,'USA','Illinois','Champaign-Urbana','2015-03-14',NULL,NULL,'2015-03-04',NULL,NULL,NULL,NULL,2),(6,'USA','New York','New York City','2015-03-22',NULL,NULL,'2015-03-15',NULL,NULL,NULL,NULL,2),(7,'USA','New York','New York City','2014-12-13',NULL,NULL,NULL,1,1,0,0,4),(8,'USA','New York','New York City','2014-12-14',NULL,NULL,NULL,1,1,0,0,4),(9,'USA','New York','New York City','2014-12-15',NULL,NULL,NULL,1,1,0,0,4),(10,'USA','New York','New York City','2015-02-21',NULL,NULL,NULL,1,1,0,0,4),(11,'USA','New York','New York City','2015-02-22',NULL,NULL,NULL,1,1,0,0,4),(12,'USA','New York','New York City','2015-03-21',NULL,NULL,NULL,1,1,0,0,4),(13,'USA','New York','New York City','2015-03-22',NULL,NULL,NULL,1,1,0,0,4),(14,'USA','California','Los Angeles','2015-01-17',NULL,NULL,'2015-01-17',1,1,0,0,5),(15,'Canada','Toronto','Ontario','2015-01-18',NULL,NULL,'2015-01-18',1,1,0,0,5),(16,'USA','New York','New York City','2015-01-24',NULL,NULL,'2015-01-24',1,1,0,0,5),(17,'USA','Oklahoma','Oklahoma City','2015-01-24',NULL,NULL,'2015-01-24',1,1,0,0,5);
/*!40000 ALTER TABLE `auditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings`
--

DROP TABLE IF EXISTS `listings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `season_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `season_id` (`season_id`),
  CONSTRAINT `listings_ibfk_2` FOREIGN KEY (`season_id`) REFERENCES `seasons` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings`
--

LOCK TABLES `listings` WRITE;
/*!40000 ALTER TABLE `listings` DISABLE KEYS */;
INSERT INTO `listings` VALUES (1,'Spotlight on Opera Program Auditions',NULL,NULL,1),(2,'New York Lyric Opera Theatre Vocal Competition',NULL,NULL,2),(3,'Canto de las Americas',NULL,NULL,3),(4,'Manhattan Opera Studio Summer Festival',NULL,NULL,4),(5,'Professional Fellows, Developing, and Young Artist Vocal Program',NULL,NULL,5);
/*!40000 ALTER TABLE `listings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organizations`
--

DROP TABLE IF EXISTS `organizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organizations` (
  `name` varchar(255) DEFAULT NULL,
  `address_1` varchar(255) DEFAULT NULL,
  `address_2` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `contact_name` varchar(255) DEFAULT NULL,
  `phone_1` varchar(255) DEFAULT NULL,
  `phone_2` varchar(255) DEFAULT NULL,
  `email_1` varchar(255) DEFAULT NULL,
  `email_2` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  `updated_at` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organizations`
--

LOCK TABLES `organizations` WRITE;
/*!40000 ALTER TABLE `organizations` DISABLE KEYS */;
INSERT INTO `organizations` VALUES ('Spotlight on Opera',NULL,NULL,'USA','Austin','Texas',NULL,'http://www.spotlightonopera.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),('New York Lyric Opera Theatre',NULL,NULL,'USA','New York City','New York',NULL,'http://www.newyorklyricopera.org',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2),('Belle Arti Center for the Arts, LLC',NULL,NULL,'USA','Forest Hills','New York',NULL,'http://www.belleartiny.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3),('Manhattan Opera Studio',NULL,NULL,'USA','New York City','New York',NULL,'http://www.manhattanoperastudio.org',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4),('Hawaii Performing Arts Festival',NULL,NULL,'USA','Kamuela','Hawaii',NULL,'http://www.hawaiiperformingartsfestival.org',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5);
/*!40000 ALTER TABLE `organizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programs` (
  `organization_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `min_age` int(11) DEFAULT NULL,
  `max_age` int(11) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `contact_name` varchar(255) DEFAULT NULL,
  `contact_phone` varchar(255) DEFAULT NULL,
  `contact_email` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (1,'Pay-to-sing',15,NULL,'http://www.spotlightonopera.com',NULL,NULL,NULL,1,NULL,NULL,'Spotlight on Opera Program','USA','Texas','Austin'),(2,'Competition',10,35,'http://www.newyorklyricopera.org',NULL,NULL,NULL,2,NULL,NULL,'New York Lyric Opera Theatre Vocal Competition','USA','New York','New York City'),(3,'Training Program',18,35,'http://www.belleartiny.com/cantodelasamericas.html',NULL,NULL,NULL,3,NULL,NULL,'Canto de las Americas','USA','New York','Forest Hills'),(4,'Pay-to-sing',NULL,34,'http://www.manhattanoperastudio.org',NULL,NULL,NULL,4,NULL,NULL,'Manhattan Opera Studio Summer Festival','USA','New York','New York City'),(5,'Pay-to-sing',14,NULL,'http://www.hawaiiperformingartsfestival.org',NULL,NULL,NULL,5,NULL,NULL,'Professional Fellows, Developing and Young Artist Vocal Program','USA','Hawaii','Kamuela');
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs_users`
--

DROP TABLE IF EXISTS `programs_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programs_users` (
  `program_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  KEY `program_id` (`program_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `programs_users_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`),
  CONSTRAINT `programs_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs_users`
--

LOCK TABLES `programs_users` WRITE;
/*!40000 ALTER TABLE `programs_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `programs_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `filename` varchar(255) NOT NULL,
  PRIMARY KEY (`filename`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20140914215616_create_users.rb'),('20140914215823_add_username_and_password_to_users.rb'),('20140914220503_add_first_name_last_name_and_email_to_users.rb'),('20140914224652_require_unique_username_for_users.rb'),('20140914224908_require_unique_email_for_users.rb'),('20140914225023_disallow_null_username_for_users.rb'),('20140914225152_disallow_null_email_and_password_for_users.rb'),('20140914225745_add_birthdate_to_users.rb'),('20140914225945_add_city_country_fach_and_admin_to_users.rb'),('20140914231052_add_timestamps_to_users.rb'),('20140914234548_create_task_lists.rb'),('20140916222632_create_tasks.rb'),('20140916223554_add_position_to_tasks.rb'),('20140916230602_remove_not_null_constraint_from_foreign_key_in_tasks.rb'),('20140927221503_drop_not_null_constraint_on_owner_id_from_tasks.rb'),('20141102193851_drop_position_from_tasks.rb'),('20141117023818_add_backlog_to_tasks.rb'),('20141120183809_add_position_to_tasks.rb'),('20141218225353_create_listings.rb'),('20141218232135_add_type_to_listings.rb'),('20141219065231_create_auditions.rb'),('20141219071638_add_timestamps_and_age_limits_to_listings.rb'),('20141219075311_add_deadline_to_auditions.rb'),('20141219200617_create_users_listings.rb'),('20141219201528_add_listing_id_pianist_provided_can_bring_own_pianist_pianist_fee_and_fee_to_auditions.rb'),('20141219220945_add_stale_to_listings.rb'),('20141220234324_create_organizations.rb'),('20141221000635_create_programs.rb'),('20141221002034_add_primary_key_to_organizations.rb'),('20141221002338_add_primary_key_and_timestamps_to_programs.rb'),('20141221003344_add_name_country_city_and_region_to_programs.rb'),('20141221005944_add_program_id_to_listings.rb'),('20141221010501_remove_program_data_from_listings.rb'),('20141221011702_create_seasons.rb'),('20141221012333_add_stale_to_seasons.rb'),('20141221013533_add_season_id_to_listings.rb'),('20141221054028_drop_program_dates_deadline_and_stale_from_listings.rb'),('20141221054752_add_season_id_and_drop_listing_id_from_auditions.rb'),('20141221091027_drop_listings_users.rb'),('20141221091348_create_programs_users.rb'),('20141221231852_drop_program_id_from_listings.rb');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seasons`
--

DROP TABLE IF EXISTS `seasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `early_bird_deadline` date DEFAULT NULL,
  `priority_deadline` date DEFAULT NULL,
  `final_deadline` date DEFAULT NULL,
  `payments` double DEFAULT NULL,
  `program_fees` double DEFAULT NULL,
  `peripheral_fees` double DEFAULT NULL,
  `application_fee` double DEFAULT NULL,
  `program_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `stale` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `program_id` (`program_id`),
  CONSTRAINT `seasons_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seasons`
--

LOCK TABLES `seasons` WRITE;
/*!40000 ALTER TABLE `seasons` DISABLE KEYS */;
INSERT INTO `seasons` VALUES (1,'2015-07-26','2015-08-16',NULL,NULL,'2015-05-01',NULL,NULL,NULL,NULL,1,NULL,NULL,NULL),(2,'2014-12-07','2015-03-22',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,NULL,NULL,NULL),(3,'2015-08-20','2015-08-30',NULL,NULL,'2015-02-07',NULL,NULL,NULL,NULL,3,NULL,NULL,NULL),(4,'2015-07-19','2015-08-19',NULL,NULL,'2015-03-25',NULL,NULL,NULL,NULL,4,NULL,NULL,NULL),(5,'2015-07-05','2015-07-27',NULL,NULL,'2015-03-15',NULL,NULL,NULL,NULL,5,NULL,NULL,NULL);
/*!40000 ALTER TABLE `seasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_lists`
--

DROP TABLE IF EXISTS `task_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `task_lists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_lists`
--

LOCK TABLES `task_lists` WRITE;
/*!40000 ALTER TABLE `task_lists` DISABLE KEYS */;
INSERT INTO `task_lists` VALUES (1,1,NULL,'2014-10-24 20:59:47',NULL);
/*!40000 ALTER TABLE `task_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_list_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'new',
  `priority` varchar(255) NOT NULL DEFAULT 'normal',
  `deadline` datetime DEFAULT NULL,
  `description` text,
  `owner_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `backlog` tinyint(1) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `task_list_id` (`task_list_id`),
  CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`task_list_id`) REFERENCES `task_lists` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1425 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (8,1,'Determine why hiding task form hides whole panel','Complete','Normal',NULL,NULL,1,'2014-10-24 22:05:47','2014-11-02 13:23:08',NULL,201),(10,1,'Debug create form','Complete','Normal',NULL,NULL,1,'2014-10-24 22:12:28','2014-11-04 17:56:39',NULL,199),(13,1,'Create task list view for dashboard','Complete','Normal',NULL,NULL,1,'2014-10-24 22:19:11','2014-10-30 15:51:11',NULL,196),(17,1,'Figure out why CORS headers work for some resources but not others','Complete','Urgent',NULL,NULL,1,'2014-10-27 13:19:22','2014-10-30 15:04:55',NULL,195),(20,1,'Fix visual for mark complete when other tasks expanded','Complete','Normal',NULL,'When tasks are expanded, they close abruptly when one is marked complete. This should be done more elegantly.',1,'2014-11-02 13:19:16','2014-11-04 17:57:48',NULL,194),(21,1,'Find out why mark complete is returning 422','Complete','Normal',NULL,'Most likely because of a bad content-type.',1,'2014-11-02 13:20:53','2014-11-03 16:29:39',NULL,193),(22,1,'Fix \"hover\" color for task form (inside panel)','Complete','High','2014-11-04 00:00:00','Currently, li:hover within the task panel is set to change the background color. However, This rule should be overriden when the create form is visible in the li. In that case, the background of the entire li should be white.',1,'2014-11-03 16:36:07','2014-11-04 20:24:20',NULL,192),(23,1,'Figure out why new tasks aren\'t being fetched','Complete','Urgent','2014-11-04 00:00:00','The dashboard is supposed to be listening to the create form and responding when the \'ajaxSuccess\' event is triggered. However, the form currently doesn\'t update on Ajax success, and when reloaded, it recognizes the existence of an additional task, but the task details are empty.',1,'2014-11-03 16:39:18','2014-11-04 17:50:31',NULL,191),(24,1,'Get white borders off of the top dash widgets','Complete','Normal',NULL,'The top dash widgets all (except for the .panel-primary one) have 1px white borders around them. Those have to go but efforts to remove them have not been successful.',1,'2014-11-03 16:44:26','2014-11-04 20:22:40',NULL,190),(25,1,'Investigate whether presence of deadlines is causing a problem','Complete','High',NULL,'The tasks that the server is not returning all have deadlines. Maybe one without a deadline will be returned.',1,'2014-11-03 18:38:03','2014-11-03 19:08:19',NULL,189),(26,1,'Investigate why deadline can\'t be retrieved from DB','Complete','Urgent',NULL,NULL,1,'2014-11-03 20:05:01','2014-11-04 17:50:35',NULL,188),(27,1,'Find out data type of the deadline when it comes in','Complete','Urgent','2014-11-05 00:00:00',NULL,1,'2014-11-04 15:38:05','2014-11-04 15:59:33',NULL,187),(28,1,'Determine whether description affects server responses','Complete','High','2014-11-05 00:00:00','It seems presence of a deadline is not the only factor affecting whether a task is returned properly by the server. Need to determine whether presence of the description is another factor.',1,'2014-11-04 16:29:59','2014-11-04 17:50:41',NULL,186),(29,1,'Determine whether description is determining factor in server hiccup','Complete','High',NULL,'Need to know whether the presence of a description alone prevents the server from returning a task properly as a JSON object or if the problem only occurs with the deadline and description together.',1,'2014-11-04 16:31:56','2014-11-04 16:32:14',NULL,185),(32,1,'Format task deadlines nicely for display','Complete','Normal',NULL,NULL,1,'2014-11-04 17:54:44','2014-11-10 11:09:19',NULL,184),(33,1,'Make dashboard task panel re-render when new task added','Complete','Normal',NULL,'Newly created tasks should show up on the list immediately.',1,'2014-11-04 17:56:29','2014-11-07 01:02:51',NULL,183),(34,1,'Add task editing functionality to dashboard task panel','Complete','Urgent',NULL,NULL,1,'2014-11-04 17:58:07','2014-11-13 22:18:58',NULL,182),(35,1,'Make only complete tasks get fetched','Complete','Normal',NULL,NULL,1,'2014-11-04 17:58:28','2014-11-04 19:51:18',NULL,181),(36,1,'Prevent task list widget from extending past last li','Complete','Normal',NULL,'The task list widget extends as if there were some sort of padding or margin down there. There shouldn\'t be.',1,'2014-11-04 18:04:04','2014-11-14 15:09:16',NULL,180),(37,1,'Change text colors for dash task panel','Complete','Normal',NULL,'All these different shades of gray and black are not so nice.',1,'2014-11-04 18:04:36','2014-11-13 14:08:23',NULL,179),(38,1,'Make create form respond to validation errors','Complete','Normal',NULL,NULL,1,'2014-11-04 18:06:22','2014-11-13 14:31:59',NULL,178),(39,1,'Make form submit on enter','Complete','Normal',NULL,NULL,1,'2014-11-04 18:06:30','2014-11-04 18:06:37',NULL,177),(40,1,'Change interface for adding new tasks from the dashboard','Complete','Normal',NULL,'The example I saw that I liked had just a single input at the top so people didn\'t have to click \"new task\" or anything, they just had to type a title and hit enter. That\'s what this should have too.',1,'2014-11-04 18:14:21','2014-11-13 14:08:45',NULL,176),(41,1,'Figure out how user can bring panel back after closing it','Complete','Normal',NULL,'Seems like a lot of people will probably click the x in the right-hand corner accidentally. There should be a way for them to bring it back without too much trouble.',1,'2014-11-04 18:18:17','2014-11-14 15:30:32',NULL,175),(42,1,'Make complete tasks be marked complete on the UI','Complete','Normal',NULL,NULL,1,'2014-11-04 19:52:52','2014-11-06 14:56:57',NULL,174),(43,1,'Make number on top dash widget update when collection changes','Complete','Normal',NULL,'When the task list changes, the top dash widget indicating number of tasks should update itself as well. ',1,'2014-11-04 19:54:12','2014-11-13 14:14:33',NULL,173),(45,1,'Fix mark complete buttons','Complete','Normal',NULL,NULL,1,'2014-11-04 20:46:58','2014-11-04 20:47:08',NULL,172),(47,1,'Check if failure to set dataType caused error callback to be executed','Complete','Normal',NULL,NULL,1,'2014-11-04 20:51:50','2014-11-04 20:51:59',NULL,171),(48,1,'Figure out if dataType: \'application/json\' fixes problem with checkboxes','Complete','Normal',NULL,NULL,1,'2014-11-04 20:58:03','2014-11-04 20:58:10',NULL,170),(49,1,'Figure out what makes the Ajax call permit no response body','Complete','Normal',NULL,NULL,1,'2014-11-04 21:00:07','2014-11-04 21:00:14',NULL,169),(52,1,'Determine if JSON.stringify() helps','Complete','Normal',NULL,NULL,1,'2014-11-04 21:11:52','2014-11-04 21:14:09',NULL,168),(53,1,'Check logs for request body of problem request','Complete','Normal',NULL,NULL,1,'2014-11-04 21:19:36','2014-11-04 21:19:42',NULL,167),(54,1,'Figure out how to log request body','Complete','Normal',NULL,NULL,1,'2014-11-04 21:23:56','2014-11-04 21:26:26',NULL,166),(59,1,'Determine why create form not triggering events properly','Complete','Normal',NULL,NULL,1,'2014-11-05 12:21:28','2014-11-06 14:57:10',NULL,165),(60,1,'Find out if \'create\' listener is screwing up the view','Complete','Normal',NULL,NULL,1,'2014-11-05 12:32:12','2014-11-05 12:35:04',NULL,164),(61,1,'Try that last one again since it was a dumb code mistake','Complete','Normal',NULL,NULL,1,'2014-11-05 12:32:56','2014-11-05 12:35:00',NULL,163),(62,1,'Try that AGAIN again since I changed one error into another','Complete','Normal',NULL,NULL,1,'2014-11-05 12:33:50','2014-11-05 12:34:59',NULL,162),(63,1,'Make sure the last problems weren\'t a result of not refreshing the page','Complete','Normal',NULL,NULL,1,'2014-11-05 12:34:15','2014-11-05 12:34:58',NULL,161),(64,1,'Try another thing for the create form','Complete','Normal',NULL,NULL,1,'2014-11-05 12:35:17','2014-11-05 12:36:13',NULL,160),(65,1,'Find out why render isn\'t called when create event triggered','Complete','Normal',NULL,NULL,1,'2014-11-05 12:35:48','2014-11-05 12:39:21',NULL,159),(66,1,'Try to get create form to add new tasks to list dynamicaly','Complete','Normal',NULL,NULL,1,'2014-11-05 12:39:46','2014-11-05 12:46:32',NULL,158),(67,1,'Make update functionality so I can change sloppy spelling','Complete','High',NULL,NULL,1,'2014-11-05 12:40:56','2014-11-13 22:19:03',NULL,157),(68,1,'Investigate circumstances under which \'add\' triggered on collection','Complete','Normal',NULL,NULL,1,'2014-11-05 12:46:59','2014-11-05 14:39:06',NULL,156),(69,1,'See if create form works now','Complete','Normal',NULL,NULL,1,'2014-11-05 13:48:46','2014-11-05 14:39:05',NULL,155),(70,1,'See if render thing still works','Complete','Normal',NULL,NULL,1,'2014-11-05 13:49:25','2014-11-05 13:52:01',NULL,154),(71,1,'Make Backbone get ID when model added to collection','Complete','Normal',NULL,NULL,1,'2014-11-05 13:52:23','2014-11-05 14:38:59',NULL,153),(72,1,'View data returned from the Ajax call','Complete','Normal',NULL,NULL,1,'2014-11-05 14:11:33','2014-11-05 14:23:02',NULL,152),(73,1,'Check if the create form/collection ajax thing is working','Complete','Normal',NULL,NULL,1,'2014-11-05 14:14:49','2014-11-05 14:39:02',NULL,151),(74,1,'Make sure I didn\'t fuck up and not refresh the page','Complete','Normal',NULL,NULL,1,'2014-11-05 14:20:11','2014-11-05 14:23:00',NULL,150),(75,1,'Find out why \"wait\" isn\'t working','Complete','Normal',NULL,NULL,1,'2014-11-05 14:22:14','2014-11-05 14:38:46',NULL,149),(76,1,'Find out if \"done\" function does the job','Complete','Normal',NULL,NULL,1,'2014-11-05 14:28:45','2014-11-05 14:35:37',NULL,148),(77,1,'Find out if this kind of done function works','Complete','Normal',NULL,NULL,1,'2014-11-05 14:35:26','2014-11-05 14:38:47',NULL,147),(78,1,'Try re-implementing create form update thing with promises','Complete','Normal',NULL,NULL,1,'2014-11-05 19:26:00','2014-11-06 14:40:36',NULL,146),(79,1,'Double check to make sure promise isn\'t broken','Complete','Normal',NULL,NULL,1,'2014-11-06 14:41:40','2014-11-06 14:44:17',NULL,145),(80,1,'Debug promises','Complete','Normal',NULL,NULL,1,'2014-11-06 14:59:51','2014-11-06 15:02:40',NULL,144),(81,1,'Determine why the task list isn\'t updating THIS time','Complete','Normal',NULL,NULL,1,'2014-11-06 15:00:32','2014-11-06 15:02:39',NULL,143),(82,1,'Find out what \"that\" refers to','Complete','Normal',NULL,NULL,1,'2014-11-06 15:01:03','2014-11-06 15:02:38',NULL,142),(83,1,'Check if it works now','Complete','Normal',NULL,NULL,1,'2014-11-06 15:02:20','2014-11-06 15:02:37',NULL,141),(84,1,'Complete some tasks so the list gets shorter','Complete','Normal',NULL,NULL,1,'2014-11-06 15:02:56','2014-11-06 15:14:22',NULL,140),(85,1,'Check if collection is updated properly','Complete','Normal',NULL,NULL,1,'2014-11-06 15:04:12','2014-11-06 15:14:20',NULL,139),(86,1,'Determine where the \'add\' event gets lost','Complete','Normal',NULL,NULL,1,'2014-11-06 15:05:28','2014-11-06 15:14:19',NULL,138),(87,1,'Look elsewhere for mysterious \"add\" event','Complete','Normal',NULL,NULL,1,'2014-11-06 15:07:02','2014-11-06 15:12:09',NULL,137),(88,1,'Testing again ','Complete','Normal',NULL,NULL,1,'2014-11-06 15:07:40','2014-11-07 00:22:05',NULL,136),(89,1,'Just testing again','Complete','Normal',NULL,NULL,1,'2014-11-06 15:09:33','2014-11-07 00:22:06',NULL,135),(90,1,'Testing another time','Complete','Normal',NULL,NULL,1,'2014-11-06 15:09:59','2014-11-07 00:22:08',NULL,134),(91,1,'Find out why form isn\'t resetting and sliding up','Complete','Normal',NULL,NULL,1,'2014-11-06 15:10:27','2014-11-06 15:12:05',NULL,133),(92,1,'Experiment with putting UI changes in callback','Complete','Normal',NULL,NULL,1,'2014-11-06 15:11:39','2014-11-06 15:12:04',NULL,132),(93,1,'Make another effort to figure out exactly why the form refuses to hide itself','Complete','Normal',NULL,NULL,1,'2014-11-06 15:13:17','2014-11-06 15:14:18',NULL,131),(94,1,'Find out why form won\'t reset','Complete','Normal',NULL,NULL,1,'2014-11-06 15:13:33','2014-11-06 15:14:16',NULL,130),(95,1,'Try again to make create form update the list asynchronously','Complete','Normal',NULL,NULL,1,'2014-11-06 15:15:01','2014-11-06 15:16:15',NULL,129),(96,1,'See if fixing variable problem fixed it','Complete','Normal',NULL,NULL,1,'2014-11-06 15:30:58','2014-11-06 15:32:25',NULL,128),(97,1,'Make last attempt to make this work before going to Willa\'s','Complete','Normal',NULL,NULL,1,'2014-11-06 15:32:15','2014-11-06 15:32:24',NULL,127),(98,1,'Break task 120,000 by Tuesday','Complete','Normal',NULL,NULL,1,'2014-11-06 18:53:07','2014-11-06 18:53:18',NULL,126),(99,1,'Determine correct kind of event to use on collection to update view properly','Complete','Normal',NULL,NULL,1,'2014-11-06 19:10:32','2014-11-06 22:48:21',NULL,125),(100,1,'Determine whether Ajax call worked','Complete','Normal',NULL,NULL,1,'2014-11-06 19:15:51','2014-11-06 22:42:59',NULL,124),(114,1,'Check formatting of task list in case title too long','Complete','Normal','2014-11-19 00:00:00','Titles should trail off with \"...\" if they\'re longer than fits in the panel, instead of wrapping onto a second line.',1,'2014-11-07 00:08:27','2014-11-14 15:52:35',NULL,123),(117,1,'Figure out how to add the auth header to all requests by default','Complete','Normal',NULL,'I extracted this into a Utils method again - let\'s make sure everything works like it\'s supposed to',1,'2014-11-07 00:12:17','2014-11-14 16:28:42',NULL,122),(132,1,'Develop detailed specs & documentation for front-end API','Complete','High',NULL,'I\'m working on this, but at this point, there\'s quite a lot to be documented.',1,'2014-11-07 11:53:09','2014-11-14 19:57:50',NULL,121),(133,1,'Implement length limit for dashboard task list','Complete','Normal',NULL,'The dashboard should only show the most important tasks. The dashboard task list should not be arbitrarily long.',1,'2014-11-07 11:54:01','2014-11-14 14:56:37',NULL,120),(134,1,'Implement ability for tasks to be moved on the list','Complete','Normal',NULL,'It is getting very close.',1,'2014-11-07 11:55:11','2014-11-19 11:54:38',NULL,119),(135,1,'Start work on task kanban board view','Complete','Normal',NULL,'This is exciting!',1,'2014-11-07 11:55:30','2014-11-15 21:43:09',NULL,118),(136,1,'Refactor back end','Complete','High',NULL,'Recent experience with front-end development indicates the back end can be somewhat more minimal than it currently is. ',1,'2014-11-07 11:56:54','2014-11-12 19:57:33',NULL,117),(137,1,'Look in to Backbone functionality for scoping collections','Complete','Normal',NULL,'It might be best if the whole idea of the back-end filter were abandoned in favor of front-end filtering. The API for GET requests to  /users/:id/tasks to accept a request body with boolean :all key, with default being that only incomplete tasks are returned.',1,'2014-11-07 11:58:30','2014-11-16 15:07:28',NULL,116),(138,1,'Make top widgets into links','Complete','Normal',NULL,NULL,1,'2014-11-07 12:27:02','2014-11-12 19:57:36',NULL,115),(140,1,'Add functionality to make tasks recurring','New','Normal',NULL,NULL,1,'2014-11-07 13:34:08','2014-12-06 16:55:04',1,18),(141,1,'Set up integration testing before you regret it','Complete','Normal',NULL,'This is a fucking nightmare.',1,'2014-11-07 13:46:27','2014-12-15 12:19:59',NULL,32),(142,1,'Figure out why database keeps breaking Travis builds','Complete','High',NULL,'This is an annoying problem but I guess I should fix it.b',1,'2014-11-07 14:06:02','2014-11-12 19:57:50',NULL,114),(144,1,'Enable users to specify what  a task is blocking on','New','High',NULL,NULL,1,'2014-11-07 14:07:27','2014-12-14 17:17:11',1,11),(146,1,'Add \"forgot password\" link on login form','Complete','Normal',NULL,NULL,1,'2014-11-07 14:12:51','2014-11-14 20:43:37',NULL,113),(147,1,'Adopt more orthodox approach to logging','Complete','Normal',NULL,NULL,1,'2014-11-07 14:28:58','2014-12-05 16:39:34',NULL,46),(1273,1,'Correct vertical alignment of task edit/delete icons','Complete','Normal',NULL,NULL,1,'2014-11-12 20:00:39','2014-11-14 20:03:20',NULL,112),(1274,1,'Check if new add form works','Complete','Normal',NULL,NULL,1,'2014-11-13 13:59:45','2014-11-13 14:00:26',NULL,111),(1275,1,'Debug type error when adding new task','Complete','Normal',NULL,NULL,1,'2014-11-13 14:00:17','2014-11-13 14:00:28',NULL,110),(1276,1,'Fix table spacing on expanded tasks inside dashboard task list view','Complete','Normal',NULL,NULL,1,'2014-11-13 14:07:40','2014-11-14 21:15:10',NULL,109),(1277,1,'Add visual ','Complete','Normal',NULL,'Really the task should just be stuck on the dashboard list at the top.',1,'2014-11-13 14:08:11','2014-11-19 10:59:09',NULL,108),(1278,1,'Check if view updates when task added','Complete','Normal',NULL,NULL,1,'2014-11-13 14:14:16','2014-11-13 14:14:21',NULL,107),(1279,1,'Change div class when submitted task is invalid','Complete','Normal',NULL,NULL,1,'2014-11-13 14:18:35','2014-11-13 14:31:44',NULL,106),(1280,1,'Make sure error goes away when task is entered correctly','Complete','Normal',NULL,NULL,1,'2014-11-13 14:31:33','2014-11-13 14:31:42',NULL,62),(1281,1,'Find way to permanently hide pull-right span when update form displayed','Complete','Normal',NULL,NULL,1,'2014-11-13 15:37:27','2014-11-14 14:54:09',NULL,105),(1282,1,'Change style so edit form is the right width','Complete','Normal',NULL,NULL,1,'2014-11-13 15:37:47','2014-11-14 22:29:50',NULL,104),(1283,1,'Prevent add form from being hidden when edit form displayed','Complete','Normal',NULL,NULL,1,'2014-11-13 15:38:04','2014-11-13 21:57:31',NULL,103),(1284,1,'Make sure quick-add form still works','Complete','Normal',NULL,NULL,1,'2014-11-13 15:51:19','2014-11-13 15:53:18',NULL,102),(1285,1,'Make sure quick-add form doesn\'t trigger event on edit form','Complete','Normal',NULL,NULL,1,'2014-11-13 15:53:33','2014-11-13 15:53:37',NULL,101),(1286,1,'Find out that only one form submission is triggered','Complete','Normal',NULL,NULL,1,'2014-11-13 15:56:17','2014-11-13 22:29:12',NULL,100),(1287,1,'Check if task form works now','Complete','Normal',NULL,NULL,1,'2014-11-13 21:57:10','2014-11-13 21:57:25',NULL,99),(1288,1,'Format edit form to make more clear that \"placeholders\" belong to task currently','Complete','Normal',NULL,NULL,1,'2014-11-13 22:29:54','2014-11-18 12:04:04',NULL,98),(1290,1,'Call crossOff only if status changed to complete!','Complete','Normal',NULL,NULL,1,'2014-11-14 13:56:44','2014-11-14 14:27:43',NULL,97),(1295,1,'See if it works without the promise','Complete','Normal',NULL,NULL,1,'2014-11-14 14:24:10','2014-11-14 14:24:28',NULL,96),(1296,1,'Accomplish more so I don\'t have to create more and more dummy tasks','Complete','Normal',NULL,NULL,1,'2014-11-14 14:26:18','2014-11-14 14:26:24',NULL,95),(1298,1,'Improve task title formatting','Complete','Normal',NULL,'Truncated titles should end with a word, not a partial word.',1,'2014-11-14 15:52:55','2014-11-19 12:05:37',NULL,94),(1299,1,'Check if auth still works','Complete','Normal',NULL,NULL,1,'2014-11-14 16:28:23','2014-11-16 17:44:14',NULL,93),(1300,1,'Reconsider the color of the search bar button','Complete','Normal',NULL,NULL,1,'2014-11-14 19:34:55','2014-11-16 17:44:44',NULL,92),(1301,1,'Add back the \"invalid task\" indicators on the main task view','Complete','Normal',NULL,NULL,1,'2014-11-14 19:48:09','2014-11-16 18:18:35',NULL,91),(1302,1,'Show/hide widget icons should not turn blue-green when hovered on','Complete','Normal',NULL,NULL,1,'2014-11-14 19:50:50','2014-11-16 18:18:41',NULL,90),(1303,1,'Develop detailed specs for front-end API','Blocking','Normal','2014-12-31 00:00:00',NULL,1,'2014-11-14 19:57:58','2014-12-06 17:37:55',NULL,20),(1304,1,'Fix media query - sidebar is huge on iPhone portrait and obscures everything else','New','Low',NULL,NULL,1,'2014-11-14 20:00:51','2014-12-10 21:37:04',1,15),(1305,1,'Fix table spacing issue caused by edit/delete icons','Complete','Normal',NULL,NULL,1,'2014-11-14 21:15:34','2014-11-19 12:07:28',NULL,89),(1306,1,'Figure out what','Complete','Normal',NULL,NULL,1,'2014-11-14 22:34:25','2014-11-19 11:54:49',NULL,88),(1307,1,'Standardize times for slideUp and slideDown for all elements','New','Normal',NULL,NULL,1,'2014-11-15 13:14:47','2014-12-05 22:36:45',1,16),(1308,1,'Make task titles display fully when details are shown','New','Normal',NULL,NULL,1,'2014-11-15 13:19:51','2014-12-06 16:56:21',1,17),(1310,1,'Modify task title truncation to break at word breaks','Complete','Normal',NULL,NULL,1,'2014-11-15 14:01:56','2014-11-20 13:39:10',NULL,87),(1312,1,'Add backlog to task table','Complete','Normal',NULL,NULL,1,'2014-11-15 21:46:42','2014-11-20 13:56:03',NULL,86),(1313,1,'Figure out why it always goes to the dashboard on refresh instead of kanban','Complete','High',NULL,NULL,1,'2014-11-16 13:30:17','2014-12-06 21:07:14',1,53),(1314,1,'Eliminate empty task panel view - should just contain add form','Complete','Normal',NULL,NULL,1,'2014-11-18 12:05:18','2014-12-05 16:45:30',NULL,56),(1315,1,'Find out why mark-complete animation doesn\'t work in Kanban view','Complete','Normal',NULL,NULL,1,'2014-11-18 12:07:22','2014-12-05 22:36:26',NULL,50),(1316,1,'Determine how to change event handlers for \'receive\' events for different views','Complete','Normal',NULL,NULL,1,'2014-11-18 22:54:34','2014-12-05 16:47:05',NULL,85),(1317,1,'Find out why draggable/sortable li\'s expand when dragged','Complete','Normal',NULL,NULL,1,'2014-11-19 09:48:18','2014-12-05 16:47:13',NULL,84),(1318,1,'Remove empty panel view from dashboard task panel','Complete','Normal',NULL,NULL,1,'2014-11-19 10:13:13','2014-12-05 16:47:17',NULL,83),(1319,1,'Find out why there are query strings','Complete','Normal',NULL,NULL,1,'2014-11-19 11:28:04','2014-12-05 16:47:20',NULL,82),(1320,1,'Find out about integrating Google calendars','New','Normal',NULL,NULL,1,'2014-11-19 16:12:45','2014-12-05 23:30:49',1,22),(1322,1,'Find out why sortable items are no longer draggable when moved to different list','Complete','Normal',NULL,NULL,1,'2014-11-19 22:03:40','2014-12-05 23:33:14',NULL,57),(1323,1,'Enable dragging/dropping tasks to empty lists in Kanban board view','Complete','Normal',NULL,NULL,1,'2014-11-19 22:05:17','2014-12-10 13:13:42',NULL,59),(1325,1,'Implement mass-update feature for tasks for positioning purposes','Complete','Normal',NULL,NULL,1,'2014-11-20 13:09:36','2014-12-05 22:05:49',NULL,81),(1326,1,'Shop for sexy underwear','Complete','Urgent',NULL,NULL,1,'2014-12-01 00:25:42','2014-12-05 22:05:52',NULL,80),(1329,1,'Find out why top nav dropdowns don\'t work at all now','New','Normal',NULL,NULL,1,'2014-12-01 00:35:09','2014-12-05 23:41:37',1,24),(1330,1,'Implement front-end logging','New','Normal',NULL,NULL,1,'2014-12-05 16:35:53','2014-12-05 23:31:32',1,28),(1332,1,'Fix issue with draggable tasks not opening properly after being dragged','New','Normal',NULL,NULL,1,'2014-12-05 21:25:02','2014-12-11 12:40:35',1,25),(1333,1,'Find out why some tasks don\'t display properly','Complete','Normal',NULL,'When I switched a task\'s status from \'Complete\' to \'New\' in the database, the task still did not show up on the dash or Kanban board views.',1,'2014-12-05 23:38:49','2014-12-05 23:55:47',NULL,47),(1334,1,'test','Complete','Normal',NULL,NULL,1,'2014-12-05 23:39:06','2014-12-05 23:39:09',NULL,79),(1335,1,'Add tooltips to tasks on dashboard','Complete','Normal',NULL,NULL,1,'2014-12-05 23:39:23','2014-12-06 17:42:58',NULL,60),(1336,1,'Make task update forms not truncate titles','Complete','High',NULL,'Task update forms currently cut off titles longer than a certain length, which then sends the titles in their shortened form with the PUT request. ',1,'2014-12-05 23:46:26','2014-12-06 00:18:06',NULL,49),(1337,1,'Make update forms disappear on submit like they used to','Complete','Normal',NULL,'For some reason, update forms do not always disappear again after they are submitted anymore. ',1,'2014-12-05 23:48:36','2014-12-06 17:58:08',NULL,58),(1338,1,'Fix update forms so li expands with them','Complete','Normal',NULL,'Sometimes, update forms are extending beyond their <li>s. This can\'t happen. (It seems to happen with tasks that have just been added to the list.)',1,'2014-12-05 23:57:24','2014-12-09 21:32:03',0,61),(1339,1,'Escape characters in task titles for tooltip purposes','New','Low',NULL,'Basic solution was to change from single to double quotes in template HTML file; will need a more comprehensive solution in the future.',1,'2014-12-06 00:01:25','2014-12-06 00:12:08',1,19),(1340,1,'Find out why markComplete is now not working on dash panel','Complete','Normal',NULL,NULL,1,'2014-12-06 00:18:20','2014-12-06 00:24:29',NULL,78),(1341,1,'Make users accept terms of use when they register','Blocking','Normal','2014-12-17 00:00:00','Blocking - we don\'t have terms of use yet',1,'2014-12-06 10:59:29','2014-12-11 10:06:22',NULL,12),(1342,1,'Quick-add form should not be draggable/sortable!','Complete','Normal',NULL,NULL,1,'2014-12-06 11:15:52','2014-12-06 16:54:22',NULL,51),(1343,1,'Add password confirmation to registration form','New','Normal',NULL,NULL,1,'2014-12-06 11:33:17','2014-12-11 10:22:19',NULL,13),(1344,1,'Add more information to user profiles','Blocking','Low','2014-12-17 00:00:00','Will need to keep this task in mind and brainstorm what information would be useful.',1,'2014-12-06 11:45:03','2014-12-11 10:05:58',NULL,9),(1345,1,'Find out why deadlines are showing up wrong in IceWeasel','In Progress','Low','2014-12-17 00:00:00',NULL,1,'2014-12-06 11:45:46','2014-12-11 10:23:47',1,23),(1346,1,'Find out why task update forms can\'t be filled out in IceWeasel','New','Low',NULL,NULL,1,'2014-12-06 11:46:18','2014-12-11 11:35:19',NULL,14),(1347,1,'Figure out how to get placeholder text into date fields','New','Normal',NULL,'I\'ll probably end up using jQueryUI for this.',1,'2014-12-06 11:50:03','2014-12-14 17:18:12',NULL,10),(1348,1,'Fix empty task-panel visual','Complete','Low',NULL,'Instead of having a clean end, something sticks out the bottom below the quick-add form when the panel is empty.',1,'2014-12-06 17:23:32','2014-12-11 12:37:41',NULL,45),(1349,1,'Verify that quick-add form works','Complete','Normal',NULL,NULL,1,'2014-12-06 17:24:34','2014-12-06 18:04:10',NULL,77),(1350,1,'Make sure quick-add forms work','Complete','Normal',NULL,NULL,1,'2014-12-06 17:29:54','2014-12-06 18:18:40',NULL,76),(1352,1,'I promise this is the last one checking if quick-add forms work','Complete','Normal',NULL,NULL,1,'2014-12-06 17:31:27','2014-12-06 18:08:45',NULL,75),(1353,1,'Once again, fix mark-complete cross-off stuff in Kanban Board','Complete','Normal',NULL,NULL,1,'2014-12-06 17:34:07','2014-12-11 12:39:52',NULL,48),(1354,1,'Fix default status of kanban-board created tasks','Complete','Normal',NULL,'Tasks created on the Kanban board view need to have their status set on the basis of what column they are created from.',1,'2014-12-06 17:35:24','2014-12-11 09:51:34',NULL,55),(1355,1,'Make sure tasks are removed from views when marked \'blocking\' or backlogged','Complete','Normal',NULL,NULL,1,'2014-12-06 17:38:50','2014-12-11 12:38:31',NULL,52),(1356,1,'Make sure quick-add form is reset after submission','Complete','Normal',NULL,NULL,1,'2014-12-06 17:40:10','2014-12-06 21:18:34',NULL,74),(1357,1,'try again ','Complete','Normal',NULL,NULL,1,'2014-12-06 17:40:36','2014-12-06 18:19:47',NULL,73),(1358,1,'try again again','Complete','Normal',NULL,NULL,1,'2014-12-06 17:40:55','2014-12-06 21:18:38',NULL,72),(1359,1,'try again a third time','Complete','Normal',NULL,NULL,1,'2014-12-06 17:41:10','2014-12-06 21:18:40',NULL,71),(1360,1,'Stop breaking shit','Complete','Normal',NULL,NULL,1,'2014-12-06 17:42:46','2014-12-06 21:18:42',NULL,70),(1363,1,'Fix stuff faster than I break it','Complete','Normal',NULL,NULL,1,'2014-12-06 17:44:55','2014-12-06 18:03:25',NULL,69),(1364,1,'Verify that form reset thing worked','Complete','Normal',NULL,NULL,1,'2014-12-06 17:47:43','2014-12-06 18:06:00',NULL,68),(1365,1,'See what form[0] is','Complete','Normal',NULL,NULL,1,'2014-12-06 17:48:12','2014-12-06 18:03:02',NULL,67),(1367,1,'Determine why cross-off doesn\'t remove tasks in dashboard view','Complete','Normal',NULL,NULL,1,'2014-12-06 17:58:25','2014-12-06 21:19:01',NULL,66),(1368,1,'Find out why, yet again, markComplete doesn\'t lead to crossOff (dash)','Complete','Normal',NULL,NULL,1,'2014-12-09 21:32:26','2014-12-11 12:39:12',NULL,54),(1369,1,'Find out why fixing the task panel breaks the Kanban board & vice versa','Complete','Normal',NULL,NULL,1,'2014-12-09 21:42:39','2014-12-14 17:19:38',NULL,33),(1370,1,'Move main login form to hidden div in homepage','Complete','Normal',NULL,NULL,1,'2014-12-10 21:05:31','2014-12-18 14:42:09',NULL,21),(1372,1,'Check status of kanban-board-created tasks','Complete','Normal',NULL,NULL,1,'2014-12-11 09:51:18','2014-12-11 09:51:27',NULL,65),(1373,1,'Make sure tasks can still be created on the dashboard','Complete','Normal',NULL,NULL,1,'2014-12-11 09:56:06','2014-12-11 10:23:54',NULL,64),(1374,1,'Make sure tasks can still be created on the dashboard','Complete','Normal',NULL,NULL,1,'2014-12-11 09:56:06','2014-12-11 10:25:35',NULL,63),(1376,1,'Make sure links lead to TOP of page unless otherwise specified','New','Normal',NULL,NULL,1,'2014-12-11 12:41:23',NULL,NULL,27),(1378,1,'Figure out how to incorporate time estimates into tasks','New','Normal',NULL,NULL,1,'2014-12-11 18:10:48','2014-12-15 11:41:54',NULL,26),(1392,1,'Find out why tasks are being created twice','Complete','Normal',NULL,NULL,1,'2014-12-14 14:31:40','2014-12-14 16:35:54',NULL,38),(1393,1,'Debug draggable/droppable','Complete','Normal',NULL,NULL,1,'2014-12-14 14:33:42','2014-12-14 17:18:21',NULL,34),(1398,1,'Make sure all functionality works with Dashboard Presenter','Complete','Normal',NULL,NULL,1,'2014-12-14 15:51:06','2014-12-18 14:41:50',NULL,7),(1404,1,'check again if this works','Complete','Normal',NULL,NULL,1,'2014-12-14 16:01:53','2014-12-14 16:02:11',NULL,44),(1405,1,'deal with mark complete fiasco','Complete','Normal',NULL,NULL,1,'2014-12-14 16:05:38','2014-12-14 16:07:20',NULL,8),(1406,1,'Find out why new tasks are added to the list at position 2','New','Normal',NULL,'Or position 3 - from the perspective of the user. I suspect this has to do with the async functionality between this and the server (i.e., server updates positions silently). IMPORTANT: Tasks added in this way seem to have the same container issues as recently moved draggables/droppables.',1,'2014-12-14 16:05:59','2014-12-15 12:33:04',NULL,4),(1408,1,'Generate tasks to mark complete','Complete','Normal',NULL,NULL,1,'2014-12-14 16:09:46','2014-12-14 16:09:53',NULL,43),(1409,1,'generate more stuff to mark complete again','Complete','Normal',NULL,NULL,1,'2014-12-14 16:12:15','2014-12-14 16:12:19',NULL,42),(1410,1,'Check mark complete functionality again','Complete','Normal',NULL,NULL,1,'2014-12-14 16:14:02','2014-12-14 16:14:09',NULL,41),(1411,1,'Find out if I really have to re-render task panel when collection changes','Complete','Normal',NULL,NULL,1,'2014-12-14 16:15:36','2014-12-14 16:15:44',NULL,40),(1412,1,'See if hypothesis about re-rendering collection is true','Complete','Normal',NULL,NULL,1,'2014-12-14 16:18:47','2014-12-14 16:18:49',NULL,39),(1413,1,'Check if jQuery in collection render method works','Complete','Normal',NULL,NULL,1,'2014-12-14 16:20:08','2014-12-14 16:20:39',NULL,6),(1414,1,'Make sure re-render doesn\'t look too ridiculous','Complete','Normal',NULL,NULL,1,'2014-12-14 16:20:32','2014-12-14 16:20:43',NULL,5),(1415,1,'Get some of these damned tasks done so I can mark shit complete','Complete','Normal',NULL,NULL,1,'2014-12-14 16:37:27','2014-12-14 16:37:41',NULL,37),(1416,1,'Make outside click close top nav links (again)','Complete','Normal',NULL,NULL,1,'2014-12-14 16:44:27','2014-12-14 17:14:57',NULL,35),(1418,1,'Find out why positioning functionality not applied to completed tasks in Dev database','Complete','Normal',NULL,NULL,1,'2014-12-14 17:05:04','2014-12-14 17:06:19',NULL,36),(1419,1,'Fix problems with reroute','Complete','High',NULL,'There is a problem when a logged-in user clicks the #login link from /#home. Specifically, only the main dashboard view apparently renders, and not the widget area. This doesn\'t happen when a logged -in user visits /.\r\n\r\n** NO LONGER SEEMS TO HAPPEN **',1,'2014-12-15 12:27:52','2014-12-17 14:02:04',NULL,31),(1420,1,'Fix problem with refreshing the dashboard','Complete','Urgent',NULL,'When a logged-in user refreshes the dashboard, nothing loads. Unsurprisingly, there are no errors in the JavaScript console, either.',1,'2014-12-15 12:32:16','2014-12-17 14:06:22',NULL,30),(1421,1,'Make sure tasks added from dashboard also truncate their titles','Complete','Normal',NULL,'I think this may actually be an issue with the Google Fonts used here - if they don\'t load we have a problem. Will have to store fonts on own server in future - Google API too slow',1,'2014-12-17 14:02:36','2014-12-18 14:41:43',NULL,29),(1422,1,'Top nav drop menus once again don\'t work on login. Fuck me.','New','Normal',NULL,NULL,1,'2014-12-17 14:09:08',NULL,NULL,3),(1423,1,'Find out why it is apparently not using google fonts anymore','New','Normal',NULL,NULL,1,'2014-12-18 14:41:22',NULL,NULL,2),(1424,1,'Tweak visual when logged-in user clicks homepage login link','New','Normal',NULL,NULL,1,'2014-12-18 18:56:39',NULL,NULL,1);
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `fach` varchar(255) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=343 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'danascheider','danascheider','dana.scheider@gmail.com','Dana','Scheider',NULL,NULL,NULL,NULL,1,NULL,NULL),(341,'anotheruser','anotherpassword','joesmith@example.com',NULL,NULL,NULL,NULL,NULL,NULL,0,'2014-12-06 12:25:22',NULL),(342,'testuser','testuser','testuser@example.com','Test','User',NULL,NULL,NULL,NULL,0,'2014-12-16 02:17:57',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-21 15:28:37
