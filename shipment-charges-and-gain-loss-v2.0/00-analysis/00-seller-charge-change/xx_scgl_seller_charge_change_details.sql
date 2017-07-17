/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
City Tracker
 
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
SET @extractstart = '2017-05-09';
SET @extractend = '2017-05-11';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        ac.bob_id_sales_order_item,
            ac.order_nr,
            ac.payment_method,
            ac.short_code,
            ac.seller_name,
            ac.tax_class,
            ac.pickup_provider_type,
            ac.shipment_scheme,
            ac.campaign,
            CASE
                WHEN ac.fk_shipment_scheme = 1 THEN 'Direct Billing'
                WHEN
                    ac.fk_campaign = 2
                THEN
                    CASE
                        WHEN ac.fk_shipment_scheme = 4 THEN 'VIP FBL'
                        ELSE 'VIP NON-FBL'
                    END
                ELSE CASE
                    WHEN
                        ac.fk_shipment_scheme = 4
                            AND ac.pickup_provider_type = 'LEX'
                    THEN
                        'LEX master account non VIP - FBL'
                    WHEN
                        ac.fk_shipment_scheme = 4
                            AND (ac.pickup_provider_type IS NULL
                            OR ac.pickup_provider_type <> 'LEX')
                    THEN
                        'JNE master account non VIP - FBL'
                    WHEN
                        ac.fk_shipment_scheme <> 4
                            AND ac.pickup_provider_type = 'LEX'
                    THEN
                        'LEX master account non VIP - non FBL'
                    ELSE 'JNE master account non VIP - non FBL'
                END
            END 'seller_flag',
            ac.shipment_fee_mp_seller_rate 'old_seller_charge_rate',
            CASE
                WHEN ac.fk_shipment_scheme = 1 THEN 7000
                WHEN
                    ac.fk_campaign = 2
                THEN
                    CASE
                        WHEN ac.fk_shipment_scheme = 4 THEN 3000
                        ELSE 4000
                    END
                WHEN ac.fk_campaign IN (3 , 4) THEN ac.shipment_fee_mp_seller_rate
                ELSE CASE
                    WHEN
                        ac.fk_shipment_scheme = 4
                            AND ac.pickup_provider_type = 'LEX'
                    THEN
                        5964
                    WHEN
                        ac.fk_shipment_scheme = 4
                            AND (ac.pickup_provider_type IS NULL
                            OR ac.pickup_provider_type <> 'LEX')
                    THEN
                        6500
                    WHEN
                        ac.fk_shipment_scheme <> 4
                            AND ac.pickup_provider_type = 'LEX'
                    THEN
                        6464
                    ELSE 7000
                END
            END 'new_seller_charge_rate',
            ac.unit_price,
            ac.paid_price,
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_surcharge, 0) / 1.1
                ELSE IFNULL(shipping_surcharge, 0)
            END 'shipping_surcharge',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_amount, 0) / 1.1
                ELSE IFNULL(shipping_amount, 0)
            END 'shipping_amount',
            total_shipment_fee_mp_seller 'old_seller_charge',
            (CASE
                WHEN ac.fk_shipment_scheme = 1 THEN 7000
                WHEN
                    ac.fk_campaign = 2
                THEN
                    CASE
                        WHEN ac.fk_shipment_scheme = 4 THEN 3000
                        ELSE 4000
                    END
                WHEN ac.fk_campaign IN (3 , 4) THEN ac.shipment_fee_mp_seller_rate
                ELSE CASE
                    WHEN
                        ac.fk_shipment_scheme = 4
                            AND ac.pickup_provider_type = 'LEX'
                    THEN
                        5964
                    WHEN
                        ac.fk_shipment_scheme = 4
                            AND (ac.pickup_provider_type IS NULL
                            OR ac.pickup_provider_type <> 'LEX')
                    THEN
                        6500
                    WHEN
                        ac.fk_shipment_scheme <> 4
                            AND ac.pickup_provider_type = 'LEX'
                    THEN
                        6464
                    ELSE 7000
                END
            END * ac.rounded_chargeable_weight) + total_insurance_fee 'new_seller_charge',
            ac.total_delivery_cost 'delivery_cost',
            ac.qty 'total_item'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN scgl.free_zone fz ON ac.id_district = fz.id_district
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND (rounded_weight / qty) <= 400
            AND fk_shipment_scheme IN (1 , 2, 4)) ae
LIMIT 100000