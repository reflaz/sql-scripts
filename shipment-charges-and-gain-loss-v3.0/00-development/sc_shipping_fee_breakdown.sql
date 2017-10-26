SELECT 
    *
FROM
    (SELECT 
        MONTH(tr.created_at) 'transaction_month',
			tt.id_transaction_type,
            tt.description 'transaction_type',
            tr.description,
            COUNT(tr.id_transaction) 'total_transaction',
            SUM(IFNULL(tr.value, 0)) 'total_value',
            MIN(tr.created_at) 'min_created_at',
            CASE
                WHEN tr.fk_transaction_type = 7 AND tr.description LIKE '%shipping fee%' THEN 71
                WHEN tr.fk_transaction_type = 7 AND tr.description LIKE '%shipping charge master account%' THEN 72
                WHEN tr.fk_transaction_type = 7 AND tr.description LIKE '%shippingfee%' THEN 73
                WHEN tr.fk_transaction_type = 7 AND tr.description LIKE '%shipping charges master account%' THEN 74
                WHEN tr.fk_transaction_type = 8 THEN 8
                WHEN tr.fk_transaction_type = 19 AND tr.description LIKE '%Sensitive Shipping Fee%' THEN 191
                WHEN tr.fk_transaction_type = 19 AND tr.description LIKE '%Adj Shipping Fee%' THEN 192
                WHEN tr.fk_transaction_type = 19 AND tr.description LIKE '%reimbursement%' THEN 193
                WHEN tr.fk_transaction_type = 19 AND tr.description LIKE '%credit%' THEN 194
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%Sensitive Shipping Fee%' THEN 201
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%debit correct%' THEN 202
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%overpaid%' THEN 203
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%shipping%' THEN 204
                WHEN tr.fk_transaction_type = 20 AND tr.description LIKE '%deduction%' THEN 205
                WHEN tr.fk_transaction_type = 21 AND tr.description LIKE '%shipping fee%' THEN 211
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
                WHEN tr.fk_transaction_type = 64 AND tr.description LIKE '%reimbursement%' THEN 641
                WHEN tr.fk_transaction_type = 76 AND tr.description LIKE '%flat%' THEN 761
                WHEN tr.fk_transaction_type = 104 AND tr.description LIKE '%Reimbursement%' THEN 1041
                WHEN tr.fk_transaction_type = 115 AND tr.description LIKE '%Reimbursement%' THEN 1151
                WHEN tr.fk_transaction_type = 115 AND tr.description LIKE '%Adj shipping fee%' THEN 1152
                WHEN tr.fk_transaction_type = 138 AND tr.description LIKE '%reimbursement%' THEN 1381
                WHEN tr.fk_transaction_type = 140 AND tr.description LIKE '%Reimbursement%' THEN 140
                WHEN tr.fk_transaction_type = 140 AND tr.description LIKE '%Adj shipping fee%' THEN 1401
                WHEN tr.fk_transaction_type = 141 AND tr.description LIKE '%Adj Shipping Fee%' THEN 1411
                WHEN tr.fk_transaction_type = 141 AND tr.description LIKE '%reimburse%' THEN 1412
                WHEN tr.fk_transaction_type = 141 AND tr.description LIKE '%master account reimburse%' THEN 1413
                WHEN tr.fk_transaction_type = 141 AND tr.description LIKE '%credit%' THEN 1414
                WHEN tr.fk_transaction_type = 144 AND tr.description LIKE '%flat fee%' THEN 1441
                WHEN tr.fk_transaction_type = 144 AND tr.description LIKE '%deduction excess%' THEN 1442
                WHEN tr.fk_transaction_type = 145 AND tr.description LIKE '%flat fee%' THEN 1451
                WHEN tr.fk_transaction_type = 145 AND tr.description LIKE '%adj shipping fee%' THEN 1452
                WHEN tr.fk_transaction_type = 145 AND tr.description LIKE '%deduction excess%' THEN 1453
            END 'breakdown'
    FROM
        asc_live.transaction tr
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
    WHERE
        tr.created_at >= '2017-01-01'
            AND tr.created_at < '2017-11-01'
            AND (tr.description LIKE '%ship%'
            OR tr.description LIKE '%flat%')
    GROUP BY transaction_month, tr.fk_transaction_type , breakdown) result