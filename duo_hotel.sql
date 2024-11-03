-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 28, 2024 at 06:15 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `duo_hotel`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `store_procedure` (IN `_id` INT(10), IN `query_type` VARCHAR(20), IN `_item_name` VARCHAR(20), IN `_item_cost` VARCHAR(20), IN `_date_of_collection` VARCHAR(20), IN `_invoice` VARCHAR(20), IN `_name_of_collector` VARCHAR(20), IN `_name_of_giver` VARCHAR(20), IN `_in_qty` INT, IN `_out_qty` INT, IN `_date` VARCHAR(20))   BEGIN
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
                out_qty,
                date
            ) VALUES (
                _name_of_collector,
                _name_of_giver,
                _item_name,
                _out_qty,
                _date
            );

            UPDATE `in_stock` 
            SET in_qty = in_qty - _out_qty
            WHERE item_name = _item_name;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `in_stock`
--

CREATE TABLE `in_stock` (
  `id` int(11) NOT NULL,
  `item_name` varchar(50) DEFAULT NULL,
  `item_cost` varchar(10) DEFAULT NULL,
  `date_of_collection` varchar(45) DEFAULT NULL,
  `invoice` varchar(400) DEFAULT NULL,
  `in_qty` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `in_stock`
--

INSERT INTO `in_stock` (`id`, `item_name`, `item_cost`, `date_of_collection`, `invoice`, `in_qty`) VALUES
(1, 'chicken', '1500', '2024-10-01', 'INV12345', '5');

-- --------------------------------------------------------

--
-- Table structure for table `outstock_table`
--

CREATE TABLE `outstock_table` (
  `id` int(11) NOT NULL,
  `name_of_collector` varchar(45) DEFAULT NULL,
  `name_of_giver` varchar(45) DEFAULT NULL,
  `item_name` varchar(45) DEFAULT NULL,
  `destination` varchar(45) DEFAULT NULL,
  `out_qty` varchar(45) DEFAULT NULL,
  `date` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `outstock_table`
--

INSERT INTO `outstock_table` (`id`, `name_of_collector`, `name_of_giver`, `item_name`, `destination`, `out_qty`, `date`) VALUES
(1, 'Aii Atoma', 'Manager', 'chicken', NULL, '5', '2024-10-28');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
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
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `in_stock`
--
ALTER TABLE `in_stock`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outstock_table`
--
ALTER TABLE `outstock_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `in_stock`
--
ALTER TABLE `in_stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `outstock_table`
--
ALTER TABLE `outstock_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
