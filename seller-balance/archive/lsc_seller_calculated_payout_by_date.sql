/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Seller Payout
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
				  - Please be mindful of the seller's account statement frequency
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-11-07';
SET @extractend = '2016-11-14';-- This MUST be D + 1

SELECT 
    bob_id_seller,
    short_code,
    seller_name,
    tax_class,
    CASE
        WHEN account_statement_frequency = 1 THEN 'Weekly'
        WHEN account_statement_frequency = 2 THEN 'Monthly'
        WHEN account_statement_frequency = 3 THEN 'Twice a month'
    END 'account_statement_frequency',
    expected_guarantee_deposit,
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
                WHEN tax_class = 1 THEN 0
                WHEN
                    CASE
                        WHEN calculated_opening_balance + calculated_sc_fees > expected_guarantee_deposit THEN expected_guarantee_deposit
                        ELSE calculated_opening_balance + calculated_sc_fees
                    END > 0
                THEN
                    CASE
                        WHEN calculated_opening_balance + calculated_sc_fees > expected_guarantee_deposit THEN expected_guarantee_deposit
                        ELSE calculated_opening_balance + calculated_sc_fees
                    END
                ELSE 0
            END 'calculated_guarantee_deposit',
            CASE
                WHEN
                    calculated_opening_balance + calculated_sc_fees - CASE
                        WHEN
                            CASE
                                WHEN calculated_opening_balance + calculated_sc_fees > expected_guarantee_deposit THEN expected_guarantee_deposit
                                ELSE calculated_opening_balance + calculated_sc_fees
                            END > 0
                        THEN
                            CASE
                                WHEN calculated_opening_balance + calculated_sc_fees > expected_guarantee_deposit THEN expected_guarantee_deposit
                                ELSE calculated_opening_balance + calculated_sc_fees
                            END
                        ELSE 0
                    END < 0
                THEN
                    0
                ELSE calculated_opening_balance + calculated_sc_fees - CASE
                    WHEN
                        CASE
                            WHEN calculated_opening_balance + calculated_sc_fees > expected_guarantee_deposit THEN expected_guarantee_deposit
                            ELSE calculated_opening_balance + calculated_sc_fees
                        END > 0
                    THEN
                        CASE
                            WHEN calculated_opening_balance + calculated_sc_fees > expected_guarantee_deposit THEN expected_guarantee_deposit
                            ELSE calculated_opening_balance + calculated_sc_fees
                        END
                    ELSE 0
                END
            END 'calculated_payout'
    FROM
        (SELECT 
        *,
            CONCAT(STR_TO_DATE(result1.start_date, '%Y-%m-%d'), ' - ', STR_TO_DATE(result1.end_date, '%Y-%m-%d')) 'last_statement_period',
            CONCAT(STR_TO_DATE(@extractstart, '%Y-%m-%d'), ' - ', STR_TO_DATE(DATE_SUB(@extractend, INTERVAL 1 DAY), '%Y-%m-%d')) 'calculated_statement_period',
            CASE
                WHEN result1.last_closing_balance < 0 THEN result1.last_closing_balance + result1.last_guarantee_deposit
                ELSE last_guarantee_deposit
            END 'calculated_opening_balance',
            tr.value 'calculated_sc_fees'
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
            CASE
                WHEN tax_class = 1 THEN 0
                WHEN
                    CASE
                        WHEN closing_balance > expected_guarantee_deposit THEN expected_guarantee_deposit
                        ELSE closing_balance
                    END > 0
                THEN
                    CASE
                        WHEN closing_balance > expected_guarantee_deposit THEN expected_guarantee_deposit
                        ELSE closing_balance
                    END
                ELSE 0
            END 'last_guarantee_deposit'
    FROM
        (SELECT 
        sel.src_id 'bob_id_seller',
            sel.id_seller,
            sel.short_code,
            name 'seller_name',
            tax_class,
            IFNULL(REPLACE(REPLACE(asf.value, '"', ''), '\'', ''), REPLACE(REPLACE(asf0.value, '"', ''), '\'', '')) 'account_statement_frequency',
            CASE
                WHEN sel.tax_class = 'local' THEN IFNULL(REPLACE(REPLACE(gd.value, '"', ''), '\'', ''), REPLACE(REPLACE(gd0.value, '"', ''), '\'', ''))
                WHEN sel.tax_class = 'international' THEN 0
            END 'expected_guarantee_deposit'
    FROM
        screport.seller sel
    LEFT JOIN screport.seller_config asf ON sel.id_seller = asf.fk_seller
        AND asf.field = 'account_statement_frequency'
    LEFT JOIN screport.seller_config gd ON sel.id_seller = gd.fk_seller
        AND gd.field = 'guarantee_deposit'
    LEFT JOIN screport.seller_config asf0 ON asf0.field = 'account_statement_frequency'
        AND asf0.fk_seller = 0
    LEFT JOIN screport.seller_config gd0 ON gd0.field = 'guarantee_deposit'
        AND gd0.fk_seller = 0) result
    LEFT JOIN screport.transaction_statement ts ON result.id_seller = ts.fk_seller
        AND ts.id_transaction_statement = (SELECT 
            MAX(id_transaction_statement)
        FROM
            screport.transaction_statement
        WHERE
            end_date >= DATE_SUB(@extractstart, INTERVAL 1 MONTH)
                AND end_date < @extractstart
                AND fk_seller = result.id_seller)) result1
    LEFT JOIN (SELECT 
        id_transaction, fk_seller, SUM(IFNULL(value, 0)) 'value'
    FROM
        screport.transaction
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
    GROUP BY fk_seller) tr ON tr.fk_seller = result1.id_seller
    WHERE
        tr.id_transaction IS NOT NULL
    GROUP BY id_seller) result2) final_result