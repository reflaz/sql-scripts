USE refrain;

SELECT 
    *
FROM
    (SELECT 
        til.bob_id_sales_order_item,
            til.order_date,
            til.first_shipped_date,
            til.shipment_scheme,
            til.is_marketplace,
            til.first_shipment_provider,
            til.auto_shipping_fee_credit,
            mdc.rounding_seller,
            mdc.seller_flat_charge_rate,
            mdc.seller_charge_rate,
            mdc.rate_card_scheme,
            mdc.rounding_3pl,
            mdc.pickup_cost_rate,
            mdc.pickup_cost_discount_rate,
            mdc.pickup_cost_vat_rate,
            mdc.delivery_cost_vat_rate
    FROM
        tmp_item_level til
    LEFT JOIN map_default_charges mdc ON til.shipment_scheme = mdc.shipment_scheme
        AND til.is_marketplace = IFNULL(mdc.is_marketplace, til.is_marketplace)
        AND IFNULL(til.first_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', IFNULL(mdc.first_shipment_provider, IFNULL(til.first_shipment_provider, 'first_shipment_provider')), '%')
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-1-1')) >= mdc.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-1-1')) <= mdc.end_date
    WHERE
        til.order_date <= '2017-01-01'
    GROUP BY bob_id_sales_order_item
    LIMIT 300000) result;

SELECT 
    *
FROM
    (SELECT 
        til.bob_id_sales_order_item,
            til.order_date,
            til.first_shipped_date,
            til.shipment_scheme,
            til.is_marketplace,
            til.first_shipment_provider,
            til.auto_shipping_fee_credit,
            mdc.rounding_seller,
            mdc.seller_flat_charge_rate,
            mdc.seller_charge_rate,
            mdc.rate_card_scheme,
            mdc.rounding_3pl,
            mdc.pickup_cost_rate,
            mdc.pickup_cost_discount_rate,
            mdc.pickup_cost_vat_rate,
            mdc.delivery_cost_vat_rate
    FROM
        tmp_item_level til
    LEFT JOIN map_default_charges mdc ON til.shipment_scheme = mdc.shipment_scheme
        AND til.is_marketplace = IFNULL(mdc.is_marketplace, til.is_marketplace)
        AND IFNULL(til.first_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', IFNULL(mdc.first_shipment_provider, IFNULL(til.first_shipment_provider, 'first_shipment_provider')), '%')
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-1-1')) >= mdc.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-1-1')) <= mdc.end_date
    WHERE
        til.order_date > '2017-01-01'
    GROUP BY bob_id_sales_order_item
    LIMIT 300000) result;