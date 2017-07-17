SELECT 
    *
FROM
    (SELECT 
        result.*,
            tt.description 'transaction_type',
            tr.number,
            tr.value,
            tr.description
    FROM
        (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            IFNULL(scsoi.id_sales_order_item, scsoia.id_sales_order_item) 'sc_sales_order_item'
    FROM
        oms_live.ims_sales_order_item soi
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN asc_live.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN asc_live.sales_order_item_archive scsoia ON soi.id_sales_order_item = scsoia.src_id
        AND IFNULL(scsoi.id_sales_order_item, 0) <> scsoia.id_sales_order_item
    WHERE
        soi.created_at >= '2016-05-01'
            AND soi.created_at < '2016-05-02'
    HAVING sc_sales_order_item IS NOT NULL) result
    LEFT JOIN asc_live.transaction tr ON result.sc_sales_order_item = tr.ref
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type UNION ALL SELECT 
        result.*,
            tt.description,
            tra.number,
            tra.value,
            tra.description
    FROM
        (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            IFNULL(scsoi.id_sales_order_item, scsoia.id_sales_order_item) 'sc_sales_order_item'
    FROM
        oms_live.ims_sales_order_item soi
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN asc_live.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN asc_live.sales_order_item_archive scsoia ON soi.id_sales_order_item = scsoia.src_id
        AND IFNULL(scsoi.id_sales_order_item, 0) <> scsoia.id_sales_order_item
    WHERE
        soi.created_at >= '2016-05-01'
            AND soi.created_at < '2016-05-02'
    HAVING sc_sales_order_item IS NOT NULL) result
    LEFT JOIN asc_live.transaction_archive tra ON result.sc_sales_order_item = tra.ref
    LEFT JOIN asc_live.transaction_type tt ON tra.fk_transaction_type = tt.id_transaction_type) result
GROUP BY number