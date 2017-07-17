SET @extractstart = '2016-02-01';
SET @extractend = '2016-03-01';

SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.payment_method,
    sp.shipment_provider_name,
    pd.tracking_number,
    soi.unit_price,
    soi.paid_price,
    soi.shipping_surcharge,
    sois.name 'item_status',
    so.created_at 'order_date',
    MIN(IF(soish.fk_sales_order_item_status = 67,
        soish.created_at,
        NULL)) 'finance_verified',
    MIN(IF(soish.fk_sales_order_item_status = 5,
        soish.created_at,
        NULL)) 'shipped',
    MIN(IF(soish.fk_sales_order_item_status = 9,
        soish.created_at,
        NULL)) 'cancelled',
    MIN(IF(soish.fk_sales_order_item_status = 27,
        soish.created_at,
        NULL)) 'delivered'
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        LEFT JOIN
    oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
        LEFT JOIN
    oms_live.oms_package_dispatching pd ON pi.fk_package = pd.fk_package
        LEFT JOIN
    oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
WHERE
    so.created_at >= @extractstart
        AND so.created_at < @extractend
        AND sp.shipment_provider_name LIKE '%lex%'
GROUP BY soi.id_sales_order_item