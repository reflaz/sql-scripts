/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Missing COD AR List
 
Prepared by		: Michael Julius
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    inc.*
FROM
    cod_ar_recon.incoming_ar inc
        RIGHT JOIN
    cod_ar_recon.ar_population pop ON inc.bob_id_sales_order_item = pop.bob_id_sales_order_item
WHERE
    pop.bob_id_sales_order_item IS NULL;