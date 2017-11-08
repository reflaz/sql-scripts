USE refrain;

SELECT 
    *
FROM
    (SELECT 
        til.bob_id_sales_order_item,
            til.api_type,
            til.shipment_scheme,
            til.pickup_provider_type,
            mcam.id_campaign,
            mcam.campaign,
            mcam.pickup_provider_type 'ppt',
            mcam.seller_flat_charge_rate,
            mcam.seller_charge_rate,
            mcam.insurance_rate,
            mco.seller_flat_charge_rate 'seller_flat_charge_rate_override',
            mco.seller_charge_rate 'seller_charge_rate_override'
    FROM
        tmp_item_level til
    JOIN map_campaign_tracker mct ON til.bob_id_supplier = mct.bob_id_supplier
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mct.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mct.end_date
    JOIN map_campaign mcam ON mct.fk_campaign = mcam.id_campaign
        AND IFNULL(til.pickup_provider_type, 'pickup_provider_type') = IFNULL(mcam.pickup_provider_type, IFNULL(til.pickup_provider_type, 'pickup_provider_type'))
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mcam.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mcam.end_date
    JOIN map_campaign_access mca ON mcam.id_campaign = mca.fk_campaign
        AND til.shipment_scheme = mca.shipment_scheme
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mca.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mca.end_date
    LEFT JOIN map_campaign_override mco ON mcam.id_campaign = mco.fk_campaign
        AND til.shipment_scheme = mco.shipment_scheme
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mco.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mco.end_date
    WHERE
        til.bob_id_sales_order_item IN ()) result