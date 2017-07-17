/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SC Fees Details
 
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
    result.bob_id_sales_order_item,
    result.unit_price,
    result.order_nr,
    result.id_supplier,
    result.bob_id_supplier,
    result.seller_name,
    result.created_at,
    result.shipped_date,
    result.delivery_date,
    asoi.id_sales_order_item 'asc_id_sales_order_item',
    atr.value 'asc_item_price_credit'
FROM
    (SELECT 
        soi.bob_id_sales_order_item,
            soi.unit_price,
            so.order_nr,
            osup.id_supplier,
            sup.id_supplier 'bob_id_supplier',
            sup.name 'seller_name',
            so.created_at,
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivery_date',
            soi.id_sales_order_item
    FROM
        oms_live.ims_sales_order_item soi
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    LEFT JOIN oms_live.ims_supplier osup ON soi.bob_id_supplier = osup.bob_id_supplier
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    WHERE
        soi.bob_id_sales_order_item IN ()
    GROUP BY bob_id_sales_order_item) result
        LEFT JOIN
    asc_live.sales_order_item asoi ON result.id_sales_order_item = asoi.src_id
        LEFT JOIN
    asc_live.transaction atr ON asoi.id_sales_order_item = atr.ref
        AND atr.fk_transaction_type = 13