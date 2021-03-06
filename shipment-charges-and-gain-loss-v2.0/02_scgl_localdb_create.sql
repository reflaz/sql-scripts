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
DROP DATABASE IF EXISTS  `scgl`;

CREATE DATABASE IF NOT EXISTS `scgl` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `scgl`;

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

DROP TABLE IF EXISTS `anondb_extract`;
DROP TABLE IF EXISTS `anondb_extract_update`;
DROP TABLE IF EXISTS `anondb_calculate`;
DROP TABLE IF EXISTS `campaign`;
DROP TABLE IF EXISTS `campaign_tracker`;
DROP TABLE IF EXISTS `free_zone`;
DROP TABLE IF EXISTS `invoice`;
DROP TABLE IF EXISTS `rate_card`;
DROP TABLE IF EXISTS `rate_card_customer`;
DROP TABLE IF EXISTS `rate_card_scheme`;
DROP TABLE IF EXISTS `shipment_scheme`;
DROP TABLE IF EXISTS `shipment_provider`;
DROP TABLE IF EXISTS `zone_type`;
DROP TABLE IF EXISTS `wp_backmargin`;

CREATE TABLE `anondb_extract` (
    `bob_id_sales_order_item` INT(10) UNSIGNED NOT NULL,
    `sc_sales_order_item` INT(10) UNSIGNED DEFAULT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `payment_method` VARCHAR(50) DEFAULT NULL,
    `sku` VARCHAR(255) DEFAULT NULL,
    `primary_category` INT(10) UNSIGNED DEFAULT NULL,
    `bob_id_supplier` INT(10) UNSIGNED DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT '',
    `seller_type` VARCHAR(10) DEFAULT NULL,
    `tax_class` VARCHAR(15) DEFAULT NULL,
    `unit_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `paid_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(20 , 4 ) DEFAULT NULL,
    `marketplace_commission_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `coupon_money_value` DECIMAL(20 , 4 ) DEFAULT NULL,
    `cart_rule_discount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `coupon_code` VARCHAR(50) DEFAULT NULL,
    `coupon_type` VARCHAR(50) DEFAULT NULL,
    `cart_rule_display_names` VARCHAR(50) DEFAULT NULL,
    `last_status` VARCHAR(50) DEFAULT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `first_shipped_date` DATETIME DEFAULT NULL,
    `last_shipped_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `not_delivered_date` DATETIME DEFAULT NULL,
    `closed_date` DATETIME DEFAULT NULL,
    `refund_completed_date` DATETIME DEFAULT NULL,
    `pickup_provider_type` VARCHAR(12) DEFAULT NULL,
    `package_number` VARCHAR(255),
    `id_package_dispatching` BIGINT(20) UNSIGNED DEFAULT NULL,
    `invoice_tracking_number` VARCHAR(45) DEFAULT NULL,
    `invoice_shipment_provider` VARCHAR(64) NOT NULL,
    `first_tracking_number` VARCHAR(45) DEFAULT NULL,
    `first_shipment_provider` VARCHAR(64) NOT NULL,
    `last_tracking_number` VARCHAR(45) DEFAULT NULL,
    `last_shipment_provider` VARCHAR(64) NOT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    `id_district` INT NOT NULL,
    `config_length` DECIMAL(6 , 4 ) DEFAULT NULL,
    `config_width` DECIMAL(6 , 4 ) DEFAULT NULL,
    `config_height` DECIMAL(6 , 4 ) DEFAULT NULL,
    `config_weight` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_length` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_width` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_height` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_weight` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipping_type` VARCHAR(100),
    `delivery_type` VARCHAR(45),
    `is_marketplace` TINYINT(4),
    `is_express_shipping` TINYINT(4),
    `fast_delivery` TINYINT(4),
    `retail_cogs` DECIMAL(20 , 4 ) DEFAULT NULL,
    `payment_cost_logic` TINYINT(4),
    `sc_fee_1` DECIMAL(20 , 4 ) DEFAULT NULL,
    `sc_fee_2` DECIMAL(20 , 4 ) DEFAULT NULL,
    `sc_fee_3` DECIMAL(20 , 4 ) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`bob_id_supplier`),
    KEY (`short_code`),
    KEY (`tax_class`),
    KEY (`order_date`),
    KEY (`first_shipped_date`),
    KEY (`last_shipped_date`),
    KEY (`delivered_date`),
    KEY (`not_delivered_date`),
    KEY (`pickup_provider_type`),
    KEY (`origin`),
    KEY (`id_package_dispatching`),
    KEY (`invoice_tracking_number`),
    KEY (`package_number`),
    KEY (`first_shipment_provider`),
    KEY (`last_shipment_provider`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='AnonDB data';

CREATE TABLE `anondb_extract_update` (
    `bob_id_sales_order_item` INT(10) UNSIGNED NOT NULL,
    `sc_sales_order_item` INT(10) UNSIGNED DEFAULT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `payment_method` VARCHAR(50) DEFAULT NULL,
    `sku` VARCHAR(255) DEFAULT NULL,
    `primary_category` INT(10) UNSIGNED DEFAULT NULL,
    `bob_id_supplier` INT(10) UNSIGNED DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT '',
    `seller_type` VARCHAR(10) DEFAULT NULL,
    `tax_class` VARCHAR(15) DEFAULT NULL,
    `unit_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `paid_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(20 , 4 ) DEFAULT NULL,
    `marketplace_commission_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `coupon_money_value` DECIMAL(20 , 4 ) DEFAULT NULL,
    `cart_rule_discount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `coupon_code` VARCHAR(50) DEFAULT NULL,
    `coupon_type` VARCHAR(50) DEFAULT NULL,
    `cart_rule_display_names` VARCHAR(50) DEFAULT NULL,
    `last_status` VARCHAR(50) DEFAULT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `first_shipped_date` DATETIME DEFAULT NULL,
    `last_shipped_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `not_delivered_date` DATETIME DEFAULT NULL,
    `closed_date` DATETIME DEFAULT NULL,
    `refund_completed_date` DATETIME DEFAULT NULL,
    `pickup_provider_type` VARCHAR(12) DEFAULT NULL,
    `package_number` VARCHAR(255) DEFAULT NULL,
    `id_package_dispatching` BIGINT(20) UNSIGNED DEFAULT NULL,
    `invoice_tracking_number` VARCHAR(45) DEFAULT NULL,
    `invoice_shipment_provider` VARCHAR(64) NOT NULL,
    `first_tracking_number` VARCHAR(45) DEFAULT NULL,
    `first_shipment_provider` VARCHAR(64) NOT NULL,
    `last_tracking_number` VARCHAR(45) DEFAULT NULL,
    `last_shipment_provider` VARCHAR(64) NOT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    `id_district` INT(11) NOT NULL,
    `config_length` DECIMAL(6 , 4 ) DEFAULT NULL,
    `config_width` DECIMAL(6 , 4 ) DEFAULT NULL,
    `config_height` DECIMAL(6 , 4 ) DEFAULT NULL,
    `config_weight` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_length` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_width` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_height` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_weight` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipping_type` VARCHAR(100) DEFAULT NULL,
    `delivery_type` VARCHAR(45) DEFAULT NULL,
    `is_marketplace` TINYINT(4) DEFAULT NULL,
    `is_express_shipping` TINYINT(4) DEFAULT NULL,
    `fast_delivery` TINYINT(4) DEFAULT NULL,
    `retail_cogs` DECIMAL(20 , 4 ) DEFAULT NULL,
    `payment_cost_logic` TINYINT(4) DEFAULT NULL,
    `sc_fee_1` DECIMAL(20 , 4 ) DEFAULT NULL,
    `sc_fee_2` DECIMAL(20 , 4 ) DEFAULT NULL,
    `sc_fee_3` DECIMAL(20 , 4 ) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY `order_nr` (`order_nr`),
    KEY `bob_id_supplier` (`bob_id_supplier`),
    KEY `short_code` (`short_code`),
    KEY `tax_class` (`tax_class`),
    KEY `order_date` (`order_date`),
    KEY `first_shipped_date` (`first_shipped_date`),
    KEY `last_shipped_date` (`last_shipped_date`),
    KEY `delivered_date` (`delivered_date`),
    KEY `not_delivered_date` (`not_delivered_date`),
    KEY `pickup_provider_type` (`pickup_provider_type`),
    KEY `origin` (`origin`),
    KEY `id_package_dispatching` (`id_package_dispatching`),
    KEY `invoice_tracking_number` (`invoice_tracking_number`),
    KEY `package_number` (`package_number`),
    KEY `first_shipment_provider` (`first_shipment_provider`),
    KEY `last_shipment_provider` (`last_shipment_provider`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='AnonDB data';

CREATE TABLE `anondb_calculate` (
    `bob_id_sales_order_item` INT(10) UNSIGNED NOT NULL,
    `sc_sales_order_item` INT(10) UNSIGNED DEFAULT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `payment_method` VARCHAR(50) DEFAULT NULL,
    `sku` VARCHAR(255) DEFAULT NULL,
    `primary_category` INT(10) UNSIGNED DEFAULT NULL,
    `bob_id_supplier` INT(10) UNSIGNED DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT '',
    `seller_type` VARCHAR(10) DEFAULT NULL,
    `tax_class` VARCHAR(15) DEFAULT NULL,
    `unit_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `paid_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_surcharge_old` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_fee_to_customer` DECIMAL(20 , 4 ) DEFAULT NULL,
    `marketplace_commission_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `coupon_money_value` DECIMAL(20 , 4 ) DEFAULT NULL,
    `cart_rule_discount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `coupon_code` VARCHAR(50) DEFAULT NULL,
    `coupon_type` VARCHAR(50) DEFAULT NULL,
    `cart_rule_display_names` VARCHAR(50) DEFAULT NULL,
    `last_status` VARCHAR(50) DEFAULT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `first_shipped_date` DATETIME DEFAULT NULL,
    `last_shipped_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `not_delivered_date` DATETIME DEFAULT NULL,
    `closed_date` DATETIME DEFAULT NULL,
    `refund_completed_date` DATETIME DEFAULT NULL,
    `pickup_provider_type` VARCHAR(12) DEFAULT NULL,
    `package_number` VARCHAR(255),
    `id_package_dispatching` BIGINT(20) UNSIGNED DEFAULT NULL,
    `invoice_tracking_number` VARCHAR(45) DEFAULT NULL,
    `invoice_shipment_provider` VARCHAR(64) NOT NULL,
    `first_tracking_number` VARCHAR(45) DEFAULT NULL,
    `first_shipment_provider` VARCHAR(64) NOT NULL,
    `last_tracking_number` VARCHAR(45) DEFAULT NULL,
    `last_shipment_provider` VARCHAR(64) NOT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    `id_district` INT NOT NULL,
    `config_length` DECIMAL(6 , 4 ) DEFAULT NULL,
    `config_width` DECIMAL(6 , 4 ) DEFAULT NULL,
    `config_height` DECIMAL(6 , 4 ) DEFAULT NULL,
    `config_weight` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_length` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_width` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_height` DECIMAL(6 , 4 ) DEFAULT NULL,
    `simple_weight` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipping_type` VARCHAR(100),
    `delivery_type` VARCHAR(45),
    `is_marketplace` TINYINT(4),
    `is_express_shipping` TINYINT(4),
    `fast_delivery` TINYINT(4),
    `retail_cogs` DECIMAL(20 , 4 ) DEFAULT NULL,
    `payment_cost_logic` TINYINT(4),
    `sc_fee_1` DECIMAL(20 , 4 ) DEFAULT NULL,
    `sc_fee_2` DECIMAL(20 , 4 ) DEFAULT NULL,
    `sc_fee_3` DECIMAL(20 , 4 ) DEFAULT NULL,
    `qty` VARCHAR(255) DEFAULT NULL,
    `formula_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `rounded_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `chargeable_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `rounded_chargeable_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `chargeable_qty` VARCHAR(255) DEFAULT NULL,
    `fk_campaign` INT(10) DEFAULT NULL,
    `campaign` VARCHAR(50) DEFAULT NULL,
    `fk_rate_card_scheme` INT(10) UNSIGNED DEFAULT NULL,
    `rate_card_scheme` VARCHAR(50) DEFAULT NULL,
    `fk_shipment_scheme` INT(10) UNSIGNED DEFAULT NULL,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `fk_zone_type` INT(10) UNSIGNED DEFAULT NULL,
    `zone_type` VARCHAR(255) DEFAULT '',
    `shipment_fee_mp_seller_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_fee_mp_seller` DECIMAL(20 , 4 ) DEFAULT NULL,
    `sel_ins_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `sel_ins_fee_vat` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_insurance_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_shipment_fee_mp_seller` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_cost_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_cost_discount` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipment_cost_vat` DECIMAL(6 , 4 ) DEFAULT NULL,
    `total_shipment_cost` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_discount` DECIMAL(6 , 4 ) DEFAULT NULL,
    `pickup_cost_vat` DECIMAL(6 , 4 ) DEFAULT NULL,
    `total_pickup_cost` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_rate` DECIMAL(6 , 4 ) DEFAULT NULL,
    `insurance_vat` DECIMAL(6 , 4 ) DEFAULT NULL,
    `sp_ins_charge` DECIMAL(20 , 4 ) DEFAULT NULL,
    `sp_ins_charge_vat` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_insurance_charge` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_delivery_cost` DECIMAL(20 , 4 ) DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`bob_id_supplier`),
    KEY (`short_code`),
    KEY (`tax_class`),
    KEY (`order_date`),
    KEY (`first_shipped_date`),
    KEY (`last_shipped_date`),
    KEY (`delivered_date`),
    KEY (`not_delivered_date`),
    KEY (`pickup_provider_type`),
    KEY (`origin`),
    KEY (`id_package_dispatching`),
    KEY (`invoice_tracking_number`),
    KEY (`package_number`),
    KEY (`first_shipment_provider`),
    KEY (`last_shipment_provider`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Calculation data';

CREATE TABLE `campaign` (
    `id_campaign` INT(10) UNSIGNED NOT NULL,
    `campaign` VARCHAR(50) DEFAULT NULL,
    `shipment_fee_mp_seller_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    KEY (`id_campaign`),
    KEY (`campaign`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Campaign';

CREATE TABLE `campaign_tracker` (
    `id_campaign_tracker` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `fk_campaign` INT(10) DEFAULT NULL,
    `bob_id_supplier` INT(10) DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT '',
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    PRIMARY KEY (`id_campaign_tracker`),
    KEY (`fk_campaign`),
    KEY (`bob_id_supplier`),
    KEY (`short_code`),
    KEY (`start_date`),
    KEY (`end_date`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Campaign tracker';

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
    `active` TINYINT DEFAULT 1,
    KEY `level0_id` (`level0_id`),
    KEY `level1_id` (`level1_id`),
    KEY `level2_id` (`level2_id`),
    KEY `level3_id` (`level3_id`),
    KEY `level4_id` (`level4_id`),
    KEY `level5_id` (`level5_id`),
    KEY `level6_id` (`level6_id`),
    KEY `lookup_cat_id` (`lookup_cat_id`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='BOB Category Tree';

CREATE TABLE `free_zone` (
    `id_free_zone` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_region` INT(10) UNSIGNED DEFAULT NULL,
    `region` VARCHAR(255) DEFAULT '',
    `id_city` INT(10) UNSIGNED DEFAULT NULL,
    `city` VARCHAR(255) DEFAULT '',
    `id_district` INT(10) UNSIGNED NOT NULL,
    `district` VARCHAR(255) DEFAULT '',
    `fk_zone_type` INT(10) UNSIGNED DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    KEY (`id_district`),
    KEY (`id_free_zone`),
    KEY (`fk_zone_type`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Free zone';

CREATE TABLE `invoice` (
    `tracking_number` VARCHAR(45) NOT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT '',
    `origin` VARCHAR(255) DEFAULT NULL,
    `destination` VARCHAR(255) DEFAULT NULL,
    `qty` VARCHAR(255) DEFAULT NULL,
    `weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `unit_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance` DECIMAL(17 , 4 ) DEFAULT NULL,
    `pickup_cost` DECIMAL(17 , 4 ) DEFAULT NULL,
    `delivery_charge` DECIMAL(17 , 4 ) DEFAULT NULL,
    `shipment_provider_name` VARCHAR(64) DEFAULT NULL,
    `free_text` VARCHAR(255) DEFAULT NULL,
    KEY (`tracking_number`),
    KEY (`order_nr`),
    KEY (`short_code`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Invoice Data';

CREATE TABLE `rate_card` (
    `id_rate_card` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `fk_rate_card_scheme` INT(10) UNSIGNED DEFAULT NULL,
    `origin` VARCHAR(64) NOT NULL,
    `id_region` INT(10) UNSIGNED DEFAULT NULL,
    `region` VARCHAR(255) DEFAULT '',
    `id_city` INT(10) UNSIGNED DEFAULT NULL,
    `city` VARCHAR(255) DEFAULT '',
    `id_district` INT(10) UNSIGNED NOT NULL,
    `district` VARCHAR(255) DEFAULT '',
    `shipment_cost_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_cost_discount` DECIMAL(6 , 4 ) DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    PRIMARY KEY (`id_rate_card`),
    KEY (`fk_rate_card_scheme`),
    KEY (`origin`),
    KEY (`id_district`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Rate card';

CREATE TABLE `rate_card_customer` (
    `id_rate_card` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `fk_rate_card_scheme` INT(10) UNSIGNED DEFAULT NULL,
    `origin` VARCHAR(64) NOT NULL,
    `id_region` INT(10) UNSIGNED DEFAULT NULL,
    `region` VARCHAR(255) DEFAULT '',
    `id_city` INT(10) UNSIGNED DEFAULT NULL,
    `city` VARCHAR(255) DEFAULT '',
    `id_district` INT(10) UNSIGNED NOT NULL,
    `district` VARCHAR(255) DEFAULT '',
    `rounding` DECIMAL(20 , 4 ) DEFAULT NULL,
    `weight_break` DECIMAL(20 , 4 ) DEFAULT NULL,
    `flat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_cost_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_cost_discount` DECIMAL(6 , 4 ) DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    PRIMARY KEY (`id_rate_card`),
    KEY (`fk_rate_card_scheme`),
    KEY (`origin`),
    KEY (`id_district`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Customer Rate card';

CREATE TABLE `rate_card_scheme` (
    `id_rate_card_scheme` INT(10) UNSIGNED NOT NULL,
    `rate_card_scheme` VARCHAR(50) DEFAULT NULL,
    `shipment_cost_discount` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipment_cost_vat` DECIMAL(6 , 4 ) DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    PRIMARY KEY (`id_rate_card_scheme`),
    KEY (`rate_card_scheme`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Rate card scheme';

CREATE TABLE `shipment_provider` (
    `id_shipment_provider` INT(10) UNSIGNED NOT NULL,
    `shipment_provider_name` VARCHAR(64) DEFAULT NULL,
    `fk_shipment_scheme` INT(10) UNSIGNED DEFAULT NULL,
    `chargeable_weight_lower` DECIMAL(6 , 4 ) DEFAULT NULL,
    `chargeable_weight_upper` DECIMAL(6 , 4 ) DEFAULT NULL,
    `volumetric_constant` DECIMAL(6 , 4 ) DEFAULT NULL,
    `weight_rounding` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipment_fee_mp_seller_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_cost_discount` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipment_cost_vat` DECIMAL(6 , 4 ) DEFAULT NULL,
    `pickup_cost` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_discount` DECIMAL(6 , 4 ) DEFAULT NULL,
    `pickup_cost_vat` DECIMAL(6 , 4 ) DEFAULT NULL,
    `insurance_rate` DECIMAL(6 , 4 ) DEFAULT NULL,
    `insurance_vat` DECIMAL(6 , 4 ) DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    PRIMARY KEY (`id_shipment_provider`),
    KEY (`shipment_provider_name`),
    KEY (`fk_shipment_scheme`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Shipment provider';

CREATE TABLE `shipment_scheme` (
    `id_shipment_scheme` INT(10) UNSIGNED NOT NULL,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `pickup_provider_type` VARCHAR(50) DEFAULT NULL,
    `shipment_fee_mp_seller_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_rate` DECIMAL(6 , 4 ) DEFAULT NULL,
    `insurance_vat` DECIMAL(6 , 4 ) DEFAULT NULL,
    `fk_rate_card_scheme` INT(10) UNSIGNED DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    PRIMARY KEY (`id_shipment_scheme`),
    KEY (`shipment_scheme`),
    KEY (`pickup_provider_type`),
    KEY (`fk_rate_card_scheme`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Shipment scheme';

CREATE TABLE `zone_type` (
    `id_zone_type` INT(10) UNSIGNED NOT NULL,
    `zone_type` VARCHAR(255) DEFAULT '',
    `active` TINYINT DEFAULT 1,
    PRIMARY KEY (`id_zone_type`),
    KEY (`zone_type`),
    KEY (`active`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Zone type';

CREATE TABLE `wp_backmargin` (
    `sku` VARCHAR(255) DEFAULT NULL,
    `backmargin_per_item` DECIMAL(20 , 4) DEFAULT NULL,
    `periode_order_date` DATE DEFAULT NULL,
    KEY (`sku`),
    KEY (`periode_order_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='WP Backmargin';