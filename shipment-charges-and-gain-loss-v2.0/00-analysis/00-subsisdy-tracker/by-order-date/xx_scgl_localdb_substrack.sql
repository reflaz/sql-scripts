/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Subsidy Tracker
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-06-09';
SET @extractend = '2017-06-10';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        city_temp 'city',
            zone_type,
            threshold_order,
            threshold_kg,
            SUM(unit_price) 'total_unit_price',
            SUM(paid_price) 'total_paid_price',
            SUM(nmv) 'nmv',
            COUNT(DISTINCT order_nr) 'total_so',
            COUNT(DISTINCT id_package_dispatching) 'total_pck',
            SUM(qty) 'total_soi',
            SUM(unit_price) / COUNT(DISTINCT order_nr) 'aov',
            SUM(shipping_surcharge_temp) 'total_shipping_surcharge',
            SUM(shipping_amount_temp) 'total_shipping_amount',
            - SUM(total_delivery_cost) 'total_delivery_cost',
            SUM(total_shipment_fee_mp_seller) 'total_shipment_fee_mp_seller',
            SUM(shipping_fee_to_customer) + SUM(total_shipment_fee_mp_seller) - SUM(total_delivery_cost) 'net_subsidy'
    FROM
        (SELECT 
        *,
            CASE
                WHEN formula_weight <= 1.3 THEN '0-1 kg'
                WHEN formula_weight <= 2.3 THEN '1-2 kg'
                WHEN formula_weight <= 3.3 THEN '2-3 kg'
                ELSE '>3 kg'
            END 'threshold_kg',
            CASE
                WHEN order_value < 30000 THEN '0-30k'
                WHEN order_value < 50000 THEN '30k-50k'
                WHEN order_value < 75000 THEN '50k-75k'
                WHEN order_value < 100000 THEN '75k-100k'
                ELSE '>100k'
            END 'threshold_order'
    FROM
        (SELECT 
        ac.*,
            fz.id_city,
            fz.city 'city_temp',
            rcc.rounding,
            rcc.flat_rate,
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_surcharge, 0) / 1.1
                ELSE IFNULL(shipping_surcharge, 0)
            END 'shipping_surcharge_temp',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_amount, 0) / 1.1
                ELSE IFNULL(shipping_amount, 0)
            END 'shipping_amount_temp',
            (SELECT 
                    SUM(IFNULL(aca.unit_price, 0))
                FROM
                    anondb_calculate aca
                WHERE
                    aca.order_nr = ac.order_nr) order_value,
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN scgl.free_zone fz ON ac.id_district = fz.id_district
    LEFT JOIN scgl.rate_card_customer rcc ON ac.id_district = rcc.id_district
        AND rcc.origin = 'DKI Jakarta'
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND fz.city IN ('Kab. Bekasi',
				'Kab. Bogor',
				'Kab. Kepulauan Seribu',
				'Kab. Tangerang',
				'Kota Bandung',
				'Kota Bekasi',
				'Kota Bogor',
				'Kota Depok',
				'Kota Jakarta Barat',
				'Kota Jakarta Pusat',
				'Kota Jakarta Selatan',
				'Kota Jakarta Timur',
				'Kota Jakarta Utara',
				'Kota Tangerang Selatan',
				'Kota Tangerang')
            AND (rounded_weight / qty) <= 400
            AND fk_shipment_scheme IN (1 , 2, 3, 4)) ac) ac
    GROUP BY id_city , threshold_order , threshold_kg) ac