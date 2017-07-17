/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Inventory Stock by Date SKU
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @extractend = '2016-12-15';-- This must be D+1

SELECT 
    supplier_name,
    sku,
    product_name,
    COUNT(id_inventory) 'stock'
FROM
    (SELECT 
        inv.id_inventory,
            sup.name 'supplier_name',
            inv.sku,
            pro.name 'product_name',
            ins.available_for_stock
    FROM
        oms_live.wms_inventory inv
    LEFT JOIN oms_live.wms_inventory_history invh ON inv.uid = invh.uid
        AND invh.id_inventory_history = (SELECT 
            MAX(id_inventory_history)
        FROM
            oms_live.wms_inventory_history
        WHERE
            uid = inv.uid
                AND created_at < @extractend)
    LEFT JOIN oms_live.wms_inventory_status ins ON invh.fk_inventory_status = ins.id_inventory_status
    LEFT JOIN oms_live.ims_product pro ON inv.fk_product = pro.id_product
    LEFT JOIN oms_live.ims_supplier_product sp ON pro.id_product = sp.fk_product
    LEFT JOIN oms_live.ims_supplier osup ON sp.fk_supplier = osup.id_supplier
    LEFT JOIN bob_live.supplier sup ON osup.bob_id_supplier = sup.id_supplier
    WHERE
        inv.sku IN ()
    HAVING ins.available_for_stock = 1) result
GROUP BY sku