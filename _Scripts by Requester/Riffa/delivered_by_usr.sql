-- SOI, order no, order creation date, tracking no., delivered update date, unit price, payment method, 3PL name

SELECT 
    soi.bob_id_sales_order_item,
    so.order_nr,
    so.created_at,
    pd.tracking_number,
    soish.created_at 'delivered_date',
    soi.unit_price,
    so.payment_method,
    sp.shipment_provider_name,
    usr.username
FROM
    oms_live.ims_sales_order_item_status_history soish
        LEFT JOIN
    oms_live.ims_user usr ON soish.fk_user = usr.id_user
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON soish.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
        LEFT JOIN
    oms_live.oms_package_dispatching pd ON pi.fk_package = pd.fk_package
        LEFT JOIN
    oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
WHERE
    soish.created_at >= '2016-05-01'
        AND soish.created_at < '2016-06-21'
        AND soish.fk_sales_order_item_status = 27
        AND fk_user = 2157