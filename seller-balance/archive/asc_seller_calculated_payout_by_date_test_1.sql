/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Seller Payout
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractstart for a specific weekly/monthly time frame before generating the report
				  - Please be mindful of the seller's account statement frequency
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-12-05';
SET @extractend = '2016-12-12';-- This MUST be D + 1

SELECT 
    bob_id_seller,
    id_seller,
    short_code,
    seller_name,
    tax_class,
    account_statement_frequency,
    guarantee_deposit_config,
    calculated_statement_period,
    calculated_opening_balance,
    calculated_sc_fees,
    calculated_closing_balance,
    calculated_guarantee_deposit,
    calculated_payout,
    last_statement_number,
    last_statement_period,
    last_statement_status,
    last_closing_balance,
    last_guarantee_deposit,
    last_payout
FROM
    (SELECT 
        *,
            calculated_opening_balance + calculated_sc_fees 'calculated_closing_balance',
            CASE
                WHEN
                    CASE
                        WHEN calculated_opening_balance + calculated_sc_fees > guarantee_deposit_config THEN guarantee_deposit_config
                        ELSE calculated_opening_balance + calculated_sc_fees
                    END > 0
                THEN
                    CASE
                        WHEN calculated_opening_balance + calculated_sc_fees > guarantee_deposit_config THEN guarantee_deposit_config
                        ELSE calculated_opening_balance + calculated_sc_fees
                    END
                ELSE 0
            END 'calculated_guarantee_deposit',
            CASE
                WHEN
                    calculated_opening_balance + calculated_sc_fees - CASE
                        WHEN
                            CASE
                                WHEN calculated_opening_balance + calculated_sc_fees > guarantee_deposit_config THEN guarantee_deposit_config
                                ELSE calculated_opening_balance + calculated_sc_fees
                            END > 0
                        THEN
                            CASE
                                WHEN calculated_opening_balance + calculated_sc_fees > guarantee_deposit_config THEN guarantee_deposit_config
                                ELSE calculated_opening_balance + calculated_sc_fees
                            END
                        ELSE 0
                    END < 0
                THEN
                    0
                ELSE calculated_opening_balance + calculated_sc_fees - CASE
                    WHEN
                        CASE
                            WHEN calculated_opening_balance + calculated_sc_fees > guarantee_deposit_config THEN guarantee_deposit_config
                            ELSE calculated_opening_balance + calculated_sc_fees
                        END > 0
                    THEN
                        CASE
                            WHEN calculated_opening_balance + calculated_sc_fees > guarantee_deposit_config THEN guarantee_deposit_config
                            ELSE calculated_opening_balance + calculated_sc_fees
                        END
                    ELSE 0
                END
            END 'calculated_payout'
    FROM
        (SELECT 
        *,
            CONCAT(STR_TO_DATE(result1.start_date, '%Y-%m-%d'), ' - ', STR_TO_DATE(result1.end_date, '%Y-%m-%d')) 'last_statement_period',
            CONCAT(STR_TO_DATE(IFNULL(DATE_ADD(result1.end_date, INTERVAL 1 DAY), DATE_SUB(@extractstart, INTERVAL 1 DAY)), '%Y-%m-%d'), ' - ', STR_TO_DATE(@extractend, '%Y-%m-%d')) 'calculated_statement_period',
            IF(result1.last_guarantee_deposit > 0, result1.last_guarantee_deposit, result1.last_closing_balance) 'calculated_opening_balance',
            (SELECT 
                    SUM(IFNULL(value, 0))
                FROM
                    asc_live.transaction
                WHERE
                    created_at > result1.end_date
                        AND fk_seller = result1.id_seller) 'calculated_sc_fees'
    FROM
        (SELECT 
        result.*,
            ts.number 'last_statement_number',
            ts.start_date,
            ts.end_date,
            CASE
                WHEN ts.paid = 1 THEN 'paid'
                WHEN ts.paid = 0 THEN 'not paid'
            END 'last_statement_status',
            IFNULL(ts.closing_balance, 0) 'last_closing_balance',
            IFNULL(ts.payout, 0) 'last_payout',
            IFNULL(ts.guarantee_deposit, 0) 'last_guarantee_deposit'
    FROM
        (SELECT 
        sel.src_id 'bob_id_seller',
            sel.id_seller,
            sel.short_code,
            name 'seller_name',
            IF(sel.tax_class = 0, 'local', 'international') 'tax_class',
            IFNULL(REPLACE(REPLACE(asf.value, '"', ''), '\'', ''), REPLACE(REPLACE(asf0.value, '"', ''), '\'', '')) 'account_statement_frequency',
            IFNULL(REPLACE(REPLACE(gd.value, '"', ''), '\'', ''), REPLACE(REPLACE(gd0.value, '"', ''), '\'', '')) 'guarantee_deposit_config'
    FROM
        asc_live.seller sel
    LEFT JOIN asc_live.seller_config asf ON sel.id_seller = asf.fk_seller
        AND asf.field = 'account_statement_frequency'
    LEFT JOIN asc_live.seller_config gd ON sel.id_seller = gd.fk_seller
        AND gd.field = 'guarantee_deposit'
    LEFT JOIN asc_live.seller_config asf0 ON asf0.field = 'account_statement_frequency'
        AND asf0.fk_seller = 0
    LEFT JOIN asc_live.seller_config gd0 ON gd0.field = 'guarantee_deposit'
        AND gd0.fk_seller = 0) result
    LEFT JOIN asc_live.transaction_statement ts ON result.id_seller = ts.fk_seller
        AND ts.id_transaction_statement = (SELECT 
            MAX(id_transaction_statement)
        FROM
            asc_live.transaction_statement
        WHERE
            end_date >= DATE_SUB(@extractstart, INTERVAL 1 MONTH)
                AND end_date < @extractstart
                AND fk_seller = result.id_seller)) result1
    GROUP BY id_seller
    HAVING calculated_sc_fees IS NOT NULL) result2) final_result