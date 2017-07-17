/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by Tracking Number
 
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
        pdh.tracking_number,
            sp1.shipment_provider_name 'first_shipment_provider',
            sp1.shipment_provider_name 'last_shipment_provider',
            MIN(IF(soish.fk_sales_order_item = 6, soish.created_at, NULL)) 'first_shipped_date',
            MAX(IF(soish.fk_sales_order_item = 6, soish.created_at, NULL)) 'last_shipped_date',
            MIN(IF(soish.fk_sales_order_item = 27, soish.created_at, NULL)) 'delivered_date',
            GROUP_CONCAT(DISTINCT socom.content
                SEPARATOR '\n\n') 'so_comment',
            GROUP_CONCAT(DISTINCT soicom.content
                SEPARATOR '\n\n') 'soi_comment',
            so.payment_method,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            sois.name 'last_Status'
    FROM
        (SELECT 
        fk_package, tracking_number
    FROM
        oms_live.oms_package_dispatching_history
    WHERE
        tracking_number IN ()
    GROUP BY tracking_number) pdh
    LEFT JOIN oms_live.oms_package_dispatching pd1 ON pdh.fk_package = pd1.fk_package
        AND pd1.id_package_dispatching = (SELECT 
            MIN(id_package_dispatching)
        FROM
            oms_live.oms_package_dispatching
        WHERE
            fk_package = pdh.fk_package
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_package_dispatching pd2 ON pdh.fk_package = pd2.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pd1.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd2.fk_shipment_provider = sp2.id_shipment_provider
    LEFT JOIN oms_live.oms_package pck ON pdh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (6 , 27)
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.oms_sales_order_comment socom ON so.id_sales_order = socom.fk_sales_order
        AND socom.fk_sales_order_item IS NULL
    LEFT JOIN oms_live.oms_sales_order_comment soicom ON soi.id_sales_order_item = soicom.fk_sales_order_item
    GROUP BY soi.id_sales_order_item) result;