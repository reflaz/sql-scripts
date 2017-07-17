SET @extractstart = '2016-09-01';
SET @extractend = '2016-10-01';

SELECT 
    supplier_type,
    tax_class,
    SUM(unit_price) 'total_unit_price',
    SUM(paid_price) 'total_paid_price',
    SUM(commission) 'total_commission',
    SUM(commission_credit) 'total_commission_credit',
    SUM(payment_fee) 'total_payment_fee',
    SUM(shipping_fee) 'total_shipping_fee',
    SUM(seller_debit_item) 'total_seller_debit_item'
FROM
    (SELECT 
        soi.id_sales_order_item,
            soi.unit_price,
            soi.paid_price,
            soish.created_at,
            sel.tax_class,
            sup.type 'supplier_type',
            SUM(IF(tr.fk_transaction_type = 16, tr.value, 0)) 'commission',
            SUM(IF(tr.fk_transaction_type = 15, tr.value, 0)) 'commission_credit',
            SUM(IF(tr.fk_transaction_type = 3, tr.value, 0)) 'payment_fee',
            SUM(IF(tr.fk_transaction_type = 7, tr.value, 0)) 'shipping_fee',
            SUM(IF(tr.fk_transaction_type = 37, tr.value, 0)) 'seller_debit_item'
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN screport.seller sel ON scsoi.fk_seller = sel.id_seller
    LEFT JOIN screport.transaction tr ON scsoi.id_sales_order_item = tr.ref
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    GROUP BY id_sales_order_item
    HAVING soish.created_at >= @extractstart
        AND soish.created_at < @extractend) result
GROUP BY supplier_type , tax_class