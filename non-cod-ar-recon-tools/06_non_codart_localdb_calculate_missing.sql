/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Missing COD AR List
 
Prepared by		: Michael Julius
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    *,
    gross_amount-total_paid_by_customer 'missing_amount'
FROM
    (SELECT 
        order_nr,
            payment_method,
            item_name,
            sku,
            bob_id_supplier,
            short_code,
            seller_name,
            seller_type,
            tax_class,
            unit_price,
            paid_price,
            shipping_amount,
            shipping_surcharge,
            SUM(total_paid_by_customer) 'total_paid_by_customer',
            last_status,
            order_date,
            ovip_date,
            ovip_by,
            delivery_updater,
            package_number
    FROM
        non_cod_recon.ar_population pop
    GROUP BY order_nr) pop
        RIGHT JOIN
    (SELECT 
        merchant_wallet_id,
            report_date,
            transaction_id,
            incoming_order_nr,
            batch_id,
            event,
            event_status,
            reference_id,
            initiation_date,
            completion_date,
            currency,
            SUM(gross_amount) 'gross_amount'
    FROM
        non_cod_recon.incoming_ar
    WHERE
        event_status NOT IN ('Cancelled')
            OR event NOT IN ('Refund')
    GROUP BY incoming_order_nr) inc ON pop.order_nr = inc.incoming_order_nr
WHERE
    abs(total_paid_by_customer - gross_amount) > 10000
        or order_nr IS NULL;

truncate table non_cod_recon.ar_missing;

insert into non_cod_recon.ar_missing
SELECT 
    inc.*
FROM
    (SELECT 
        order_nr,
            payment_method,
            item_name,
            sku,
            bob_id_supplier,
            short_code,
            seller_name,
            seller_type,
            tax_class,
            unit_price,
            paid_price,
            shipping_amount,
            shipping_surcharge,
            SUM(total_paid_by_customer) 'total_paid_by_customer',
            last_status,
            order_date,
            ovip_date,
            ovip_by,
            delivery_updater,
            package_number
    FROM
        non_cod_recon.ar_population pop
    GROUP BY order_nr) pop
        RIGHT JOIN
    (SELECT 
        merchant_wallet_id,
            report_date,
            transaction_id,
            incoming_order_nr,
            batch_id,
            event,
            event_status,
            reference_id,
            initiation_date,
            completion_date,
            currency,
            SUM(gross_amount) 'gross_amount'
    FROM
        non_cod_recon.incoming_ar
    WHERE
        event_status NOT IN ('Cancelled')
            OR event NOT IN ('Refund')
    GROUP BY incoming_order_nr) inc ON pop.order_nr = inc.incoming_order_nr
WHERE
    abs(total_paid_by_customer - gross_amount) > 10000
        or order_nr IS NULL;