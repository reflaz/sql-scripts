/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Subsidy Tracker Seller Level by Order Date
 
Prepared by		: RM
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
				  - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3_qv;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-07-01';
SET @extractend = '2017-08-01';-- This MUST be D + 1

SELECT 
    fin.bob_id_supplier,
    fin.short_code,
    fin.seller_name,
    fin.seller_type,
    fin.tax_class,
    fin.price_bucket,
    MAX(fin.campaign) 'campaign',
    SUM(fin.unit_price) 'total_unit_price',
    SUM(fin.paid_price) 'total_paid_price',
    SUM(fin.nmv) 'nmv',
    COUNT(DISTINCT fin.order_nr) 'total_so',
    COUNT(DISTINCT fin.id_package_dispatching) 'total_pck',
    COUNT(fin.bob_id_sales_order_item) 'total_soi',
    SUM(fin.unit_price) / COUNT(DISTINCT fin.order_nr) 'aov',
    SUM(fin.shipping_surcharge_temp) 'total_shipping_surcharge',
    SUM(fin.shipping_amount_temp) 'total_shipping_amount',
    SUM(fin.total_delivery_cost_item) 'total_delivery_cost',
    SUM(fin.total_shipment_fee_mp_seller_item) 'total_shipment_fee_mp_seller',
    SUM(fin.shipping_surcharge_temp) + SUM(fin.shipping_amount_temp) + SUM(fin.total_shipment_fee_mp_seller_item) + SUM(fin.total_delivery_cost_item) 'net_subsidy'
FROM
    (SELECT 
        ac.order_nr,
            ac.id_package_dispatching,
            ac.bob_id_supplier,
            ac.short_code,
            ac.seller_name,
            ac.seller_type,
            ac.tax_class,
            cam.campaign,
            ac.zone_type 'zone_type_temp',
            ac.id_district 'id_district_temp',
            ac.bob_id_sales_order_item,
            ac.origin 'origin_temp',
            ac.order_value,
            ac.unit_price,
            ac.paid_price,
            ac.total_shipment_fee_mp_seller_item,
            ac.total_delivery_cost_item,
            CASE
                WHEN
                    cam.campaign LIKE '%jawara%'
                        AND ac.unit_price < 500000
                THEN
                    'BELOW'
                WHEN
                    cam.campaign LIKE '%maestro%'
                        AND ac.unit_price < 500000
                THEN
                    'BELOW'
                ELSE 'ABOVE'
            END 'price_bucket',
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN ABS(total_delivery_cost_item / unit_price) > 5 THEN 0
                WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_surcharge, 0) / 1.1
                ELSE IFNULL(shipping_surcharge, 0)
            END 'shipping_surcharge_temp',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_amount, 0) / 1.1
                ELSE IFNULL(shipping_amount, 0)
            END 'shipping_amount_temp',
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        anondb_calculate ac
    LEFT JOIN campaign cam ON ac.campaign = cam.campaign
        AND ac.pickup_provider_type = cam.pickup_provider_type
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) >= cam.start_date
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) <= cam.end_date
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.is_marketplace = 1
    GROUP BY ac.bob_id_sales_order_item
    HAVING pass = 1) fin
GROUP BY bob_id_supplier , price_bucket