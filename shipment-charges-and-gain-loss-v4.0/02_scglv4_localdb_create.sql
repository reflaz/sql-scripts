/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss
LocalDB Create

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

DROP DATABASE IF EXISTS  `scglv4`;
CREATE DATABASE IF NOT EXISTS `scglv4` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `scglv4`;

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

CREATE TABLE IF NOT EXISTS `anondb_extract` (
    `bob_id_sales_order_item` INT(10) UNSIGNED NOT NULL,
    `sc_sales_order_item` INT(10) UNSIGNED DEFAULT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `payment_method` VARCHAR(50) DEFAULT NULL,
    `tenor` VARCHAR(64) DEFAULT NULL,
    `bank` VARCHAR(45) DEFAULT NULL,
    `sku` VARCHAR(50) DEFAULT NULL,
    `primary_category` INT(10) UNSIGNED DEFAULT NULL,
    `bob_id_supplier` INT(10) UNSIGNED DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT NULL,
    `seller_type` VARCHAR(10) DEFAULT NULL,
    `tax_class` VARCHAR(15) DEFAULT NULL,
    `is_marketplace` TINYINT(4) DEFAULT NULL,
    `order_value` DECIMAL(20 , 4 ) DEFAULT NULL,
    `payment_value` DECIMAL(20 , 4 ) DEFAULT NULL,
    `unit_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `paid_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(20 , 4 ) DEFAULT NULL,
    `coupon_money_value` DECIMAL(20 , 4 ) DEFAULT NULL,
    `cart_rule_discount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `retail_cogs` DECIMAL(20 , 4 ) DEFAULT NULL,
    `coupon_type` VARCHAR(50) DEFAULT NULL,
    `last_status` VARCHAR(50) DEFAULT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `finance_verified_date` DATETIME DEFAULT NULL,
    `first_shipped_date` DATETIME DEFAULT NULL,
    `last_shipped_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `not_delivered_date` DATETIME DEFAULT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `id_district` INT NOT NULL,
    `bob_id_customer` INT(10) UNSIGNED DEFAULT NULL,
    `pickup_provider_type` VARCHAR(12) DEFAULT NULL,
    `id_package_dispatching` BIGINT(20) UNSIGNED DEFAULT NULL,
    `package_number` VARCHAR(50) DEFAULT NULL,
    `first_tracking_number` VARCHAR(45) DEFAULT NULL,
    `first_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `last_tracking_number` VARCHAR(45) DEFAULT NULL,
    `last_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `config_length` DECIMAL(20 , 4 ) DEFAULT NULL,
    `config_width` DECIMAL(20 , 4 ) DEFAULT NULL,
    `config_height` DECIMAL(20 , 4 ) DEFAULT NULL,
    `config_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `simple_length` DECIMAL(20 , 4 ) DEFAULT NULL,
    `simple_width` DECIMAL(20 , 4 ) DEFAULT NULL,
    `simple_height` DECIMAL(20 , 4 ) DEFAULT NULL,
    `simple_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_type` VARCHAR(100) DEFAULT NULL,
    `delivery_type` VARCHAR(45) DEFAULT NULL,
    `commission` DECIMAL(20 , 4 ) DEFAULT NULL,
    `payment_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `auto_shipping_fee_credit` DECIMAL(20 , 4 ) DEFAULT NULL,
    `manual_shipping_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`payment_method`),
    KEY (`tenor`),
    KEY (`bank`),
    KEY (`sku`),
    KEY (`primary_category`),
    KEY (`bob_id_supplier`),
    KEY (`short_code`),
    KEY (`seller_type`),
    KEY (`tax_class`),
    KEY (`is_marketplace`),
    KEY (`coupon_type`),
    KEY (`last_status`),
    KEY (`order_date`),
    KEY (`finance_verified_date`),
    KEY (`first_shipped_date`),
    KEY (`last_shipped_date`),
    KEY (`delivered_date`),
    KEY (`not_delivered_date`),
    KEY (`origin`),
    KEY (`id_district`),
    KEY (`bob_id_customer`),
    KEY (`pickup_provider_type`),
    KEY (`id_package_dispatching`),
    KEY (`package_number`),
    KEY (`first_tracking_number`),
    KEY (`first_shipment_provider`),
    KEY (`last_tracking_number`),
    KEY (`last_shipment_provider`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='AnonDB Extracted data';

CREATE TABLE IF NOT EXISTS `api_const_charge_type` (
    `id_api_charge_type` INT(10) NOT NULL AUTO_INCREMENT,
    `charge_type` VARCHAR(20) DEFAULT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `created_at` DATETIME DEFAULT NULL,
    `updated_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_api_charge_type`),
    UNIQUE KEY (`charge_type`),
    KEY (`created_at`),
    KEY (`updated_at`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='API Charge Type Constraints';

CREATE TABLE IF NOT EXISTS `api_const_posting_type` (
    `id_api_posting_type` INT(10) NOT NULL AUTO_INCREMENT,
    `posting_type` VARCHAR(20) DEFAULT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `created_at` DATETIME DEFAULT NULL,
    `updated_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_api_posting_type`),
    UNIQUE KEY (`posting_type`),
    KEY (`created_at`),
    KEY (`updated_at`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='API Posting Type Constraints';

CREATE TABLE IF NOT EXISTS `api_const_status` (
    `id_api_status` INT(10) NOT NULL AUTO_INCREMENT,
    `status` VARCHAR(20) DEFAULT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `created_at` DATETIME DEFAULT NULL,
    `updated_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_api_status`),
    UNIQUE KEY (`status`),
    KEY (`created_at`),
    KEY (`updated_at`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='API Status Constraints';

CREATE TABLE `api_direct_billing` (
    `id_api_direct_billing` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `api_date` VARCHAR(20) DEFAULT NULL,
    `posting_type` VARCHAR(20) DEFAULT NULL,
    `charge_type` VARCHAR(20) DEFAULT NULL,
    `is_actual` TINYINT(4) DEFAULT NULL,
    `id_package_dispatching` BIGINT(20) UNSIGNED DEFAULT NULL,
    `package_number` VARCHAR(50) DEFAULT NULL,
    `bob_id_supplier` INT(10) UNSIGNED DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `formula_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `rounded_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `weight_source` VARCHAR(50) DEFAULT NULL,
    `amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `tax_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `id_api_direct_billing_reference` BIGINT(20) DEFAULT NULL,
    `commentary` VARCHAR(255) DEFAULT NULL,
    `is_in_master_account` TINYINT(4) DEFAULT NULL,
    `status` VARCHAR(20) DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `created_at` DATETIME DEFAULT NULL,
    `updated_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_api_direct_billing`),
    KEY (`api_date`),
    KEY (`posting_type`),
    KEY (`charge_type`),
    KEY (`is_actual`),
    KEY (`id_package_dispatching`),
    KEY (`package_number`),
    KEY (`bob_id_supplier`),
    KEY (`short_code`),
    KEY (`id_api_direct_billing_reference`),
    KEY (`is_in_master_account`),
    KEY (`status`),
    KEY (`delivered_date`),
    KEY (`created_at`),
    KEY (`updated_at`),
    CONSTRAINT `posting_type_constraint_db` FOREIGN KEY (`posting_type`)
        REFERENCES `api_const_posting_type` (`posting_type`)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `charge_type_constraint_db` FOREIGN KEY (`charge_type`)
        REFERENCES `api_const_charge_type` (`charge_type`)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `status_constraint_db` FOREIGN KEY (`status`)
        REFERENCES `api_const_status` (`status`)
        ON DELETE RESTRICT ON UPDATE RESTRICT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Direct Billing API Data';

CREATE TABLE `api_master_account` (
    `id_api_master_account` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `api_date` VARCHAR(20) DEFAULT NULL,
    `posting_type` VARCHAR(20) DEFAULT NULL,
    `charge_type` VARCHAR(20) DEFAULT NULL,
    `is_actual` TINYINT(4) DEFAULT NULL,
    `id_package_dispatching` BIGINT(20) UNSIGNED DEFAULT NULL,
    `package_number` VARCHAR(50) DEFAULT NULL,
    `bob_id_supplier` INT(10) UNSIGNED DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `formula_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `rounded_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `weight_source` VARCHAR(50) DEFAULT NULL,
    `amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `tax_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `id_api_master_account_reference` BIGINT(20) DEFAULT NULL,
    `commentary` VARCHAR(255) DEFAULT NULL,
    `is_in_direct_billing` TINYINT(4) DEFAULT NULL,
    `status` VARCHAR(20) DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `created_at` DATETIME DEFAULT NULL,
    `updated_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_api_master_account`),
    KEY (`api_date`),
    KEY (`posting_type`),
    KEY (`charge_type`),
    KEY (`is_actual`),
    KEY (`id_package_dispatching`),
    KEY (`package_number`),
    KEY (`bob_id_supplier`),
    KEY (`short_code`),
    KEY (`id_api_master_account_reference`),
    KEY (`is_in_direct_billing`),
    KEY (`status`),
    KEY (`delivered_date`),
    KEY (`created_at`),
    KEY (`updated_at`),
    CONSTRAINT `posting_type_constraint_ma` FOREIGN KEY (`posting_type`)
        REFERENCES `api_const_posting_type` (`posting_type`)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `charge_type_constraint_ma` FOREIGN KEY (`charge_type`)
        REFERENCES `api_const_charge_type` (`charge_type`)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `status_constraint_ma` FOREIGN KEY (`status`)
        REFERENCES `api_const_status` (`status`)
        ON DELETE RESTRICT ON UPDATE RESTRICT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Master Account API Data';

CREATE TABLE IF NOT EXISTS `shipment_scheme` (
    `id_shipment_scheme` INT(10) UNSIGNED NOT NULL,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `exclude_payment_method` VARCHAR(50) DEFAULT NULL,
    `tax_class` VARCHAR(15) DEFAULT NULL,
    `is_marketplace` TINYINT(4) DEFAULT NULL,
    `exclude_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `first_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `last_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `shipping_type` VARCHAR(100) DEFAULT NULL,
    `delivery_type` VARCHAR(45) DEFAULT NULL,
    `auto_shipping_fee_credit` DECIMAL(20 , 4 ) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    KEY (`id_shipment_scheme`),
    KEY (`shipment_scheme`),
    KEY (`exclude_payment_method`),
    KEY (`tax_class`),
    KEY (`is_marketplace`),
    KEY (`exclude_shipment_provider`),
    KEY (`first_shipment_provider`),
    KEY (`last_shipment_provider`),
    KEY (`shipping_type`),
    KEY (`delivery_type`),
    KEY (`auto_shipping_fee_credit`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Shipment Scheme';

CREATE TABLE IF NOT EXISTS `transaction` (
    `id_transaction` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
    `fk_seller` BIGINT(20) DEFAULT NULL COMMENT 'seller id',
    `fk_transaction_type` INT(11) NOT NULL COMMENT 'transaction type id',
    `is_unique` TINYINT(4) DEFAULT NULL COMMENT 'is unique',
    `transaction_source` VARCHAR(128) DEFAULT 'sellercenter' COMMENT 'enum(\'sellercenter\',\'web\',\'csv\')',
    `fk_user` BIGINT(20) DEFAULT NULL COMMENT 'user id',
    `description` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'description',
    `value` DECIMAL(20 , 2 ) NOT NULL DEFAULT '0.00' COMMENT 'transaction amount',
    `taxes_vat` DECIMAL(22 , 4 ) DEFAULT NULL COMMENT 'vat value',
    `taxes_wht` DECIMAL(22 , 4 ) DEFAULT NULL COMMENT 'wht value',
    `is_wht_in_amount` TINYINT(4) NOT NULL DEFAULT '0' COMMENT 'is_wht_in_amount',
    `ref` BIGINT(20) DEFAULT NULL COMMENT 'order item id, order id, etc',
    `ref_date` INT(11) DEFAULT NULL COMMENT 'ref date',
    `override_ref_source` VARCHAR(128) DEFAULT NULL COMMENT 'override ref_source',
    `number` VARCHAR(36) DEFAULT NULL COMMENT 'transaction number',
    `fk_transaction_statement` BIGINT(20) DEFAULT NULL COMMENT 'statement id',
    `created_at` DATETIME NOT NULL COMMENT 'create time',
    `updated_at` DATETIME NOT NULL COMMENT 'update time',
    `fk_qc_user` BIGINT(20) DEFAULT NULL COMMENT 'qc user id',
    PRIMARY KEY (`id_transaction`),
    UNIQUE KEY `unique_index` (`fk_transaction_type` , `is_unique` , `ref`),
    UNIQUE KEY `number` (`number`),
    KEY `created_at` (`created_at`),
    KEY `ref_date` (`ref_date`),
    KEY `ref` (`ref`),
    KEY `fk_transaction_statement` (`fk_transaction_statement`),
    KEY `idx_fk_seller_fk_transaction_type` (`fk_seller` , `fk_transaction_type`),
    KEY `transaction_fk_user` (`fk_user`),
    KEY `transaction_fk_qc_user` (`fk_qc_user`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='finance transaction';

CREATE TABLE IF NOT EXISTS `transaction_type` (
    `id_transaction_type` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'transaction type id',
    `description` VARCHAR(255) NOT NULL COMMENT 'description',
    `type` VARCHAR(128) NOT NULL COMMENT 'debit or credit',
    `fk_fee_type` INT(11) DEFAULT NULL COMMENT 'fee type id',
    `ref_source` VARCHAR(128) DEFAULT NULL COMMENT 'reference source',
    `fee_process_type` VARCHAR(128) DEFAULT NULL COMMENT 'fee processing type automatic/manual',
    PRIMARY KEY (`id_transaction_type`),
    KEY `description` (`description`),
    KEY `fk_fee_type` (`fk_fee_type`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Transaction Type';