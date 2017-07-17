/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Seller Payout
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractend for a specific weekly/monthly time frame before generating the report
				  - Change @last_statement_status accordingly
				  - Please be mindful of the seller's account statement frequency
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractend = '2016-12-26'; -- This MUST be D + 1

-- This should be filled with: 'all', 'paid', or 'not paid'
SET @last_statement_status = 'paid';

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
    last_statement_number,
    last_statement_period,
    last_statement_status,
    last_closing_balance,
    last_guarantee_deposit,
    last_payout
FROM
    (SELECT 
        result.*,
            ts.number 'last_statement_number',
            CONCAT(STR_TO_DATE(ts.start_date, '%Y-%m-%d'), ' - ', STR_TO_DATE(ts.end_date, '%Y-%m-%d')) 'last_statement_period',
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
            IF(sel.tax_class = 0, 'local', 'international') 'tax_class',
            IFNULL(REPLACE(REPLACE(asf.value, '"', ''), '\'', ''), REPLACE(REPLACE(asf0.value, '"', ''), '\'', '')) 'account_statement_frequency',
            CASE
                WHEN sel.tax_class = 0 THEN IFNULL(REPLACE(REPLACE(gd.value, '"', ''), '\'', ''), REPLACE(REPLACE(gd0.value, '"', ''), '\'', ''))
                WHEN sel.tax_class = 1 THEN 0
            END 'expected_guarantee_deposit'
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
            end_date >= DATE_SUB(@extractend, INTERVAL 1 MONTH)
                AND end_date < @extractend
                AND fk_seller = result.id_seller
                AND paid = (CASE
                WHEN @last_statement_status = 'all' THEN paid
                WHEN @last_statement_status = 'paid' THEN 1
                WHEN @last_statement_status = 'not paid' THEN 0
            END))
    HAVING last_statement_number IS NOT NULL) result1