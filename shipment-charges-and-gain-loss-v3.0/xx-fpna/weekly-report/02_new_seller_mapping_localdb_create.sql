/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss LocalDB Create

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

CREATE DATABASE IF NOT EXISTS `seller_mapping` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `seller_mapping`;

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

CREATE TABLE IF NOT EXISTS `brand_partnership` (
    `id_brand_partnership` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_supplier` INT(10) DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT NULL,
    `fk_catalog_brand` INT(10) DEFAULT NULL,
    `catalog_category` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id_brand_partnership`),
    KEY (`id_supplier`),
    KEY (`short_code`),
    KEY (`fk_catalog_brand`),
    KEY (`catalog_category`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE IF NOT EXISTS `catalog_brand` (
    `id_catalog_brand` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `regional_key` VARCHAR(5) DEFAULT NULL,
    `status` ENUM('active', 'inactive', 'deleted', 'pending_approve') NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `name_en` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id_catalog_brand`),
    KEY `regional_key` (`regional_key`),
    KEY `idx_status` (`status`),
    KEY `name` (`name`),
    KEY `name_en` (`name_en`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='SEAAMZ-4728';

CREATE TABLE IF NOT EXISTS `catalog_config` (
    `id_catalog_config` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `sku` VARCHAR(255) NOT NULL,
    `status` ENUM('active', 'inactive', 'deleted') NOT NULL DEFAULT 'active',
    `fk_catalog_brand` INT(10) UNSIGNED DEFAULT NULL,
    `primary_category` INT(10) UNSIGNED DEFAULT NULL,
    `created_at` DATETIME DEFAULT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_catalog_config`),
    UNIQUE KEY `sku` (`sku`),
    KEY `status` (`status`),
    KEY `fk_catalog_brand` (`fk_catalog_brand`),
    KEY `primary_category_to_catalog_category` (`primary_category`),
    KEY `created_at` (`created_at`),
    KEY `updated_at` (`updated_at`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;