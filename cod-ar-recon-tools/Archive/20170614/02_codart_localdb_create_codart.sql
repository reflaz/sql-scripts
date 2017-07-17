/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
COD AR Recon Tools LocalDB Create
 
Prepared by		: Michael Julius
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

CREATE DATABASE IF NOT EXISTS `cod_ar_recon` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `cod_ar_recon`;

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

CREATE TABLE `ar_population` (
    `soi_created_at` DATETIME DEFAULT NULL,
    `payment_method` VARCHAR(50) NOT NULL,
    `is_marketplace` INT NOT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `bob_id_sales_order_item` INT(10) NOT NULL,
    `sku` VARCHAR(255) NOT NULL,
    `item_name` VARCHAR(255) NOT NULL,
    `unit_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `paid_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `total_paid_by_customer` DECIMAL(17 , 2 ) DEFAULT NULL,
    `tracking_number` VARCHAR(255) DEFAULT NULL,
    `package_number` VARCHAR(255) NOT NULL,
    `id_shipment_provider` INT NOT NULL,
    `shipment_provider` VARCHAR(255) NOT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `last_status` VARCHAR(15) NOT NULL,
    `last_status_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`order_date`),
    KEY (`tracking_number`),
    KEY (`package_number`),
    KEY (`sku`),
    KEY (`id_shipment_provider`),
    KEY (`shipment_provider`),
    KEY (`soi_created_at`),
    KEY (`delivered_date`),
    KEY (`last_status_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='AR Population by SOI';

CREATE TABLE `incoming_ar` (
    `country` VARCHAR(10) DEFAULT NULL,
    `extract_type` VARCHAR(50) NOT NULL,
    `soi_created_at` DATETIME DEFAULT NULL,
    `payment_method` VARCHAR(50) NOT NULL,
    `is_marketplace` INT NOT NULL,
    `posting_date` DATETIME DEFAULT NULL,
    `doc_date` DATETIME DEFAULT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `bob_id_sales_order_item` INT(10) NOT NULL,
    `unit_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `paid_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `store_redit` DECIMAL(17 , 2 ) DEFAULT NULL,
    `marketing_voucher` DECIMAL(17 , 2 ) DEFAULT NULL,
    `cart_rule_discount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `bundle_discount_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `article` VARCHAR(50) NOT NULL,
    `bob_id_customer` INT NOT NULL,
    `tracking_number` VARCHAR(255) DEFAULT NULL,
    `package_number` VARCHAR(255) NOT NULL,
    `shippingprovider` VARCHAR(255) NOT NULL,
    `tax_percent` INT NOT NULL,
    `tax_amount` INT NOT NULL,
    `bob_regional_key` BIGINT NOT NULL,
    `supplier_code` VARCHAR(50) NOT NULL,
    `receiving_bank` VARCHAR(255) NOT NULL,
    `loyalty_point_discount_on_item` DECIMAL(17 , 2 ) DEFAULT NULL,
    `is_gst_free` INT NOT NULL,
    `id_sales_order_item_status_history` INT NOT NULL,
    `coupon_code` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`soi_created_at`),
    KEY (`doc_date`),
    KEY (`order_nr`),
    KEY (`bob_id_customer`),
    KEY (`tracking_number`),
    KEY (`package_number`),
    KEY (`shippingprovider`),
    KEY (`bob_regional_key`),
    KEY (`supplier_code`),
    KEY (`id_sales_order_item_status_history`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Lex incoming AR Population';

CREATE TABLE `ar_missing` (
    `country` VARCHAR(10) DEFAULT NULL,
    `extract_type` VARCHAR(50) NOT NULL,
    `soi_created_at` DATETIME DEFAULT NULL,
    `payment_method` VARCHAR(50) NOT NULL,
    `is_marketplace` INT NOT NULL,
    `posting_date` DATETIME DEFAULT NULL,
    `doc_date` DATETIME DEFAULT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `bob_id_sales_order_item` INT(10) NOT NULL,
    `unit_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `paid_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `store_redit` DECIMAL(17 , 2 ) DEFAULT NULL,
    `marketing_voucher` DECIMAL(17 , 2 ) DEFAULT NULL,
    `cart_rule_discount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `bundle_discount_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `article` VARCHAR(50) NOT NULL,
    `bob_id_customer` INT NOT NULL,
    `tracking_number` VARCHAR(255) DEFAULT NULL,
    `package_number` VARCHAR(255) NOT NULL,
    `id_shipment_provider` INT NOT NULL,
    `shippingprovider` VARCHAR(255) NOT NULL,
    `tax_percent` INT NOT NULL,
    `tax_amount` INT NOT NULL,
    `bob_regional_key` BIGINT NOT NULL,
    `supplier_code` VARCHAR(50) NOT NULL,
    `receiving_bank` VARCHAR(255) NOT NULL,
    `loyalty_point_discount_on_item` DECIMAL(17 , 2 ) DEFAULT NULL,
    `is_gst_free` INT NOT NULL,
    `id_sales_order_item_status_history` INT NOT NULL,
    `coupon_code` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`soi_created_at`),
    KEY (`doc_date`),
    KEY (`order_nr`),
    KEY (`bob_id_customer`),
    KEY (`tracking_number`),
    KEY (`package_number`),
    KEY (`shippingprovider`),
    KEY (`bob_regional_key`),
    KEY (`supplier_code`),
    KEY (`id_sales_order_item_status_history`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Missing AR';

CREATE TABLE `recon_table` (
    `recon_status` VARCHAR(255) NOT NULL,
    `id_shipment_provider` INT NOT NULL,
    `shipment_provider_name` VARCHAR(255) NOT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `bob_id_sales_order_item` INT(10) NOT NULL,
    `package_number` VARCHAR(255) NOT NULL,
    `tracking_number` VARCHAR(255) DEFAULT NULL,
    `item_name` VARCHAR(255) NOT NULL,
    `last_status` VARCHAR(15) NOT NULL,
    `last_status_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `paid_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `total_paid_by_customer` DECIMAL(17 , 2 ) DEFAULT NULL,
    `incoming_shipment_provider` VARCHAR(255) NOT NULL,
    `incoming_package_number` VARCHAR(255) NOT NULL,
    `incoming_tracking_number` VARCHAR(255) DEFAULT NULL,
    `incoming_doc_date` DATETIME DEFAULT NULL,
    `incoming_paid_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `incoming_shipping_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `incoming_shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `incoming_total_paid_by_customer` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipment_provider_remarks` VARCHAR(255) NOT NULL,
    `package_number_remarks` VARCHAR(255) NOT NULL,
    `tracking_number_remarks` VARCHAR(255) NOT NULL,
    `delivered_date_remarks` VARCHAR(255) NOT NULL,
    `paid_by_customer_remarks` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`id_shipment_provider`),
    KEY (`shipment_provider_name`),
    KEY (`order_nr`),
    KEY (`package_number`),
    KEY (`tracking_number`),
    KEY (`delivered_date`),
	KEY (`incoming_shipment_provider`),
    KEY (`incoming_package_number`),
    KEY (`incoming_tracking_number`),
    KEY (`incoming_doc_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Recon Table';

CREATE TABLE `ar_outstanding` (
    `soi_created_at` DATETIME DEFAULT NULL,
    `payment_method` VARCHAR(50) NOT NULL,
    `is_marketplace` INT NOT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `bob_id_sales_order_item` INT(10) NOT NULL,
    `sku` VARCHAR(255) NOT NULL,
    `item_name` VARCHAR(255) NOT NULL,
    `unit_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `paid_price` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(17 , 2 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(17 , 2 ) DEFAULT NULL,
    `total_paid_by_customer` DECIMAL(17 , 2 ) DEFAULT NULL,
    `tracking_number` VARCHAR(255) DEFAULT NULL,
    `package_number` VARCHAR(255) NOT NULL,
    `id_shipment_provider` INT NOT NULL,
    `shipment_provider_name` VARCHAR(255) NOT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `last_status` VARCHAR(15) NOT NULL,
    `last_status_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`order_date`),
    KEY (`tracking_number`),
    KEY (`package_number`),
    KEY (`sku`),
    KEY (`id_shipment_provider`),
    KEY (`shipment_provider_name`),
    KEY (`soi_created_at`),
    KEY (`delivered_date`),
    KEY (`last_status_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Outstanding AR by SOI';