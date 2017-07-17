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

CREATE DATABASE  IF NOT EXISTS `zpcr` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `zpcr`;

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

DROP TABLE IF EXISTS `category_tree`;
DROP TABLE IF EXISTS `general_commission`;
DROP TABLE IF EXISTS `commission_tree_mapping`;
DROP TABLE IF EXISTS `oms`;

CREATE TABLE `category_tree` (
    `level0_id` INT(11) DEFAULT NULL,
    `level0` VARCHAR(50) DEFAULT NULL,
    `level1_id` INT(11) DEFAULT NULL,
    `level1` VARCHAR(50) DEFAULT NULL,
    `level2_id` INT(11) DEFAULT NULL,
    `level2` VARCHAR(50) DEFAULT NULL,
    `level3_id` INT(11) DEFAULT NULL,
    `level3` VARCHAR(50) DEFAULT NULL,
    `level4_id` INT(11) DEFAULT NULL,
    `level4` VARCHAR(50) DEFAULT NULL,
    `level5_id` INT(11) DEFAULT NULL,
    `level5` VARCHAR(50) DEFAULT NULL,
    `level6_id` INT(11) DEFAULT NULL,
    `level6` VARCHAR(50) DEFAULT NULL,
    `lookup_cat_id` INT(11) DEFAULT NULL,
    `lookup_cat_name` VARCHAR(50) DEFAULT NULL,
    KEY `level0_id` (`level0_id`),
    KEY `level1_id` (`level1_id`),
    KEY `level2_id` (`level2_id`),
    KEY `level3_id` (`level3_id`),
    KEY `level4_id` (`level4_id`),
    KEY `level5_id` (`level5_id`),
    KEY `level6_id` (`level6_id`),
    KEY `lookup_cat_id` (`lookup_cat_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Category Tree';

CREATE TABLE `general_commission` (
    `tax_class` VARCHAR(50) NOT NULL,
    `level0` VARCHAR(50) DEFAULT NULL,
    `level1` VARCHAR(255) DEFAULT NULL,
    `level2` VARCHAR(1000) DEFAULT NULL,
    `level3` VARCHAR(1000) DEFAULT NULL,
    `level4` VARCHAR(1000) DEFAULT NULL,
    `level5` VARCHAR(1000) DEFAULT NULL,
    `level6` VARCHAR(1000) DEFAULT NULL,
    `general_commission` DECIMAL(6 , 2 ),
    `lookup_cat_id` INT NOT NULL,
    `lookup_cat_name` VARCHAR(1000) DEFAULT NULL,
    PRIMARY KEY `pk_general_commission` (`tax_class` , `lookup_cat_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='General Commission';

CREATE TABLE `commission_tree_mapping` (
    `tax_class` VARCHAR(50) NOT NULL,
    `level0_id` INT(11) DEFAULT NULL,
    `level0` VARCHAR(50) DEFAULT NULL,
    `level1_id` INT(11) DEFAULT NULL,
    `level1` VARCHAR(50) DEFAULT NULL,
    `level2_id` INT(11) DEFAULT NULL,
    `level2` VARCHAR(50) DEFAULT NULL,
    `level3_id` INT(11) DEFAULT NULL,
    `level3` VARCHAR(50) DEFAULT NULL,
    `level4_id` INT(11) DEFAULT NULL,
    `level4` VARCHAR(50) DEFAULT NULL,
    `level5_id` INT(11) DEFAULT NULL,
    `level5` VARCHAR(50) DEFAULT NULL,
    `level6_id` INT(11) DEFAULT NULL,
    `level6` VARCHAR(50) DEFAULT NULL,
    `general_commission` DECIMAL(6 , 2 ),
    `lookup_cat_id` INT(11) NOT NULL,
    `lookup_cat_name` VARCHAR(50) DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    PRIMARY KEY `pk_general_commission` (`tax_class` , `lookup_cat_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='BOB Category Tree';

CREATE TABLE `oms` (
    `order_nr` INT NOT NULL,
    `bob_id_sales_order_item` INT NOT NULL,
    `sap_item_id` INT NOT NULL,
    `sc_sales_order_item` INT NOT NULL,
    `payment_method` VARCHAR(50) DEFAULT NULL,
    `item_status` VARCHAR(50) DEFAULT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `verified_date` DATETIME DEFAULT NULL,
    `shipped_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `delivered_date_input` DATETIME DEFAULT NULL,
    `returned_date` DATETIME DEFAULT NULL,
    `replaced_date` DATETIME DEFAULT NULL,
    `refunded_date` DATETIME DEFAULT NULL,
    `unit_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `paid_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `coupon_money_value` DECIMAL(17 , 2 ) DEFAULT NULL,
    `cart_rule_discount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `item_price_credit` DECIMAL(17 , 2 ) DEFAULT NULL,
    `commission` DECIMAL(17 , 2 ) DEFAULT NULL,
    `payment_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_fee_credit` DECIMAL(17 , 2 ) DEFAULT NULL,
    `item_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `commission_credit` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `sku` VARCHAR(50) DEFAULT NULL,
    `primary_category` INT DEFAULT NULL,
    `id_district` INT DEFAULT NULL,
    `shipment_provider` VARCHAR(50) DEFAULT NULL,
    `seller_id` INT DEFAULT NULL,
    `sc_seller_id` VARCHAR(50) DEFAULT NULL,
    `seller_name` VARCHAR(50) DEFAULT NULL,
    `tax_class` VARCHAR(50) DEFAULT NULL
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='OMS';