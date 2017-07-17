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

DROP TABLE IF EXISTS `anondb_calculate_ffsim`;

CREATE TABLE `anondb_calculate_ffsim` (
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