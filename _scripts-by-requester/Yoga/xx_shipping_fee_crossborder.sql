-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-03-01';
SET @extractend = '2017-03-09';-- This MUST be D + 1

SELECT 
    MIN(IF(soish.fk_sales_order_item_status = 5,
        soish.created_at,
        NULL)) 'first_shipped_date',
    MAX(IF(soish.fk_sales_order_item_status = 5,
        soish.created_at,
        NULL)) 'last_shipped_date',
    IFNULL(ascsoi.id_sales_order_item,
            ascsoia.id_sales_order_item) 'sc_sales_order_item',
    soi.bob_id_sales_order_item,
    first_tracking_number,
    so.order_nr,
    ascsel.tax_class,
    sup.id_supplier 'bob_id_supplier',
    ascsel.short_code,
    sup.name 'seller_name',
    soi.unit_price,
    CASE
        WHEN soi.is_marketplace = 0 THEN NULL
        ELSE IFNULL((SELECT 
                        SUM(IFNULL(value, 0))
                    FROM
                        asc_live.transaction
                    WHERE
                        ref = IFNULL(ascsoi.id_sales_order_item,
                                ascsoia.id_sales_order_item)
                            AND fk_transaction_type = 7),
                (SELECT 
                        SUM(IFNULL(value, 0))
                    FROM
                        asc_live.transaction_archive
                    WHERE
                        ref = IFNULL(ascsoi.id_sales_order_item,
                                ascsoia.id_sales_order_item)
                            AND fk_transaction_type = 7))
    END 'shipping_fee'
FROM
    (SELECT 
        pck.id_package,
            pck.package_number,
            pd.id_package_dispatching,
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider'
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 4
    GROUP BY fk_package) result
    LEFT JOIN oms_live.oms_package pck ON result.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON pd.id_package_dispatching = pdh.fk_package_dispatching
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package_dispatching = pd.id_package_dispatching
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
    HAVING first_shipment_provider IS NOT NULL) result
        LEFT JOIN
    oms_live.oms_package_item pi ON result.id_package = pi.fk_package
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5)
        LEFT JOIN
    bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
        LEFT JOIN
    asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
        LEFT JOIN
    asc_live.sales_order_item ascsoi ON soi.id_sales_order_item = ascsoi.src_id
        LEFT JOIN
    asc_live.sales_order_item_archive ascsoia ON soi.id_sales_order_item = ascsoia.src_id
WHERE
    ascsel.tax_class = '1'
GROUP BY soi.id_sales_order_item
HAVING first_shipped_date >= @extractstart
    AND first_shipped_date < @extractend