-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2015-01-01';
SET @extractend = '2017-10-01';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        sup.id_supplier,
            sup.name 'seller_name',
            sup.type 'seller_type',
            CASE
                WHEN ascsel.tax_class = 0 THEN 'local'
                WHEN ascsel.tax_class = 1 THEN 'international'
            END 'tax_class',
            ip.sku,
            ih.uid,
            ih.history_created_at 'lost_date',
            ihuser.username 'lost_status_updater',
            wis.name 'last_status',
            IFNULL(hlast.changed_reason_status, '') 'status_changed_reason',
            hlast.history_created_at 'last_status_date',
            hlastuser.username 'last_status_updater',
            inv.cost 'inventory_cost',
            ip.price 'product_price',
            cs.price 'simple_price',
            cs.special_price 'special_price',
            soi.cost 'soi_cost',
            so.order_nr,
            soi.bob_id_sales_order_item
    FROM
        (SELECT 
        *
    FROM
        oms_live.wms_inventory_history
    WHERE
        history_created_at >= @extractstart
            AND history_created_at < @extractend
            AND fk_inventory_status = 9
    GROUP BY uid) ih
    LEFT JOIN oms_live.ims_user ihuser ON ih.updated_by = ihuser.id_user
    LEFT JOIN oms_live.wms_inventory inv ON ih.id_inventory = inv.id_inventory
    LEFT JOIN oms_live.wms_inventory_history hlast ON inv.id_inventory = hlast.id_inventory
        AND hlast.id_inventory_history = (SELECT 
            MAX(id_inventory_history)
        FROM
            oms_live.wms_inventory_history
        WHERE
            id_inventory = inv.id_inventory)
    LEFT JOIN oms_live.wms_inventory_status wis ON hlast.fk_inventory_status = wis.id_inventory_status
    LEFT JOIN oms_live.ims_user hlastuser ON hlast.updated_by = hlastuser.id_user
    LEFT JOIN oms_live.ims_product ip ON inv.fk_product = ip.id_product
    LEFT JOIN oms_live.ims_purchase_order_item poi ON ih.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN oms_live.ims_supplier_product sp ON poi.fk_supplier_product = sp.id_supplier_product
    LEFT JOIN oms_live.ims_supplier isup ON sp.fk_supplier = isup.id_supplier
    LEFT JOIN bob_live.supplier sup ON isup.bob_id_supplier = sup.id_supplier
    LEFT JOIN oms_live.oms_package_item pi ON inv.id_inventory = pi.fk_inventory
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN bob_live.catalog_simple cs ON ip.sku = cs.sku
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    WHERE
        sup.type = 'merchant') result