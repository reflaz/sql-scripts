/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Data Check

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE refrain;

SELECT 
    *
FROM
    api_data_direct_billing
WHERE
    status NOT IN ('ACTIVE' , 'COMPLETE');

SELECT 
    *
FROM
    api_data_master_account
WHERE
    status NOT IN ('ACTIVE' , 'COMPLETE');