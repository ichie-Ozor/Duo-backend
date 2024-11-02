-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 02, 2024 at 04:19 PM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `menu_ingredient` (IN `query_type` VARCHAR(20), IN `_menu_name` VARCHAR(20), IN `_menu_price` VARCHAR(15), IN `_menu_ingredients` VARCHAR(255))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `store_procedure` (IN `_id` INT(10), IN `query_type` VARCHAR(20), IN `_item_name` VARCHAR(20), IN `_output_item_name` VARCHAR(20), IN `_destination` VARCHAR(20), IN `_item_cost` VARCHAR(20), IN `_date_of_collection` VARCHAR(20), IN `_invoice` VARCHAR(20), IN `_name_of_collector` VARCHAR(20), IN `_name_of_giver` VARCHAR(20), IN `_in_qty` INT, IN `_out_qty` INT, IN `_date` VARCHAR(20), IN `_vibe_user_name` VARCHAR(20), IN `_vibe_item_name` VARCHAR(20), IN `_vibe_item_price` VARCHAR(20), IN `_vibe_item_qty` INT, IN `_vip_user_name` VARCHAR(20), IN `_vip_item_name` VARCHAR(20), IN `_vip_item_price` VARCHAR(20), IN `_vip_item_qty` INT, IN `_kitchen_user_name` VARCHAR(20), IN `_kitchen_item_name` VARCHAR(20), IN `_kitchen_item_price` VARCHAR(20), IN `_kitchen_item_qty` INT, IN `_status` VARCHAR(20))   BEGIN
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
(1, 'chicken', '1500', '2024-10-01', 'INV12345', '5'),
(2, 'Sample Item', '50', '2024-10-31', 'INV123', '50');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu_ingredient`
--

CREATE TABLE `menu_ingredient` (
  `id` int(11) NOT NULL,
  `menu_name` varchar(45) DEFAULT NULL,
  `menu_ingredient` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `discount` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_list`
--

INSERT INTO `menu_list` (`id`, `menu_name`, `menu_price`, `discount`) VALUES
(1, 'Burger', '5.99', NULL);

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
(1, 'Aii Atoma', 'Manager', 'chicken', NULL, '5', '2024-10-28'),
(2, 'Collector A', 'Giver B', 'Sample Item', 'vibes', '10', '2024-10-31'),
(3, 'Collector A', 'Giver B', 'Sample Item', 'vibes', '10', '2024-10-31'),
(4, 'Collector A', 'Giver B', 'Sample Item', 'vibes', '10', '2024-10-31'),
(5, 'Collector A', 'Giver B', 'Sample Item', 'vibes', '10', '2024-10-31'),
(6, 'Collector A', 'Giver B', 'Sample Item', 'vip', '10', '2024-10-31');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `account_type`, `email`, `phone`, `password`, `status`, `role`, `account_id`, `accessTo`, `functionalities`, `createdAt`, `updatedAt`) VALUES
(1, 'ozor', 'ozor', 'user', 'ozor@gmail.com', '1122334455', '$2a$10$Tvpaj8VIQACBsY1vvFB6t.qK18yLXDwf1agaQtO9CxB0DEJnuIOfy', 'active', 'user', NULL, 'read_access', 'view_profile', '2024-11-02 15:06:29', '2024-11-02 15:06:29'),
(2, 'mary', 'mary', 'user', 'mary@gmail.com', '1122334455', '$2a$10$7Ck28RSyQSXPsvy6OUTCQ.zh9x6no7xLoIkPgN5/z7j9kFjedgou6', 'active', 'user', NULL, 'read_access', 'view_profile', '2024-11-02 15:08:03', '2024-11-02 15:08:03');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vibe_table`
--

INSERT INTO `vibe_table` (`id`, `vibe_user_name`, `vibe_item_name`, `vibe_item_price`, `vibe_item_qty`, `status`) VALUES
(1, 'Collector A', 'Sample Item', '50', '10', 'in_coming');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vip_table`
--

INSERT INTO `vip_table` (`id`, `vip_user_name`, `vip_item_name`, `vip_item_price`, `vip_item_qty`, `status`) VALUES
(1, 'Collector A', 'Sample Item', '50', '10', 'in_coming');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `kitchen_table`
--
ALTER TABLE `kitchen_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `menu_ingredient`
--
ALTER TABLE `menu_ingredient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `menu_list`
--
ALTER TABLE `menu_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `outstock_table`
--
ALTER TABLE `outstock_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `vibe_table`
--
ALTER TABLE `vibe_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `vip_table`
--
ALTER TABLE `vip_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
