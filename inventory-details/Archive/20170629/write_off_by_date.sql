SET @PeriodEndDate = '';
SET @PeriodStartDate = '';

-- Written off at the start of the period and not written off anymore
SELECT DISTINCT
    'Write Off' AS reason,
    PEWO.po_type,
    PEWO.uid,
    p.sku,
    p.erp_reference,
    PEWO.cost,
    transdate
FROM
    (SELECT DISTINCT
        id_inventory
    FROM
        oms_live.wms_inventory_history ih
    JOIN (SELECT 
        UID, MAX(id_inventory_history) AS id_inventory_history
    FROM
        oms_live.wms_inventory_history
    WHERE
        history_created_at < @PeriodStartDate
    GROUP BY UID) PS ON ih.id_inventory_history = PS.id_inventory_history
        AND ih.fk_inventory_status <> 32) PSWO
        RIGHT JOIN
    (SELECT 
        id_inventory,
            ih.created_at,
            ih.uid,
            cost,
            po_type,
            fk_product,
            MAX(history_created_at) AS TransDate,
            fk_delivery_receipt_item
    FROM
        oms_live.wms_inventory_history ih
    JOIN (SELECT 
        UID, MAX(id_inventory_history) AS id_inventory_history
    FROM
        oms_live.wms_inventory_history
    WHERE
        history_created_at < @PeriodEndDate
    GROUP BY UID) PE ON ih.id_inventory_history = PE.id_inventory_history
        AND ih.fk_inventory_status = 32
    WHERE
        ih.history_created_at > @PeriodStartDate
    GROUP BY id_inventory , ih.uid , cost , po_type , fk_product) PEWO ON PSWO.id_inventory = PEWO.id_inventory
        JOIN
    oms_live.ims_product p ON PEWO.fk_product = p.id_product
        LEFT JOIN
    oms_live.wms_delivery_receipt_item dri ON PEWO.fk_delivery_receipt_item = dri.id_delivery_receipt_item
        LEFT JOIN
    oms_live.wms_delivery_receipt dr ON dri.fk_delivery_receipt = dr.id_delivery_receipt
WHERE
    (dr.created_at > @PeriodStartDate
        OR PSWO.id_inventory IS NOT NULL);