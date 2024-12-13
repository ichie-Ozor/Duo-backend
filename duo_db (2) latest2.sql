-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 05, 2024 at 06:54 PM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 8.0.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `duo_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `menu_ingredient` (IN `query_type` VARCHAR(20), IN `_menu_name` VARCHAR(20), IN `_menu_price` VARCHAR(15), IN `_menu_ingredients` VARCHAR(255))  BEGIN
    DECLARE ingredient VARCHAR(50);
    DECLARE ing_start INT DEFAULT 1;
    DECLARE ing_end INT DEFAULT 0;

    -- Insert menu item if query_type is 'insert_menu'
    IF query_type = "insert_menu" THEN 
        INSERT INTO `menu_list`(
            menu_name,
            menu_price
        ) VALUES (
            _menu_name,
            _menu_price
        );
    
    -- Insert ingredients if query_type is 'insert_ingredient'
    ELSEIF query_type = "insert_ingredient" THEN 
        -- Loop through each ingredient in the comma-separated list
        SET ing_end = LOCATE(',', _menu_ingredients, ing_start);
        
        WHILE ing_end > 0 DO
            -- Extract each ingredient and trim it if necessary
            SET ingredient = TRIM(SUBSTRING(_menu_ingredients, ing_start, ing_end - ing_start));
            
            -- Insert into `menu_ingredient` table
            INSERT INTO `menu_ingredient`(
                menu_name,
                menu_ingredient
            ) VALUES (
                _menu_name,
                ingredient
            );
            
            -- Update `kitchen_table` to decrement the ingredient quantity
            UPDATE kitchen_table
            SET kitchen_item_qty = kitchen_item_qty - 1
            WHERE kitchen_item_name = ingredient;  -- Use the correct column name here

            -- Move to the next ingredient in the list
            SET ing_start = ing_end + 1;
            SET ing_end = LOCATE(',', _menu_ingredients, ing_start);
        END WHILE;
        
        -- Process the last ingredient in the list
        SET ingredient = TRIM(SUBSTRING(_menu_ingredients, ing_start));

        INSERT INTO `menu_ingredient`(
            menu_name,
            menu_ingredient
        ) VALUES (
            _menu_name,
            ingredient
        );

        -- Update `kitchen_table` for the last ingredient
        UPDATE kitchen_table
        SET kitchen_item_qty = kitchen_item_qty - 1
        WHERE kitchen_item_name = ingredient;  -- Use the correct column name here
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `store_procedure` (IN `query_type` VARCHAR(20), IN `_item_name` VARCHAR(20), IN `_output_item_name` VARCHAR(20), IN `_destination` VARCHAR(20), IN `_item_cost` VARCHAR(20), IN `_date_of_collection` VARCHAR(50), IN `_invoice` VARCHAR(20), IN `_name_of_collector` VARCHAR(20), IN `_name_of_giver` VARCHAR(20), IN `_in_qty` INT, IN `_out_qty` INT, IN `_date` VARCHAR(20), IN `_vibe_user_name` VARCHAR(20), IN `_vibe_item_name` VARCHAR(20), IN `_vibe_item_price` VARCHAR(20), IN `_vibe_item_qty` INT, IN `_vip_user_name` VARCHAR(20), IN `_vip_item_name` VARCHAR(20), IN `_vip_item_price` VARCHAR(20), IN `_vip_item_qty` INT, IN `_kitchen_user_name` VARCHAR(20), IN `_kitchen_item_name` VARCHAR(20), IN `_kitchen_item_price` VARCHAR(20), IN `_kitchen_item_qty` INT, IN `_status` VARCHAR(20))  BEGIN
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
            _date,
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
            _item_name,
            _destination,
            _out_qty,
            _date
        );

        UPDATE `in_stock` 
        SET in_qty = in_qty - _out_qty
        WHERE item_name = _item_name;
        
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `in_stock`
--

INSERT INTO `in_stock` (`id`, `item_name`, `item_cost`, `date_of_collection`, `invoice`, `in_qty`) VALUES
(1, 'chicken', '1500', '2024-10-01', 'INV12345', '1'),
(4, 'Toilet Paper', '5000', '2024-11-20', 'inv0013', '6'),
(6, 'beans', '1000', '2024-11-03', '11', '3');

-- --------------------------------------------------------

--
-- Table structure for table `kitchen_table`
--

CREATE TABLE `kitchen_table` (
  `id` int(11) NOT NULL,
  `kitchen_user_name` varchar(45) DEFAULT NULL,
  `kitchen_item_name` varchar(45) DEFAULT NULL,
  `kitchen_item_price` varchar(45) DEFAULT NULL,
  `kitchen_item_qty` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kitchen_table`
--

INSERT INTO `kitchen_table` (`id`, `kitchen_user_name`, `kitchen_item_name`, `kitchen_item_price`, `kitchen_item_qty`, `status`) VALUES
(1, '', '', '', '0', 'in_coming'),
(2, '', '', '', '0', 'in_coming'),
(3, '', '', '', '0', 'in_coming'),
(4, '', '', '', '0', 'in_coming'),
(5, '', '', '', '1', 'in_coming'),
(6, '', '', '', '-1', 'in_coming'),
(7, '', '', '', '1', 'in_coming'),
(8, '', '', '', '2', 'in_coming'),
(9, '', '', '', '1', 'in_coming'),
(10, '', '', '', '2', 'in_coming'),
(11, '', '', '', '2', 'in_coming');

-- --------------------------------------------------------

--
-- Table structure for table `menu_ingredient`
--

CREATE TABLE `menu_ingredient` (
  `id` int(11) NOT NULL,
  `menu_name` varchar(45) DEFAULT NULL,
  `menu_ingredient` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `menu_ingredient`
--

INSERT INTO `menu_ingredient` (`id`, `menu_name`, `menu_ingredient`) VALUES
(1, 'Burger', 'Bun'),
(2, 'Burger', 'Bun'),
(3, 'Burger', 'Bun'),
(4, 'Burger', 'Bun'),
(5, 'Burger', 'Bun'),
(6, 'Burger', 'Patty'),
(7, 'Burger', 'Lettuce'),
(8, 'Burger', 'Tomato'),
(9, 'Burger', 'Cheese');

-- --------------------------------------------------------

--
-- Table structure for table `menu_list`
--

CREATE TABLE `menu_list` (
  `id` int(11) NOT NULL,
  `menu_name` varchar(45) DEFAULT NULL,
  `menu_price` varchar(45) DEFAULT NULL,
  `sub_menu` varchar(255) DEFAULT NULL,
  `discount` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `menu_list`
--

INSERT INTO `menu_list` (`id`, `menu_name`, `menu_price`, `sub_menu`, `discount`) VALUES
(1, 'Burger', '5000', NULL, NULL),
(3, 'palleta', '10000', 'Rice,Rice,Plantain', NULL),
(9, 'rice and beans', '2000', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `new_vibe_table`
--

CREATE TABLE `new_vibe_table` (
  `vibe_id` int(11) NOT NULL,
  `menu` varchar(45) DEFAULT NULL,
  `item_price` int(11) DEFAULT NULL,
  `out_qty` int(11) DEFAULT NULL,
  `payment_method` varchar(45) DEFAULT NULL,
  `vibe_discount` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `new_vibe_table`
--

INSERT INTO `new_vibe_table` (`vibe_id`, `menu`, `item_price`, `out_qty`, `payment_method`, `vibe_discount`) VALUES
(1, 'palleta', 10000, 1, 'transfer', ''),
(2, 'palleta', 10000, 1, 'pos', ''),
(3, 'palleta', 10000, 1, 'cash', ''),
(4, 'Burger', 5000, 1, 'cash', ''),
(5, 'Burger', 5000, 6, 'transfer', ''),
(6, 'Burger', 5000, 1, '', ''),
(7, 'Burger', 5000, 3, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `new_vip_table`
--

CREATE TABLE `new_vip_table` (
  `new_vip_id` int(11) NOT NULL,
  `menu` varchar(45) DEFAULT NULL,
  `item_price` int(11) DEFAULT NULL,
  `out_qty` int(11) DEFAULT NULL,
  `payment_method` varchar(45) DEFAULT NULL,
  `vip_discount` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `new_vip_table`
--

INSERT INTO `new_vip_table` (`new_vip_id`, `menu`, `item_price`, `out_qty`, `payment_method`, `vip_discount`) VALUES
(1, 'biryani', 10000, 1, 'pos', ''),
(2, 'Burger', 5000, 1, 'cash', ''),
(3, 'palleta', 10000, 1, 'transfer', ''),
(4, 'Burger', 5000, 1, 'transfer', ''),
(5, 'palleta', 10000, 3, 'transfer', ''),
(6, '', NULL, 1, '', '');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `outstock_table`
--

INSERT INTO `outstock_table` (`id`, `name_of_collector`, `name_of_giver`, `item_name`, `destination`, `out_qty`, `date`) VALUES
(1, 'Aii Atoma', 'Manager', 'chicken', NULL, '5', '2024-10-28'),
(2, 'Collector A', 'Giver B', 'Sample Item', 'vibes', '10', '2024-10-31'),
(3, 'Collector A', 'Giver B', 'Sample Item', 'vibes', '10', '2024-10-31'),
(4, 'Collector A', 'Giver B', 'Sample Item', 'vibes', '10', '2024-10-31'),
(5, 'Collector A', 'Giver B', 'Sample Item', 'vibes', '10', '2024-10-31'),
(6, 'Collector A', 'Giver B', 'Sample Item', 'vip', '10', '2024-10-31'),
(10, '', '', 'Toilet Paper', 'kitchen', '0', '2024-11-03'),
(11, '', '', 'chicken', 'kitchen', '1', '2024-11-03'),
(12, '', '', 'Toilet Paper', 'vip', '2', '2024-11-03'),
(13, '', '', 'Toilet Paper', 'kitchen', '-1', '2024-11-03'),
(14, '', '', 'chicken', 'kitchen', '1', '2024-11-03'),
(15, '', '', 'Toilet Paper', 'kitchen', '2', '2024-11-03'),
(16, '', 'Frank Edward', 'chicken', 'kitchen', '1', '2024-11-03'),
(17, '', 'Frank Edward', 'chicken', 'kitchen', '2', '2024-11-04'),
(18, '', 'Frank Edward', 'Sample Item', 'vibes', '10', '2024-11-05'),
(19, '', 'Frank Edward', 'beans', 'kitchen', '2', '2024-11-05'),
(20, '', 'Frank Edward', 'Toilet Paper', 'vip', '3', '2024-11-06');

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `account_type` varchar(50) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `accessTo` text DEFAULT NULL,
  `functionalities` text DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`id`, `name`, `username`, `account_type`, `email`, `phone`, `password`, `status`, `role`, `accessTo`, `functionalities`, `account_id`) VALUES
(1, 'Alice Johnson', 'alice', 'admin', 'alice@example.com', '1234567890', '08898778', 'active', 'admin', 'all_access', 'manage_users,view_reports', 1),
(2, 'Bob Smith', 'bob', 'user', 'bob@example.com', '0987654321', '098789987', 'active', 'user', 'limited_access', 'view_reports', 2),
(4, 'Sadiq Haruna', 'reignsb', 'admin', 'sadiq@gmail.com', '1234567890', '123456789', 'active', 'admin', 'all_access', 'manage_users,view_reports', 3);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `account_type`, `email`, `phone`, `password`, `status`, `role`, `account_id`, `accessTo`, `functionalities`, `createdAt`, `updatedAt`) VALUES
(1, 'ozor', 'ozor', 'user', 'ozor@gmail.com', '1122334455', '$2a$10$Tvpaj8VIQACBsY1vvFB6t.qK18yLXDwf1agaQtO9CxB0DEJnuIOfy', 'active', 'user', NULL, 'read_access', 'view_profile', '2024-11-02 15:06:29', '2024-11-02 15:06:29'),
(2, 'mary', 'mary', 'user', 'mary@gmail.com', '1122334455', '$2a$10$7Ck28RSyQSXPsvy6OUTCQ.zh9x6no7xLoIkPgN5/z7j9kFjedgou6', 'active', 'user', NULL, 'read_access', 'view_profile', '2024-11-02 15:08:03', '2024-11-02 15:08:03'),
(3, 'Ahmad Ismail', 'aiialpha', '', 'aii07038713563@gmail.com', NULL, '$2a$10$CZ444JLuSDYkR8FOPmoEzOO2n3k63PlGo7oM5n6UpAS8rqhr4AJw6', '', 'staff', NULL, '', NULL, '2024-11-03 09:14:44', '2024-11-03 09:14:44'),
(4, 'Ahmad Ismail', 'aiialpha', '', 'aii070387123@gmail.com', NULL, '$2a$10$e8gIEpZg.WxpCQcRu/l1nOD6hg2eVcoSBhFQfiyDV80NS5ugQAqD6', '', 'staff', NULL, 'store', NULL, '2024-11-03 09:16:32', '2024-11-03 09:16:32'),
(5, 'Ahmad Ismail', 'akjdxjdmx', '', 'aii07038713@gmail.com', '07047145948', '$2a$10$IsM4pJP0KmhZ1.PgMAzzeO8LqIR8cP50kGh5.EEKruju7p.qThSau', 'active', 'staff', NULL, '', NULL, '2024-11-03 09:21:46', '2024-11-03 09:21:46'),
(6, 'Admin', 'admin_manager', '', 'admin@gmail.com', '0812345678', '$2a$10$nbCreJnjABA1m5Iyr.aOaOqsS/fSCgteVbgJudK8mcBRnyYingV96', 'active', 'admin', NULL, 'store', NULL, '2024-11-03 14:55:16', '2024-11-03 14:55:16'),
(7, 'Ahmad Ismail', 'admin_user', '', 'aii0703863@gmail.com', '07047145948', '$2a$10$FTsJwUYXSHu5TrqYyWmUf.zuQXhOHPsGTXIUB6yIRW7V3.PJxb0RO', 'active', 'staff', NULL, '', NULL, '2024-11-05 16:42:21', '2024-11-05 16:42:21'),
(8, 'Ahmad Ismail', 'admin_user', '', 'aii07033@gmail.com', '07047145948', '$2a$10$zPBN1hQOS39xCXPoSzGK1.IAFQe97wL/0Io55aKj6oqu.aN.QAzka', 'active', 'staff', NULL, '', NULL, '2024-11-05 16:44:09', '2024-11-05 16:44:09'),
(9, 'Ahmad Ismail', 'admin_user', '', 'aii03@gmail.com', '07047145948', '$2a$10$vZy.aBstAGTnLvIUdb2OKeGfjqkw5yFa./qKsd1Zuo4LUpfkrVFEq', 'active', 'staff', NULL, '', NULL, '2024-11-05 16:44:54', '2024-11-05 16:44:54'),
(10, 'Ahmad Ismail', 'admin_user', '', 'aii0@gmail.com', '07047145948', '$2a$10$aFAZjKmVhN6RGE7IOHjFZOtMbd.PKRHyjthPD/N2fyS7BZQUmF/Dm', 'active', 'staff', NULL, '', NULL, '2024-11-05 16:46:15', '2024-11-05 16:46:15'),
(11, 'Ahmad Ismail', 'admin_user', '', 'aii@gmail.com', '07047145948', '$2a$10$MMPsZ8clEMoA9XOpWbzKBuyj2OzcQnYirlFIZczSHN9MFU88phv8a', 'active', 'staff', NULL, '', NULL, '2024-11-05 16:46:43', '2024-11-05 16:46:43');

-- --------------------------------------------------------

--
-- Table structure for table `vibe_table`
--

CREATE TABLE `vibe_table` (
  `id` int(11) NOT NULL,
  `vibe_user_name` varchar(45) DEFAULT NULL,
  `vibe_item_name` varchar(45) DEFAULT NULL,
  `vibe_item_price` varchar(45) DEFAULT NULL,
  `vibe_item_qty` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vibe_table`
--

INSERT INTO `vibe_table` (`id`, `vibe_user_name`, `vibe_item_name`, `vibe_item_price`, `vibe_item_qty`, `status`) VALUES
(1, 'Collector A', 'Sample Item', '50', '10', 'in_coming'),
(2, '', '', '', '10', 'in_coming');

-- --------------------------------------------------------

--
-- Table structure for table `vip_table`
--

CREATE TABLE `vip_table` (
  `id` int(11) NOT NULL,
  `vip_user_name` varchar(45) DEFAULT NULL,
  `vip_item_name` varchar(45) DEFAULT NULL,
  `vip_item_price` varchar(45) DEFAULT NULL,
  `vip_item_qty` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vip_table`
--

INSERT INTO `vip_table` (`id`, `vip_user_name`, `vip_item_name`, `vip_item_price`, `vip_item_qty`, `status`) VALUES
(1, 'Collector A', 'Sample Item', '50', '10', 'in_coming'),
(2, '', '', '', '2', 'in_coming'),
(3, '', '', '', '3', 'in_coming');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `in_stock`
--
ALTER TABLE `in_stock`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kitchen_table`
--
ALTER TABLE `kitchen_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu_ingredient`
--
ALTER TABLE `menu_ingredient`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu_list`
--
ALTER TABLE `menu_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `new_vibe_table`
--
ALTER TABLE `new_vibe_table`
  ADD PRIMARY KEY (`vibe_id`);

--
-- Indexes for table `new_vip_table`
--
ALTER TABLE `new_vip_table`
  ADD PRIMARY KEY (`new_vip_id`);

--
-- Indexes for table `outstock_table`
--
ALTER TABLE `outstock_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vibe_table`
--
ALTER TABLE `vibe_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vip_table`
--
ALTER TABLE `vip_table`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `in_stock`
--
ALTER TABLE `in_stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `kitchen_table`
--
ALTER TABLE `kitchen_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `menu_ingredient`
--
ALTER TABLE `menu_ingredient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `menu_list`
--
ALTER TABLE `menu_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `new_vibe_table`
--
ALTER TABLE `new_vibe_table`
  MODIFY `vibe_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `new_vip_table`
--
ALTER TABLE `new_vip_table`
  MODIFY `new_vip_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `outstock_table`
--
ALTER TABLE `outstock_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `vibe_table`
--
ALTER TABLE `vibe_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `vip_table`
--
ALTER TABLE `vip_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
