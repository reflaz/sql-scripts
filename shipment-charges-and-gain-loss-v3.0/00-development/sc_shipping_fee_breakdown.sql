SELECT 
    tt.id_transaction_type,
    tt.description 'transaction_type',
    tr.value,
    tr.description,
    CASE
        WHEN
            fk_transaction_type = 7
                AND tr.description LIKE '%shipping fee%'
        THEN
            71
        WHEN
            fk_transaction_type = 7
                AND tr.description LIKE '%shipping charge master account%'
        THEN
            72
        WHEN
            fk_transaction_type = 20
                AND tr.description LIKE '%Sensitive Shipping Fee%'
        THEN
            201
        WHEN
            fk_transaction_type = 20
                AND tr.description LIKE '%debit correct%'
        THEN
            202
        WHEN
            fk_transaction_type = 20
                AND tr.description LIKE '%overpaid%'
        THEN
            202
        WHEN
            fk_transaction_type = 36
                AND tr.description LIKE '%Reimbursement Shipping Fee%'
        THEN
            361
        WHEN
            fk_transaction_type = 36
                AND tr.description LIKE '%Adj Shipping Fee%'
        THEN
            362
        WHEN
            fk_transaction_type = 36
                AND tr.description LIKE '%Add Manual%'
        THEN
            363
        WHEN
            fk_transaction_type = 37
                AND tr.description LIKE '%Reversal Adj Shipping Fee%'
        THEN
            371
        WHEN
            fk_transaction_type = 37
                AND tr.description LIKE '%Adj Shipping Fee%'
        THEN
            372
        WHEN
            fk_transaction_type = 37
                AND tr.description LIKE '%Deduction%Excess%'
        THEN
            373
        WHEN
            fk_transaction_type = 37
                AND tr.description LIKE '%Customer flat%'
        THEN
            374
        WHEN
            fk_transaction_type = 37
                AND tr.description LIKE '%Reimbursement%'
        THEN
            375
    END 'breakdown'
FROM
    asc_live.transaction tr
        LEFT JOIN
    asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
WHERE
    tr.created_at >= '2017-01-01'
        AND tr.created_at < '2017-08-01'
        AND ((tr.fk_transaction_type IN (7 , 20, 36, 37)
        AND (tr.description LIKE '%ship%'
        OR tr.description LIKE '%flat%'))
        OR tr.fk_transaction_type = 8)
GROUP BY tr.fk_transaction_type , breakdown