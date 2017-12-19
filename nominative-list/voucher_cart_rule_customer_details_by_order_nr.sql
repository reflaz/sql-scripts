/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Voucher Cart Rule Customer Details by Order Number
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item 'sales_order_item',
            soi.sku,
            soi.name 'item_name',
            is_marketplace,
            IFNULL(soi.unit_price, 0) 'unit_price',
            IFNULL(soi.paid_price, 0) 'paid_price',
            IFNULL(soi.coupon_money_value, 0) 'coupon_money_value',
            IFNULL(soi.cart_rule_discount, 0) 'cart_rule_discount',
            so.coupon_code,
            socr.cart_rule_name,
            srs.name 'campaign_name',
            so.created_at 'order_date',
            MIN(soish.created_at) 'delivered_date'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
    LEFT JOIN oms_live.ims_sales_order_cart_rule socr ON so.id_sales_order = socr.fk_sales_order
    LEFT JOIN order_api.sales_order_item oasoi ON soi.bob_id_sales_order_item = oasoi.id_sales_order_item
    LEFT JOIN order_api.sales_order oaso ON oasoi.fk_sales_order = oaso.id_sales_order
    LEFT JOIN bob_live.sales_rule_apply sra ON oaso.id_sales_order = sra.fk_sales_order
    LEFT JOIN bob_live.sales_rule sr ON sra.fk_sales_rule = sr.id_sales_rule
    LEFT JOIN bob_live.sales_rule_set srs ON sr.fk_sales_rule_set = srs.id_sales_rule_set
    WHERE
        so.order_nr IN ()
            AND soi.is_marketplace = 1
    GROUP BY soi.bob_id_sales_order_item) result