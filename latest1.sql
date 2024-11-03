-- MySQL dump 10.13  Distrib 8.0.38, for macos14 (x86_64)
--
-- Host: 127.0.0.1    Database: duo_hotel_server
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.28-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `in_stock`
--

DROP TABLE IF EXISTS `in_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `in_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_name` varchar(50) DEFAULT NULL,
  `item_cost` varchar(10) DEFAULT NULL,
  `date_of_collection` varchar(45) DEFAULT NULL,
  `invoice` varchar(400) DEFAULT NULL,
  `in_qty` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `in_stock`
--

LOCK TABLES `in_stock` WRITE;
/*!40000 ALTER TABLE `in_stock` DISABLE KEYS */;
INSERT INTO `in_stock` VALUES (1,'chicken','1500','2024-10-01','INV12345','5'),(2,'Sample Item','50','2024-10-31','INV123','50');
/*!40000 ALTER TABLE `in_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kitchen_table`
--

DROP TABLE IF EXISTS `kitchen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kitchen_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kitchen_user_name` varchar(45) DEFAULT NULL,
  `kitchen_item_name` varchar(45) DEFAULT NULL,
  `kitchen_item_price` varchar(45) DEFAULT NULL,
  `kitchen_item_qty` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kitchen_table`
--

LOCK TABLES `kitchen_table` WRITE;
/*!40000 ALTER TABLE `kitchen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `kitchen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outstock_table`
--

DROP TABLE IF EXISTS `outstock_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `outstock_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_of_collector` varchar(45) DEFAULT NULL,
  `name_of_giver` varchar(45) DEFAULT NULL,
  `item_name` varchar(45) DEFAULT NULL,
  `destination` varchar(45) DEFAULT NULL,
  `out_qty` varchar(45) DEFAULT NULL,
  `date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outstock_table`
--

LOCK TABLES `outstock_table` WRITE;
/*!40000 ALTER TABLE `outstock_table` DISABLE KEYS */;
INSERT INTO `outstock_table` VALUES (1,'Aii Atoma','Manager','chicken',NULL,'5','2024-10-28'),(2,'Collector A','Giver B','Sample Item','vibes','10','2024-10-31'),(3,'Collector A','Giver B','Sample Item','vibes','10','2024-10-31'),(4,'Collector A','Giver B','Sample Item','vibes','10','2024-10-31'),(5,'Collector A','Giver B','Sample Item','vibes','10','2024-10-31'),(6,'Collector A','Giver B','Sample Item','vip','10','2024-10-31');
/*!40000 ALTER TABLE `outstock_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `account_type` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `account_id` varchar(255) DEFAULT NULL,
  `accessTo` varchar(255) DEFAULT NULL,
  `functionalities` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vibe_table`
--

DROP TABLE IF EXISTS `vibe_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vibe_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vibe_user_name` varchar(45) DEFAULT NULL,
  `vibe_item_name` varchar(45) DEFAULT NULL,
  `vibe_item_price` varchar(45) DEFAULT NULL,
  `vibe_item_qty` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vibe_table`
--

LOCK TABLES `vibe_table` WRITE;
/*!40000 ALTER TABLE `vibe_table` DISABLE KEYS */;
INSERT INTO `vibe_table` VALUES (1,'Collector A','Sample Item','50','10','in_coming');
/*!40000 ALTER TABLE `vibe_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vip_table`
--

DROP TABLE IF EXISTS `vip_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vip_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vip_user_name` varchar(45) DEFAULT NULL,
  `vip_item_name` varchar(45) DEFAULT NULL,
  `vip_item_price` varchar(45) DEFAULT NULL,
  `vip_item_qty` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vip_table`
--

LOCK TABLES `vip_table` WRITE;
/*!40000 ALTER TABLE `vip_table` DISABLE KEYS */;
INSERT INTO `vip_table` VALUES (1,'Collector A','Sample Item','50','10','in_coming');
/*!40000 ALTER TABLE `vip_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'duo_hotel_server'
--

--
-- Dumping routines for database 'duo_hotel_server'
--
/*!50003 DROP PROCEDURE IF EXISTS `store_procedure` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `store_procedure`(
    IN `_id` INT(10), 
    IN `query_type` VARCHAR(20), 
    IN `_item_name` VARCHAR(20), 
    IN `_output_item_name` VARCHAR(20), 
    IN `_destination` VARCHAR(20), 
    IN `_item_cost` VARCHAR(20), 
    IN `_date_of_collection` VARCHAR(20), 
    IN `_invoice` VARCHAR(20), 
    IN `_name_of_collector` VARCHAR(20), 
    IN `_name_of_giver` VARCHAR(20), 
    IN `_in_qty` INT, 
    IN `_out_qty` INT, 
    IN `_date` VARCHAR(20),
    IN `_vibe_user_name` VARCHAR(20),
    IN `_vibe_item_name` VARCHAR(20),
    IN `_vibe_item_price` VARCHAR(20),
    IN `_vibe_item_qty` INT,
    IN `_vip_user_name` VARCHAR(20),
    IN `_vip_item_name` VARCHAR(20),
    IN `_vip_item_price` VARCHAR(20),
    IN `_vip_item_qty` INT,
    IN `_kitchen_user_name` VARCHAR(20),
    IN `_kitchen_item_name` VARCHAR(20),
    IN `_kitchen_item_price` VARCHAR(20),
    IN `_kitchen_item_qty` INT,
    IN `_status` VARCHAR(20)
)
BEGIN
    IF query_type = 'create_input' THEN 
        INSERT INTO `in_stock` (
            item_name,
            item_cost,
            date_of_collection,
            invoice,
            in_qty
        ) VALUES (
            _item_name,
            _item_cost,
            _date_of_collection,
            _invoice,
            _in_qty
        );

    ELSEIF query_type = 'create_output' THEN
        INSERT INTO `outstock_table` (
            name_of_collector,
            name_of_giver,
            item_name,
            destination,
            out_qty,
            date
        ) VALUES (
            _name_of_collector,
            _name_of_giver,
            _output_item_name,
            _destination,
            _out_qty,
            _date
        );

        UPDATE `in_stock` 
        SET in_qty = in_qty - _out_qty
        WHERE item_name = _output_item_name;
        
        IF _destination = "vibes" THEN 
            INSERT INTO `vibe_table` (
                vibe_user_name,
                vibe_item_name,
                vibe_item_price,
                vibe_item_qty,
                status
            ) VALUES (
                _name_of_collector,
                _output_item_name,
                _vibe_item_price,
                _out_qty,
                "in_coming"
            );
        ELSEIF _destination = "vip" THEN 
            INSERT INTO `vip_table` (
                vip_user_name,
                vip_item_name,
                vip_item_price,
                vip_item_qty,
                status
            ) VALUES (
                _name_of_collector,
                _output_item_name,
                _vip_item_price,
                _out_qty,
                "in_coming"
            );
        ELSEIF _destination = "kitchen" THEN 
            INSERT INTO `kitchen_table` (
                kitchen_user_name,
                kitchen_item_name,
                kitchen_item_price,
                kitchen_item_qty,
                status
            ) VALUES (
                _name_of_collector,
                _output_item_name,
                _kitchen_item_price,
                _out_qty,
                "in_coming"
            );
        END IF;

    ELSEIF query_type = 'insert_vip' THEN
        INSERT INTO `vip_table` (
            vip_user_name,
            vip_item_name,
            vip_item_price,
            vip_item_qty,
            status
        ) VALUES (
            _vip_user_name,
            _vip_item_name,
            _vip_item_price,
            _vip_item_qty,
            _status
        );
        
    ELSEIF query_type = 'insert_kitchen' THEN
        INSERT INTO `kitchen_table` (
            kitchen_user_name,
            kitchen_item_name,
            kitchen_item_price,
            kitchen_item_qty,
            status
        ) VALUES (
            _kitchen_user_name,
            _kitchen_item_name,
            _kitchen_item_price,
            _kitchen_item_qty,
            _status
        );
        
    ELSEIF query_type = 'insert_vibes' THEN
        INSERT INTO `vibe_table` (
            vibe_user_name,
            vibe_item_name,
            vibe_item_price,
            vibe_item_qty,
            status
        ) VALUES (
            _vibe_user_name,
            _vibe_item_name,
            _vibe_item_price,
            _vibe_item_qty,
            _status
        );
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-31 10:42:08
