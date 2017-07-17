-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-05-01';
SET @extractend = '2017-06-01'; -- This MUST be D + 1

SELECT 
    'Write Off' AS reason,
    poct.name AS po_contract_type,
    hist1.uid AS uid,
    p.sku AS sku,
    p.erp_reference,
    hist2.cost,
    hist2.history_created_at 'written_off_date',
    hist3.fk_inventory_status 'last_status_code',
    hist2.fk_inventory_status 'max_status_code'
FROM
    (SELECT 
        *
    FROM
        oms_live.wms_inventory_history ih
    WHERE
        ih.history_created_at >= @extractstart
            AND ih.history_created_at < @extractend
            AND ih.fk_inventory_status = 32) hist1
        LEFT JOIN
    oms_live.wms_inventory_history hist2 ON hist1.id_inventory = hist2.id_inventory
        AND hist2.id_inventory_history = (SELECT 
            MAX(invhis.id_inventory_history)
        FROM
            oms_live.wms_inventory_history invhis
        WHERE
            invhis.id_inventory = hist1.id_inventory
                AND invhis.history_created_at >= @extractstart
                AND invhis.history_created_at < @extractend)
        LEFT JOIN
    oms_live.wms_inventory_history hist3 ON hist1.id_inventory = hist3.id_inventory
        AND hist3.id_inventory_history = (SELECT 
            MAX(inhis.id_inventory_history)
        FROM
            oms_live.wms_inventory_history inhis
        WHERE
            inhis.history_created_at < @extractstart
                AND inhis.id_inventory = hist1.id_inventory)
        LEFT JOIN
    oms_live.ims_product p ON hist1.fk_product = p.id_product
        LEFT JOIN
    oms_live.ims_purchase_order_item poi ON hist1.fk_purchase_order_item = poi.id_purchase_order_item
        LEFT JOIN
    oms_live.ims_purchase_order po ON po.id_purchase_order = poi.fk_purchase_order
        LEFT JOIN
    oms_live.ims_purchase_order_contract_type poct ON po.fk_purchase_order_contract_type = poct.id_purchase_order_contract_type
HAVING po_contract_type IN ('Outright' , 'Consignment')
    AND (hist3.fk_inventory_status <> 32
    OR hist3.fk_inventory_status IS NULL)
    AND hist2.fk_inventory_status = 32;