USE refrain;

SELECT 
    *
FROM
    (SELECT 
        til.bob_id_sales_order_item,
            til.payment_method 'ae_payment_method',
            til.tax_class 'ae_tax_class',
            til.is_marketplace 'ae_is_marketplace',
            til.first_shipment_provider 'ae_first_shipment_provider',
            til.last_shipment_provider 'ae_last_shipment_provider',
            til.shipping_type 'ae_shipping_type',
            til.delivery_type 'ae_delivery_type',
            til.auto_shipping_fee_credit 'ae_auto_shipping_fee_credit',
            til.api_type 'ae_api_type',
            mss.*
    FROM
        tmp_item_level til
    JOIN map_shipment_scheme mss ON til.payment_method <> IFNULL(mss.exclude_payment_method, '')
        AND IFNULL(til.tax_class, 'tax_class') = IFNULL(mss.tax_class, IFNULL(til.tax_class, 'tax_class'))
        AND IFNULL(til.is_marketplace, 0) = IFNULL(mss.is_marketplace, IFNULL(til.is_marketplace, 0))
        AND IFNULL(til.first_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', IFNULL(mss.first_shipment_provider, IFNULL(til.first_shipment_provider, 'first_shipment_provider')), '%')
        AND IFNULL(til.last_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', IFNULL(mss.last_shipment_provider, IFNULL(til.last_shipment_provider, 'first_shipment_provider')), '%')
        AND IFNULL(til.first_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(mss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
        AND IFNULL(til.last_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(mss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
        AND IFNULL(til.shipping_type, 'shipping_type') = IFNULL(mss.shipping_type, IFNULL(til.shipping_type, 'shipping_type'))
        AND IFNULL(til.delivery_type, 'delivery_type') = IFNULL(mss.delivery_type, IFNULL(til.delivery_type, 'delivery_type'))
        AND IFNULL(til.auto_shipping_fee_credit, 0) < IFNULL(mss.auto_shipping_fee_credit, 1)
        AND IFNULL(til.api_type, 0) = IFNULL(mss.api_type, IFNULL(til.api_type, 0))
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mss.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mss.end_date
    WHERE
        til.bob_id_sales_order_item IN (97882574)) result;