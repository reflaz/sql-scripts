/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account Shipping Surcharge by Tracking Number
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Insert formatted Tracking Number in >> WHERE oms_pd.tracking_number IN () part of the script. You can format the ID in
				  excel using this formula: ="'"&<Column>&"'," --> change <Column> accordingly
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    oms_pd.tracking_number,
    oms_pck.package_number,
    oms_sp.shipment_provider_name,
    oms_so.order_nr,
    sc_sel.name 'seller_name',
    bob_sup.type 'seller_type',
    sc_sel.tax_class,
    oms_so.created_at,
    oms_sois.name 'item_status',
    oms_ship.created_at 'shipped_date',
    SUM(oms_soi.shipping_surcharge) 'shipping_surcharge',
    oms_soa.city 'shipping_city',
    COUNT(oms_soi.id_sales_order_item) 'item_count'
FROM
    oms_live.oms_package_dispatching oms_pd
        LEFT JOIN
    oms_live.oms_package oms_pck ON oms_pd.fk_package = oms_pck.id_package
        LEFT JOIN
    oms_live.oms_shipment_provider oms_sp ON oms_pd.fk_shipment_provider = oms_sp.id_shipment_provider
        LEFT JOIN
    oms_live.oms_package_item oms_pi ON oms_pck.id_package = oms_pi.fk_package
        LEFT JOIN
    oms_live.ims_sales_order_item oms_soi ON oms_pi.fk_sales_order_item = oms_soi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history oms_ship ON oms_soi.id_sales_order_item = oms_ship.fk_sales_order_item
        AND oms_ship.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = oms_soi.id_sales_order_item
                AND fk_sales_order_item_status = 5)
        LEFT JOIN
    oms_live.ims_sales_order_item_status oms_sois ON oms_soi.fk_sales_order_item_status = oms_sois.id_sales_order_item_status
        LEFT JOIN
    oms_live.ims_sales_order oms_so ON oms_soi.fk_sales_order = oms_so.id_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_address oms_soa ON oms_so.fk_sales_order_address_shipping = oms_soa.id_sales_order_address
        LEFT JOIN
    bob_live.supplier bob_sup ON oms_soi.bob_id_supplier = bob_sup.id_supplier
        LEFT JOIN
    screport.seller sc_sel ON oms_soi.bob_id_supplier = sc_sel.src_id
WHERE
    oms_pd.tracking_number IN ('')
GROUP BY oms_pd.tracking_number;