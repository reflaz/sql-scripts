CREATE DATABASE  IF NOT EXISTS `ship_reimb` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ship_reimb`;

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


DROP TABLE IF EXISTS `jne_rate`;
DROP TABLE IF EXISTS `free_zone`;
DROP TABLE IF EXISTS `oms_data`;
DROP TABLE IF EXISTS `reimbursement`;

CREATE TABLE `jne_rate` (
    `origin` VARCHAR(50) NOT NULL,
    `id_region` INT NOT NULL,
    `region` VARCHAR(50) DEFAULT NULL,
    `id_city` INT NOT NULL,
    `city` VARCHAR(50) DEFAULT NULL,
    `id_district` INT NOT NULL,
    `district` VARCHAR(50) DEFAULT NULL,
    `rate` DECIMAL(17 , 2 ) DEFAULT 0,
    PRIMARY KEY (`origin` , `id_region` , `id_city` , `id_district`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Uploaded JNE Rate';

CREATE TABLE `free_zone` (
    `id_region` INT NOT NULL,
    `region` VARCHAR(50) DEFAULT NULL,
    `id_city` INT NOT NULL,
    `city` VARCHAR(50) DEFAULT NULL,
    `id_district` INT NOT NULL,
    `district` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`id_region` , `id_city` , `id_district`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Home Zone';

CREATE TABLE `oms_data` (
    `bob_id_sales_order_item` INT(10) NOT NULL,
    `sc_id_sales_order_item` INT(10) NOT NULL,
    `order_nr` INT(10) NOT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `shipped_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `sku` VARCHAR(50) DEFAULT NULL,
    `id_package_dispatching` INT(10) NOT NULL,
    `tracking_number` VARCHAR(50) NOT NULL,
    `shipment_provider` VARCHAR(100) DEFAULT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `id_region` INT NOT NULL,
    `region` VARCHAR(50) DEFAULT NULL,
    `id_city` INT NOT NULL,
    `city` VARCHAR(50) DEFAULT NULL,
    `id_district` INT NOT NULL,
    `district` VARCHAR(50) DEFAULT NULL,
    `sc_seller_id` VARCHAR(50) DEFAULT NULL,
    `seller_name` VARCHAR(50) DEFAULT NULL,
    `length` DECIMAL(6 , 2 ) DEFAULT NULL,
    `width` DECIMAL(6 , 2 ) DEFAULT NULL,
    `height` DECIMAL(6 , 2 ) DEFAULT NULL,
    `weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `volumetric_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item` , `order_nr` , `origin`, `id_package_dispatching`, `id_district`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Extracted data from database server';

CREATE TABLE `reimbursement` (
    `bob_id_sales_order_item` INT(10) NOT NULL,
    `sc_id_sales_order_item` INT(10) NOT NULL,
    `order_nr` INT(10) NOT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `shipped_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `sku` VARCHAR(50) DEFAULT NULL,
    `id_package_dispatching` INT(10) NOT NULL,
    `tracking_number` VARCHAR(50) NOT NULL,
    `shipment_provider` VARCHAR(100) DEFAULT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `id_region` INT NOT NULL,
    `region` VARCHAR(50) DEFAULT NULL,
    `id_city` INT NOT NULL,
    `city` VARCHAR(50) DEFAULT NULL,
    `id_district` INT NOT NULL,
    `district` VARCHAR(50) DEFAULT NULL,
    `sc_seller_id` VARCHAR(50) DEFAULT NULL,
    `seller_name` VARCHAR(50) DEFAULT NULL,
    `length` DECIMAL(6 , 2 ) DEFAULT NULL,
    `width` DECIMAL(6 , 2 ) DEFAULT NULL,
    `height` DECIMAL(6 , 2 ) DEFAULT NULL,
    `weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `volumetric_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `formula_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `rounded_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `rate` DECIMAL(17 , 2 ) DEFAULT NULL,
    `calculated_shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `paid_by_customer` DECIMAL(17 , 2 ) DEFAULT NULL,
    `paid_by_seller` DECIMAL(17 , 2 ) DEFAULT NULL,
    `reimbursed_to_seller` DECIMAL(17 , 2 ) DEFAULT NULL,
    `free_zone` TINYINT(1) DEFAULT 0,
    `remarks` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item` , `order_nr` , `origin` , `id_package_dispatching` , `id_district` , `free_zone`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Calculated shipping fee from system and query';