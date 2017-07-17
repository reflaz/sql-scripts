/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
COD Report

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 4.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
				  - Change @sellertype for a specific seller type (merchant/supplier)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-07-01';
SET @extractend = '2016-08-01'; -- This MUST be H + 1
SET @sellertype = 'merchant'; -- MUST be filled with merchant/supplier

SELECT 
    last_shipment_provider,
    order_nr,
    last_tracking_number,
    item_name,
    last_status,
    SUM(paid_price) 'total_paid_price',
    SUM(shipping_amount) 'total_shipping_amount',
    SUM(shipping_surcharge) 'total_shipping_surcharge',
    SUM(total) 'total_paid_by_customer',
    order_date,
    last_shipped_date,
    real_delivered_date,
    delivered_date,
    delivered_status_creator,
    seller_name,
    bob_id_sales_order_item,
    invoice_number,
    COUNT(bob_id_sales_order_item) 'qty'
FROM
    (SELECT 
        result.id_package,
            result.shipment_provider_name 'last_shipment_provider',
            so.order_nr,
            result.tracking_number 'last_tracking_number',
            soi.name 'item_name',
            sois.name 'last_status',
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.paid_price + soi.shipping_amount + soi.shipping_surcharge 'total',
            so.created_at 'order_date',
            MAX(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'last_shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.real_action_date, NULL)) 'real_delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, user.username, NULL)) 'delivered_status_creator',
            sup.name 'seller_name',
            soi.bob_id_sales_order_item,
            result.invoice_number
    FROM
        (SELECT 
        pck.id_package,
            pck.package_number,
            pck.invoice_number,
            pd.id_package_dispatching,
            pd.tracking_number,
            sp.shipment_provider_name
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6
    GROUP BY fk_package) result
    LEFT JOIN oms_live.oms_package pck ON result.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    HAVING shipment_provider_name IS NOT NULL) result
    LEFT JOIN oms_live.oms_package_item pi ON result.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5 , 27)
    LEFT JOIN oms_live.ims_user user ON soish.fk_user = user.id_user
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        so.payment_method = 'CashOnDelivery'
            AND sup.type = @sellertype
    GROUP BY soi.id_sales_order_item
    HAVING delivered_date >= @extractstart
        AND delivered_date < @extractend) result
GROUP BY id_package