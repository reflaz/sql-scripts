/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Seller Charge Calculation
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
-- insurance 0.25% if package >= 1m
-- insurance flat at 2500 if package price < 1m
-- 10% VAT from insurance

SET @extractstart = '2016-04-04';
SET @extractend = '2016-04-07';

SELECT 
    sc_id_sales_order_item,
    order_nr,
    order_date,
    shipped_date,
    delivered_date,
    tracking_number,
    shipment_provider,
    sc_seller_id,
    seller_name,
    total_paid_price,
    insurance,
    vat,
    (insurance + vat) 'total_insurance_fee'
FROM
    (SELECT 
        *,
            SUM(paid_price) 'total_paid_price',
            ROUND(IF(SUM(paid_price) > 1000000, SUM(paid_price) * 0.0025, 2500), 2) 'insurance',
            ROUND(ROUND(IF(SUM(paid_price) > 1000000, SUM(paid_price) * 0.0025, 2500), 2) * 0.1, 2) 'vat'
    FROM
        (SELECT 
        soi.bob_id_sales_order_item 'bob_id_sales_order_item',
            scsoi.id_sales_order_item 'sc_id_sales_order_item',
            so.order_nr 'order_nr',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            soi.paid_price,
            soi.sku 'sku',
            pd.id_package_dispatching 'id_package_dispatching',
            pd.tracking_number 'tracking_number',
            sp.shipment_provider_name 'shipment_provider',
            sel.short_code 'sc_seller_id',
            sup.name 'seller_name'
    FROM
        (SELECT 
        *
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 4
    GROUP BY fk_package) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN screport.seller sel ON scsoi.fk_seller = sel.id_seller
    WHERE
        so.created_at >= '2016-04-04'
            AND sel.tax_class = 'local'
    GROUP BY soi.id_sales_order_item) result
    WHERE
        shipped_date >= @extractstart
            AND shipped_date < @extractend
            AND shipment_provider IN ('LEX FBL' , 'LEX MP', 'ESL MP', 'JNE FBL', 'JNE MP', 'JNE MP SUB', 'NCS MP', 'REPEX MP')
    GROUP BY result.id_package_dispatching) result