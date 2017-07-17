set @refund_start = '2016-10-01'; -- Start_Date
set @refund_end = '2016-11-01'; -- End_Date +1
 
-- Duration : 131.281 sec / 10.250 sec
-- 7540 row(s) returned
 
SELECT
	soi.created_at as soi_created_at,
    so.payment_method,
    soi.is_marketplace,
	CASE WHEN soi.fk_sales_order_item_status = 56 THEN 'refund_completed' else NULL end as history_status,    
    soish.created_at as created_date,
    soi.real_delivery_date,
    so.order_nr as order_number,
    soi.bob_id_sales_order_item,
    soi.id_sales_order_item,
    round(ifnull(soi.paid_price,0),0) as paid_price,
    round(ifnull(soi.tax_amount,0),0) as tax_amount,
    round(ifnull(soi.tax_percent,0),0) as tax_percent,
    round(ifnull(soi.shipping_amount,0),0) as shipping_amount,
    round(ifnull(soi.shipping_surcharge,0),0) as shipping_surcharge,
    round(ifnull(soi.paid_price,0),0) + round(ifnull(soi.shipping_amount,0),0) + round(ifnull(shipping_surcharge,0),0) as from_customer,
    case when so.fk_voucher_type = 1 then round(ifnull(soi.coupon_money_value,0),0) else 0 end as store_credit,
	case when so.fk_voucher_type = 3 then round(ifnull(soi.coupon_money_value,0),0) else 0 end as marketing_voucher,
    round(ifnull(soi.cart_rule_discount,0),0) as cart_rule_discount,
    round(ifnull(soi.paid_price,0),0) + round(ifnull(soi.shipping_amount,0),0) + round(ifnull(soi.shipping_surcharge,0),0) + round(ifnull(soi.coupon_money_value,0),0) + round(ifnull(soi.cart_rule_discount,0),0) as total,
    round(ifnull(soi.refunded_other,0),0) as refunded_other,
    round(ifnull(soi.refunded_shipping,0),0) as refunded_shipping,
    round(ifnull(soi.refunded_wallet_credit,0),0) as refunded_wallet_credit,
    MAX(IF(soi.fk_refund_sales_order_process = sop.id_sales_order_process, sop.name, NULL)) as refund_method,
    so.bob_id_customer,
    soi.sku,
    CASE WHEN 
		cat.bob_regional_key='' OR cat.bob_regional_key is null 
		THEN '99'
		ELSE cat.bob_regional_key
	END as bob_regional_key,
	soi.fk_marketplace_merchant
    
FROM
	oms_live.ims_sales_order_item soi
LEFT JOIN 
	oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
LEFT JOIN
	oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
LEFT JOIN
	oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
LEFT JOIN
	oms_live.ims_sales_order_process sop ON soi.fk_refund_sales_order_process = sop.id_sales_order_process
LEFT JOIN
	oms_live.ims_product pr ON soi.fk_product = pr.id_product
LEFT JOIN
	 oms_live.ims_catalog_category cat ON pr.fk_catalog_category = cat.id_catalog_category

WHERE
	soish.created_at >= @refund_start 
AND	
    soish.created_at < @refund_end 
AND 
	soish.fk_sales_order_item_status IN ('56')
GROUP BY
    soi.id_sales_order_item;
    