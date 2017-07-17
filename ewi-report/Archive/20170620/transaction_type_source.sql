SET @extractstart = '2016-01-01';
SET @extractend = '2017-01-01';

SELECT 
    tt.id_transaction_type,
    tt.description,
    CASE
        WHEN soi.id_sales_order_item IS NOT NULL THEN 'sales_order_item'
        WHEN tr.fk_seller IS NOT NULL THEN 'seller'
    END 'fk_source',
    tt.ref_source
FROM
    screport.transaction tr
        LEFT JOIN
    screport.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
        LEFT JOIN
    screport.sales_order_item soi ON tr.ref = soi.id_sales_order_item
WHERE
    tr.created_at >= @extractstart
        AND tr.created_at < @extractend
GROUP BY tr.fk_transaction_type , fk_source;

SELECT 
    tt.id_transaction_type,
    tt.description,
    CASE
        WHEN soi.id_sales_order_item IS NOT NULL THEN 'sales_order_item'
        WHEN tr.fk_seller IS NOT NULL THEN 'seller'
    END 'fk_source',
    tt.ref_source
FROM
    asc_live.transaction tr
        LEFT JOIN
    asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
        LEFT JOIN
    asc_live.sales_order_item soi ON tr.ref = soi.id_sales_order_item
WHERE
    tr.created_at >= @extractstart
        AND tr.created_at < @extractend
GROUP BY tr.fk_transaction_type , fk_source;