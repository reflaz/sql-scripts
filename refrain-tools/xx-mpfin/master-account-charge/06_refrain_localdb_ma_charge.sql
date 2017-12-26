/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Master Account Result

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-12-01';
SET @extractend = '2017-12-04';-- This MUST be D + 1

USE refrain_live;

SELECT 
    *
FROM
    (SELECT 
        fsoi.bob_id_sales_order_item,
            fsoi.sc_id_sales_order_item,
            fsoi.oms_id_sales_order_item,
            fsoi.order_nr,
            fsoi.payment_method,
            fsoi.sku,
            fsoi.bob_id_supplier,
            fsoi.short_code,
            fsoi.seller_name,
            fsoi.seller_type,
            fsoi.tax_class,
            fsoi.is_marketplace,
            SUM(IFNULL(fsoi.unit_price, 0)) 'unit_price',
            SUM(IFNULL(fsoi.paid_price, 0)) 'paid_price',
            SUM(IFNULL(fsoi.shipping_amount, 0)) 'shipping_amount',
            SUM(IFNULL(fsoi.shipping_surcharge, 0)) 'shipping_surcharge',
            SUM(IFNULL(fsoi.coupon_money_value, 0)) 'coupon_money_value',
            SUM(IFNULL(fsoi.cart_rule_discount, 0)) 'cart_rule_discount',
            fsoi.coupon_type,
            fsoi.last_status,
            fsoi.order_date,
            fsoi.finance_verified_date,
            fsoi.first_shipped_date,
            fsoi.last_shipped_date,
            fsoi.delivered_date,
            fsoi.failed_delivery_date,
            fsoi.origin,
            fsoi.id_district,
            fsoi.package_number,
            fsoi.first_shipment_provider,
            fsoi.last_shipment_provider,
            fsoi.shipping_type,
            fsoi.delivery_type,
            SUM(IFNULL(fsoi.auto_shipping_fee, 0)) 'auto_shipping_fee',
            SUM(IFNULL(fsoi.manual_shipping_fee_lzd, 0)) 'manual_shipping_fee_lzd',
            SUM(IFNULL(fsoi.manual_shipping_fee_3p, 0)) 'manual_shipping_fee_3p',
            SUM(IFNULL(fsoi.shipping_fee_adjustment, 0)) 'shipping_fee_adjustment',
            fsoi.api_type,
            fsoi.shipment_scheme,
            fsoi.campaign,
            SUM(IFNULL(fsoi.formula_weight_seller, 0)) 'formula_weight_seller',
            SUM(IFNULL(fsoi.chargeable_weight_3pl, 0)) 'api_weight',
            SUM(IFNULL(fsoi.chargeable_weight_seller, 0)) 'chargeable_weight_seller',
            SUM(IFNULL(fsoi.seller_flat_charge, 0)) 'seller_flat_charge',
            SUM(IFNULL(fsoi.seller_charge, 0)) 'seller_charge',
            SUM(IFNULL(fsoi.insurance_seller, 0)) 'insurance_seller',
            SUM(IFNULL(fsoi.insurance_vat_seller, 0)) 'insurance_vat_seller',
            SUM(IFNULL(fsoi.total_seller_charge, 0)) 'total_seller_charge',
            SUM(IFNULL(fsoi.total_delivery_cost, 0)) 'total_delivery_cost',
            SUM(IFNULL(fsoi.total_failed_delivery_cost, 0)) 'total_failed_delivery_cost',
            '' AS 'File Line Id',
            'Order_LazadaFees' AS 'Transaction Type Level 1-2 ',
            'Shipping Fee (Charged by Lazada)' AS 'Transaction Type',
            fsoi.short_code 'Seller ID or Name',
            fsoi.sc_id_sales_order_item 'Order Item Id',
            fsoi.oms_id_sales_order_item 'Lazada Item Id',
            SUM(IFNULL(fsoi.total_seller_charge, 0)) 'Amount',
            CONCAT_WS(' ', fsoi.shipment_scheme, fsoi.campaign, CASE
                WHEN fsoi.first_shipment_provider NOT LIKE '%LEX%' THEN 'NON-LEX'
            END) 'Comment'
    FROM
        fms_sales_order_item fsoi
    WHERE
        first_shipped_date >= @extractstart
            AND first_shipped_date < @extractend
            AND shipment_scheme IN ('EXPRESS FBL' , 'EXPRESS MASTER ACCOUNT', 'FBL', 'MASTER ACCOUNT')
            AND is_marketplace = 1
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching
    HAVING total_seller_charge > 0) result