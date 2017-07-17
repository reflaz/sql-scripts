/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SC Payout Report
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Change @curr_start and @curr_end for a specific weekly/monthly time frame before generating the report
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @curr_start = '2016-04-04';
SET @curr_end = '2016-04-05';
SET @last_start = DATE_ADD(@curr_start, INTERVAL (-(DAYOFWEEK(@curr_start) - 2) - 7) DAY);
SET @last_end = DATE_ADD(@last_start, INTERVAL 7 DAY);

SELECT 
    sel.id_seller,
    sel.short_code 'seller_id',
    sel.name 'supplier',
    SUM(IFNULL(tr.value, 0)) 'payout_curr_timeframe',
    CONCAT(STR_TO_DATE(@curr_start, '%Y-%m-%d'),
            ' - ',
            STR_TO_DATE(DATE_ADD(@curr_end, INTERVAL - 1 DAY),
                    '%Y-%m-%d')) 'curr_timeframe',
    IF(IFNULL(ts.payout, 0) <= 0,
        SUM(IFNULL(tr.value, 0)) - (IFNULL(ts.guarantee_deposit, 0) - IFNULL(ts.closing_balance, 0)),
        SUM(IFNULL(tr.value, 0))) 'payment_providers',
    CONCAT(STR_TO_DATE(@last_start, '%Y-%m-%d'),
            ' - ',
            STR_TO_DATE(DATE_ADD(@last_end, INTERVAL - 1 DAY),
                    '%Y-%m-%d')) 'prev_timeframe',
    ts.payout 'payout_prev_timeframe'
FROM
    screport.transaction tr
        LEFT JOIN
    (SELECT 
        *
    FROM
        screport.transaction_statement ts
    WHERE
        ts.start_date >= STR_TO_DATE(@last_start, '%Y-%m-%d')
            AND ts.end_date < STR_TO_DATE(@last_end, '%Y-%m-%d')
    GROUP BY ts.fk_seller) ts ON tr.fk_seller = ts.fk_seller
        LEFT JOIN
    screport.seller sel ON tr.fk_seller = sel.id_seller
WHERE
    tr.created_at >= STR_TO_DATE(@curr_start, '%Y-%m-%d')
        AND tr.created_at < STR_TO_DATE(@curr_end, '%Y-%m-%d')
GROUP BY sel.id_seller