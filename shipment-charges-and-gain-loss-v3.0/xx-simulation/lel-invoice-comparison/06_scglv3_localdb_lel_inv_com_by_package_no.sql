/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Lel Invoice Weight and Charge Comparison

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Pull data from ANON DB using LEL package number
				  - Import LEL and ANON DB data
                  - Run step 4 & 5
				  - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3_qv;

SELECT 
    package_number,
    order_nr,
    bob_id_sales_order_item,
    short_code,
    seller_name,
    seller_type,
    tax_class,
    SUM(unit_price) 'unit_price',
    SUM(paid_price) 'paid_price',
    SUM(shipping_amount) 'shipping_amount',
    SUM(shipping_surcharge) 'shipping_surcharge',
    delivery_cost_rate,
    delivery_cost_discount_rate,
    invoice_weight,
    simple_config_weight,
    config_weight,
    invoice_delivery_charge,
    SUM(simple_config_delivery_cost) 'simple_config_delivery_cost',
    SUM(config_delivery_cost) 'config_delivery_cost'
FROM
    (SELECT 
        inv.tracking_number 'package_number',
            ac.order_nr,
            ac.bob_id_sales_order_item,
            ac.short_code,
            ac.seller_name,
            ac.seller_type,
            ac.tax_class,
            IFNULL(ac.unit_price, 0) 'unit_price',
            IFNULL(ac.paid_price, 0) 'paid_price',
            IFNULL(ac.shipping_amount, 0) 'shipping_amount',
            IFNULL(ac.shipping_surcharge, 0) 'shipping_surcharge',
            ac.delivery_cost_rate,
            ac.delivery_cost_discount_rate,
            inv.weight 'invoice_weight',
            ac.chargeable_weight_3pl_ps 'simple_config_weight',
            acc.chargeable_weight_3pl_ps 'config_weight',
            inv.delivery_charge 'invoice_delivery_charge',
            IFNULL(ac.delivery_cost_item, 0) + IFNULL(ac.delivery_cost_discount_item, 0) + IFNULL(ac.delivery_cost_vat_item, 0) 'simple_config_delivery_cost',
            IFNULL(acc.delivery_cost_item, 0) + IFNULL(acc.delivery_cost_discount_item, 0) + IFNULL(acc.delivery_cost_vat_item, 0) 'config_delivery_cost'
    FROM
        invoice inv
    LEFT JOIN anondb_calculate ac ON inv.tracking_number = ac.package_number
        AND inv.short_code = ac.short_code
    LEFT JOIN anondb_calculate_config acc ON ac.package_number = acc.package_number
        AND ac.short_code = acc.short_code
    GROUP BY bob_id_sales_order_item) result
GROUP BY package_number , short_code