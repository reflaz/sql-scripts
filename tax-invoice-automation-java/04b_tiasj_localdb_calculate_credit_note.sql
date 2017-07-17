SET @extractstart = '2016-10-01';
SET @extractend = '2016-11-01';

SELECT 
    *
FROM
    (SELECT 
        IFNULL(sd.legal_name, IFNULL(sdm.legal_name, '')) 'legal_name',
            IFNULL(sd.seller_name, IFNULL(sdm.seller_name, '')) 'seller_name',
            IFNULL(IF(TRIM(sd.vat_number) = 'null'
                OR TRIM(sd.vat_number) = '', '00.000.000.0-000.000', TRIM(sd.vat_number)), IFNULL(sdm.vat_number, '00.000.000.0-000.000')) 'vat_number1',
            IFNULL(sd.address, IFNULL(sdm.address, '')) 'address',
            IFNULL(sd.email, IFNULL(sdm.email, '')) 'email',
            result.*
    FROM
        (SELECT 
        SUM(IF(tr.transaction_type = 'Payment Fee', value, 0)) 'payment_fee',
            SUM(IF(tr.transaction_type = 'Commission Credit', value, 0)) 'commission_credit',
            SUM(IF(tr.transaction_type = 'Commission', value, 0)) 'commission',
            SUM(IF(tr.transaction_type = 'Seller Credit', value, 0)) 'seller_credit',
            SUM(IF(tr.transaction_type = 'Seller Credit Item', value, 0)) 'seller_credit_item',
            SUM(IF(tr.transaction_type = 'Seller Debit Item', value, 0)) 'seller_debit_item',
            SUM(IF(tr.transaction_type = 'Other Fee', value, 0)) 'other_fee',
            - SUM(tr.value) 'amount_paid_to_seller',
            - SUM(tr.value) / 1.1 'amount_subjected_to_tax',
            - SUM(tr.value) + (SUM(value) / 1.1) 'tax_amount',
            IFNULL(tr.bob_id_supplier, '') 'bob_id_supplier'
    FROM
        tias_java.transaction tr
    WHERE
        delivered_date < @extractstart
            AND delivered_date >= DATE_SUB(@extractstart, INTERVAL 3 MONTH)
    GROUP BY bob_id_supplier
    HAVING bob_id_supplier IS NOT NULL) result
    LEFT JOIN tias_java.seller_details sd ON result.bob_id_supplier = sd.bob_id_supplier
    LEFT JOIN tias_java.seller_details_manual sdm ON result.bob_id_supplier = sdm.bob_id_supplier) result