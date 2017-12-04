SET @extractstart = '2015-03-01';
SET @extractend = '2015-04-01';
SET @id_seller = '';

SELECT 
    *
FROM
    (SELECT 
        tr.created_at 'Transaction Date',
            tt.description 'Transaction Type',
            tr.number 'Transaction Number',
            tr.name 'Details',
            tr.sku_seller 'Seller SKU',
            tr.sku 'Lazada SKU',
            tr.value 'Amount',
            IFNULL(tr.taxes_vat, '') 'VAT in Amount',
            IFNULL(tr.taxes_wht, '') 'WHT Amount',
            IF(tr.is_wht_in_amount = 1, 'Yes', 'No') 'WHT included in Amount',
            CONCAT_WS('-', DATE_FORMAT(ts.start_date, '%d %M %Y'), DATE_FORMAT(ts.end_date, '%d %M %Y')) 'Statement',
            IF(ts.paid = 1, 'Paid', 'Not paid') 'Paid Status',
            tr.order_nr 'Order No.',
            tr.id_sales_order_item 'Order Item No.',
            tr.src_status 'Order Item Status',
            sp.name 'Shipping Provider',
            tr.shipping_provider_type 'Shipping Speed',
            st.name 'Shipment Type',
            tr.id_sales_order_item 'Reference',
            tr.description 'Comment',
            '' AS 'PaymentRefId',
            tr.number
    FROM
        (SELECT 
        tr.*,
            IFNULL(soi.name, soia.name) 'name',
            IFNULL(soi.sku_seller, soia.sku_seller) 'sku_seller',
            IFNULL(soi.sku, soia.sku) 'sku',
            IFNULL(so.order_nr, soa.order_nr) 'order_nr',
            IFNULL(soi.id_sales_order_item, soia.id_sales_order_item) 'id_sales_order_item',
            IFNULL(soi.src_status, soia.src_status) 'src_status',
            COALESCE(soi.shipping_provider_type, soia.shipping_provider_type, '') 'shipping_provider_type',
            IFNULL(soi.fk_shipment_provider, soia.fk_shipment_provider) 'fk_shipment_provider',
            IFNULL(soi.fk_shipment_type, soia.fk_shipment_type) 'fk_shipment_type'
    FROM
        asc_live.transaction tr
    LEFT JOIN asc_live.sales_order_item soi ON tr.ref = soi.id_sales_order_item
    LEFT JOIN asc_live.sales_order_item_archive soia ON tr.ref = soia.id_sales_order_item
    LEFT JOIN asc_live.sales_order so ON IFNULL(soi.fk_sales_order, soia.fk_sales_order) = so.id_sales_order
    LEFT JOIN asc_live.sales_order_archive soa ON IFNULL(soi.fk_sales_order, soia.fk_sales_order) = soa.id_sales_order
    WHERE
        tr.created_at >= @extractstart
            AND tr.created_at < @extractend
            AND tr.fk_seller = @id_seller
    GROUP BY tr.id_transaction) tr
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
    LEFT JOIN asc_live.transaction_statement ts ON tr.fk_transaction_statement = ts.id_transaction_statement
    LEFT JOIN asc_live.shipment_provider sp ON tr.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN asc_live.shipment_type st ON tr.fk_shipment_type = st.id_shipment_type UNION ALL SELECT 
        tr.created_at 'Transaction Date',
            tt.description 'Transaction Type',
            tr.number 'Transaction Number',
            tr.name 'Details',
            tr.sku_seller 'Seller SKU',
            tr.sku 'Lazada SKU',
            tr.value 'Amount',
            IFNULL(tr.taxes_vat, '') 'VAT in Amount',
            IFNULL(tr.taxes_wht, '') 'WHT Amount',
            IF(tr.is_wht_in_amount = 1, 'Yes', 'No') 'WHT included in Amount',
            CONCAT_WS('-', DATE_FORMAT(ts.start_date, '%d %M %Y'), DATE_FORMAT(ts.end_date, '%d %M %Y')) 'Statement',
            IF(ts.paid = 1, 'Paid', 'Not paid') 'Paid Status',
            tr.order_nr 'Order No.',
            tr.id_sales_order_item 'Order Item No.',
            tr.src_status 'Order Item Status',
            sp.name 'Shipping Provider',
            tr.shipping_provider_type 'Shipping Speed',
            st.name 'Shipment Type',
            tr.id_sales_order_item 'Reference',
            tr.description 'Comment',
            '' AS 'PaymentRefId',
            tr.number
    FROM
        (SELECT 
        tr.*,
            IFNULL(soi.name, soia.name) 'name',
            IFNULL(soi.sku_seller, soia.sku_seller) 'sku_seller',
            IFNULL(soi.sku, soia.sku) 'sku',
            IFNULL(so.order_nr, soa.order_nr) 'order_nr',
            IFNULL(soi.id_sales_order_item, soia.id_sales_order_item) 'id_sales_order_item',
            IFNULL(soi.src_status, soia.src_status) 'src_status',
            COALESCE(soi.shipping_provider_type, soia.shipping_provider_type, '') 'shipping_provider_type',
            IFNULL(soi.fk_shipment_provider, soia.fk_shipment_provider) 'fk_shipment_provider',
            IFNULL(soi.fk_shipment_type, soia.fk_shipment_type) 'fk_shipment_type'
    FROM
        asc_live.transaction_archive tr
    LEFT JOIN asc_live.sales_order_item soi ON tr.ref = soi.id_sales_order_item
    LEFT JOIN asc_live.sales_order_item_archive soia ON tr.ref = soia.id_sales_order_item
    LEFT JOIN asc_live.sales_order so ON IFNULL(soi.fk_sales_order, soia.fk_sales_order) = so.id_sales_order
    LEFT JOIN asc_live.sales_order_archive soa ON IFNULL(soi.fk_sales_order, soia.fk_sales_order) = soa.id_sales_order
    WHERE
        tr.created_at >= @extractstart
            AND tr.created_at < @extractend
            AND tr.fk_seller = @id_seller
    GROUP BY tr.id_transaction) tr
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
    LEFT JOIN asc_live.transaction_statement ts ON tr.fk_transaction_statement = ts.id_transaction_statement
    LEFT JOIN asc_live.shipment_provider sp ON tr.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN asc_live.shipment_type st ON tr.fk_shipment_type = st.id_shipment_type) result
GROUP BY number;