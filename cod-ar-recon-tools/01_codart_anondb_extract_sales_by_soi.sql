/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
COD AR Recon by SOI 
 
Prepared by		: Michael Julius
Modified by		: MJ
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    soi_created_at,
    payment_method,
    is_marketplace,
    order_number,
    bob_id_sales_order_item,
    sku,
    REPLACE(REPLACE(item_name, '\\', ''), char(10), ' ') AS item_name,
    unit_price,
    paid_price,
    shipping_amount,
    shipping_surcharge,
    (IFNULL(paid_price, 0) + IFNULL(shipping_amount, 0) + IFNULL(shipping_surcharge, 0)) AS total_paid_by_customer,
    tracking_number,
    package_number,
    id_shipment_provider,
    shipment_provider,
    order_date,
    delivered_date,
    delivery_updater,
    last_status,
    last_status_date
FROM
    (SELECT 
        soi_created_at,
            so.payment_method,
            soi.is_marketplace,
            so.order_nr AS order_number,
            soi.bob_id_sales_order_item AS bob_id_sales_order_item,
            soi.sku,
            item_name,
            soi.unit_price AS unit_price,
            soi.paid_price AS paid_price,
            soi.shipping_amount AS shipping_amount,
            soi.shipping_surcharge AS shipping_surcharge,
            pad.tracking_number AS tracking_number,
            pa.package_number AS package_number,
            sp.id_shipment_provider AS id_shipment_provider,
            sp.shipment_provider_name AS shipment_provider,
            so.created_at AS order_date,
            pash.created_at AS delivered_date,
            user.username 'delivery_updater',
            sois.name AS last_status,
            soish.created_at AS last_status_date
    FROM
        (SELECT 
        soi.created_at AS soi_created_at,
            soi.is_marketplace,
            soi.bob_id_sales_order_item AS bob_id_sales_order_item,
            soi.id_sales_order_item,
            soi.fk_sales_order,
            soi.fk_sales_order_item_status,
            soi.sku,
            soi.name AS item_name,
            IFNULL(soi.unit_price, 0) AS unit_price,
            IFNULL(soi.paid_price, 0) AS paid_price,
            IFNULL(soi.shipping_amount, 0) AS shipping_amount,
            IFNULL(soi.shipping_surcharge, 0) AS shipping_surcharge
    FROM
        oms_live.ims_sales_order_item soi
    WHERE
        soi.bob_id_sales_order_item IN ()
    GROUP BY bob_id_sales_order_item) soi
    LEFT JOIN oms_live.oms_package_item pai ON soi.id_sales_order_item = pai.fk_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.oms_package_dispatching pad ON pai.fk_package = pad.fk_package
    LEFT JOIN oms_live.oms_package pa ON pai.fk_package = pa.id_package
    LEFT JOIN oms_live.oms_package_status_history pash ON pa.id_package = pash.fk_package
     AND pash.id_package_status_history = (SELECT 
            MIN(id_package_status_history)
        FROM
            oms_live.oms_package_status_history
        WHERE
            fk_package = pa.id_package
                AND fk_package_status = 6)
    LEFT JOIN oms_live.oms_shipment_provider sp ON pad.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item)
    LEFT JOIN oms_live.ims_user user on pash.fk_ims_user=user.id_user
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status) fin
