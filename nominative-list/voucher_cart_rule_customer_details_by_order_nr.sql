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
    so.order_nr,
    soi.bob_id_sales_order_item 'sales_order_item',
    is_marketplace,
    SUM(IFNULL(soi.coupon_money_value, 0)) 'coupon_money_value',
    SUM(IFNULL(soi.cart_rule_discount, 0)) 'cart_rule_discount',
    so.created_at 'order_date',
    MIN(soish.created_at) 'delivered_date',
    soa.first_name,
    soa.address1,
    soa.city
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
        LEFT JOIN
    oms_live.ims_sales_order_cart_rule socr ON so.id_sales_order = socr.fk_sales_order
WHERE
    so.order_nr IN ()
GROUP BY so.order_nr