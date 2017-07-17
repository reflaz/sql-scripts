
/*
Change @default_period accordingly
- '"1"' for 'Weekly'
- '"2"' for 'Monthly'
- '"3"' for 'Twice a Month'
*/
SET @default_period = '"1"';

-- DO NOT CHANGE THIS EVER!!
SET @start_weekly = STR_TO_DATE(CONCAT(YEARWEEK(IF(DAYNAME(NOW()) = 'Sunday', DATE_SUB(NOW(), INTERVAL 1 DAY), NOW())), ' Monday'), '%X%V %W');
SET @start_biweekly = IF(DAY(NOW()) < 16, CONCAT(DATE_FORMAT(NOW(), '%Y-%m'), '-01'), CONCAT(DATE_FORMAT(NOW(), '%Y-%m'), '-16'));
SET @end_weekly = DATE_ADD(@start_weekly, INTERVAL 7 DAY);
SET @end_biweekly = IF(DAY(NOW()) < 16, CONCAT(DATE_FORMAT(NOW(), '%Y-%m'), '-16'), CONCAT(DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 MONTH), '%Y-%m'), '-01'));

SELECT @start_weekly, @start_biweekly, @end_weekly, @end_biweekly;

SELECT 
    result.bob_id_seller,
    result.short_code,
    result.seller_name,
    result.account_statement_frequency,
    result.curr_timeframe,
    result.curr_balance,
    IF(IFNULL(ts.payout, 0) <= 0,
        curr_balance - (IFNULL(ts.guarantee_deposit, 0) - IFNULL(ts.closing_balance, 0)),
        curr_balance) 'payment_provider',
    ts.number 'last_payout_number',
    ts.start_date 'last_payout_start',
    ts.end_date 'last_payout_end',
    IFNULL(ts.payout, 0) 'last_payout',
    IF(ts.paid = 0, 'not paid', 'paid') 'last_payout_status',
    ts.guarantee_deposit
FROM
    (SELECT 
        sel.src_id 'bob_id_seller',
            sel.id_seller,
            sel.short_code,
            name 'seller_name',
            IF(sel.tax_class = 0, 'local', 'international') 'tax_class',
            CASE
                WHEN scon.value = '"1"' THEN 'Weekly'
                WHEN scon.value = '"2"' THEN 'Monthly'
                WHEN scon.value = '"3"' THEN 'Twice a Month'
                ELSE 'Default Setting'
            END 'account_statement_frequency',
            CONCAT(CASE
                WHEN scon.value = '"1"' THEN @start_weekly
                WHEN scon.value = '"3"' THEN @start_biweekly
                WHEN @default_period = '"1"' THEN @start_weekly
                WHEN @default_period = '"3"' THEN @start_biweekly
            END, ' - ', DATE_SUB(CASE
                WHEN scon.value = '"1"' THEN @end_weekly
                WHEN scon.value = '"3"' THEN @end_biweekly
                WHEN @default_period = '"1"' THEN @end_weekly
                WHEN @default_period = '"3"' THEN @end_biweekly
            END, INTERVAL - 1 DAY)) 'curr_timeframe',
            SUM(IFNULL(tr.value, 0)) 'curr_balance'
    FROM
        asc_live.seller sel
    LEFT JOIN asc_live.seller_config scon ON sel.id_seller = scon.fk_seller
        AND scon.field = 'account_statement_frequency'
    LEFT JOIN asc_live.transaction tr ON sel.id_seller = tr.fk_seller
        AND tr.created_at >= (CASE
        WHEN scon.value = '"1"' THEN @start_weekly
        WHEN scon.value = '"3"' THEN @start_biweekly
        WHEN @default_period = '"1"' THEN @start_weekly
        WHEN @default_period = '"3"' THEN @start_biweekly
    END)
        AND tr.created_at < NOW()
    GROUP BY sel.id_seller) result
        LEFT JOIN
    (SELECT 
        MAX(id_transaction_statement) 'id_transaction_statement',
            fk_seller
    FROM
        asc_live.transaction_statement
    WHERE
        end_date >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
            AND end_date < NOW()
    GROUP BY fk_seller) ts_max ON result.id_seller = ts_max.fk_seller
        LEFT JOIN
    asc_live.transaction_statement ts ON ts_max.id_transaction_statement = ts.id_transaction_statement;