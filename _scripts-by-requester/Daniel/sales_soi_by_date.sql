/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss AnonDB Population Extract

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
SET @extractstart = '2017-03-01';
SET @extractend = '2017-03-02';-- This MUST be D + 1

SET @vip = '773,812,815,907,916,945,949,950,969,1099,1268,1287,1289,1294,1375,1492,1493,1520,1559,1596,1609,1674,1691,1720,1744,1751,1893,2007,2088,2132,2272,2333,2334,2342,2486,2521,2549,2602,2740,2771,2871,2917,3043,3328,3330,3400,3432,3439,3566,3578,3671,3857,3928,3969,4328,4387,4398,4599,4737,4862,4971,5056,5066,5108,5292,5300,5334,5631,5803,6012,6346,6800,6809,7665,8651,8897,9048,9205,9627,10011,10207,10287,10441,10540,11935,12237,12851,13286,13702,13902,14237,14286,14502,14600,14644,15375,16637,17930,18455,21324,21949,25194,28986,32304,32830,33607,35441,36441,36562,36883,38581,39487,41051,42413,42414,43733,43915,45808,45882,46324,46345,48879,49883,50127,50673,50771,52205,52943,53596,54831,55445,56050,57452,11372,15070,18751,50302,58577,59085,66948,60611,60589,4661,3530,71915,2103,2157,5870,51664,57276,58673,73747';

SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value / 1.1, 0), 0) 'nmv',
            sup.id_supplier,
            sup.name 'seller',
            sup.type 'seller_type',
            CASE
                WHEN soi.is_marketplace = 0 THEN 'RETAIL'
                WHEN ascsel.tax_class = 0 THEN 'MP - LOCAL'
                WHEN ascsel.tax_class = 1 THEN 'MP - CB'
            END 'business_unit',
            CASE
                WHEN FIND_IN_SET(soi.bob_id_supplier, @vip) THEN 1
                ELSE 0
            END 'vip_flag'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history verified ON soi.id_sales_order_item = verified.fk_sales_order_item
        AND verified.fk_sales_order_item_status = 67
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
    GROUP BY soi.bob_id_sales_order_item) result