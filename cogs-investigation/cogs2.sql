SET @extractstart = '2016-12-01';
SET @extractend = '2016-12-12';

SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    soi.unit_price,
    soi.paid_price,
    soi.cost,
    soish.created_at 'verified_date',
    sois.name,
    poi.id_purchase_order_item,
    poi.cost,
    i.uid,
    i.id_inventory,
    i.cost,
    inv.uid,
    inv.id_inventory,
    inv.cost
FROM
    oms_live.ims_sales_order_item soi
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 67)
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
        LEFT JOIN
    oms_live.wms_inventory i ON i.sales_order_item_id = soi.id_sales_order_item
        LEFT JOIN
    oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
        LEFT JOIN
    oms_live.wms_inventory inv ON pi.fk_inventory = inv.id_inventory
        LEFT JOIN
    oms_live.ims_purchase_order_item poi ON inv.fk_purchase_order_item = poi.id_purchase_order_item
WHERE
    soi.created_at >= @extractstart
        AND soi.created_at < @extractend
        AND soi.sku = 'SA848ELAA704XVANID-17193644'
        AND soish.created_at IS NOT NULL