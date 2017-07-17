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
        pck.invoice_number,
            pck.package_number,
            so.order_nr,
            soi.bob_id_sales_order_item,
            so.payment_method,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            sois.name 'last_Status',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'first_shipped_date',
            MAX(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'last_shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            pd1.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd2.tracking_number 'last_tracking_number',
            sp1.shipment_provider_name 'last_shipment_provider',
            GROUP_CONCAT(DISTINCT socom.content
                SEPARATOR '\n\n') 'so_comment',
            GROUP_CONCAT(DISTINCT soicom.content
                SEPARATOR '\n\n') 'soi_comment'
    FROM
        (SELECT 
        id_package, invoice_number, package_number
    FROM
        oms_live.oms_package
    WHERE
        invoice_number IN ()
    GROUP BY invoice_number) pck
    LEFT JOIN oms_live.oms_package_dispatching pd1 ON pck.id_package = pd1.fk_package
        AND pd1.id_package_dispatching = (SELECT 
            MIN(id_package_dispatching)
        FROM
            oms_live.oms_package_dispatching
        WHERE
            fk_package = pck.id_package
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_package_dispatching pd2 ON pck.id_package = pd2.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pd1.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd2.fk_shipment_provider = sp2.id_shipment_provider
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5 , 27)
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.oms_sales_order_comment socom ON so.id_sales_order = socom.fk_sales_order
        AND socom.fk_sales_order_item IS NULL
    LEFT JOIN oms_live.oms_sales_order_comment soicom ON soi.id_sales_order_item = soicom.fk_sales_order_item
    GROUP BY soi.id_sales_order_item) result;