/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by Order Number
 
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
            soi.bob_id_sales_order_item,
            sois.name,
            so.created_at 'order_date',
            soish.created_at 'finance_verified_date',
            usr.username 'finance_verified_by',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            GROUP_CONCAT(DISTINCT socom.content
                SEPARATOR '\n\n') 'so_comment',
            GROUP_CONCAT(DISTINCT soicom.content
                SEPARATOR '\n\n') 'soi_comment'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
    LEFT JOIN oms_live.ims_user usr ON soish.fk_user = usr.id_user
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.oms_sales_order_comment socom ON so.id_sales_order = socom.fk_sales_order
        AND socom.fk_sales_order_item IS NULL
    LEFT JOIN oms_live.oms_sales_order_comment soicom ON soi.id_sales_order_item = soicom.fk_sales_order_item
    WHERE
        so.order_nr IN ()
    GROUP BY soi.id_sales_order_item) result;