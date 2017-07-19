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
DROP DATABASE IF EXISTS  `scglv3`;

CREATE DATABASE IF NOT EXISTS `scglv3` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `scglv3`;

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
    `package_number` VARCHAR(255) DEFAULT NULL,
    `id_package_dispatching` BIGINT(20) UNSIGNED DEFAULT NULL,
    `tenor` VARCHAR(64) DEFAULT NULL,
    `bank` VARCHAR(45) DEFAULT NULL,
    `first_tracking_number` VARCHAR(45) DEFAULT NULL,
    `first_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `last_tracking_number` VARCHAR(45) DEFAULT NULL,
    `last_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    `id_district` INT NOT NULL,
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
    `is_marketplace` TINYINT(4) DEFAULT NULL,
    `bob_id_customer` INT(10) UNSIGNED DEFAULT NULL,
    `fast_delivery` TINYINT(4) DEFAULT NULL,
    `retail_cogs` DECIMAL(20 , 4 ) DEFAULT NULL,
    `order_value` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_fee_credit` DECIMAL(20 , 4 ) DEFAULT NULL,
    `seller_cr_db_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`payment_method`),
    KEY (`bob_id_supplier`),
    KEY (`short_code`),
    KEY (`tax_class`),
    KEY (`order_date`),
    KEY (`last_status`),
    KEY (`first_shipped_date`),
    KEY (`last_shipped_date`),
    KEY (`delivered_date`),
    KEY (`not_delivered_date`),
    KEY (`pickup_provider_type`),
    KEY (`origin`),
    KEY (`id_package_dispatching`),
    KEY (`package_number`),
    KEY (`first_shipment_provider`),
    KEY (`last_shipment_provider`),
    KEY (`id_district`),
    KEY (`tenor`),
    KEY (`bank`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='AnonDB Extracted data';

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
    `tenor` VARCHAR(64) DEFAULT NULL,
    `bank` VARCHAR(45) DEFAULT NULL,
    `first_tracking_number` VARCHAR(45) DEFAULT NULL,
    `first_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `last_tracking_number` VARCHAR(45) DEFAULT NULL,
    `last_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `origin` VARCHAR(50) NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    `id_district` INT NOT NULL,
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
    `is_marketplace` TINYINT(4) DEFAULT NULL,
    `bob_id_customer` INT(10) UNSIGNED DEFAULT NULL,
    `fast_delivery` TINYINT(4) DEFAULT NULL,
    `retail_cogs` DECIMAL(20 , 4 ) DEFAULT NULL,
    `order_value` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_fee` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_fee_credit` DECIMAL(20 , 4 ) DEFAULT NULL,
    `seller_cr_db_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `zone_type` VARCHAR(255) DEFAULT NULL,
    `weight_seller_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    -- `is_package_weight_seller` TINYINT(4),
    `formula_weight_seller_ps` DECIMAL(20 , 4 ) DEFAULT NULL,
    `chargeable_weight_seller_ps` DECIMAL(20 , 4 ) DEFAULT NULL,
    `weight_3pl_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    -- `is_package_weight_3pl` TINYINT(4),
    `formula_weight_3pl_ps` DECIMAL(20 , 4 ) DEFAULT NULL,
    `chargeable_weight_3pl_ps` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `rate_card_scheme` VARCHAR(12) DEFAULT NULL,
    `campaign` VARCHAR(50) DEFAULT NULL,
    `qty_ps` DECIMAL(6 , 4 ) DEFAULT NULL,
    `rounding_seller` DECIMAL(6 , 4 ) DEFAULT NULL,
    `rounding_3pl` DECIMAL(6 , 4 ) DEFAULT NULL,
    `order_flat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `mdr_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `ipp_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_fee_mp_seller_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_discount_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_vat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_vat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_rate_sel` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_vat_rate_sel` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_rate_3pl` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_vat_rate_3pl` DECIMAL(20 , 4 ) DEFAULT NULL,
    `flat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_discount_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `unit_price_pct` DECIMAL(20 , 4 ) DEFAULT NULL,
    `cust_charge_pct` DECIMAL(20 , 4 ) DEFAULT NULL,
    `weight_seller_pct` DECIMAL(20 , 4 ) DEFAULT NULL,
    `weight_3pl_pct` DECIMAL(20 , 4 ) DEFAULT NULL,
    `order_flat_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `mdr_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `ipp_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_fee_mp_seller_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_seller_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_vat_seller_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_discount_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_vat_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_discount_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_vat_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_3pl_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_vat_3pl_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_shipment_fee_mp_seller_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_delivery_cost_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_failed_delivery_cost_item` DECIMAL(20 , 4 ) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`payment_method`),
    KEY (`sku`),
    KEY (`bob_id_supplier`),
    KEY (`short_code`),
    KEY (`tax_class`),
    KEY (`order_date`),
    KEY (`last_status`),
    KEY (`first_shipped_date`),
    KEY (`last_shipped_date`),
    KEY (`delivered_date`),
    KEY (`not_delivered_date`),
    KEY (`pickup_provider_type`),
    KEY (`origin`),
    KEY (`id_package_dispatching`),
    KEY (`package_number`),
    KEY (`first_shipment_provider`),
    KEY (`last_shipment_provider`),
    KEY (`id_district`),
    KEY (`tenor`),
    KEY (`bank`),
    KEY (`zone_type`),
    KEY (`shipment_scheme`),
    KEY (`rate_card_scheme`),
    KEY (`campaign`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='AnonDB Calculated data';

CREATE TABLE `anondb_extract_temp` (
    `bob_id_sales_order_item` INT(10) UNSIGNED NOT NULL,
    `order_nr` VARCHAR(45) DEFAULT NULL,
    `bob_id_supplier` INT(10) UNSIGNED DEFAULT NULL,
    `unit_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `paid_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_amount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipping_surcharge` DECIMAL(20 , 4 ) DEFAULT NULL,
    `order_date` DATETIME DEFAULT NULL,
    `first_shipped_date` DATETIME DEFAULT NULL,
    `last_shipped_date` DATETIME DEFAULT NULL,
    `delivered_date` DATETIME DEFAULT NULL,
    `not_delivered_date` DATETIME DEFAULT NULL,
    `closed_date` DATETIME DEFAULT NULL,
    `refund_completed_date` DATETIME DEFAULT NULL,
    `zone_type` VARCHAR(255) DEFAULT NULL,
    `id_package_dispatching` BIGINT(20) UNSIGNED DEFAULT NULL,
    `package_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `volumetric_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `is_package_weight_seller` TINYINT(4),
    `formula_weight_seller` DECIMAL(20 , 4 ) DEFAULT NULL,
    `chargeable_weight_seller` DECIMAL(20 , 4 ) DEFAULT NULL,
    `is_package_weight_3pl` TINYINT(4),
    `formula_weight_3pl` DECIMAL(20 , 4 ) DEFAULT NULL,
    `chargeable_weight_3pl` DECIMAL(20 , 4 ) DEFAULT NULL,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `rate_card_scheme` VARCHAR(12) DEFAULT NULL,
    `campaign` VARCHAR(50) DEFAULT NULL,
    `qty` DECIMAL(6 , 4 ) DEFAULT NULL,
    `rounding_seller` DECIMAL(6 , 4 ) DEFAULT NULL,
    `rounding_3pl` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipment_fee_mp_seller_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_discount_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_vat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_vat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_rate_tmp` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_rate_sel` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_vat_rate_sel` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_rate_3pl` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_vat_rate_3pl` DECIMAL(20 , 4 ) DEFAULT NULL,
    `flat_rate` DECIMAL(20 , 5 ) DEFAULT NULL,
    `delivery_cost_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_discount_rate` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipment_fee_mp_seller` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_seller` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_vat_seller` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_discount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_vat` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_discount` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_vat` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_3pl` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_vat_3pl` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_shipment_fee_mp_seller` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_delivery_cost` DECIMAL(20 , 4 ) DEFAULT NULL,
    `total_failed_delivery_cost` DECIMAL(20 , 4 ) DEFAULT NULL,
    PRIMARY KEY (`bob_id_sales_order_item`),
    KEY (`order_nr`),
    KEY (`bob_id_supplier`),
    KEY (`id_package_dispatching`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='AnonDB temporary calculation data';

CREATE TABLE `backmargin` (
    `sku` VARCHAR(255) DEFAULT NULL,
    `backmargin` DECIMAL(20 , 4) DEFAULT NULL,
    `bm_date` DATE DEFAULT NULL,
    KEY (`sku`),
    KEY (`bm_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Backmargin';

CREATE TABLE `campaign` (
    `id_campaign` INT(10) UNSIGNED NOT NULL,
    `campaign` VARCHAR(50) DEFAULT NULL,
    `shipment_fee_mp_seller_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    KEY `id_campaign` (`id_campaign`),
    KEY `campaign` (`campaign`),
    KEY `start_date` (`start_date`),
    KEY `end_date` (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Campaign';

CREATE TABLE `campaign_mapping` (
    `id_campaign_mapping` INT(10) UNSIGNED NOT NULL,
    `fk_campaign` VARCHAR(50) DEFAULT NULL,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_campaign_mapping`),
    KEY (`fk_campaign`),
    KEY (`shipment_scheme`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Campaign';

CREATE TABLE `campaign_shipment_scheme` (
    `id_campaign_shipment_scheme` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `fk_campaign` INT(10) DEFAULT NULL,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `shipment_fee_mp_seller_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_campaign_shipment_scheme`),
    KEY (`fk_campaign`),
    KEY (`shipment_scheme`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Campaign tracker';

CREATE TABLE `campaign_tracker` (
    `id_campaign_tracker` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `fk_campaign` INT(10) DEFAULT NULL,
    `bob_id_supplier` INT(10) DEFAULT NULL,
    `short_code` VARCHAR(7) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT '',
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_campaign_tracker`),
    KEY (`fk_campaign`),
    KEY (`bob_id_supplier`),
    KEY (`short_code`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Campaign tracker';

CREATE TABLE `category_general_commission` (
    `tax_class` VARCHAR(50) NOT NULL,
    `level0` VARCHAR(50) DEFAULT NULL,
    `level1` VARCHAR(255) DEFAULT NULL,
    `level2` VARCHAR(255) DEFAULT NULL,
    `level3` VARCHAR(255) DEFAULT NULL,
    `level4` VARCHAR(255) DEFAULT NULL,
    `level5` VARCHAR(255) DEFAULT NULL,
    `level6` VARCHAR(255) DEFAULT NULL,
    `general_commission` DECIMAL(6 , 2 ),
    `id_primary_category` INT NOT NULL,
    `category_name` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY `pk_general_commission` (`tax_class` , `id_primary_category`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='General Commission';

CREATE TABLE `category_tree` (
    `level0_id` INT(11) DEFAULT NULL,
    `level0` VARCHAR(255) DEFAULT NULL,
    `level1_id` INT(11) DEFAULT NULL,
    `level1` VARCHAR(255) DEFAULT NULL,
    `level2_id` INT(11) DEFAULT NULL,
    `level2` VARCHAR(255) DEFAULT NULL,
    `level3_id` INT(11) DEFAULT NULL,
    `level3` VARCHAR(255) DEFAULT NULL,
    `level4_id` INT(11) DEFAULT NULL,
    `level4` VARCHAR(255) DEFAULT NULL,
    `level5_id` INT(11) DEFAULT NULL,
    `level5` VARCHAR(255) DEFAULT NULL,
    `level6_id` INT(11) DEFAULT NULL,
    `level6` VARCHAR(255) DEFAULT NULL,
    `id_primary_category` INT(11) DEFAULT NULL,
    `category_name` VARCHAR(255) DEFAULT NULL,
    `active` TINYINT DEFAULT 1,
    KEY `level0_id` (`level0_id`),
    KEY `level1_id` (`level1_id`),
    KEY `level2_id` (`level2_id`),
    KEY `level3_id` (`level3_id`),
    KEY `level4_id` (`level4_id`),
    KEY `level5_id` (`level5_id`),
    KEY `level6_id` (`level6_id`),
    KEY `id_primary_category` (`id_primary_category`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='BOB Category Tree';

CREATE TABLE `charges_scheme` (
    `id_charges_scheme` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `is_marketplace` TINYINT(4) DEFAULT NULL,
    `pickup_provider_type` VARCHAR(12) DEFAULT NULL,
    `first_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `rate_card_scheme` VARCHAR(12) DEFAULT NULL,
    `rounding_3pl` DECIMAL(6 , 4 ) DEFAULT NULL,
    `rounding_seller` DECIMAL(6 , 4 ) DEFAULT NULL,
    `shipment_fee_mp_seller_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_discount_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `pickup_cost_vat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_vat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_charges_scheme`),
    KEY (`shipment_scheme`),
    KEY (`is_marketplace`),
    KEY (`pickup_provider_type`),
    KEY (`first_shipment_provider`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Charges Scheme';

CREATE TABLE `insurance_scheme` (
    `id_insurance_scheme` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `type` VARCHAR(50) DEFAULT NULL,
    `min_unit_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `max_unit_price` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `insurance_vat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_insurance_scheme`),
    KEY (`shipment_scheme`),
    KEY (`type`),
    KEY (`min_unit_price`),
    KEY (`max_unit_price`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Insurance Scheme';

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

CREATE TABLE `payment_cost_mapping` (
    `id_payment_cost_mapping` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `payment_method` VARCHAR(100) DEFAULT NULL,
    `tenor` INT(10) DEFAULT NULL,
    `bank` VARCHAR(100) DEFAULT NULL,
    `order_flat_rate` DECIMAL(20 , 5 ) DEFAULT NULL,
    `mdr_rate` DECIMAL(20 , 5 ) DEFAULT NULL,
    `ipp_rate` DECIMAL(20 , 5 ) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_payment_cost_mapping`),
    KEY (`payment_method`),
    KEY (`tenor`),
    KEY (`bank`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Payment Cost Mapping';

CREATE TABLE `shipping_fee_rate_card_3pl` (
    `id_rate_card` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `rate_card_scheme` VARCHAR(12) DEFAULT NULL,
    `origin` VARCHAR(64) NOT NULL,
    `id_district` INT(10) UNSIGNED NOT NULL,
    `min_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `max_weight` DECIMAL(20 , 4 ) DEFAULT NULL,
    `flat_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_rate` DECIMAL(20 , 4 ) DEFAULT NULL,
    `delivery_cost_discount_rate` DECIMAL(6 , 4 ) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_rate_card`),
    KEY (`rate_card_scheme`),
    KEY (`origin`),
    KEY (`id_district`),
    KEY (`min_weight`),
    KEY (`max_weight`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Rate card';

CREATE TABLE `shipping_fee_rate_card` (
    `id_shipping_fee_rate_card` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `origin` VARCHAR(128) NOT NULL DEFAULT '',
    `leadtime` ENUM('Standard', 'Express', 'Economy', 'Digital') DEFAULT NULL,
    `destination_zone` INT(10) UNSIGNED NOT NULL,
    `product_class` VARCHAR(128) NOT NULL,
    `fee_type` ENUM('FIX', 'KG') NOT NULL DEFAULT 'FIX',
    `charging_level` ENUM('Order', 'Source', 'Item', 'SourceMax') NOT NULL DEFAULT 'Item',
    `threshold_level` ENUM('Order', 'Source', 'NA') DEFAULT 'Order',
    `value_threshold` DECIMAL(17 , 2 ) DEFAULT NULL,
    `weight_threshold` DECIMAL(10 , 2 ) DEFAULT NULL,
    `shipping_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    `is_live` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    `charging_mechanism` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`id_shipping_fee_rate_card`),
    KEY (`origin`),
    KEY (`leadtime`),
    KEY (`destination_zone`),
    KEY (`product_class`),
    KEY (`fee_type`),
    KEY (`charging_level`),
    KEY (`threshold_level`),
    KEY (`is_live`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE `shipping_fee_rate_card_kg` (
    `id_shipping_fee_rate_card_kg` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `origin` VARCHAR(128) NOT NULL DEFAULT '',
    `leadtime` ENUM('Standard', 'Express', 'Economy', 'Digital') DEFAULT NULL,
    `destination_zone` INT(10) UNSIGNED NOT NULL,
    `rounding` DECIMAL(10 , 2 ) NOT NULL DEFAULT '0.25',
    `weight_break` DECIMAL(10 , 2 ) NOT NULL DEFAULT '0.25',
    `flat_rate` DECIMAL(10 , 2 ) NOT NULL DEFAULT '1.00',
    `step_rate` DECIMAL(10 , 2 ) NOT NULL DEFAULT '0.00',
    `is_live` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
    PRIMARY KEY (`id_shipping_fee_rate_card_kg`),
    KEY (`origin`),
    KEY (`leadtime`),
    KEY (`destination_zone`),
    KEY (`is_live`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE `shipment_scheme` (
    `id_shipment_scheme` INT(10) UNSIGNED NOT NULL,
    `shipment_scheme` VARCHAR(50) DEFAULT NULL,
    `tax_class` VARCHAR(15) DEFAULT NULL,
    `delivery_type` VARCHAR(45) DEFAULT NULL,
    `first_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `last_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `is_marketplace` TINYINT(4) DEFAULT NULL,
    `shipping_type` VARCHAR(100) DEFAULT NULL,
    `exclude_payment_method` VARCHAR(50) DEFAULT NULL,
    `exclude_shipment_provider` VARCHAR(64) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    KEY (`id_shipment_scheme`),
    KEY (`shipment_scheme`),
    KEY (`tax_class`),
    KEY (`delivery_type`),
    KEY (`first_shipment_provider`),
    KEY (`last_shipment_provider`),
    KEY (`is_marketplace`),
    KEY (`shipping_type`),
    KEY (`exclude_payment_method`),
    KEY (`exclude_shipment_provider`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Shipment Scheme';

CREATE TABLE `weight_threshold` (
    `id_weight_threshold` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `item_threshold` DECIMAL(20 , 4 ) DEFAULT NULL,
    `package_threshold` DECIMAL(20 , 4 ) DEFAULT NULL,
    `item_threshold_offset` TINYINT(4) DEFAULT NULL,
    `package_threshold_offset` TINYINT(4) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_weight_threshold`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Weight Threshold';

CREATE TABLE `zone_mapping` (
    `id_zone_mapping` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_region` INT(10) UNSIGNED DEFAULT NULL,
    `region` VARCHAR(255) DEFAULT '',
    `id_city` INT(10) UNSIGNED DEFAULT NULL,
    `city` VARCHAR(255) DEFAULT '',
    `id_district` INT(10) UNSIGNED NOT NULL,
    `district` VARCHAR(255) DEFAULT '',
    `zone_type` VARCHAR(255) DEFAULT NULL,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id_zone_mapping`),
    KEY (`id_district`),
    KEY (`zone_type`),
    KEY (`start_date`),
    KEY (`end_date`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='Free zone';