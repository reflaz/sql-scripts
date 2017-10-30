SET @extractstart = '2017-04-01';
SET @extractend = '2017-05-01';

SET @exchange_rate = '13303.1';

SELECT 
    sr.seller_score,
    (SUM(IFNULL(tr.value, 0)) / @exchange_rate) / DATEDIFF(@extractend, @extractstart) 'avg_revenue',
    sr.seller_id,
    sel.id_seller,
    sel.short_code,
    sel.name,
    sel.created_at
FROM
    (SELECT 
        MAX(id) 'id'
    FROM
        asc_live.seller_rating
    WHERE
        end_date < @extractend
    GROUP BY seller_id) a
        LEFT JOIN
    asc_live.seller_rating sr ON a.id = sr.id
        LEFT JOIN
    asc_live.seller sel ON sr.seller_id = sel.short_code
        LEFT JOIN
    asc_live.transaction tr ON sel.id_seller = tr.fk_seller
        AND tr.created_at >= @extractstart
        AND tr.created_at < @extractend
        AND tr.fk_transaction_type = 13
WHERE
    sel.tax_class = 0
GROUP BY sel.id_seller