CREATE TABLE `ims_sales_order` (
  `id_sales_order` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Id of the sales order',
  `fk_sales_order_address_billing` int(10) unsigned NOT NULL COMMENT 'key to know which is the billing address of the customer',
  `fk_sales_order_address_shipping` int(10) unsigned NOT NULL COMMENT 'key to know which is the shipping address of the customer',
  `fk_sales_order_status` int(10) unsigned NOT NULL COMMENT 'key for the sales order status',
  `fk_mwh_country` smallint(5) unsigned NOT NULL,
  `customer_first_name` varchar(255) DEFAULT NULL COMMENT 'first name of the customer',
  `customer_last_name` varchar(255) DEFAULT NULL COMMENT 'last name of the customer',
  `customer_email` varchar(255) NOT NULL COMMENT 'email of the customer',
  `customer_national_id` int(11) DEFAULT NULL,
  `order_nr` varchar(45) DEFAULT NULL COMMENT 'order number of the sales order',
  `grand_total` decimal(17,2) DEFAULT NULL COMMENT 'Total amount of the order',
  `tax_amount` decimal(17,2) DEFAULT NULL COMMENT 'Total amount tax',
  `shipping_amount` decimal(17,2) DEFAULT NULL COMMENT 'Total amount of shipping',
  `shipping_method` varchar(255) DEFAULT NULL COMMENT 'Shipping method',
  `coupon_code` varchar(50) DEFAULT NULL COMMENT 'coupon code used by user',
  `fk_voucher_type` int(10) unsigned DEFAULT NULL,
  `payment_method` varchar(50) NOT NULL COMMENT 'Description of the payment method',
  `gift_option` enum('t','f') DEFAULT 'f' COMMENT 'Triggered from bob',
  `gift_message` text COMMENT 'Triggered from bob',
  `remarks` text COMMENT 'remarks of the sales order',
  `created_at` datetime DEFAULT NULL COMMENT 'datetime when the sales order was created on the system',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date time when the order was updated',
  `fk_shipping_carrier` int(11) DEFAULT NULL COMMENT 'N/A',
  `tracking_url` mediumtext COMMENT 'Triggered from bob',
  `otrs_ticket` varchar(255) DEFAULT NULL COMMENT 'Triggered from bob',
  `fk_sales_order_process` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'id sales order process (status of the sales order)',
  `shipping_discount_amount` decimal(17,2) DEFAULT NULL COMMENT 'Discount amount for shipping',
  `reverse` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'N/A',
  `payment_date` datetime NOT NULL COMMENT 'Date time when payment was made',
  `payment_verification_date` datetime NOT NULL COMMENT 'N/A',
  `extra_payment_cost` decimal(17,2) DEFAULT NULL COMMENT 'extra payment added to the sales order',
  `wrapping_amount` decimal(17,2) DEFAULT NULL COMMENT 'N/A',
  `bob_id_customer` int(10) unsigned DEFAULT NULL COMMENT 'id of the customer in bob database',
  `customer_gender` enum('male','female') DEFAULT NULL COMMENT 'gender of customer male, female',
  `customer_birthday` date DEFAULT NULL COMMENT 'birthday of the customer',
  `delivery_info` varchar(255) DEFAULT NULL COMMENT 'info about the delivery',
  `customer_extra_info` text COMMENT 'extra info about customer provided',
  `customer_type` varchar(50) DEFAULT NULL COMMENT 'Customer type from BOB',
  `tax_name` varchar(200) DEFAULT NULL COMMENT 'Name of the tax',
  `tax_address` varchar(300) DEFAULT NULL COMMENT 'Triggered from lazada bob ',
  `tax_code` varchar(100) DEFAULT NULL COMMENT 'Code Tax',
  `loyalty_point_discount_amount` decimal(17,2) DEFAULT NULL COMMENT 'Triggered from bob',
  `loyalty_point_transaction` int(10) DEFAULT NULL COMMENT 'Triggered from bob',
  `invoice_reference` text COMMENT 'Triggered from bob',
  `check_validation` text COMMENT 'column to specify which validations have failed associated with the payment',
  `is_csr_verified` tinyint(1) DEFAULT '0' COMMENT 'Flag to indicate if this order has already been processed on the csr verify',
  `on_hold` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Order is on hold? 1/0',
  `reference` varchar(250) DEFAULT NULL COMMENT 'reconciliation reference',
  `internal_reference` varchar(500) DEFAULT NULL COMMENT 'Internal reference from package handler',
  `amount_received` float(10,2) DEFAULT NULL COMMENT 'amount received',
  `target_delivery_date` date DEFAULT NULL COMMENT 'delivery date expected by customer',
  `fk_flag` int(10) unsigned DEFAULT NULL COMMENT 'Top priority Flag of the sales order',
  `wallet_credits` decimal(10,2) DEFAULT NULL COMMENT 'Wallet Credits',
  `shipping_wallet_discount` decimal(10,2) DEFAULT NULL COMMENT 'Shipping Wallet Discount',
  `imported_at` datetime DEFAULT NULL,
  `bob_customer_flag_name` varchar(255) DEFAULT NULL COMMENT 'Imported customer flag from Bob',
  `language` varchar(20) DEFAULT NULL,
  `payment_method_description` varchar(350) DEFAULT NULL COMMENT 'Payment method as text (description)',
  `tax_id` varchar(13) DEFAULT NULL COMMENT 'Field tax id is a legal requirement for zalora TH',
  `delivery_price_total` float(10,2) DEFAULT NULL,
  `store_credit` decimal(17,2) DEFAULT '0.00',
  `placed_by` varchar(64) DEFAULT NULL COMMENT 'CS agent or Sales agent who placed the order',
  `gst_free_shipping_address` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_sales_order`),
  UNIQUE KEY `UNIQUE_ORDER_NR` (`order_nr`),
  KEY `fk_order_address` (`fk_sales_order_address_billing`),
  KEY `fk_order_address1` (`fk_sales_order_address_shipping`),
  KEY `fk_sales_order_process` (`fk_sales_order_process`),
  KEY `fk_sales_order_status` (`fk_sales_order_status`),
  KEY `is_csr_verified` (`is_csr_verified`),
  KEY `i_bob_id_customer` (`bob_id_customer`),
  KEY `icustomer_email` (`customer_email`),
  KEY `fk_voucher_type` (`fk_voucher_type`),
  KEY `idx_created_at_status` (`created_at`,`fk_sales_order_status`),
  KEY `ims_sales_order_flag` (`fk_flag`),
  KEY `i_sales_order_first_name` (`customer_first_name`),
  KEY `i_sales_order_last_name` (`customer_last_name`),
  KEY `i_sales_order_grand_total` (`grand_total`),
  KEY `ims_sales_order_fk_mwh_country_fk` (`fk_mwh_country`),
  KEY `sales_order_shipping_method_idx` (`shipping_method`),
  CONSTRAINT `fk_order_address_billing` FOREIGN KEY (`fk_sales_order_address_billing`) REFERENCES `ims_sales_order_address` (`id_sales_order_address`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_address_shipping` FOREIGN KEY (`fk_sales_order_address_shipping`) REFERENCES `ims_sales_order_address` (`id_sales_order_address`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ims_sales_order_fk_mwh_country_fk` FOREIGN KEY (`fk_mwh_country`) REFERENCES `oms_country` (`id_country`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ims_sales_order_flag` FOREIGN KEY (`fk_flag`) REFERENCES `oms_flag` (`id_flag`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ims_sales_order_ibfk_1` FOREIGN KEY (`fk_sales_order_process`) REFERENCES `ims_sales_order_process` (`id_sales_order_process`),
  CONSTRAINT `ims_sales_order_ibfk_2` FOREIGN KEY (`fk_voucher_type`) REFERENCES `ims_sales_order_voucher_type` (`id_sales_order_voucher_type`)
) ENGINE=InnoDB AUTO_INCREMENT=24001696 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED;
