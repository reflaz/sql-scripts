/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Item Delivery Details by Invoice Number
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Insert formatted Package Number in >> WHERE oms_pck.invoice_number IN () << part of the script
				  - You can format the ID in excel using this formula: ="'"&Column&"'," --> change Column accordingly
                  - Delete the last comma (,)
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    *
FROM
    (SELECT 
        pd.tracking_number 'tracking_number',
            pck.invoice_number 'invoice_number',
            so.order_nr 'order_number',
            soi.bob_id_sales_order_item 'oms_sales_order_item',
            pck.package_number 'package_number',
            sup.name 'seller_name',
            sup.type 'seller_type',
            sp.shipment_provider_name 'last_shipment_provider',
            MAX(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'item_last_shipped_date',
            MAX(IF(soish.fk_sales_order_item_status = 5, usr.username, NULL)) 'item_last_shipped_user',
            MAX(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'item_last_delivered_date',
            MAX(IF(soish.fk_sales_order_item_status = 27, usr.username, NULL)) 'item_last_delivered_user',
            MAX(IF(soish.fk_sales_order_item_status IS NOT NULL, sois.name, NULL)) 'item_last_status',
            MAX(IF(soish.fk_sales_order_item_status IS NOT NULL, soish.created_at, NULL)) 'item_last_status_date',
            MAX(IF(soish.fk_sales_order_item_status IS NOT NULL, usr.username, NULL)) 'item_last_status_user'
    FROM
        oms_live.oms_package pck
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5 , 27)
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soish.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_user usr ON soish.fk_user = usr.id_user
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    WHERE
        pck.invoice_number IN ('')
    GROUP BY invoice_number , soi.bob_id_sales_order_item) result;