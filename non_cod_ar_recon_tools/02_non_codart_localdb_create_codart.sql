/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
NON COD AR Recon Tools LocalDB Create
 
Prepared by		: Michael Julius
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

CREATE DATABASE IF NOT EXISTS `non_cod_recon` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `non_cod_recon`;

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

DROP TABLE IF EXISTS `ar_population`;
DROP TABLE IF EXISTS `incoming_ar`;
DROP TABLE IF EXISTS `ar_missing`;
DROP TABLE IF EXISTS `ar_outstanding`;
DROP TABLE IF EXISTS `recon_table`;
DROP TABLE IF EXISTS `outstanding_incoming_ar`; 

CREATE TABLE `ar_population` (
    `bob_id_sales_order_item` VARCHAR(45) NOT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `payment_method` VARCHAR(50) NOT NULL,
	`item_name` VARCHAR(255) NOT NULL,
    `sku` VARCHAR(255) NOT NULL,
    `bob_id_supplier` VARCHAR(255) DEFAULT NULL,
    `short_code` VARCHAR(255) DEFAULT NULL,
	`seller_name` VARCHAR(255) DEFAULT NULL,
    `seller_type` VARCHAR(255) DEFAULT NULL,
	`tax_class` VARCHAR(255) DEFAULT NULL,
    `unit_price` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `paid_price` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `shipping_amount` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `shipping_surcharge` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `total_paid_by_customer` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `last_status` VARCHAR(15) NOT NULL,
    `order_date` DATETIME DEFAULT NULL,
	`ovip_date` DATETIME DEFAULT NULL,
    `ovip_by` VARCHAR(255) NOT NULL,
    `delivery_updater` VARCHAR(255) NOT NULL,
    `package_number` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`package_number`),
    KEY (`sku`),
    KEY (`order_date`),
    KEY (`ovip_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='AR Population by OVIP Date and Payment Method';

CREATE TABLE `incoming_ar` (
    `merchant_wallet_id` VARCHAR(50) DEFAULT NULL,
    `report_date` DATETIME DEFAULT NULL,
    `transaction_id` VARCHAR(50) DEFAULT NULL,
    `incoming_order_nr` VARCHAR(50) NOT NULL,
    `batch_id` VARCHAR(50) DEFAULT NULL,
    `event` VARCHAR(50) DEFAULT NULL,
    `event_status` VARCHAR(50) DEFAULT NULL,
    `reference_id` VARCHAR(50) DEFAULT NULL,
    `initiation_date` DATETIME DEFAULT NULL,
    `completion_date` DATETIME DEFAULT NULL,
    `currency` VARCHAR(50) NOT NULL,
    `gross_amount` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    KEY (`incoming_order_nr`),
    KEY (`report_date`),
    KEY (`transaction_id`),
    KEY (`completion_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Incoming AR Population';

CREATE TABLE `ar_missing` (
     `merchant_wallet_id` VARCHAR(50) DEFAULT NULL,
    `report_date` DATETIME DEFAULT NULL,
    `transaction_id` VARCHAR(50) DEFAULT NULL,
    `incoming_order_nr` VARCHAR(50) NOT NULL,
    `batch_id` VARCHAR(50) DEFAULT NULL,
    `event` VARCHAR(50) DEFAULT NULL,
    `event_status` VARCHAR(50) DEFAULT NULL,
    `reference_id` VARCHAR(50) DEFAULT NULL,
    `initiation_date` DATETIME DEFAULT NULL,
    `completion_date` DATETIME DEFAULT NULL,
    `currency` VARCHAR(50) NOT NULL,
    `gross_amount` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    KEY (`incoming_order_nr`),
    KEY (`report_date`),
    KEY (`transaction_id`),
    KEY (`completion_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Missing AR';

CREATE TABLE `recon_table` (
    `order_nr` VARCHAR(45) NOT NULL,
    `payment_method` VARCHAR(50) NOT NULL,
	`item_name` VARCHAR(255) NOT NULL,
    `sku` VARCHAR(255) NOT NULL,
    `bob_id_supplier` VARCHAR(255) DEFAULT NULL,
    `short_code` VARCHAR(255) DEFAULT NULL,
	`seller_name` VARCHAR(255) DEFAULT NULL,
    `seller_type` VARCHAR(255) DEFAULT NULL,
	`tax_class` VARCHAR(255) DEFAULT NULL,
    `unit_price` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `paid_price` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `shipping_amount` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `shipping_surcharge` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `total_paid_by_customer` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `last_status` VARCHAR(15) NOT NULL,
    `order_date` DATETIME DEFAULT NULL,
	`ovip_date` DATETIME DEFAULT NULL,
    `ovip_by` VARCHAR(255) NOT NULL,
    `delivery_updater` VARCHAR(255) NOT NULL,
    `package_number` VARCHAR(255) NOT NULL,
    `merchant_wallet_id` VARCHAR(50) DEFAULT NULL,
    `report_date` DATETIME DEFAULT NULL,
    `transaction_id` VARCHAR(50) DEFAULT NULL,
    `incoming_order_nr` VARCHAR(50) NOT NULL,
    `batch_id` VARCHAR(50) DEFAULT NULL,
    `event` VARCHAR(50) DEFAULT NULL,
    `event_status` VARCHAR(50) DEFAULT NULL,
    `reference_id` VARCHAR(50) DEFAULT NULL,
    `initiation_date` DATETIME DEFAULT NULL,
    `completion_date` DATETIME DEFAULT NULL,
    `currency` VARCHAR(50) NOT NULL,
    `gross_amount` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    KEY (`order_date`),
    KEY (`package_number`),
    KEY (`sku`),
    KEY (`ovip_date`),
    KEY (`report_date`),
    KEY (`transaction_id`),
    KEY (`completion_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Recon Table';

CREATE TABLE `ar_outstanding` (
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `payment_method` VARCHAR(50) NOT NULL,
	`item_name` VARCHAR(255) NOT NULL,
    `sku` VARCHAR(255) NOT NULL,
    `bob_id_supplier` VARCHAR(255) DEFAULT NULL,
    `short_code` VARCHAR(255) DEFAULT NULL,
	`seller_name` VARCHAR(255) DEFAULT NULL,
    `seller_type` VARCHAR(255) DEFAULT NULL,
	`tax_class` VARCHAR(255) DEFAULT NULL,
    `unit_price` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `paid_price` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `shipping_amount` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `shipping_surcharge` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `total_paid_by_customer` DECIMAL(17 , 2 ) NOT NULL DEFAULT 0,
    `last_status` VARCHAR(15) NOT NULL,
    `order_date` DATETIME DEFAULT NULL,
	`ovip_date` DATETIME DEFAULT NULL,
    `ovip_by` VARCHAR(255) NOT NULL,
    `delivery_updater` VARCHAR(255) NOT NULL,
    `package_number` VARCHAR(255) NOT NULL,
    KEY (`order_nr`),
    KEY (`order_date`),
    KEY (`package_number`),
    KEY (`sku`),
    KEY (`ovip_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Outstanding AR by SOI';