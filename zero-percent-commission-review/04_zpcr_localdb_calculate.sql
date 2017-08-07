/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Zero Percent Commission Reivew
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE zpcr;

SET @extractstart = '2017-05-01';

SELECT 
    oms.order_nr,
    oms.bob_id_sales_order_item,
    oms.sap_item_id,
    oms.sc_sales_order_item,
    oms.payment_method,
    oms.item_status,
    oms.order_date,
    oms.verified_date,
    oms.shipped_date,
    oms.delivered_date,
    oms.delivered_date_input,
    oms.returned_date,
    oms.replaced_date,
    oms.refunded_date,
    oms.unit_price,
    oms.paid_price,
    oms.shipping_amount,
    oms.shipping_surcharge,
    oms.coupon_money_value,
    oms.cart_rule_discount,
    oms.item_price_credit,
    oms.commission,
    IFNULL(oms.commission,
            IFNULL(gc.general_commission,
                    rc.general_commission) * unit_price / - 100) 'commission_should_be',
    oms.payment_fee,
    oms.shipping_fee_credit,
    oms.item_price,
    oms.commission_credit,
    oms.shipping_fee,
    oms.sku,
    gc.level1,
    gc.level2,
    gc.level3,
    gc.level4,
    oms.id_district,
    oms.shipment_provider,
    oms.seller_id,
    oms.sc_seller_id,
    oms.seller_name,
    oms.tax_class
FROM
    oms
        LEFT JOIN
    commission_tree_mapping gc ON oms.primary_category = gc.lookup_cat_id
        AND oms.tax_class = gc.tax_class
        LEFT JOIN
    commission_tree_mapping rc ON oms.tax_class = rc.tax_class
        AND rc.lookup_cat_id = 1
WHERE
    oms.delivered_date_input >= @extractstart