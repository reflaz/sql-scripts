/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Return To Seller by Date
 
Prepared by		: Michael Julius
Modified by		: MJ
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractstart for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-11-01';
SET @extractend = '2016-12-01'; -- This MUST be D + 1

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
            -- Update New Version / 2016-11-21 / Requested By Melisa --
            poct.name, 
            -- END Update --
            i.created_at AS created_at,
            i.updated_at AS updated_at,
            i.expiry_date AS expiry_date,
            poi.cost AS cogp,
            i.cost AS write_down_cost,
            IF(po.po_number IS NULL, '', po.po_number) AS po_number,
            IF(po.po_type IS NULL, '', po.po_type) AS po_type,
            IF(so.order_nr IS NULL, '', so.order_nr) AS order_nr,
            sup.name AS supplier_name,
            i.changed_reason_status,
            poct.name AS po_contract_type,
            wh.name AS warehouse_name,
            CONCAT('IDR', RIGHT(CONCAT('0000', srpck.id_supplier_return_package), 7)) AS sap_rts_po_number,
            CONCAT('ID', sup.id_supplier) AS supplier,
            p.erp_reference,
            MAX(i.history_created_at) 'sold_offline_date'
    FROM
        oms_live.wms_inventory_history i
    LEFT JOIN oms_live.wms_inventory_history ih ON i.id_inventory = ih.id_inventory
        AND ih.id_inventory_history = (SELECT 
            MAX(id_inventory_history)
        FROM
            oms_live.wms_inventory_history
        WHERE
            history_created_at >= @extractstart
                AND history_created_at < @extractend
                AND id_inventory = i.id_inventory)
    LEFT JOIN oms_live.wms_inventory_status wis ON ih.fk_inventory_status = wis.id_inventory_status
    LEFT JOIN oms_live.ims_product p ON i.fk_product = p.id_product
    LEFT JOIN oms_live.ims_location l ON l.id_location = i.fk_location
    LEFT JOIN oms_live.ims_purchase_order_item poi ON i.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN oms_live.ims_purchase_order po ON po.id_purchase_order = poi.fk_purchase_order
    LEFT JOIN oms_live.ims_sales_order_item soi ON poi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_supplier_product sp ON poi.fk_supplier_product = sp.id_supplier_product
    LEFT JOIN oms_live.ims_purchase_order_contract_type poct ON po.fk_purchase_order_contract_type = poct.id_purchase_order_contract_type
    LEFT JOIN oms_live.oms_supplier_return_picklist_item srpi ON i.id_inventory = srpi.fk_inventory
    LEFT JOIN oms_live.oms_supplier_return_package_item srpai ON srpi.id_supplier_return_picklist_item = srpai.fk_supplier_return_picklist_item
    LEFT JOIN oms_live.oms_supplier_return_package srpck ON srpai.fk_supplier_return_package = srpck.id_supplier_return_package
    LEFT JOIN oms_live.oms_warehouse AS wh ON wh.id_warehouse = i.fk_current_warehouse
    LEFT JOIN oms_live.ims_supplier s ON sp.fk_supplier = s.id_supplier
    LEFT JOIN bob_live.supplier sup ON s.bob_id_supplier = sup.id_supplier
    WHERE
        i.history_created_at >= @extractstart
            AND i.history_created_at < @extractend
            AND ih.fk_inventory_status = 20
    GROUP BY supplier , uid , erp_reference , po_type) result;