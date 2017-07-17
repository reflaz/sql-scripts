/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Package per Order

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-10-01';
SET @extractend = '2017-03-01';-- This MUST be D + 1

SELECT 
    bu,
    delivered_month,
    COUNT(DISTINCT package_number) 'count_package',
    COUNT(DISTINCT order_nr) 'count_so',
    COUNT(DISTINCT package_number) / COUNT(DISTINCT order_nr) 'package_per_order'
FROM
    (SELECT 
        order_nr,
            package_number,
            delivered_date,
            MONTH(delivered_date) 'delivered_month',
            tax_class,
            seller_type,
            CASE
                WHEN tax_class = 1 THEN 'CB'
                WHEN
                    GROUP_CONCAT(DISTINCT seller_type
                        SEPARATOR ', ') LIKE '%, %'
                THEN
                    'FBL-MIX'
                WHEN seller_type = 'supplier' THEN 'RETAIL'
                WHEN seller_type = 'merchant' THEN 'MP LOCAL'
            END 'bu'
    FROM
        (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            result.created_at 'delivered_date',
            pck.package_number,
            sup.type 'seller_type',
            ascsel.tax_class,
            CASE
                WHEN delivery_type = 'digital' THEN 1
                WHEN
                    sp1.shipment_provider_name = 'Digital Delivery'
                        OR sp2.shipment_provider_name = 'Digital Delivery'
                THEN
                    1
                ELSE 0
            END 'is_digital'
    FROM
        (SELECT 
        fk_package, created_at
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status IN (6)
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
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.oms_shipping_type st ON soi.fk_shipping_type = st.id_shipping_type
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    HAVING is_digital = 0) result
    GROUP BY package_number) result
GROUP BY bu , delivered_month