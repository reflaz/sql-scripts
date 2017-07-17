/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Return To Seller - Write back by Date
 
Prepared by		: Michael Julius
Modified by		: MJ
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractstart for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/


-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-11-01';
SET @extractend = '2016-12-01'; -- This MUST be D + 1

-- 848.906 sec / 0.125 sec
-- 2893 rows

select
	*
from(
select
	ih.id_inventory_history,
	ih.id_inventory,
    ih.uid,
    ih.fk_inventory_status,
    wis.name as last_status,
    ih.history_created_at as last_created_date,
    pop.history_created_at as first_rts_date
from(
select
				id_inventory,
				uid,
                sku,
                fk_inventory_status,
                history_created_at,
                barcode,
                created_at ,
                updated_at,
				expiry_date,
                cost,
                changed_reason_status
			from
				oms_live.wms_inventory_history
			where
				history_created_at >= @extractstart
            AND history_created_at < @extractend
            and fk_inventory_status = 18
		) pop
        
     LEFT JOIN oms_live.wms_inventory_history ih on pop.id_inventory = ih.id_inventory
     and ih.id_inventory_history = (select max(id_inventory_history)
     from oms_live.wms_inventory_history
	 where uid = ih.uid)
     
	 LEFT JOIN oms_live.wms_inventory_status wis ON ih.fk_inventory_status = wis.id_inventory_status
     -- LID906ce2
     -- where ih.uid = 'LID102cfe'
	 group by ih.uid) fin
       
     where fk_inventory_status not in (18)  
	