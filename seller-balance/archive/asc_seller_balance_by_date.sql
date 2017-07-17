/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Seller Balance
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @curr_start and @curr_end for a specific weekly/monthly time frame before generating the report
				  - Please be mindful of the seller's account statement frequency when setting the timeframe parameters
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @curr_start = '2016-08-15';
SET @curr_end = '2016-08-22'; -- This MUST be H + 1

-- The rest of the parameters will be automatically set
SET @last_start = IF(DATEDIFF(@curr_end, @curr_start) = 7, DATE_SUB(@curr_start, INTERVAL 7 DAY), IF(DAY(@curr_start) = 1, CONCAT(DATE_FORMAT(DATE_SUB(@curr_start, INTERVAL 1 MONTH), '%Y-%m'), '-16'), CONCAT(DATE_FORMAT(@curr_start, '%Y-%m'), '-01')));
SET @freq = IF(DATEDIFF(@curr_end,@curr_start) = 7, 'Weekly', 'Twice a Month');

SELECT 
    src_id 'Seller ID',
    short_code 'SC Seller ID',
    name 'Seller Name',
    tax_class 'Tax Class',
    value 'Account Statement Frequency',
    curr_timeframe 'Current Timeframe',
    curr_balance 'Current Balance',
    payment_provider 'Payment Provider',
    prev_timeframe 'Previous Timeframe',
    prev_payout 'Previous Payout'
FROM
    (SELECT 
        sel.src_id,
            sel.short_code,
            sel.name,
            sel.tax_class,
            CASE
                WHEN scon.value = '"1"' THEN 'Weekly'
                WHEN scon.value = '"2"' THEN 'Monthly'
                WHEN scon.value = '"3"' THEN 'Twice a Month'
                ELSE 'Twice a Month'
            END 'value',
            CONCAT(STR_TO_DATE(@curr_start, '%Y-%m-%d'), ' - ', STR_TO_DATE(DATE_ADD(@curr_end, INTERVAL - 1 DAY), '%Y-%m-%d')) 'curr_timeframe',
            SUM(IFNULL(tr.value, 0)) 'curr_balance',
            IF(IFNULL(ts.payout, 0) <= 0, SUM(IFNULL(tr.value, 0)) - (IFNULL(ts.guarantee_deposit, 0) - IFNULL(ts.closing_balance, 0)), SUM(IFNULL(tr.value, 0))) 'payment_provider',
            CONCAT(STR_TO_DATE(@last_start, '%Y-%m-%d'), ' - ', STR_TO_DATE(DATE_ADD(@curr_start, INTERVAL - 1 DAY), '%Y-%m-%d')) 'prev_timeframe',
            ts.payout 'prev_payout'
    FROM
        asc_live.transaction tr
    LEFT JOIN (SELECT 
        *
    FROM
        asc_live.transaction_statement ts
    WHERE
        ts.start_date >= STR_TO_DATE(@last_start, '%Y-%m-%d')
            AND ts.end_date < STR_TO_DATE(@curr_start, '%Y-%m-%d')
    GROUP BY ts.fk_seller) ts ON tr.fk_seller = ts.fk_seller
    LEFT JOIN asc_live.seller sel ON tr.fk_seller = sel.id_seller
    LEFT JOIN asc_live.seller_config scon ON sel.id_seller = scon.fk_seller
        AND scon.field = 'account_statement_frequency'
    WHERE
        tr.created_at >= STR_TO_DATE(@curr_start, '%Y-%m-%d')
            AND tr.created_at < STR_TO_DATE(@curr_end, '%Y-%m-%d')
    GROUP BY sel.id_seller
    HAVING value = @freq) result