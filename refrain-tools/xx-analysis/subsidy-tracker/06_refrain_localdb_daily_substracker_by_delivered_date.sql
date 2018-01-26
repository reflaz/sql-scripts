/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Daily Subsidy Tracker by Delivered Date
 
Prepared by		: RM
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE refrain_live;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-11-01';
SET @extractend = '2017-11-02';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        delivered_date,
            origin,
            city 'destination_city',
            tier,
            zone_type,
            range_price,
            range_kg,
            threshold_price,
            threshold_kg,
            is_free,
            SUM(customer_weight) 'total_customer_weight',
            SUM(chargeable_weight_seller) 'total_chargeable_weight_seller',
            SUM(chargeable_weight_3pl) 'total_chargeable_weight_3pl',
            SUM(unit_price) 'total_unit_price',
            SUM(paid_price) 'total_paid_price',
            SUM(nmv) 'nmv',
            COUNT(DISTINCT order_nr) 'total_so',
            COUNT(DISTINCT id_package_dispatching) 'total_pck',
            SUM(qty) 'total_soi',
            SUM(unit_price) / COUNT(DISTINCT order_nr) 'aov',
            SUM(shipping_surcharge) 'total_shipping_surcharge',
            SUM(shipping_amount) 'total_shipping_amount',
            SUM(seller_charge) 'seller_charge',
            SUM(delivery_cost) 'delivery_cost',
            SUM(pickup_cost) 'pickup_cost',
            SUM(insurance_cost) 'insurance_cost',
            SUM(total_delivery_cost) 'total_delivery_cost',
            SUM(shipping_surcharge) + SUM(shipping_amount) + SUM(seller_charge) + SUM(total_delivery_cost) 'subsidy'
    FROM
        (SELECT 
        delivered_date,
            order_nr,
            sku,
            bob_id_supplier,
            short_code,
            seller_name,
            seller_type,
            order_value,
            package_value,
            SUM(unit_price) 'unit_price',
            SUM(paid_price) 'paid_price',
            SUM(shipping_amount) 'shipping_amount',
            SUM(shipping_surcharge) 'shipping_surcharge',
            SUM(nmv) 'nmv',
            SUM(seller_charge) 'seller_charge',
            SUM(pickup_cost) 'pickup_cost',
            SUM(insurance_cost) 'insurance_cost',
            SUM(delivery_cost) 'delivery_cost',
            SUM(total_delivery_cost) 'total_delivery_cost',
            id_package_dispatching,
            shipping_type,
            origin,
            zone_type,
            id_district,
            id_city,
            city,
            id_tier_mapping,
            tier,
            COUNT(bob_id_sales_order_item) 'qty',
            SUM(chargeable_weight_seller) 'chargeable_weight_seller',
            SUM(chargeable_weight_3pl) 'chargeable_weight_3pl',
            SUM(weight) 'weight',
            SUM(volumetric_weight) 'volumetric_weight',
            GREATEST(SUM(weight), SUM(volumetric_weight)) 'customer_weight',
            CASE
                WHEN
                    SUM(shipping_amount) = 0
                        AND SUM(shipping_surcharge) = 0
                THEN
                    'free'
                ELSE 'paid'
            END 'is_free',
            CASE
                WHEN package_value < 50000 THEN 'unit price < 50k'
                WHEN package_value < 75000 THEN 'unit price >= 50k'
                WHEN package_value < 100000 THEN 'unit price >= 75k'
                ELSE 'unit price >= 100k'
            END 'range_price',
            CASE
                WHEN GREATEST(SUM(weight), SUM(volumetric_weight)) <= 1.3 THEN 'package 1 kg'
                WHEN GREATEST(SUM(weight), SUM(volumetric_weight)) <= 2.3 THEN 'package 2 kg'
                WHEN GREATEST(SUM(weight), SUM(volumetric_weight)) <= 7.3 THEN 'package 3-7 kg'
                ELSE 'package > 7 kg'
            END 'range_kg',
            CASE
                WHEN SUM(shipping_amount) > 0 THEN 'under'
                ELSE 'above'
            END 'threshold_price',
            CASE
                WHEN SUM(shipping_surcharge) > 0 THEN 'above'
                ELSE 'under'
            END 'threshold_kg'
    FROM
        (SELECT 
        DATE_FORMAT(delivered_date, '%Y-%m-%d') 'delivered_date',
            order_nr,
            bob_id_sales_order_item,
            sku,
            bob_id_supplier,
            short_code,
            seller_name,
            seller_type,
            order_value,
            (SELECT 
                    SUM(unit_price)
                FROM
                    refrain_live.fms_sales_order_item
                WHERE
                    order_nr = fsoi.order_nr
                        AND IFNULL(id_package_dispatching, 1) = IFNULL(fsoi.id_package_dispatching, 1)) 'package_value',
            IFNULL(unit_price, 0) 'unit_price',
            IFNULL(paid_price, 0) 'paid_price',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_amount, 0) / 1.1
                ELSE IFNULL(shipping_amount, 0)
            END 'shipping_amount',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_surcharge, 0) / 1.1
                ELSE IFNULL(shipping_surcharge, 0)
            END 'shipping_surcharge',
            (IFNULL(paid_price, 0) + IFNULL(shipping_surcharge, 0) + IFNULL(shipping_amount, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value, 0), 0)) / 1.1 'nmv',
            IFNULL(total_seller_charge, 0) 'seller_charge',
            IFNULL(delivery_cost, 0) + IFNULL(delivery_cost_discount, 0) + IFNULL(delivery_cost_vat, 0) 'delivery_cost',
            IFNULL(total_pickup_cost, 0) 'pickup_cost',
            IFNULL(insurance_3pl, 0) 'insurance_cost',
            IFNULL(total_delivery_cost, 0) 'total_delivery_cost',
            id_package_dispatching,
            CASE
                WHEN shipment_scheme LIKE '%DIRECT BILLING%' THEN 'DIRECT BILLING'
                WHEN
                    delivery_type = 'warehouse'
                        OR seller_type = 'supplier'
                THEN
                    'WAREHOUSE'
                WHEN first_shipment_provider LIKE '%LEX%' THEN 'MA-LEX'
                ELSE 'MA-NON-LEX'
            END 'shipping_type',
            CASE
                WHEN origin IN ('SamsungXD' , 'Cross Border') THEN 'DKI Jakarta'
                ELSE origin
            END 'origin',
            zone_type,
            fsoi.id_district,
            tm.id_city,
            tm.city,
            tm.id_tier_mapping,
            tm.tier,
            IFNULL(chargeable_weight_seller, 0) 'chargeable_weight_seller',
            IFNULL(chargeable_weight_3pl, 0) 'chargeable_weight_3pl',
            IFNULL(bob_weight, 0) 'weight',
            IFNULL(bob_volumetric_weight, 0) 'volumetric_weight',
            CASE
                WHEN fsoi.fk_api_type <> 0 THEN 1
                WHEN ABS(IFNULL(total_delivery_cost, 0) / unit_price) > 5 THEN 0
                WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass'
    FROM
        refrain_live.fms_sales_order_item fsoi
    LEFT JOIN scglv3.zone_mapping zm ON fsoi.id_district = zm.id_district
        AND GREATEST(fsoi.order_date, fsoi.first_shipped_date) >= zm.start_date
        AND GREATEST(fsoi.order_date, fsoi.first_shipped_date) <= zm.end_date
    LEFT JOIN scglv3.tier_mapping tm ON fsoi.id_district = tm.id_district
    WHERE
        fsoi.delivered_date >= @extractstart
            AND fsoi.delivered_date < @extractend
            AND delivery_type NOT IN ('express' , 'nextday', 'sameday')
            AND fsoi.shipment_scheme IN ('RETAIL' , 'DIRECT BILLING', 'FBL', 'MASTER ACCOUNT')
    HAVING pass = 1) fsoi
    GROUP BY order_nr , id_package_dispatching) pck
    GROUP BY delivered_date , origin , id_city , tier , range_price , range_kg , threshold_price , threshold_kg , is_free) city