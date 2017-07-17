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

CREATE DATABASE IF NOT EXISTS `lel_invoice_tracker` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `lel_invoice_tracker`;

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

DROP TABLE IF EXISTS `lel_invoice`;
DROP TABLE IF EXISTS `lel_invoice_history`;

CREATE TABLE `lel_invoice` (
    `bob_id_sales_order_item` INT(10) NOT NULL,
    `lazada_package_number` VARCHAR(255) NOT NULL,
    `weight` DECIMAL(17 , 2 ) DEFAULT NULL,
    `discounted_delivery_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_delivery_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `discounted_return_failed_delivery_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_return_failed_delivery_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `cod_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_cod_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `insurance_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_insurance_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `discounted_pickup_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_pickup_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `total_payment` DECIMAL(17 , 2 ) DEFAULT NULL,
    KEY (`bob_id_sales_order_item`),
    KEY (`lazada_package_number`),
    KEY (`total_payment`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='LEL Billing Invoice';

CREATE TABLE `lel_invoice_history` (
    `bob_id_sales_order_item` INT(10) NOT NULL,
    `lazada_package_number` VARCHAR(255) NOT NULL,
    `discounted_delivery_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_delivery_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `discounted_return_failed_delivery_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_return_failed_delivery_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `cod_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_cod_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `insurance_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_insurance_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `discounted_pickup_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `vat_pickup_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `total_payment` DECIMAL(17 , 2 ) DEFAULT NULL,
    `period` VARCHAR(255) NOT NULL,
    KEY (`bob_id_sales_order_item`),
    KEY (`lazada_package_number`),
    KEY (`total_payment`),
    KEY (`period`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='LEL History Invoice';