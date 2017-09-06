SET @extractstart = '2017-08-01';
SET @extractend = '2017-09-01';

SELECT 
    *
FROM
    (SELECT 
        IFNULL(sd.legal_name, IFNULL(sdm.legal_name, '')) 'legal_name',
            IFNULL(sd.seller_name, IFNULL(sdm.seller_name, '')) 'seller_name',
            IFNULL(IF(TRIM(sd.vat_number) = 'null'
                OR TRIM(sd.vat_number) = '', '00.000.000.0-000.000', TRIM(sd.vat_number)), IFNULL(sdm.vat_number, '00.000.000.0-000.000')) 'vat_number',
            IFNULL(sd.address, IFNULL(sdm.address, '')) 'address',
            IFNULL(sd.email, IFNULL(sdm.email, '')) 'email',
            result.*
    FROM
        (SELECT 
        SUM(IF(tr.transaction_type IN ('Payment Fee'), value, 0)) / 1.1 'payment_fee',
            SUM(IF(tr.transaction_type IN ('Commission Credit' , 'Reversal Commission'), value, 0)) / 1.1 'commission_credit',
            SUM(IF(tr.transaction_type IN ('Commission'), value, 0)) / 1.1 'commission',
            SUM(IF(tr.transaction_type IN ('Seller Credit'), value, 0)) / 1.1 'seller_credit',
            SUM(IF(tr.transaction_type IN ('Seller Credit Item'), value, 0)) / 1.1 'seller_credit_item',
            SUM(IF(tr.transaction_type IN ('Seller Debit Item' , 'Other Debit - Non Taxable', 'Other Debits (Returns)'), value, 0)) / 1.1 'seller_debit_item',
            SUM(IF(tr.transaction_type IN ('Other Fee' , 'Sponsored Product Fee'), value, 0)) / 1.1 'other_fee',
            - SUM(tr.value) 'amount_paid_to_seller',
            - SUM(tr.value) / 1.1 'amount_subjected_to_tax',
            - SUM(tr.value) + (SUM(value) / 1.1) 'tax_amount',
            IFNULL(tr.bob_id_supplier, '') 'bob_id_supplier'
    FROM
        (SELECT 
        *,
            CASE
                WHEN
                    transaction_type IN ('Commission Credit' , 'Reversal Commission')
                        AND delivered_date < @extractstart
                THEN
                    0
                WHEN
                    transaction_type IN ('Commission Credit' , 'Reversal Commission')
                        AND delivered_date IS NULL
                THEN
                    0
                ELSE 1
            END 'pass'
    FROM
        tias_java.transaction
    HAVING pass = 1) tr
    GROUP BY bob_id_supplier
    HAVING bob_id_supplier IS NOT NULL) result
    LEFT JOIN tias_java.seller_details sd ON result.bob_id_supplier = sd.bob_id_supplier
    LEFT JOIN tias_java.seller_details_manual sdm ON result.bob_id_supplier = sdm.bob_id_supplier) result