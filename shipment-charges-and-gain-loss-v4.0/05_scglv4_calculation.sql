/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss
Calculation

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv4;

SET SQL_SAFE_UPDATES = 0;

/*-----------------------------------------------------------------------------------------------------------------------------------
Assign shipment scheme
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE anondb_extract_item_level aeil
        JOIN
    shipment_scheme ss ON aeil.payment_method <> IFNULL(ss.exclude_payment_method, '')
        AND IFNULL(aeil.tax_class, 'tax_class') = IFNULL(ss.tax_class, IFNULL(aeil.tax_class, 'tax_class'))
        AND IFNULL(aeil.is_marketplace, 0) = IFNULL(ss.is_marketplace, IFNULL(aeil.is_marketplace, 0))
        AND IFNULL(aeil.first_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', IFNULL(ss.first_shipment_provider, IFNULL(aeil.first_shipment_provider, 'first_shipment_provider')), '%')
        AND IFNULL(aeil.last_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', IFNULL(ss.last_shipment_provider, IFNULL(aeil.last_shipment_provider, 'first_shipment_provider')), '%')
		AND IFNULL(aeil.first_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(ss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
		AND IFNULL(aeil.last_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(ss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
        AND IFNULL(aeil.shipping_type, 'shipping_type') = IFNULL(ss.shipping_type, IFNULL(aeil.shipping_type, 'shipping_type'))
        AND IFNULL(aeil.delivery_type, 'delivery_type') = IFNULL(ss.delivery_type, IFNULL(aeil.delivery_type, 'delivery_type'))
        AND IFNULL(aeil.auto_shipping_fee_credit, 0) < IFNULL(ss.auto_shipping_fee_credit, 1)
        AND IFNULL(aeil.api_type, 0) = IFNULL(ss.api_type, IFNULL(aeil.api_type, 0))
        AND GREATEST(aeil.order_date, IFNULL(aeil.first_shipped_date, '1900-01-01')) >= ss.start_date
        AND GREATEST(aeil.order_date, IFNULL(aeil.first_shipped_date, '1900-01-01')) <= ss.end_date
SET 
    aeil.shipment_scheme = ss.shipment_scheme;



SET SQL_SAFE_UPDATES = 1;