/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account vs Invoice Charge LocalDB Create
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

CREATE DATABASE  IF NOT EXISTS `maic` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `maic`;

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

DROP TABLE IF EXISTS `insurance_waive`;
DROP TABLE IF EXISTS `invoice`;
DROP TABLE IF EXISTS `oms`;
DROP TABLE IF EXISTS `vip_seller`;

CREATE TABLE `insurance_waive` (
    `seller_id` VARCHAR(50) NOT NULL,
    `seller_name` VARCHAR(150) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`seller_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Insurance Waive Data';

CREATE TABLE `invoice` (
    `tracking_number` VARCHAR(50) NOT NULL,
    `dest` VARCHAR(150) DEFAULT NULL,
    `qty` INT(10) NOT NULL,
    `weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `goods_value` DECIMAL(17 , 2 ) DEFAULT NULL,
    `insurance` DECIMAL(17 , 2 ) DEFAULT NULL,
    `delivery_charges` DECIMAL(17 , 2 ) DEFAULT NULL,
    PRIMARY KEY (`tracking_number`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Invoice Data';

CREATE TABLE `oms` (
    `order_nr` INT(10) NOT NULL,
    `sc_sales_order_item` INT(10) DEFAULT NULL,
    `seller_id` VARCHAR(50) NOT NULL,
    `sc_seller_id` VARCHAR(50) DEFAULT NULL,
    `seller_name` VARCHAR(50) DEFAULT NULL,
    `seller_type` VARCHAR(50) DEFAULT NULL,
    `tax_class` VARCHAR(50) DEFAULT NULL,
    `unit_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `last_status` VARCHAR(50) DEFAULT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `shipped_date` DATETIME DEFAULT NULL,
    `tracking_number` VARCHAR(50),
    `first_tracking_number` VARCHAR(50),
    `first_shipment_provider` VARCHAR(100) DEFAULT NULL,
    `qty` INT(10) NOT NULL,
    `sku` VARCHAR(50) DEFAULT NULL,
    `charged_to_seller` DECIMAL(17 , 2 ) DEFAULT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `city` VARCHAR(150) DEFAULT NULL,
    `length` DECIMAL(6 , 2 ) DEFAULT NULL,
    `width` DECIMAL(6 , 2 ) DEFAULT NULL,
    `height` DECIMAL(6 , 2 ) DEFAULT NULL,
    `weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `volumetric_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `system_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `formula_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `weight_remarks` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`tracking_number` , `order_nr` , `seller_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='OMS Data';

CREATE TABLE `vip_seller` (
    `seller_id` VARCHAR(50) NOT NULL,
    `seller_name` VARCHAR(150) DEFAULT NULL,
    `category` VARCHAR(50) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`seller_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='VIP Sellers Data';