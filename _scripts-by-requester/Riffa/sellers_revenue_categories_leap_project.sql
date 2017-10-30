SET @extractstart = '2017-04-01';
SET @extractend = '2017-05-01';

SET @exchange_rate = '13303.1';

SELECT 
    *
FROM
    (SELECT 
        revenue_bracket,
            SUM(IF(DATEDIFF(@extractend, created_at) <= 30, 1, 0)) '<1 Month',
            SUM(IF(DATEDIFF(@extractend, created_at) > 30
                AND DATEDIFF(@extractend, created_at) / 30 <= 6, 1, 0)) '1-6 Months',
            SUM(IF(DATEDIFF(@extractend, created_at) > 30
                AND DATEDIFF(@extractend, created_at) / 30 > 6, 1, 0)) '6 Months +'
    FROM
        (SELECT 
        *,
            CASE
                WHEN avg_revenue <= 100 THEN '<= $100/day, all Ops score'
                WHEN
                    avg_revenue <= 500
                        AND seller_score <= 3.5
                THEN
                    '<= $500/day, Ops score <= 3.5'
                WHEN
                    avg_revenue <= 500
                        AND seller_score > 3.5
                THEN
                    '<= $500/day, Ops score > 3.5'
                WHEN avg_revenue <= 1000 THEN '<= $1000/day, all Ops score'
                WHEN avg_revenue > 1000 THEN '> $1000/day, all Ops score'
            END 'revenue_bracket'
    FROM
        (SELECT 
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
    LEFT JOIN asc_live.seller_rating sr ON a.id = sr.id
    LEFT JOIN asc_live.seller sel ON sr.seller_id = sel.short_code
    LEFT JOIN asc_live.transaction tr ON sel.id_seller = tr.fk_seller
        AND tr.created_at >= @extractstart
        AND tr.created_at < @extractend
        AND tr.fk_transaction_type = 13
    WHERE
        sel.tax_class = 0
    GROUP BY sel.id_seller) result) result
    GROUP BY revenue_bracket) result