-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2022 at 02:17 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbtheatre`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_old` ()  begin

	declare curdate date;
set curdate=curdate();

DELETE FROM shows 
WHERE datediff(Date,curdate)<0;

DELETE FROM shows 
WHERE movie_id IN 
(SELECT movie_id 
FROM movies
WHERE datediff(show_end,curdate)<0);

DELETE FROM movies 
WHERE datediff(show_end,curdate)<0;

end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `booked_tickets`
--

CREATE TABLE `booked_tickets` (
  `ticket_no` int(11) NOT NULL,
  `show_id` int(11) NOT NULL,
  `seat_no` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `halls`
--

CREATE TABLE `halls` (
  `hall_id` int(11) NOT NULL,
  `class` varchar(10) NOT NULL,
  `no_of_seats` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `halls`
--

INSERT INTO `halls` (`hall_id`, `class`, `no_of_seats`) VALUES
(1, 'gold', 35),
(1, 'standard', 75),
(2, 'gold', 27),
(2, 'standard', 97),
(3, 'gold', 26),
(3, 'standard', 98);

--
-- Triggers `halls`
--
DELIMITER $$
CREATE TRIGGER `get_price` AFTER INSERT ON `halls` FOR EACH ROW begin

UPDATE shows s, price_listing p 
SET s.price_id=p.price_id 
WHERE p.price_id IN 
(SELECT price_id 
FROM price_listing p 
WHERE dayname(s.Date)=p.day AND s.type=p.type);

end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `movie_id` int(11) NOT NULL,
  `movie_name` varchar(40) DEFAULT NULL,
  `length` int(11) DEFAULT NULL,
  `language` varchar(10) DEFAULT NULL,
  `show_start` date DEFAULT NULL,
  `show_end` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`movie_id`, `movie_name`, `length`, `language`, `show_start`, `show_end`) VALUES
(60146899, 'Demo Movie Name', 125, 'English', '2022-03-08', '2022-05-19'),
(194062403, 'Uncharted', 112, 'English', '2022-02-16', '2022-04-26'),
(476621797, 'The Batman', 176, 'English', '2022-03-03', '2022-05-17');

-- --------------------------------------------------------

--
-- Table structure for table `price_listing`
--

CREATE TABLE `price_listing` (
  `price_id` int(11) NOT NULL,
  `type` varchar(3) DEFAULT NULL,
  `day` varchar(10) DEFAULT NULL,
  `price` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `price_listing`
--

INSERT INTO `price_listing` (`price_id`, `type`, `day`, `price`) VALUES
(1, '2D', 'Monday', 10),
(2, '3D', 'Monday', 12),
(3, '4DX', 'Monday', 15),
(4, '2D', 'Tuesday', 10),
(5, '3D', 'Tuesday', 12),
(6, '4DX', 'Tuesday', 14),
(7, '2D', 'Wednesday', 8),
(8, '3D', 'Wednesday', 10),
(9, '4DX', 'Wednesday', 12),
(10, '2D', 'Thursday', 10),
(11, '3D', 'Thursday', 12),
(12, '4DX', 'Thursday', 15),
(13, '2D', 'Friday', 12),
(14, '3D', 'Friday', 15),
(15, '4DX', 'Friday', 22),
(16, '2D', 'Saturday', 12),
(17, '3D', 'Saturday', 15),
(18, '4DX', 'Saturday', 20),
(19, '2D', 'Sunday', 10),
(20, '3D', 'Sunday', 13),
(21, '4DX', 'Sunday', 17);

-- --------------------------------------------------------

--
-- Table structure for table `shows`
--

CREATE TABLE `shows` (
  `show_id` int(11) NOT NULL,
  `movie_id` int(11) DEFAULT NULL,
  `hall_id` int(11) DEFAULT NULL,
  `type` varchar(3) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `price_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shows`
--

INSERT INTO `shows` (`show_id`, `movie_id`, `hall_id`, `type`, `time`, `Date`, `price_id`) VALUES
(288841196, 476621797, 3, '2D', 1900, '2022-03-10', 10),
(859902520, 194062403, 3, '4DX', 1945, '2022-03-10', 12),
(1095272239, 194062403, 2, '2D', 1900, '2022-03-10', 10),
(2001281728, 476621797, 2, '2D', 900, '2022-03-10', 10),
(2054684557, 60146899, 1, '4DX', 1900, '2022-03-10', 12);

-- --------------------------------------------------------

--
-- Table structure for table `types`
--

CREATE TABLE `types` (
  `movie_id` int(11) NOT NULL,
  `type1` varchar(3) DEFAULT NULL,
  `type2` varchar(3) DEFAULT NULL,
  `type3` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `types`
--

INSERT INTO `types` (`movie_id`, `type1`, `type2`, `type3`) VALUES
(60146899, '4DX', 'NUL', 'NUL'),
(194062403, '2D', '3D', '4DX'),
(476621797, '2D', '3D', '4DX');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booked_tickets`
--
ALTER TABLE `booked_tickets`
  ADD PRIMARY KEY (`ticket_no`,`show_id`),
  ADD KEY `show_id` (`show_id`);

--
-- Indexes for table `halls`
--
ALTER TABLE `halls`
  ADD PRIMARY KEY (`hall_id`,`class`);

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`movie_id`);

--
-- Indexes for table `price_listing`
--
ALTER TABLE `price_listing`
  ADD PRIMARY KEY (`price_id`);

--
-- Indexes for table `shows`
--
ALTER TABLE `shows`
  ADD PRIMARY KEY (`show_id`),
  ADD KEY `movie_id` (`movie_id`),
  ADD KEY `hall_id` (`hall_id`),
  ADD KEY `price_id` (`price_id`);

--
-- Indexes for table `types`
--
ALTER TABLE `types`
  ADD PRIMARY KEY (`movie_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booked_tickets`
--
ALTER TABLE `booked_tickets`
  ADD CONSTRAINT `booked_tickets_ibfk_1` FOREIGN KEY (`show_id`) REFERENCES `shows` (`show_id`) ON DELETE CASCADE;

--
-- Constraints for table `shows`
--
ALTER TABLE `shows`
  ADD CONSTRAINT `shows_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`),
  ADD CONSTRAINT `shows_ibfk_2` FOREIGN KEY (`hall_id`) REFERENCES `halls` (`hall_id`),
  ADD CONSTRAINT `shows_ibfk_3` FOREIGN KEY (`price_id`) REFERENCES `price_listing` (`price_id`) ON UPDATE CASCADE;

--
-- Constraints for table `types`
--
ALTER TABLE `types`
  ADD CONSTRAINT `types_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
