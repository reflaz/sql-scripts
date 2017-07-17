SET @extractstart = '2015-10-27';
SET @extractend = '2016-07-25';
SET @sku = 'IN848ELBCH8QANID-1243298,IN848ELBERX1ANID-1359166,IN848ELCHKE0ANID-2982992,IN848ELCHKF3ANID-2983031,ME826ELAA3CO1FANID-6389457';

SELECT 
    sku 'SKU',
    CASE
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2015-11-27'
		WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2015-11-27'
		WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2015-11-27'
		WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2015-11-27'
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2015-10-27'
    END 'Start Date',
    CASE
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-02-12'
		WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-02-12'
		WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-02-12'
		WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-02-12'
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-02-12'
    END 'End Date',
    COUNT(CASE
        WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2015-10-27' AND created_at <= '2016-02-12' THEN sku

        ELSE NULL
    END) 'Count of Item Ordered',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2015-10-27' AND created_at <= '2016-02-12' THEN cart_rule_discount

        ELSE 0
    END) 'Cart Rule',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2015-10-27' AND created_at <= '2016-02-12' THEN coupon_money_value

        ELSE 0
    END) 'Marketing Voucher (Coupon)',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2015-10-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)

        ELSE 0
    END) 'NMV',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2015-11-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2015-10-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee

        ELSE 0
    END) 'Commission',
    CASE
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-02-13'
		WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-02-13'
		WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-02-13'
		WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-02-13'
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-02-13'

    END 'Start Date',
    CASE
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-04-30'
		WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-04-30'
		WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-04-30'
		WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-04-30'
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-05-31'

    END 'End Date',
    COUNT(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-02-13' AND created_at <= '2016-05-31' THEN sku

        ELSE NULL
    END) 'Count of Item Ordered',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-02-13' AND created_at <= '2016-05-31' THEN cart_rule_discount

        ELSE 0
    END) 'Cart Rule',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-02-13' AND created_at <= '2016-05-31' THEN coupon_money_value

        ELSE 0
    END) 'Marketing Voucher (Coupon)',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-02-13' AND created_at <= '2016-05-31' THEN (paid_price + shipping_surcharge)

        ELSE 0
    END) 'NMV',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-02-13' AND created_at <= '2016-05-31' THEN marketplace_commission_fee

        ELSE 0
    END) 'Commission',
    CASE
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-05-01'
		WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-05-01'
		WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-05-01'
		WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-05-01'
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-06-01'

    END 'Start Date',
    CASE
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-07-17'
		WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-07-17'
		WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-07-17'
		WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-07-17'
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-07-25'

    END 'End Date',
    COUNT(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN sku
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN sku
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN sku
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN sku
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-07-25' THEN sku

        ELSE NULL
    END) 'Count of Item Ordered',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN cart_rule_discount
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN cart_rule_discount
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-07-25' THEN cart_rule_discount

        ELSE 0
    END) 'Cart Rule',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN coupon_money_value
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN coupon_money_value
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-07-25' THEN coupon_money_value

        ELSE 0
    END) 'Marketing Voucher (Coupon)',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-07-25' THEN (paid_price + shipping_surcharge)

        ELSE 0
    END) 'NMV',
    SUM(CASE
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-07-17' THEN marketplace_commission_fee
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-07-25' THEN marketplace_commission_fee

        ELSE 0
    END) 'Commission'
FROM
    (SELECT 
        soi.sku,
            soi.created_at,
            soish.created_at 'shipped_at',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            soi.marketplace_commission_fee
    FROM
        oms_live.ims_sales_order_item soi
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 5)
    WHERE
        soi.created_at >= @extractstart
            AND soi.created_at < @extractend
            AND FIND_IN_SET(soi.sku, @sku)) result
GROUP BY sku