/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Fee Upload
 
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
SET @extractstart = '2016-03-16';
SET @extractend = '2016-03-18'; -- this must be the day after the expected end date/h+1

SELECT 
    sc_so.order_nr 'order_nr',
    sc_soi.id_sales_order_item 'sc_soi',
    sc_tr.value 'shipping_fee',
    sc_tr.created_at 'created_date',
    sc_sel.name 'seller_name',
    sc_soi.tracking_code 'awb',
    sc_sp.name 'shipping_provider',
    sc_tr.description 'description'
FROM
    asc_live.transaction sc_tr
        LEFT JOIN
    asc_live.sales_order_item sc_soi ON sc_tr.ref = sc_soi.id_sales_order_item
        LEFT JOIN
    asc_live.sales_order sc_so ON sc_soi.fk_sales_order = sc_so.id_sales_order
        LEFT JOIN
    asc_live.shipment_provider sc_sp ON sc_soi.fk_shipment_provider = sc_sp.id_shipment_provider
        LEFT JOIN
    asc_live.seller sc_sel ON sc_soi.fk_seller = sc_sel.id_seller
WHERE
    sc_tr.created_at >= @extractstart
        AND sc_tr.created_at < @extractend
        AND sc_tr.fk_transaction_type = 7