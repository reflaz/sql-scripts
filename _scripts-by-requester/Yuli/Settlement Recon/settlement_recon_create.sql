CREATE DATABASE  IF NOT EXISTS `settlement_recon` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `settlement_recon`;

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

DROP TABLE IF EXISTS `fbl5n`;
DROP TABLE IF EXISTS `settlement_report`;
DROP TABLE IF EXISTS `upload_incoming`;

CREATE TABLE `fbl5n` (
    `id_fbl5n` INT,
    `cocd` VARCHAR(5),
    `account` VARCHAR(20),
    `gl` INT,
    `document_no` INT,
    `reference` VARCHAR(50),
    `type` CHAR(2),
    `itm` INT,
    `doc_date` VARCHAR(12),
    `pstng_date` VARCHAR(12),
    `entry_date` VARCHAR(12),
    `pk` INT,
    `assignment` INT,
    `lc_amnt` DECIMAL(17 , 2 ) DEFAULT 0,
    `period` INT,
    `text` VARCHAR(50),
    `clrng_doc` VARCHAR(20),
    `clearing` VARCHAR(20),
    `ref_key_1` VARCHAR(20),
    `user_name` VARCHAR(20),
    `rev_with` VARCHAR(20),
    `reference_key_3` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id_fbl5n`),
    KEY `assignment` (`assignment`),
    KEY `type` (`type`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='SAP FBL5N Data Extract';

CREATE TABLE `settlement_report` (
	`id_settlement_report` INT,
    `transaction_date` DATETIME,
    `order_no` INT,
    `amount_gross` DECIMAL(17 , 2 ) DEFAULT 0,
    `amount_net` DECIMAL(17 , 2 ) DEFAULT 0,
    `notes` VARCHAR(100),
    PRIMARY KEY (`id_settlement_report`),
    KEY `order_no` (`order_no`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Settlement Report from Payment Team';

CREATE TABLE `upload_incoming` (
    `id_upload_incoming` INT,
    `type_of_charge` CHAR(4),
    `company_code` CHAR(4),
    `customer_no` VARCHAR(10),
    `invoice_number` VARCHAR(20),
    `document_date` VARCHAR(8),
    `posting_date` VARCHAR(8),
    `currency` CHAR(4),
    `oms_order_number` INT,
    `article_number` VARCHAR(20),
    `cost_center` VARCHAR(10),
    `amount` DECIMAL(20 , 2 ),
    `fee` DECIMAL(20 , 2 ),
    `bank_acct` VARCHAR(20),
    `tax_amount` DECIMAL(20 , 2 ),
    `tax_code` VARCHAR(10),
    `text` VARCHAR(50),
    PRIMARY KEY (`id_upload_incoming`),
    KEY `type_of_charge` (`type_of_charge`),
    KEY `oms_order_number` (`oms_order_number`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Upload Incoming to SAP';