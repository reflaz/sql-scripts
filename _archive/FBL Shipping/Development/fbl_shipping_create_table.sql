USE fbl_shipping;

DROP TABLE IF EXISTS `oms_data`,`fbl_fee`;

CREATE TABLE `fbl_fee` (
    `tracking_number` VARCHAR(45) NOT NULL,
    `delivery_fee` DECIMAL(17 , 2 ) DEFAULT NULL,
    PRIMARY KEY (`tracking_number`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE `oms_data` (
    `order_nr` VARCHAR(45) NOT NULL,
    `sc_sales_order_item` INT(10) NOT NULL,
    `sc_seller_id` VARCHAR(7) DEFAULT NULL,
    `seller_name` VARCHAR(255) DEFAULT NULL,
    `seller_type` VARCHAR(10) DEFAULT NULL,
    `shipment_provider` VARCHAR(45) DEFAULT NULL,
    `tracking_number` VARCHAR(45) NOT NULL,
    `package_dimension` VARCHAR(20) DEFAULT NULL,
    `volumetric_weight` DECIMAL(10 , 2 ) DEFAULT NULL,
    `package_weight` DECIMAL(10 , 2 ) DEFAULT NULL,
    `formula_weight` DECIMAL(10 , 2 ) DEFAULT NULL,
    `total_formula_weight` DECIMAL(10 , 2 ) DEFAULT NULL,
    `type_concat` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`order_nr` , `sc_sales_order_item`, `tracking_number`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;