USE ship_reimb;

SELECT 
    *
FROM
    (SELECT 
        result.*,
            rounded_weight * rate 'calculated_shipping_surcharge',
            result.shipping_surcharge 'paid_by_customer',
            (rounded_weight * 7000) 'paid_by_seller',
            IF((rounded_weight * rate) - (rounded_weight * 7000) - result.shipping_surcharge > 0, (rounded_weight * rate) - (rounded_weight * 7000) - result.shipping_surcharge, 0) 'reimbursed_to_seller',
            IF(LENGTH(result.origin) > 0
                AND rate IS NOT NULL, '', IF(LENGTH(result.origin) = 0
                AND rate IS NULL, 'Origin and destination unknown', IF(LENGTH(result.origin) = 0, 'Origin unknown', 'Destination Unknown'))) 'remarks'
    FROM
        (SELECT 
        sd.*,
            IF(formula_weight < 1, 1, IF(MOD(formula_weight, 1) <= 0.3, FLOOR(formula_weight), CEIL(formula_weight))) 'rounded_weight',
            jr.rate
    FROM
        (SELECT 
        sd.bob_id_sales_order_item,
            sd.sc_id_sales_order_item,
            sd.order_nr,
            sd.order_date,
            sd.shipped_date,
            sd.delivered_date,
            IFNULL(SUM(sd.shipping_surcharge), 0) shipping_surcharge,
            sd.sku,
            sd.tracking_number,
            sd.shipment_provider,
            sd.origin,
            sd.id_region,
            sd.region,
            sd.id_city,
            sd.city,
            sd.id_district,
            sd.district,
            sd.sc_seller_id,
            sd.seller_name,
            SUM(weight) 'weight',
            SUM(volumetric_weight) 'volumetric_weight',
            IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)) 'formula_weight'
    FROM
        oms_data sd
    GROUP BY tracking_number) sd
    LEFT JOIN jne_rate jr ON sd.origin = jr.origin
        AND sd.id_district = jr.id_district) result) result