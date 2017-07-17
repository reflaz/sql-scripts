/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
EWI Report
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.4
Changes made	: - 1.4. Change layout
				  - 1.3. Took out SKU category, as it is not needed anymore, to speed up the script.
				  - 1.3. To cater weekly and bi-weekly statement. Also add other transactions in the result (other fee,
					seller credit item, seller debit item, seller credit). Implemented in second part of the script (UNION).

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-05-16';
SET @extractend = '2016-06-01';-- this must be the day after the expected end date/h+1

SELECT 
    *
FROM
    (SELECT 
        so.order_nr 'order_number',
            soi.bob_id_sales_order_item 'sales_order_item',
            soi.id_sales_order_item 'sap_item_id',
            scsoi.id_sales_order_item 'sc_sales_order_item',
            so.payment_method 'payment_method',
            sois.name 'item_status',
            so.created_at 'order_date',
            '' AS 'verified_date',
            '' AS 'shipped_date',
            '' AS 'delivered_date',
            '' AS 'delivered_date_input',
            '' AS 'returned_date',
            '' AS 'replaced_date',
            '' AS 'refunded_date',
            soi.unit_price,
            soi.paid_price,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            soi.shipping_amount,
            soi.shipping_surcharge,
            SUM(IF(tr.fk_transaction_type = 13, tr.value, 0)) 'item_price_credit',
            SUM(IF(tr.fk_transaction_type = 16, tr.value, 0)) 'commission',
            SUM(IF(tr.fk_transaction_type = 3, tr.value, 0)) 'payment_fee',
            SUM(IF(tr.fk_transaction_type = 8, tr.value, 0)) 'shipping_fee_credit',
            SUM(IF(tr.fk_transaction_type = 14, tr.value, 0)) 'item_price',
            SUM(IF(tr.fk_transaction_type = 15, tr.value, 0)) 'comission_credit',
            SUM(IF(tr.fk_transaction_type = 7, tr.value, 0)) 'shipping_fee',
            SUM(IF(tr.fk_transaction_type = 19, tr.value, 0)) 'seller_credit',
            SUM(IF(tr.fk_transaction_type = 36, tr.value, 0)) 'seller_credit_item',
            SUM(IF(tr.fk_transaction_type = 20, tr.value, 0)) 'other_fee',
            SUM(IF(tr.fk_transaction_type = 37, tr.value, 0)) 'seller_debit_item',
            SUM(tr.value) 'amount_paid_seller',
            tr.number 'transaction_id',
            tr.created_at 'transaction_date',
            ts.start_date 'statement_time_frame_start',
            ts.end_date 'statement_time_frame_end',
            tr.description AS 'sku',
            soa.fk_customer_address_region 'district_id',
            pd.tracking_number 'awb',
            sp.shipment_provider_name 'shipment_provider',
            sel.short_code,
            sel.name 'seller_name',
            sel.name_company 'legal_name',
            sel.tax_class
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package_dispatching pd ON pi.fk_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN asc_live.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN asc_live.transaction tr ON scsoi.id_sales_order_item = tr.ref
    LEFT JOIN asc_live.transaction_statement ts ON ts.id_transaction_statement = tr.fk_transaction_statement
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
    LEFT JOIN screport.seller sel ON tr.fk_seller = sel.id_seller
    WHERE
        so.order_nr IN ('')
            AND tr.value IS NOT NULL) result;