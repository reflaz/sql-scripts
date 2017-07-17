/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account Charge and Gain Loss LocalDB Create
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

CREATE DATABASE  IF NOT EXISTS `macgl` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `macgl`;

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

DROP TABLE IF EXISTS `free_zone`;
DROP TABLE IF EXISTS `insurance_waive`;
DROP TABLE IF EXISTS `jne_rate`;
DROP TABLE IF EXISTS `oms`;
DROP TABLE IF EXISTS `vip_seller`;

CREATE TABLE `free_zone` (
    `id_region` INT NOT NULL,
    `region` VARCHAR(50) DEFAULT NULL,
    `id_city` INT NOT NULL,
    `city` VARCHAR(50) DEFAULT NULL,
    `id_district` INT NOT NULL,
    `district` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`id_district`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Home Zone';

CREATE TABLE `insurance_waive` (
    `seller_id` VARCHAR(50) NOT NULL,
    `seller_name` VARCHAR(150) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`seller_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Insurance Waive Data';

CREATE TABLE `jne_rate` (
    `origin` VARCHAR(50) NOT NULL,
    `id_region` INT NOT NULL,
    `region` VARCHAR(50) DEFAULT NULL,
    `id_city` INT NOT NULL,
    `city` VARCHAR(50) DEFAULT NULL,
    `id_district` INT NOT NULL,
    `district` VARCHAR(50) DEFAULT NULL,
    `rate` DECIMAL(17 , 2 ) DEFAULT 0,
    PRIMARY KEY (`origin` , `id_district`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Uploaded JNE Rate';

CREATE TABLE `oms` (
    `bob_id_sales_order_item` INT NOT NULL,
    `sc_sales_order_item` INT DEFAULT NULL,
    `order_nr` INT NOT NULL,
    `payment_method` VARCHAR(50) DEFAULT NULL,
    `sku` VARCHAR(50) DEFAULT NULL,
    `primary_category` INT DEFAULT NULL,
    `seller_id` VARCHAR(50) NOT NULL,
    `sc_seller_id` VARCHAR(50) DEFAULT NULL,
    `seller_name` VARCHAR(50) DEFAULT NULL,
    `seller_type` VARCHAR(50) DEFAULT NULL,
    `tax_class` VARCHAR(50) DEFAULT NULL,
    `unit_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `paid_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `commission_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `coupon_money_value` DECIMAL(17 , 2 ) DEFAULT NULL,
    `cart_rule_discount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `coupon_code` VARCHAR(50) DEFAULT NULL,
    `coupon_type` VARCHAR(50) DEFAULT NULL,
    `cart_rule_display_names` VARCHAR(50) DEFAULT NULL,
    `last_status` VARCHAR(50) DEFAULT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `first_shipped_date` DATETIME DEFAULT NULL,
    `last_shipped_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `package_number` VARCHAR(255),
    `id_package_dispatching` INT NOT NULL,
    `first_tracking_number` VARCHAR(50),
    `first_shipment_provider` VARCHAR(100) DEFAULT NULL,
    `last_tracking_number` VARCHAR(50),
    `last_shipment_provider` VARCHAR(100) DEFAULT NULL,
    `sc_shipping_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    `id_district` INT NOT NULL,
    `length` DECIMAL(6 , 2 ) DEFAULT NULL,
    `width` DECIMAL(6 , 2 ) DEFAULT NULL,
    `height` DECIMAL(6 , 2 ) DEFAULT NULL,
    `weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `volumetric_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `item_formula_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    `item_rounded_weight` DECIMAL(6 , 2 ) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`seller_id`),
    KEY (`sc_seller_id`),
    KEY (`tax_class`),
    KEY (`order_date`),
    KEY (`first_shipped_date`),
    KEY (`last_shipped_date`),
    KEY (`delivered_date`),
    KEY (`id_package_dispatching`),
    KEY (`first_shipment_provider`),
    KEY (`last_shipment_provider`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='OMS Data';

CREATE TABLE `vip_seller` (
    `seller_id` VARCHAR(50) NOT NULL,
    `seller_name` VARCHAR(150) DEFAULT NULL,
    `category` VARCHAR(50) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`seller_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='VIP Sellers Data';