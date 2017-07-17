SET @extractstart = '2016-10-01';
SET @extractend = '2016-11-01';

SELECT 
    COUNT(DISTINCT (id_sales_order)) 'count_so',
    COUNT(id_sales_order_item) 'count_soi',
    COUNT(id_sales_order_item) / COUNT(DISTINCT (id_sales_order)) 'basket_size'
FROM
    (SELECT 
        so.id_sales_order,
            soi.id_sales_order_item,
            soi.bob_id_sales_order_item,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.paid_price + soi.shipping_amount + soi.shipping_surcharge 'nmv',
            sup.id_supplier,
            sup.name,
            sup.type,
            CASE
                WHEN lscsel.tax_class IS NOT NULL THEN lscsel.tax_class
                ELSE CASE
                    WHEN ascsel.tax_class = 0 THEN 'local'
                    WHEN ascsel.tax_class = 1 THEN 'international'
                END
            END 'tax_class'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region cty ON dst.fk_customer_address_region = cty.id_customer_address_region
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN screport.seller lscsel ON sup.id_supplier = lscsel.src_id
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND soish.id_sales_order_item_status_history IS NOT NULL
    GROUP BY soi.id_sales_order_item) result