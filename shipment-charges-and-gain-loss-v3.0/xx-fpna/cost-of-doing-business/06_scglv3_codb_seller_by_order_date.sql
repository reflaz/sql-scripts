/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Cost of Doing Business

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
SET @extractstart = '2017-07-01';
SET @extractend = '2017-07-17';-- This MUST be D + 1

-- Cross Border Rate
SET @cbrate = -2161.67824846249000;


SELECT 
    *
FROM
    (SELECT 
        ac.bob_id_supplier 'Seller ID',
            ac.short_code 'SC Seller ID',
            ac.seller_name 'Seller name',
            CASE
                WHEN ac.tax_class = 'local' THEN 'Local'
                WHEN ac.tax_class = 'international' THEN 'CB'
            END 'Local / CB',
            ac.origin,
            'Cluster (Category) - NULL',
            'Cat 1 (full seller allocation) - NULL',
            MAX(CASE
                WHEN ac.campaign LIKE '%VIP%' THEN 'VIP'
                ELSE ''
            END) 'Seller segment tag-simplified - NULL',
            'Seller ranking group',
            SUM(IFNULL(ac.unit_price, 0)) 'Revenue(based on unit price)',
            'Revenue (based on unit price)',
            COUNT(ac.bob_id_sales_order_item) 'Items sold',
            COUNT(DISTINCT ac.order_nr) 'Orders',
            SUM(IFNULL(ac.unit_price, 0)) / COUNT(ac.bob_id_sales_order_item) 'ASP (calculated: Unit price/items)',
            'ASP Group',
            SUM(IFNULL(ac.marketplace_commission_fee, 0)) 'Commission paid',
            SUM(IFNULL(ac.total_shipment_fee_mp_seller_item, 0)) 'Delivery charges paid - Total',
            SUM(IFNULL(ac.shipping_fee_credit, 0)) 'Shipping fee credit received',
            SUM(IFNULL(ac.seller_cr_db_item, 0)) 'Shipping Reimbursement Received',
            SUM(CASE
                WHEN ac.seller_type = 'supplier' THEN 0
                ELSE (CASE
                    WHEN ac.tax_class = 'local' THEN (0.013 * IFNULL(ac.unit_price, 0))
                    ELSE (0.020 * IFNULL(ac.unit_price, 0))
                END)
            END) 'Payment charges paid (After Tax)',
            'FBL charges paid - NULL',
            'Penalties / service fees - NULL',
            'Marketing service fees - NULL',
            SUM(ac.commission_waiver) 'Commission waivers - NULL',
            'Pricing subsidies - NULL',
            'Shipping Fee subsidies - MA NULL',
            'Shipping Fee subsidies - DB - NULL',
            SUM(CASE
                WHEN shipment_scheme LIKE '%CROSS BORDER%' THEN @cbrate
                ELSE IFNULL(shipping_amount_temp, 0) + IFNULL(shipping_surcharge_temp, 0) + IFNULL(total_shipment_fee_mp_seller_item, 0) - IFNULL(total_failed_delivery_cost_item, 0)
            END) 'Shipping Fee subsidies',
            SUM(IF(coupon_type = 'coupon', coupon_money_value, 0)) 'Voucher amount (paid by Lazada) (IDR)',
            'Seller\'s Take Home Pay - NULL',
            'Seller\'s Take Home Rate - NULL',
            'Voucher+Commission waiver + Subsidies (princing+shipping) ($) - NULL',
            'Commission waiver + Subsidies (princing+shipping) ($)',
            SUM(IFNULL(ac.paid_price / 1.1, 0) + IFNULL(ac.shipping_surcharge / 1.1, 0) + IFNULL(ac.shipping_amount / 1.1, 0) + IF(ac.coupon_type <> 'coupon', IFNULL(ac.coupon_money_value / 1.1, 0), 0)) 'NMV (IDR)',
            SUM(IFNULL(ac.pickup_cost_item, 0) + IFNULL(ac.pickup_cost_discount_item, 0) + IFNULL(ac.pickup_cost_vat_item, 0)) 'Shipping costs (Pickup Cost Only)',
            SUM(CASE
                WHEN ac.seller_type = 'supplier' THEN 0
                ELSE (CASE
                    WHEN ac.tax_class = 'local' THEN (0.013 * IFNULL(ac.unit_price, 0))
                    ELSE (0.020 * IFNULL(ac.unit_price, 0))
                END)
            END) / 1.1 'Payment Charges (before tax)',
            SUM(IFNULL(ac.marketplace_commission_fee / 1.1, 0)) 'Commission (before tax)',
            SUM(IFNULL(ac.order_flat_item, 0) + IFNULL(ac.mdr_item, 0) + IFNULL(ac.ipp_item, 0)) 'Payment costs',
            'Warehouse costs (in case of FBL) - NULL',
            'CS costs (allocated at seller level) - NULL',
            'PC1 (IDR) - NULL',
            'PC1 (%) - NULL',
            'PC2 (IDR) - NULL',
            'PC2 (%) - NULL',
            SUM(IFNULL(weight_3pl_item, 0)) / COUNT(bob_id_sales_order_item) 'Average Weight'
    FROM
        (SELECT 
        ac.*,
            shipping_amount / IF(ac.tax_class = 0, 1.1, 0) 'shipping_amount_temp',
            shipping_surcharge / IF(ac.tax_class = 0, 1.1, 0) 'shipping_surcharge_temp',
            CASE
                WHEN IFNULL(ac.marketplace_commission_fee, 0) = 0 THEN 0
                ELSE IFNULL(gc.general_commission, rc.general_commission) * unit_price / - 100
            END 'commission_waiver',
            CASE
                WHEN ac.chargeable_weight_3pl_ps / ac.qty_ps > 400 THEN 0
                WHEN ac.shipping_amount + ac.shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass'
    FROM
        scglv3.anondb_calculate ac
    LEFT JOIN scglv3.category_general_commission gc ON ac.primary_category = gc.id_primary_category
        AND ac.tax_class = gc.tax_class
    LEFT JOIN scglv3.category_general_commission rc ON ac.primary_category = rc.id_primary_category
        AND ac.tax_class = rc.tax_class
        AND rc.id_primary_category = 1
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.tax_class IN ('local' , 'international')
    HAVING pass = 1) ac
    GROUP BY bob_id_supplier) result