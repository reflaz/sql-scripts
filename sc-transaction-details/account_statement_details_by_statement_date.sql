SET @extractstart = '2015-01-01';
SET @extractend = '2015-01-08';

SELECT 
    *
FROM
    (SELECT 
        tr.created_at 'Transaction Date',
            tt.description 'Transaction Type',
            tr.number 'Transaction Number',
            REPLACE(REPLACE(COALESCE(soi.name, soia.name, ''), '\\', ''), char(10), ' ') 'Details',
            COALESCE(soi.sku_seller, soia.sku_seller, '') 'Seller SKU',
            COALESCE(soi.sku, soia.sku, '') 'Lazada SKU',
            tr.value 'Amount',
            IFNULL(tr.taxes_vat, '') 'VAT in Amount',
            IFNULL(tr.taxes_wht, '') 'WHT Amount',
            IF(tr.is_wht_in_amount = 1, 'Yes', 'No') 'WHT included in Amount',
            CONCAT_WS('-', DATE_FORMAT(ts.start_date, '%d %M %Y'), DATE_FORMAT(ts.end_date, '%d %M %Y')) 'Statement',
            IF(ts.paid = 1, 'Paid', 'Not paid') 'Paid Status',
            COALESCE(so.order_nr, soa.order_nr, '') 'Order No.',
            COALESCE(soi.id_sales_order_item, soia.id_sales_order_item, '') 'Order Item No.',
            COALESCE(soi.src_status, soia.src_status, '') 'Order Item Status',
            IFNULL(sp.name, '') 'Shipping Provider',
            COALESCE(soi.shipping_provider_type, soia.shipping_provider_type, '') 'Shipping Speed',
            IFNULL(st.name, '') 'Shipment Type',
            COALESCE(soi.id_sales_order_item, soia.id_sales_order_item, '') 'Reference',
            tr.description 'Comment',
            '' AS 'PaymentRefId',
            tr.number,
            ts.number 'statment_number',
            sel.short_code,
            sel.name 'seller_name'
    FROM
        asc_live.transaction_statement ts
    LEFT JOIN asc_live.transaction tr ON ts.id_transaction_statement = tr.fk_transaction_statement
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
    LEFT JOIN asc_live.seller sel ON tr.fk_seller = sel.id_seller
    LEFT JOIN asc_live.sales_order_item soi ON tr.ref = soi.id_sales_order_item
    LEFT JOIN asc_live.sales_order_item_archive soia ON tr.ref = soia.id_sales_order_item
    LEFT JOIN asc_live.sales_order so ON IFNULL(soi.fk_sales_order, soia.fk_sales_order) = so.id_sales_order
    LEFT JOIN asc_live.sales_order_archive soa ON IFNULL(soi.fk_sales_order, soia.fk_sales_order) = soa.id_sales_order
    LEFT JOIN asc_live.shipment_provider sp ON IFNULL(soi.fk_shipment_provider, soia.fk_shipment_provider) = sp.id_shipment_provider
    LEFT JOIN asc_live.shipment_type st ON IFNULL(soi.fk_shipment_type, soia.fk_shipment_type) = st.id_shipment_type
    WHERE
        start_date >= @extractstart
            AND start_date < @extractend UNION ALL SELECT 
        tr.created_at 'Transaction Date',
            tt.description 'Transaction Type',
            tr.number 'Transaction Number',
            REPLACE(REPLACE(COALESCE(soi.name, soia.name, ''), '\\', ''), char(10), ' ') 'Details',
            COALESCE(soi.sku_seller, soia.sku_seller, '') 'Seller SKU',
            COALESCE(soi.sku, soia.sku, '') 'Lazada SKU',
            tr.value 'Amount',
            IFNULL(tr.taxes_vat, '') 'VAT in Amount',
            IFNULL(tr.taxes_wht, '') 'WHT Amount',
            IF(tr.is_wht_in_amount = 1, 'Yes', 'No') 'WHT included in Amount',
            CONCAT_WS('-', DATE_FORMAT(ts.start_date, '%d %M %Y'), DATE_FORMAT(ts.end_date, '%d %M %Y')) 'Statement',
            IF(ts.paid = 1, 'Paid', 'Not paid') 'Paid Status',
            COALESCE(so.order_nr, soa.order_nr, '') 'Order No.',
            COALESCE(soi.id_sales_order_item, soia.id_sales_order_item, '') 'Order Item No.',
            COALESCE(soi.src_status, soia.src_status, '') 'Order Item Status',
            IFNULL(sp.name, '') 'Shipping Provider',
            COALESCE(soi.shipping_provider_type, soia.shipping_provider_type, '') 'Shipping Speed',
            IFNULL(st.name, '') 'Shipment Type',
            COALESCE(soi.id_sales_order_item, soia.id_sales_order_item, '') 'Reference',
            tr.description 'Comment',
            '' AS 'PaymentRefId',
            tr.number,
            ts.number 'statment_number',
            sel.short_code,
            sel.name 'seller_name'
    FROM
        asc_live.transaction_statement ts
    LEFT JOIN asc_live.transaction_archive tr ON ts.id_transaction_statement = tr.fk_transaction_statement
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
    LEFT JOIN asc_live.seller sel ON tr.fk_seller = sel.id_seller
    LEFT JOIN asc_live.sales_order_item soi ON tr.ref = soi.id_sales_order_item
    LEFT JOIN asc_live.sales_order_item_archive soia ON tr.ref = soia.id_sales_order_item
    LEFT JOIN asc_live.sales_order so ON IFNULL(soi.fk_sales_order, soia.fk_sales_order) = so.id_sales_order
    LEFT JOIN asc_live.sales_order_archive soa ON IFNULL(soi.fk_sales_order, soia.fk_sales_order) = soa.id_sales_order
    LEFT JOIN asc_live.shipment_provider sp ON IFNULL(soi.fk_shipment_provider, soia.fk_shipment_provider) = sp.id_shipment_provider
    LEFT JOIN asc_live.shipment_type st ON IFNULL(soi.fk_shipment_type, soia.fk_shipment_type) = st.id_shipment_type
    WHERE
        start_date >= @extractstart
            AND start_date < @extractend) result
GROUP BY number