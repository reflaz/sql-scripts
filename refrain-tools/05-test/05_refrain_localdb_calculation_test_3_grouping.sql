USE refrain;

SELECT 
    bob_id_sales_order_item,
    order_nr,
    payment_method,
    bob_id_supplier,
    seller_type,
    tax_class,
    is_marketplace,
    order_value,
    payment_value,
    unit_price_tmp 'unit_price',
    paid_price_tmp 'paid_price',
    shipping_amount_tmp 'shipping_amount',
    shipping_surcharge_tmp 'shipping_surcharge',
    order_date,
    finance_verified_date,
    first_shipped_date,
    last_shipped_date,
    delivered_date,
    failed_delivery_date,
    origin,
    id_district,
    pickup_provider_type,
    id_package_dispatching,
    first_shipment_provider,
    last_shipment_provider,
    shipping_type,
    delivery_type,
    auto_shipping_fee_credit 'auto_shipping_fee_credit',
    manual_shipping_fee_tmp 'manual_shipping_fee',
    api_type,
    shipment_scheme,
    campaign,
    weight_tmp 'weight',
    volumetric_weight_tmp 'volumetric_weight',
    item_weight_seller_tmp 'item_weight_seller',
    item_weight_seller_flag,
    rounding_seller,
    formula_weight_sel_tmp 'formula_weight_sel',
    CASE
        WHEN package_weight_threshold IS NULL THEN chargeable_weight_sel_tmp
        WHEN chargeable_weight_sel_tmp <= package_weight_threshold THEN chargeable_weight_sel_tmp
        ELSE CASE
            WHEN package_weight_no_bulky = 1 THEN 0
            WHEN package_weight_offset = 1 THEN chargeable_weight_sel_tmp - package_weight_threshold
            WHEN package_weight_max = 1 THEN package_weight_threshold
        END
    END 'chargeable_weight_sel',
    seller_flat_charge_rate,
    seller_charge_rate,
    insurance_rate_sel,
    insurance_vat_rate_sel,
    weight_seller_pct,
    seller_flat_charge,
    seller_charge,
    insurance_seller,
    insurance_vat_seller,
    rate_card_scheme,
    rounding_3pl,
    formula_weight_3pl_tmp 'formula_weight_3pl',
    chargeable_weight_3pl_tmp 'chargeable_weight_3pl',
    pickup_cost_rate,
    pickup_cost_discount_rate,
    pickup_cost_vat_rate,
    delivery_flat_cost_rate,
    delivery_cost_rate,
    delivery_cost_discount_rate,
    delivery_cost_vat_rate,
    insurance_rate_3pl,
    insurance_vat_rate_3pl,
    weight_3pl_pct,
    pickup_cost,
    pickup_cost_discount,
    pickup_cost_vat,
    delivery_flat_cost,
    delivery_cost,
    delivery_cost_discount,
    delivery_cost_vat,
    insurance_3pl,
    insurance_vat_3pl,
    total_customer_charge,
    total_seller_charge,
    total_pickup_cost,
    total_delivery_cost,
    total_falied_delivery_cost
FROM
    (SELECT 
        tpl.*,
            CASE
                WHEN formula_weight_sel_tmp = 0 THEN 0
                WHEN formula_weight_sel_tmp < 1 THEN 1
                WHEN MOD(formula_weight_sel_tmp, 1) <= rounding_seller THEN FLOOR(formula_weight_sel_tmp)
                ELSE CEIL(formula_weight_sel_tmp)
            END 'chargeable_weight_sel_tmp',
            CASE
                WHEN formula_weight_3pl_tmp = 0 THEN 0
                WHEN formula_weight_3pl_tmp < 1 THEN 1
                WHEN MOD(formula_weight_3pl_tmp, 1) <= rounding_3pl THEN FLOOR(formula_weight_3pl_tmp)
                ELSE CEIL(formula_weight_3pl_tmp)
            END 'chargeable_weight_3pl_tmp'
    FROM
        (SELECT 
        *,
            SUM(IFNULL(unit_price, 0)) 'unit_price_tmp',
            SUM(IFNULL(paid_price, 0)) 'paid_price_tmp',
            SUM(IFNULL(shipping_amount, 0)) 'shipping_amount_tmp',
            SUM(IFNULL(shipping_surcharge, 0)) 'shipping_surcharge_tmp',
            SUM(IFNULL(auto_shipping_fee_credit, 0)) 'auto_shipping_fee_credit_tmp',
            SUM(IFNULL(manual_shipping_fee, 0)) 'manual_shipping_fee_tmp',
            SUM(IFNULL(weight, 0)) 'weight_tmp',
            SUM(IFNULL(volumetric_weight, 0)) 'volumetric_weight_tmp',
            SUM(IFNULL(item_weight_seller, 0)) 'item_weight_seller_tmp',
            CASE
                WHEN item_weight_threshold IS NOT NULL THEN SUM(IFNULL(item_weight_seller, 0))
                WHEN package_weight_threshold IS NOT NULL THEN GREATEST(SUM(IFNULL(weight, 0)), SUM(IFNULL(volumetric_weight, 0)))
            END 'formula_weight_sel_tmp',
            GREATEST(SUM(IFNULL(weight, 0)), SUM(IFNULL(volumetric_weight, 0))) 'formula_weight_3pl_tmp'
    FROM
        tmp_item_level til
    JOIN map_weight_threshold_seller mwts ON GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mwts.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mwts.end_date
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) tpl) result