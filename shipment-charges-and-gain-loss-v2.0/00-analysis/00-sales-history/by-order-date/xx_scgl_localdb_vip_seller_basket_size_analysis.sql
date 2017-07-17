/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Summary

Prepared by		: R Maliangkay
Modified by		: RM
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
SET @extractstart = '2017-02-01';
SET @extractend = '2017-02-06';-- This MUST be D + 1

-- Free districts mapping
SET @vip_all = '4599,1289,1492,2333,5066,5108,50771,18751,1268,57452,4862,32830,21324,3432,43915,1893,2132,46345,8897,2740,1609,1559,14644,42413,49883,42414,6346,52205,25194,12237,18455,21949,9048,2549,10441,54831,1493,32304,6800,13286,4661,3566,1674,6012,2007,2272,9627,5803,4387,39487,45882,50127,4737,13702,3857,945,1744,907,50302,59085,3530,1520,1375,4971,38581,36883,60611,56050,46324,8651,2334,14502,3578,2871,2088,14600,4328,4398,5631,2486,33607,1287,71915,3400,41051,10287,17930,1596,2917,35441,5292,1751,815,1294,55445,5334,6809,7665,12851,950,10207,5056,2521,13902,949,36562,45808,14237,1720,50673,52943,66948,10011,60589,3328,15070,53596,36441,43733,1099,812,15375,16637,773,5300,11372,58577,2771,2602,3969,3043,3439,9205,969,2342,1691,10540,48879,3330,916,11935,14286,28986,3671,3928';
SET @new_vip = '2157,73747,51664,57276,58673,2103,5870';
SET @former_vip = '10944,15468,2753,30675,46724,15082,48824,61393,55769,66195,53785,2360,10786,7590,1740,976,3284,1836,25111,46349,24481,21817,11059,4998,9946,17783,9646,5125,2422,64120,7879,4564,3644,9147,3244,4264,43581,50126,49153,58363,57047,53839,11071,1923,1186,9878,2199,4491,2742,3715,50289,1651,17846,9768,3449,5212,7166,61454,42555,43196,1273,1747,5765,40051,4274,50672,55626,32660,3453,2965,44685,2348,29095,18256';

SELECT 
    order_value,
    bu,
    COUNT(order_nr) 'count_so',
    SUM(qty) 'total_qty',
    SUM(paid_price) 'total_paid_price',
    SUM(paid_price) / COUNT(order_nr) 'aov',
    SUM(qty) / COUNT(order_nr) 'average_item_per_order',
    SUM(total_delivery_cost) 'total_3pl_cost',
    SUM(total_shipment_fee_mp_seller) 'total_seller_charge',
    SUM(shipping_amount_temp) 'total_shipping_amount',
    SUM(shipping_surcharge_temp) 'total_shipping_surcharge',
    SUM(shipping_fee_to_customer) 'total_shipping_fee_to_customer',
    SUM(gain_loss) 'total_gain_loss'
FROM
    (SELECT 
        *,
            CASE
                WHEN basket_size < 30000 THEN 'Below 30k'
                WHEN basket_size < 50000 THEN '30k - 50k'
                WHEN basket_size < 100000 THEN '50k - 100k'
                ELSE 'Above 100k'
            END 'order_value'
    FROM
        (SELECT 
        *,
            CASE
                WHEN is_marketplace = 0 THEN (IFNULL(shipping_amount, 0) / 1.1)
                ELSE shipping_amount
            END 'shipping_amount_temp',
            CASE
                WHEN is_marketplace = 0 THEN (IFNULL(shipping_surcharge, 0) / 1.1)
                ELSE shipping_surcharge
            END 'shipping_surcharge_temp',
            IFNULL(total_shipment_fee_mp_seller, 0) + IFNULL(shipping_fee_to_customer, 0) - IFNULL(total_delivery_cost, 0) 'gain_loss',
            CASE
                WHEN FIND_IN_SET(bob_id_supplier, @vip_all) THEN 'vip_all_the_way'
                WHEN FIND_IN_SET(bob_id_supplier, @new_vip) THEN 'new_vip'
                WHEN FIND_IN_SET(bob_id_supplier, @former_vip) THEN 'former_vip'
                ELSE 'non_vip_all_the_way'
            END 'bu',
            CASE
                WHEN formula_weight <= 0.17 THEN '<= 0.17'
                WHEN rounded_weight < 3 THEN '1-2 Kg'
                WHEN rounded_weight < 4 THEN '3 Kg'
                WHEN rounded_weight < 5 THEN '4 Kg'
                WHEN rounded_weight < 6 THEN '5 Kg'
                WHEN rounded_weight < 7 THEN '6 Kg'
                WHEN rounded_weight < 8 THEN '7 Kg'
                ELSE '8 Kg and above'
            END 'weight_bucket',
            CASE
                WHEN
                    (order_date < '2017-01-01'
                        OR first_shipped_date < '2017-01-01')
                        AND (rounded_weight / qty) > 7
                        AND shipping_fee_to_customer = 0
                THEN
                    0
                WHEN
                    (order_date >= '2017-01-01'
                        OR first_shipped_date >= '2017-01-01')
                        AND (rounded_weight / qty) > 2
                        AND shipping_fee_to_customer = 0
                THEN
                    0
                WHEN
                    fk_shipment_scheme <> 5
                        AND rounded_weight > 0
                        AND total_shipment_cost = 0
                THEN
                    0
                WHEN rounded_weight / qty > 400 THEN 0
                ELSE 1
            END 'pass',
            (SELECT 
                    SUM(unit_price)
                FROM
                    scgl.anondb_calculate ac_temp
                WHERE
                    ac_temp.order_nr = ac.order_nr
                        AND fk_shipment_scheme IN (1 , 2, 3, 4, 7)) 'basket_size'
    FROM
        scgl.anondb_calculate ac
    WHERE
        order_date >= @extractstart
            AND order_date < @extractend
            AND fk_shipment_scheme IN (1 , 2, 3, 4, 7)
            AND fk_zone_type NOT IN (3 , 4)
    HAVING pass = 1) ac) ac
GROUP BY order_value , bu