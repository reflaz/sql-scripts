SELECT 
    sel.name 'seller_name',
    sel.name_company 'legal_name',
    CONCAT(MIN(ts.start_date), ' - ', MIN(ts.end_date)) 'first_period',
    CONCAT(MAX(ts.start_date), ' - ', MAX(ts.end_date)) 'last_period',
    SUM(ts.payout) total_payout
FROM
    screport.transaction_statement ts
        LEFT JOIN
    screport.seller sel ON ts.fk_seller = sel.id_seller
WHERE
    start_date >= '2014-12-29'
        AND start_date <= '2015-12-14'
GROUP BY fk_seller
HAVING total_payout >= 6907315000