SET @extractstart = '2017-11-01';
SET @extractend = '2017-12-01';

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
        delivered_month,
            delivered_month_text,
            SUM(IF(tr.transaction_type IN ('Commission Credit' , 'Reversal Commission'), value, 0)) / 1.1 'commission_credit',
            - SUM(IF(tr.transaction_type IN ('Commission Credit' , 'Reversal Commission'), value, 0)) 'amount_paid_to_seller',
            - SUM(IF(tr.transaction_type IN ('Commission Credit' , 'Reversal Commission'), value, 0)) / 1.1 'amount_subjected_to_tax',
            - SUM(IF(tr.transaction_type IN ('Commission Credit' , 'Reversal Commission'), value, 0)) + SUM(IF(tr.transaction_type IN ('Commission Credit' , 'Reversal Commission'), value, 0)) / 1.1 'tax_amount',
            IFNULL(tr.bob_id_supplier, '') 'bob_id_supplier'
    FROM
        (SELECT 
        *,
            DATE_FORMAT(delivered_date, '%Y-%m') 'delivered_month',
            DATE_FORMAT(delivered_date, '%M %Y') 'delivered_month_text'
    FROM
        tias_java.transaction
    WHERE
        delivered_date < @extractstart) tr
    GROUP BY bob_id_supplier , delivered_month
    HAVING bob_id_supplier IS NOT NULL) result
    LEFT JOIN tias_java.seller_details sd ON result.bob_id_supplier = sd.bob_id_supplier
    LEFT JOIN tias_java.seller_details_manual sdm ON result.bob_id_supplier = sdm.bob_id_supplier) result