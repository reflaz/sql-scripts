SET @extractend = '2017-06-01';

SELECT 
    *
FROM
    (SELECT 
        inv.sku,
            inv.uid,
            soi.unit_price,
            soi.paid_price,
            sup.id_supplier,
            sup.name 'seller_name',
            sup.type 'seller_type'
    FROM
        oms_live.wms_inventory inv
    LEFT JOIN oms_live.ims_purchase_order_item poi ON inv.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN oms_live.ims_sales_order_item soi ON inv.sku = soi.sku
        AND soi.id_sales_order_item = (SELECT 
            MAX(id_sales_order_item)
        FROM
            oms_live.ims_sales_order_item
        WHERE
            sku = inv.sku
                AND created_at < @extractend)
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN bob_live.catalog_simple cs ON inv.sku = cs.sku
    LEFT JOIN bob_live.catalog_source cso ON cs.id_catalog_simple = cso.fk_catalog_simple
    JOIN bob_live.supplier sup ON cso.fk_supplier = sup.id_supplier
        AND sup.type = 'supplier'
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        inv.uid IN ()
    GROUP BY uid) result