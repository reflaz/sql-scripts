SELECT 
    *
FROM
    (SELECT 
        p.sku AS sku,
            i.uid AS uid,
            i.barcode AS manufacturer_barcode,
            p.name AS item_description,
            IF(l.description IS NULL, '', l.description) AS location,
            IF(wis.name IS NULL, '', wis.name) AS status,
            i.created_at AS created_at,
            i.updated_at AS updated_at,
            i.expiry_date AS expiry_date,
            poi.cost AS cogp,
            i.cost AS write_down_cost,
            IF(po.po_number IS NULL, '', po.po_number) AS po_number,
            IF(po.po_type IS NULL, '', po.po_type) AS po_type,
            IF(so.order_nr IS NULL, '', so.order_nr) AS order_nr,
            s.name AS supplier_name,
            i.changed_reason_status,
            poct.name AS po_contract_type,
            wh.name AS warehouse_name
    FROM
        oms_live.wms_inventory i
    JOIN oms_live.ims_product p ON i.fk_product = p.id_product
    LEFT JOIN oms_live.ims_location l ON l.id_location = i.fk_location
    JOIN oms_live.ims_purchase_order_item poi ON i.fk_purchase_order_item = poi.id_purchase_order_item
    JOIN oms_live.ims_purchase_order po ON po.id_purchase_order = poi.fk_purchase_order
    LEFT JOIN oms_live.ims_sales_order_item soi ON poi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.wms_inventory_status wis ON i.fk_inventory_status = wis.id_inventory_status
    JOIN oms_live.ims_supplier_product sp ON poi.fk_supplier_product = sp.id_supplier_product
    JOIN oms_live.ims_supplier sup ON sp.fk_supplier = sup.id_supplier
    JOIN oms_live.ims_purchase_order_contract_type poct ON po.fk_purchase_order_contract_type = poct.id_purchase_order_contract_type
    JOIN oms_live.oms_warehouse AS wh ON wh.id_warehouse = i.fk_current_warehouse
    LEFT JOIN bob_live.supplier s ON sup.bob_id_supplier = s.id_supplier
    WHERE
        i.fk_inventory_status NOT IN (6 , 15, 28)
            AND poct.name = 'Outright') result;