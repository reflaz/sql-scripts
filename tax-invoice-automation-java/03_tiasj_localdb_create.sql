/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Tax Invoice Automation System - LocalDB Create
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/
DROP DATABASE IF EXISTS `tias_java`;

CREATE DATABASE IF NOT EXISTS `tias_java` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `tias_java`;

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

DROP TABLE IF EXISTS `seller_details`;
DROP TABLE IF EXISTS `seller_details_manual`;
DROP TABLE IF EXISTS `transaction`;
DROP TABLE IF EXISTS `transaction_type`;

CREATE TABLE `seller_details` (
    `bob_id_supplier` INT(10) UNSIGNED NOT NULL,
    `sc_id_seller` INT(10) UNSIGNED DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `legal_name` VARCHAR(255) DEFAULT NULL,
    `seller_name` VARCHAR(255) NOT NULL,
    `tax_class` ENUM('international', 'local') DEFAULT 'local',
    `vat_number` VARCHAR(255) DEFAULT NULL,
    `address` TEXT DEFAULT NULL,
    `email` VARCHAR(100) DEFAULT NULL,
    `updated_at` DATETIME DEFAULT NULL,
    PRIMARY KEY `bob_id_supplier` (`bob_id_supplier`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Supplier Details Manual List';

CREATE TABLE `seller_details_manual` (
    `bob_id_supplier` INT(10) UNSIGNED NOT NULL,
    `legal_name` VARCHAR(255) DEFAULT NULL,
    `seller_name` VARCHAR(255) NOT NULL,
    `vat_number` VARCHAR(255) DEFAULT NULL,
    `address` TEXT DEFAULT NULL,
    `email` VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY `bob_id_supplier` (`bob_id_supplier`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Supplier Details Manual List';

CREATE TABLE `transaction` (
    `transaction_number` VARCHAR(36) NOT NULL,
    `transaction_type` VARCHAR(255) DEFAULT NULL,
    `value` DECIMAL(20 , 2 ) DEFAULT NULL DEFAULT '0.00',
    `transaction_date` DATETIME DEFAULT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `sap_item_id` INT(10) UNSIGNED DEFAULT NULL COMMENT 'sync',
    `delivered_date` DATETIME DEFAULT NULL,
    `bob_id_supplier` INT(10) UNSIGNED DEFAULT NULL,
    PRIMARY KEY `transaction_number` (`transaction_number`),
    KEY `transaction_type` (`transaction_type`),
    KEY `transaction_date` (`transaction_date`),
    KEY `bob_id_supplier` (`bob_id_supplier`),
    KEY `sap_item_id` (`sap_item_id`),
    KEY `delivered_date` (`delivered_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Seller Center Transactions';

CREATE TABLE `transaction_type` (
    `id_transaction_type` INT(10) UNSIGNED NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `type` ENUM('credit', 'debit') DEFAULT NULL,
    `fk_fee_type` INT(10) UNSIGNED DEFAULT NULL,
    `ref_source` VARCHAR(128) DEFAULT NULL,
    PRIMARY KEY (`id_transaction_type`),
    KEY `description` (`description`),
    KEY `fk_fee_type` (`fk_fee_type`)
)  ENGINE=INNODB AUTO_INCREMENT=63 DEFAULT CHARSET=UTF8 COMMENT='Seller Center Transaction Types';