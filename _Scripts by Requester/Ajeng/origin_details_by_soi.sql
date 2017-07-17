SELECT 
    soi.bob_id_sales_order_item,
    so.order_nr,
    sup.name 'seller_name',
    pd.tracking_number,
    sp.shipment_provider_name,
    sfom.origin
FROM
    oms_live.ims_sales_order_item soi
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
        LEFT JOIN
    oms_live.oms_package pck ON pi.fk_package = pck.id_package
        LEFT JOIN
    oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
        LEFT JOIN
    oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
        LEFT JOIN
    bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
        LEFT JOIN
    bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.address_type = 'standard'
        LEFT JOIN
    bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
WHERE
    soi.bob_id_sales_order_item IN ('')
GROUP BY soi.bob_id_sales_order_item