/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SC Transaction Details by Order Number
 
Prepared by		: Michael Julius
Modified by		: MJ
Version			: 1.0
Changes made	: 

Instructions	: - Just run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

select 
	sel.short_code 'sc_id_seller',
    sel.name 'seller_name',
    sel.name_company 'legal_name',
	oms.order_number,
    oms.bob_id_sales_order_item,
    oms.id_sales_order_item,
    oms.shipping_surcharge,
    oms.shipping_amount,
    SUM(IF(tr.fk_transaction_type = 13, tr.value, 0)) 'item_price_credit',
    SUM(IF(tr.fk_transaction_type = 16, tr.value, 0)) 'commission',
    SUM(IF(tr.fk_transaction_type = 3, tr.value, 0)) 'payment_fee',
    SUM(IF(tr.fk_transaction_type = 8, tr.value, 0)) 'shipping_fee_credit',
    SUM(IF(tr.fk_transaction_type = 14, tr.value, 0)) 'item_price',
    SUM(IF(tr.fk_transaction_type = 15, tr.value, 0)) 'comission_credit',
    SUM(IF(tr.fk_transaction_type = 7, tr.value, 0)) 'shipping_fee',
    SUM(IF(tr.fk_transaction_type = 19, tr.value, 0)) 'seller_credit',
    SUM(IF(tr.fk_transaction_type = 36, tr.value, 0)) 'seller_credit_item',
    SUM(IF(tr.fk_transaction_type = 20, tr.value, 0)) 'other_fee',
    SUM(IF(tr.fk_transaction_type = 37, tr.value, 0)) 'seller_debit_item',
            
    MIN(IF(tr.fk_transaction_type = 13, tr.created_at, NULL)) 'item_price_credit_date',
    MIN(IF(tr.fk_transaction_type = 16, tr.created_at, NULL)) 'commission_date',
    MIN(IF(tr.fk_transaction_type = 3, tr.created_at, NULL)) 'payment_fee_date',
    MIN(IF(tr.fk_transaction_type = 8, tr.created_at, NULL)) 'shipping_fee_credit_date',
    MIN(IF(tr.fk_transaction_type = 14, tr.created_at, NULL)) 'item_price_date',
    MIN(IF(tr.fk_transaction_type = 15, tr.created_at, NULL)) 'comission_credit_date',
    MIN(IF(tr.fk_transaction_type = 7, tr.created_at, NULL))'shipping_fee_date',
    MIN(IF(tr.fk_transaction_type = 19, tr.created_at, NULL)) 'seller_credit_date',
    MIN(IF(tr.fk_transaction_type = 36, tr.created_at, NULL)) 'seller_credit_item_date',
    MIN(IF(tr.fk_transaction_type = 20, tr.created_at, NULL)) 'other_fee_date',
    MIN(IF(tr.fk_transaction_type = 37, tr.created_at, NULL)) 'seller_debit_item_date',
    
    MIN(IF(tr.fk_transaction_type = 13, ts.number, NULL)) 'item_price_credit_number',
    MIN(IF(tr.fk_transaction_type = 16, ts.number, NULL)) 'commission_number',
    MIN(IF(tr.fk_transaction_type = 3, ts.number, NULL)) 'payment_fee_number',
    MIN(IF(tr.fk_transaction_type = 8, ts.number, NULL)) 'shipping_fee_credit_number',
    MIN(IF(tr.fk_transaction_type = 14, ts.number, NULL)) 'item_price_number',
    MIN(IF(tr.fk_transaction_type = 15, ts.number, NULL)) 'comission_credit_number',
    MIN(IF(tr.fk_transaction_type = 7, ts.number, NULL))'shipping_fee_number',
    MIN(IF(tr.fk_transaction_type = 19, ts.number, NULL)) 'seller_credit_number',
    MIN(IF(tr.fk_transaction_type = 36, ts.number, NULL)) 'seller_credit_item_number',
    MIN(IF(tr.fk_transaction_type = 20, ts.number, NULL)) 'other_fee_number',
    MIN(IF(tr.fk_transaction_type = 37, ts.number, NULL)) 'seller_debit_item_number'
from(
	select
		so.order_nr as order_number,
		soi.bob_id_sales_order_item as bob_id_sales_order_item ,
		soi.id_sales_order_item as id_sales_order_item,
		soi.shipping_surcharge as shipping_surcharge,
		soi.shipping_amount as  shipping_amount
	from
		oms_live.ims_sales_order_item soi
	left join
		oms_live.ims_sales_order so on soi.fk_sales_order = so.id_sales_order
	where
		so.order_nr in ()
	) oms

left join asc_live.sales_order_item scsoi ON oms.id_sales_order_item = scsoi.src_id
left join asc_live.transaction tr on tr.ref = scsoi.id_sales_order_item 
left join asc_live.transaction_statement ts on tr.fk_transaction_statement = ts.id_transaction_statement
left join asc_live.seller sel ON scsoi.fk_seller = sel.id_seller
   group by oms.bob_id_sales_order_item
  having sc_id_seller is not null 