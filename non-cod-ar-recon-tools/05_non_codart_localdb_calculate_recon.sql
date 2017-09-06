/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Recon COD AR List
 
Prepared by		: Michael Julius
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    IF((order_nr = incoming_order_nr
            AND ABS(total_paid_by_customer - gross_amount) <= 10000),
        'RECON',
        'NOT RECON') 'recon_status',
    pop.*,
    inc.*,
    IF(order_nr = incoming_order_nr,
        'RECON',
        'NOT RECON') AS order_nr_remarks,
    IF(ABS(total_paid_by_customer - gross_amount) > 10000,
        'NOT RECON',
        'RECON') AS paid_by_customer_remarks
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
        LEFT JOIN
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
    ABS(total_paid_by_customer - gross_amount) <= 10000
        OR order_nr IS NULL;
        
truncate table non_cod_recon.recon_table;

insert into non_cod_recon.recon_table
SELECT
    *
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
        LEFT JOIN
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
    ABS(total_paid_by_customer - gross_amount) <= 10000
        OR order_nr IS NULL;