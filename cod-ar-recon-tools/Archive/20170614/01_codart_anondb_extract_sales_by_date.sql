/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
COD AR Recon by Delivered Date 
 
Prepared by		: Michael Julius
Modified by		: MJ
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractstart for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-01-16';
SET @extractend = '2017-01-23';-- This MUST be D + 1

SELECT 
    soi_created_at,
    payment_method,
    is_marketplace,
    order_number,
    bob_id_sales_order_item,
    sku,
    REPLACE(item_name, '\\', '') AS item_name,
    unit_price,
    paid_price,
    shipping_amount,
    shipping_surcharge,
    (paid_price + shipping_amount + shipping_surcharge) AS total_paid_by_customer,
    tracking_number,
    package_number,
    id_shipment_provider,
    shipment_provider,
    order_date,
    delivered_date,
    last_status,
    last_status_date
FROM
    (SELECT 
        soi.created_at AS soi_created_at,
            so.payment_method,
            soi.is_marketplace,
            so.order_nr AS order_number,
            soi.bob_id_sales_order_item AS bob_id_sales_order_item,
            soi.sku,
            soi.name AS item_name,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            pad.tracking_number AS tracking_number,
            pa.package_number AS package_number,
            sp.id_shipment_provider AS id_shipment_provider,
            sp.shipment_provider_name AS shipment_provider,
            so.created_at AS order_date,
            soish2.created_at AS delivered_date,
            sois.name AS last_status,
            soish.created_at AS last_status_date
    FROM
        (SELECT 
        fk_package, created_at
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6) pash
    LEFT JOIN oms_live.oms_package pa ON pash.fk_package = pa.id_package
    LEFT JOIN oms_live.oms_package_item pai ON pa.id_package = pai.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pai.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.oms_package_dispatching pad ON pai.fk_package = pad.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pad.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_package_status pas ON pa.fk_package_status = pas.id_package_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item)
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish2 ON soi.id_sales_order_item = soish2.fk_sales_order_item
        AND soish2.fk_sales_order_item_status = 27
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    GROUP BY bob_id_sales_order_item) fin
HAVING payment_method = 'CashOnDelivery'
	AND delivered_date IS NOT NULL
    