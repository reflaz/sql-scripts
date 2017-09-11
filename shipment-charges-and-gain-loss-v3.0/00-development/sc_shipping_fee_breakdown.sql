SELECT 
    *
FROM
    (SELECT 
        MONTH(tr.created_at) 'transaction_month',
			tt.id_transaction_type,
            tt.description 'transaction_type',
            SUM(tr.value) 'total_value',
            tr.description,
            COUNT(tr.id_transaction) 'total_transaction',
            MIN(tr.created_at) 'min_created_at',
            CASE
                WHEN tr.fk_transaction_type = 7 AND tr.description LIKE '%shipping fee%' THEN 71
                WHEN tr.fk_transaction_type = 7 AND tr.description LIKE '%shipping charge master account%' THEN 72
                WHEN tr.fk_transaction_type = 8 THEN 8
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%Sensitive Shipping Fee%' THEN 201
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%debit correct%' THEN 202
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%overpaid%' THEN 203
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%shipping%' THEN 204
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%deduction%' THEN 205
                WHEN tr.fk_transaction_type = 36 AND tr.description LIKE '%Reimbursement Shipping Fee%' THEN 361
                WHEN tr.fk_transaction_type = 36 AND tr.description LIKE '%Adj Shipping Fee%' THEN 362
                WHEN tr.fk_transaction_type = 36 AND tr.description LIKE '%Add Manual%' THEN 363
                WHEN tr.fk_transaction_type = 36 AND tr.description LIKE '%Adjustment%' THEN 364
                WHEN tr.fk_transaction_type = 37 AND tr.description LIKE '%Reversal Adj Shipping Fee%' THEN 371
                WHEN tr.fk_transaction_type = 37 AND tr.description LIKE '%Adj Shipping Fee%' THEN 372
                WHEN tr.fk_transaction_type = 37 AND tr.description LIKE '%Deduction%Excess%' THEN 373
                WHEN tr.fk_transaction_type = 37 AND tr.description LIKE '%Customer flat%' THEN 374
                WHEN tr.fk_transaction_type = 37 AND tr.description LIKE '%Reimbursement%' THEN 375
                WHEN tr.fk_transaction_type = 37 AND tr.description LIKE '%Adjustment%' THEN 376
            END 'breakdown'
    FROM
        asc_live.transaction tr
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
    WHERE
        tr.created_at >= '2017-01-01'
            AND tr.created_at < '2017-09-01'
            AND (tr.description LIKE '%ship%'
            OR tr.description LIKE '%flat%')
    GROUP BY transaction_month, tr.fk_transaction_type , breakdown) result