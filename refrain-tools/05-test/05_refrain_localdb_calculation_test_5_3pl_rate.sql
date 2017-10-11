USE refrain;

SELECT 
    *
FROM
    (SELECT 
        tpl.bob_id_sales_order_item,
            tpl.order_nr,
            tpl.bob_id_supplier,
            tpl.id_package_dispatching,
            tpl.shipping_amount,
            tpl.shipping_surcharge,
            tpl.origin,
            mom.origin_mapping,
            tpl.id_district,
            tpl.api_type,
            tpl.shipment_scheme,
            tpl.campaign,
            tpl.seller_flat_charge_rate,
            tpl.seller_charge_rate,
            CASE
                WHEN mwts.package_weight_threshold IS NULL THEN tpl.chargeable_weight_seller
                WHEN tpl.chargeable_weight_seller <= mwts.package_weight_threshold THEN tpl.chargeable_weight_seller
                ELSE CASE
                    WHEN mwts.package_weight_no_bulky = 1 THEN 0
                    WHEN mwts.package_weight_offset = 1 THEN tpl.chargeable_weight_seller - mwts.package_weight_threshold
                    WHEN mwts.package_weight_max = 1 THEN mwts.package_weight_threshold
                    ELSE 0
                END
            END 'chargeable_weight_seller',
            tpl.seller_flat_charge_rate 'seller_flat_charge',
            CASE
                WHEN mwts.package_weight_threshold IS NULL THEN tpl.chargeable_weight_seller
                WHEN tpl.chargeable_weight_seller <= mwts.package_weight_threshold THEN tpl.chargeable_weight_seller
                ELSE CASE
                    WHEN mwts.package_weight_no_bulky = 1 THEN 0
                    WHEN mwts.package_weight_offset = 1 THEN tpl.chargeable_weight_seller - mwts.package_weight_threshold
                    WHEN mwts.package_weight_max = 1 THEN mwts.package_weight_threshold
                    ELSE 0
                END
            END * tpl.seller_charge_rate 'seller_charge',
            tpl.insurance_seller,
            tpl.insurance_vat_seller,
            tpl.chargeable_weight_3pl,
            mrc3.delivery_flat_cost_rate,
            mrc3.delivery_cost_rate,
            mrc3.delivery_cost_discount_rate,
            mrc3.delivery_flat_cost_rate 'delivery_flat_cost',
            - tpl.chargeable_weight_3pl * mrc3.delivery_cost_rate 'delivery_cost',
            tpl.chargeable_weight_3pl * mrc3.delivery_cost_rate * mrc3.delivery_cost_discount_rate 'delivery_cost_discount',
            - tpl.chargeable_weight_3pl * mrc3.delivery_cost_rate * (1 - mrc3.delivery_cost_discount_rate) * tpl.delivery_cost_vat_rate 'delivery_cost_vat',
            total_customer_charge
    FROM
        tmp_package_level tpl
    LEFT JOIN map_origin_mapping mom ON IFNULL(tpl.origin, 'origin') = COALESCE(mom.origin, tpl.origin, 'origin')
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) >= mom.start_date
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) <= mom.end_date
    LEFT JOIN map_rate_card_3pl mrc3 ON tpl.id_district = mrc3.id_district
        AND mom.origin_mapping = mrc3.origin
        AND tpl.rate_card_scheme = mrc3.rate_card_scheme
        AND tpl.chargeable_weight_3pl > mrc3.min_weight
        AND tpl.chargeable_weight_3pl <= mrc3.max_weight
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) >= mrc3.start_date
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) <= mrc3.end_date
    LEFT JOIN map_weight_threshold_seller mwts ON GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) >= mwts.start_date
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) <= mwts.end_date
    WHERE
        api_type = 0
    GROUP BY bob_id_sales_order_item) result