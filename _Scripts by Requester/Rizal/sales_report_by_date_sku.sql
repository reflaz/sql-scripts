/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by Order Number
 
Prepared by		: R Maliangkay
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

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-04-01';
SET @extractend = '2017-05-01';-- This MUST be D + 1

SELECT 
    soi.sku,
    sup.name 'supplier_name',
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.created_at,
    pd.tracking_number,
    soi.unit_price
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
		JOIN
	oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
		AND soish.fk_sales_order_item_status = 67
        LEFT JOIN
    oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
        LEFT JOIN
    oms_live.oms_package pck ON pi.fk_package = pck.id_package
        LEFT JOIN
    oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
        LEFT JOIN
    bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
WHERE
    so.created_at >= @extractstart
        AND so.created_at < @extractend
        AND soi.sku IN ()