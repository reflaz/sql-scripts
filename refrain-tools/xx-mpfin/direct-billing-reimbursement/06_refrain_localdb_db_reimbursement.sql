/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
API Statistics for Irregularities

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @api_date accordingly
				  - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @api_date = '20171030-20171105';

USE refrain;

SELECT 
    *,
    '' AS 'File Line Id',
    'Order_LazadaFees' AS 'Transaction Type Level 1-2',
    'Adjustments Shipping Fee' AS 'Transaction Type',
    short_code 'Seller ID or Name',
    sc_id_sales_order_item 'Order Item Id',
    oms_id_sales_order_item 'Lazada Item Id',
    (total_seller_charge + total_delivery_cost + total_failed_delivery_cost - auto_shipping_fee - manual_shipping_fee_lzd - manual_shipping_fee_3p - shipping_fee_adjustment) * - 1 'Amount',
    CONCAT_WS(';',
            'SFC',
            IFNULL(DATE(delivered_date), 'NULL'),
            order_nr,
            'Reimbursement Shipping Fee') 'Comment'
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
            SUM(IFNULL(fsoi.chargeable_weight_seller, 0)) 'chargeable_weight_seller',
            SUM(IFNULL(fsoi.seller_flat_charge, 0)) 'seller_flat_charge',
            SUM(IFNULL(fsoi.seller_charge, 0)) 'seller_charge',
            SUM(IFNULL(fsoi.insurance_seller, 0)) 'insurance_seller',
            SUM(IFNULL(fsoi.insurance_vat_seller, 0)) 'insurance_vat_seller',
            SUM(IFNULL(fsoi.total_seller_charge, 0)) 'total_seller_charge',
            SUM(IFNULL(fsoi.total_delivery_cost, 0)) 'total_delivery_cost',
            SUM(IFNULL(fsoi.total_failed_delivery_cost, 0)) 'total_failed_delivery_cost',
            adma.api_date,
            adma.package_number 'api_package_number',
            adma.short_code 'api_short_code',
            adma.delivery_amount 'api_delivery_amount',
            adma.delivery_discount 'api_delivery_discount',
            adma.delivery_tax_amount 'api_delivery_tax_amount',
            adma.delivery_total_amount 'api_delivery_total_amount',
            adma.delivery_status 'api_delivery_status'
    FROM
        (SELECT 
        api_date,
            id_package_dispatching,
            package_number,
            bob_id_supplier,
            short_code,
            SUM(IF(charge_type = 'DELIVERY', amount, 0)) 'delivery_amount',
            SUM(IF(charge_type = 'DELIVERY', discount, 0)) 'delivery_discount',
            SUM(IF(charge_type = 'DELIVERY', tax_amount, 0)) 'delivery_tax_amount',
            SUM(IF(charge_type = 'DELIVERY', total_amount, 0)) 'delivery_total_amount',
            MAX(IF(charge_type = 'DELIVERY', status, '')) 'delivery_status'
    FROM
        refrain.api_data_direct_billing
    WHERE
        api_date = @api_date
    GROUP BY package_number , short_code) adma
    LEFT JOIN fms_sales_order_item fsoi ON adma.package_number = fsoi.package_number
        AND adma.short_code = fsoi.short_code
    GROUP BY adma.package_number , adma.short_code) result;