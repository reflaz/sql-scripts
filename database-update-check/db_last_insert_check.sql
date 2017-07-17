/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Database Update Check

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    'asc_live.transaction' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.transaction 
UNION ALL SELECT 
    'asc_live.transaction_statement' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.transaction_statement 
UNION ALL SELECT 
    'asc_live.sales_order_item' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.sales_order_item 
UNION ALL SELECT 
    'asc_live.sales_order' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.sales_order 
UNION ALL SELECT 
    'asc_live.seller_commission' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.seller_commission 
UNION ALL SELECT 
    'asc_live.transaction' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.transaction 
UNION ALL SELECT 
    'asc_live.transaction_statement' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.transaction_statement 
UNION ALL SELECT 
    'asc_live.sales_order_item' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.sales_order_item 
UNION ALL SELECT 
    'asc_live.sales_order' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.sales_order 
UNION ALL SELECT 
    'asc_live.seller_commission' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    asc_live.seller_commission 
UNION ALL SELECT 
    'oms_live.ims_sales_order_item' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    oms_live.ims_sales_order_item 
UNION ALL SELECT 
    'oms_live.ims_sales_order' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    oms_live.ims_sales_order 
UNION ALL SELECT 
    'oms_live.ims_sales_order_item_status_history' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    oms_live.ims_sales_order_item_status_history 
UNION ALL SELECT 
    'oms_live.oms_package_dispatching' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    oms_live.oms_package_dispatching 
UNION ALL SELECT 
    'bob_live.sales_order_item' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    bob_live.sales_order_item 
UNION ALL SELECT 
    'bob_live.sales_order' AS 'Table Name',
    MAX(created_at) 'Last Insert'
FROM
    bob_live.sales_order;