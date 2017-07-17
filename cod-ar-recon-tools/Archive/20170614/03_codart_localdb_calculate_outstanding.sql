/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Outstanding COD AR List
 
Prepared by		: Michael Julius
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
	pop.* 
FROM 
	cod_ar_recon.ar_population pop
LEFT JOIN 
	cod_ar_recon.incoming_ar inc ON pop.bob_id_sales_order_item = inc.bob_id_sales_order_item
where inc.bob_id_sales_order_item is null limit 1000000;

SELECT 
	pop.* 
FROM 
	cod_ar_recon.ar_population pop
LEFT JOIN 
	cod_ar_recon.incoming_ar inc ON pop.bob_id_sales_order_item = inc.bob_id_sales_order_item
where inc.bob_id_sales_order_item is null limit 1000000,1000000;
