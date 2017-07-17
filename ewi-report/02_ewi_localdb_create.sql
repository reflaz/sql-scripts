/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
EWI Report LocalDB Create

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/
DROP DATABASE IF EXISTS  `ewi`;

CREATE DATABASE IF NOT EXISTS `ewi` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ewi`;

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

DROP TABLE IF EXISTS `ewi_extract`;

CREATE TABLE `ewi_extract` (
    `order_number` VARCHAR(45) DEFAULT NULL,
    `sales_order_item` INT(10) UNSIGNED NOT NULL,
    `sap_item_id` INT(10) UNSIGNED DEFAULT NULL,
    `sc_sales_order_item` INT(10) UNSIGNED DEFAULT NULL,
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
    `unit_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `paid_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `coupon_money_value` DECIMAL(20 , 4 ) DEFAULT NULL,
    `cart_rule_discount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(20 , 4 ) DEFAULT NULL,
    `item_price_credit` DECIMAL(20 , 4 ) DEFAULT NULL,
    `commission` DECIMAL(20 , 4 ) DEFAULT NULL,
    `payment_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_fee_credit` DECIMAL(20 , 4 ) DEFAULT NULL,
    `item_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `comission_credit` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `seller_credit` DECIMAL(20 , 4 ) DEFAULT NULL,
    `seller_credit_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `other_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `seller_debit_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `amount_paid_seller` DECIMAL(20 , 4 ) DEFAULT NULL,
    `transaction_id` VARCHAR(50) DEFAULT NULL,
    `transaction_date` DATETIME DEFAULT NULL,
    `statement_time_frame_start` DATETIME DEFAULT NULL,
    `statement_time_frame_end` DATETIME DEFAULT NULL,
    `sku` VARCHAR(50) DEFAULT NULL,
    `district_id` INT(10) DEFAULT NULL,
    `awb` VARCHAR(45) DEFAULT NULL,
    `shipment_provider` VARCHAR(64) NOT NULL,
    `sc_id_seller` VARCHAR(50) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT NULL,
    `legal_name` VARCHAR(255) DEFAULT NULL,
    `tax_class` VARCHAR(15) DEFAULT NULL,
    KEY (`sales_order_item`),
    KEY (`item_price_credit`),
    KEY (`order_number`),
    KEY (`sap_item_id`),
    KEY (`sc_sales_order_item`),
    KEY (`tax_class`),
    KEY (`order_date`),
    KEY (`verified_date`),
    KEY (`shipped_date`),
    KEY (`delivered_date`),
    KEY (`returned_date`),
    KEY (`replaced_date`),
    KEY (`refunded_date`),
    KEY (`transaction_id`),
    KEY (`district_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='AnonDB data';
