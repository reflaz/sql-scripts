/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Parameter Setup

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/
USE scgl;

SELECT 
    weight_bucket,
    COUNT(bob_id_sales_order_item) 'count_soi',
    SUM(paid_price) 'nmv',
    SUM(gain_loss) 'gain_loss'
FROM
    (SELECT 
        *,
            total_shipment_fee_mp_seller + shipping_surcharge + shipping_amount - total_delivery_cost 'gain_loss',
            CASE
                WHEN rounded_weight <= 1 THEN 1
                WHEN rounded_weight = 2 THEN 2
                WHEN rounded_weight = 3 THEN 3
                WHEN rounded_weight = 4 THEN 4
                WHEN rounded_weight = 5 THEN 5
                WHEN rounded_weight = 6 THEN 6
                WHEN rounded_weight = 7 THEN 7
                WHEN rounded_weight = 8 THEN 8
                WHEN rounded_weight = 9 THEN 9
                WHEN rounded_weight = 10 THEN 10
                ELSE '11 and above'
            END 'weight_bucket'
    FROM
        scgl.anondb_calculate
    WHERE
        fk_shipment_scheme IN (1 , 2, 3, 4)
            AND fk_zone_type <> 0) master_account
GROUP BY weight_bucket;