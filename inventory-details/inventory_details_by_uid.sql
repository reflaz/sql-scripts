SELECT 
    inv.sku 'Sku',
    inv.uid 'Uid',
    inv.barcode 'Manufacturer Barcode',
    pro.name 'Item Description',
    pro.brand 'Brand',
    pro.category_string 'Category',
    loc.description 'Location',
    wis.name 'Status',
    inv.created_at 'Created At',
    crt.username 'Created By',
    inv.updated_at 'Updated At',
    upd.username 'Updated By',
    inv.expiry_date 'Expiry Date',
    inv.expiration_date 'Expiration Date',
    inv.batch_number 'Batch Number',
    poi.cost 'COGP',
    inv.cost 'Write Down Cost',
    po.po_number 'PO Number',
    po.po_type 'PO Type',
    so.order_nr 'Order #',
    '' AS 'Supplier Code',
    inv.changed_reason_status 'Changed Status Reason',
    '' AS 'IMEI'
--    soi.bob_id_sales_order_item 'BOB SOI',
--    sois.name 'Last Status'
FROM
    oms_live.wms_inventory inv
        LEFT JOIN
    oms_live.ims_product pro ON inv.fk_product = pro.id_product
        LEFT JOIN
    oms_live.ims_location loc ON inv.fk_location = loc.id_location
        LEFT JOIN
    oms_live.wms_inventory_status wis ON inv.fk_inventory_status = wis.id_inventory_status
        LEFT JOIN
    oms_live.ims_user crt ON inv.created_by = crt.id_user
        LEFT JOIN
    oms_live.ims_user upd ON inv.updated_by = upd.id_user
        LEFT JOIN
    oms_live.ims_purchase_order_item poi ON inv.fk_purchase_order_item = poi.id_purchase_order_item
        LEFT JOIN
    oms_live.ims_purchase_order po ON poi.fk_purchase_order = po.id_purchase_order
		LEFT JOIN
	oms_live.ims_sales_order_item soi ON poi.fk_sales_order_item = soi.id_sales_order_item
		LEFT JOIN
	oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
		LEFT JOIN
	oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
WHERE
    inv.uid IN ()