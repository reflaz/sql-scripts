-- sales_order_item for finance
select
    -- id
    so.order_nr,
    p.id_package,
    soi.bob_id_sales_order_item,
    so.bob_id_customer,
    -- soi
    soi.id_sales_order_item as oms_soi,
    COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) as sc_soi,
    sta.name as oms_status,
    scs.name as sc_status,
    soi.created_at as soi_created_at,
    date_format(soi_grp.delivered_created_at,'%Y%m') as delivered_yearmonth,
    soi_grp.delivered_created_at,
    soi_grp.returned_created_at,
    -- package
    p.package_number,
    pd.tracking_number,
    soi_grp.package_weight,
    soi_grp.warehouse_order_weight,
    sp.shipment_provider_name,
    -- composition
    number_of_item_order,
    number_of_item_order_retail,
    number_of_item_order_local,
    number_of_item_order_cb,
    number_of_package_order,
    number_of_item_package,
    number_of_item_package_delivered,
    -- seller
    s.name as supplier_name,
    se.name as seller_name,
    se.short_code,
    soi.bob_id_supplier,
    pilot_group.pilot_group,
    -- soi type
    case se.tax_class when 0 then 'Local' when 1 then 'International' end as tax_class,
    @platform:=case soi.is_marketplace when 0 then 'Retail' when 1 then case soi.fk_shipping_type when 3 then 'FBL' else 'MP' end end as platform,
    soi.is_marketplace,
    st.name as shipping_type,
    w.name as warehouse,
    dt.name as delivery_type,
    -- origin
    sa.postcode as origin_postcode,
    origin.city as origin_city,
    origin.state as origin_state,
    case 
        when @platform in ('FBL','Retail') then case 
            when w.name in ('Pos Logistics (KLB)','SCA FLEX WHv','Subang','USJ','USJ Groceries') then 'WM'
            when w.name in ('Hubwire','Hubwire Kuching','Kuching') then 'EM'
        end
        WHEN sp.shipment_provider_name = 'LGS-CNMY14' THEN 'EM'
        WHEN sp.shipment_provider_name LIKE 'LGS%' THEN 'WM'
        else origin.region 
    end as origin_region,
    -- destination
    icar.name as destionation_postcode,
    destination.city as destination_city,
    destination.state as destination_state,
    destination.region as destination_region,
    -- sku
    soi.sku,
    soi.name,
    wh_weight,
    cc.package_weight as bob_weight,
    cat1.name as cat1,
    cat2.name as cat2,
    cat3.name as cat3,
    -- soi money
    i.cost as inventory_cost,
    soi.unit_price,
    soi.paid_price,
    soi.shipping_fee as soi_shipping_fee,
    soi.shipping_surcharge as soi_shipping_surcharge,
    so.payment_method,
    so.coupon_code,
    soi.coupon_money_value,
    soi.cart_rule_display_names,
    soi.cart_rule_discount,
    -- sc transaction
    sum(coalesce(commission.value,commission_archive.value)) as commission,
    sum(coalesce(commission_reversal.value,commission_reversal_archive.value)) as commission_reversal,
    sum(coalesce(shipping_fee.value,shipping_fee_archive.value)) as shipping_fee,
    sum(coalesce(shipping_fee_credit.value,shipping_fee_credit_archive.value)) as shipping_fee_credit,
    sum(coalesce(automatic_shipping_fee.value,automatic_shipping_fee_archive.value)) as automatic_shipping_fee,
    sum(coalesce(payment_fee.value,payment_fee_archive.value)) as payment_fee,
    sum(coalesce(payment_fee_credit.value,payment_fee_credit_archive.value)) as payment_fee_credit,
    sum(coalesce(fbl_fee.value,fbl_fee_archive.value)) as fbl_fee
    -- sum(coalesce(price_subsidy.value,price_subsidy_archive.value)) as price_subsidy

from oms_live.ims_sales_order_item soi
left join oms_live.ims_sales_order so on so.id_sales_order = soi.fk_sales_order
left join oms_live.ims_sales_order_item_status sta on sta.id_sales_order_item_status = soi.fk_sales_order_item_status   
left join oms_live.oms_shipping_type st on st.id_shipping_type = soi.fk_shipping_type
left join oms_live.ims_sales_order_item_delivery_type dt on dt.id_sales_order_item_delivery_type = soi.fk_sales_order_item_delivery_type
left join oms_live.oms_warehouse w on w.id_warehouse = soi.fk_mwh_warehouse
left join oms_live.wms_picklist_item pli on pli.fk_sales_order_item = soi.id_sales_order_item
left join oms_live.wms_inventory i on i.id_inventory = pli.fk_inventory

-- package info
left join oms_live.oms_package_item pie on pie.fk_sales_order_item = soi.id_sales_order_item
left join oms_live.oms_package p on p.id_package = pie.fk_package
left join oms_live.oms_package_dispatching pd on pd.fk_package = p.id_package
left join oms_live.oms_shipment_provider sp on sp.id_shipment_provider = pd.fk_shipment_provider

-- seller center item, transaction and transaction_archive
LEFT JOIN asc_live.sales_order_item scsoi ON scsoi.src_id = soi.id_sales_order_item
LEFT JOIN asc_live.sales_order_item_archive scsoi_archive ON scsoi_archive.src_id = soi.id_sales_order_item
left join asc_live.sales_order_item_status scs on scs.id_sales_order_item_status = COALESCE(scsoi.fk_sales_order_item_status,scsoi_archive.fk_sales_order_item_status)

LEFT JOIN asc_live.transaction commission ON commission.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND commission.fk_transaction_type = (16) 
LEFT JOIN asc_live.transaction commission_reversal ON commission_reversal.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND commission_reversal.fk_transaction_type = (15) 
LEFT JOIN asc_live.transaction shipping_fee ON shipping_fee.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND shipping_fee.fk_transaction_type = (7)
LEFT JOIN asc_live.transaction shipping_fee_credit ON shipping_fee_credit.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND shipping_fee_credit.fk_transaction_type = (8)
LEFT JOIN asc_live.transaction automatic_shipping_fee ON automatic_shipping_fee.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND automatic_shipping_fee.fk_transaction_type = (28)
LEFT JOIN asc_live.transaction payment_fee ON payment_fee.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND payment_fee.fk_transaction_type = (3)
LEFT JOIN asc_live.transaction payment_fee_credit ON payment_fee_credit.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND payment_fee_credit.fk_transaction_type = (4)
LEFT JOIN asc_live.transaction fbl_fee ON fbl_fee.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND fbl_fee.fk_transaction_type = (22)       
-- LEFT JOIN asc_live.transaction price_subsidy ON price_subsidy.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND price_subsidy.fk_transaction_type = (36)  AND (price_subsidy.description LIKE 'reimb-pssd%' or price_subsidy.description LIKE 'reimb-comm dis%' or price_subsidy.description like 'l.sub%')

LEFT JOIN asc_live.transaction_archive commission_archive ON commission_archive.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND commission_archive.fk_transaction_type = (16)
LEFT JOIN asc_live.transaction_archive commission_reversal_archive ON commission_reversal_archive.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND commission_reversal_archive.fk_transaction_type = (15) 
LEFT JOIN asc_live.transaction_archive shipping_fee_archive ON shipping_fee_archive.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND shipping_fee_archive.fk_transaction_type = (7)
LEFT JOIN asc_live.transaction_archive shipping_fee_credit_archive ON shipping_fee_credit_archive.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND shipping_fee_credit_archive.fk_transaction_type = (8)
LEFT JOIN asc_live.transaction_archive automatic_shipping_fee_archive ON automatic_shipping_fee_archive.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND automatic_shipping_fee_archive.fk_transaction_type = (28) 
LEFT JOIN asc_live.transaction_archive payment_fee_archive ON payment_fee_archive.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND payment_fee_archive.fk_transaction_type = (3)
LEFT JOIN asc_live.transaction_archive payment_fee_credit_archive ON payment_fee_credit_archive.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND payment_fee_credit_archive.fk_transaction_type = (4)
LEFT JOIN asc_live.transaction_archive fbl_fee_archive ON fbl_fee_archive.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND fbl_fee_archive.fk_transaction_type = (22)
-- LEFT JOIN asc_live.transaction_archive price_subsidy_archive ON price_subsidy_archive.ref = COALESCE(scsoi.id_sales_order_item,scsoi_archive.id_sales_order_item) AND price_subsidy_archive.fk_transaction_type = (36)  AND (price_subsidy_archive.description LIKE 'reimb-pssd%' or price_subsidy_archive.description LIKE 'reimb-comm dis%' or price_subsidy_archive.description like 'l.sub%')

-- seller data
left join asc_live.seller se on se.src_id = soi.bob_id_supplier
left join bob_live.supplier s on s.id_supplier = soi.bob_id_supplier
left join (
    SELECT fk_supplier,cr.name as pilot_group FROM bob_live.supplier_address sa
    left join bob_live.country_region cr on cr.id_country_region = sa.fk_country_region
    where cr.name like 'pilot%' group by 1) pilot_group on pilot_group.fk_supplier = soi.bob_id_supplier

-- origin and destination
left join (select fk_supplier,postcode from bob_live.supplier_address sa join bob_live.customer_address_region car on car.name = nullif(sa.postcode,'') and car.customer_address_region_type = 4 group by 1) sa on if(is_marketplace,sa.fk_supplier = s.id_supplier,NULL)
left join oms_live.ims_sales_order_address soa on soa.id_sales_order_address = so.fk_sales_order_address_shipping
left join oms_live.ims_customer_address_region icar on icar.id_customer_address_region = soa.fk_customer_address_region
left join (
    SELECT postcode.name AS postcode,city.name as city,state.name as state, case when state.name in ('sabah','sarawah','wp labuan') then 'EM' else 'WM' end as region
    FROM bob_live.customer_address_region postcode
    LEFT JOIN bob_live.customer_address_region city ON city.id_customer_address_region = postcode.fk_customer_address_region
    LEFT JOIN bob_live.customer_address_region state ON state.id_customer_address_region = city.fk_customer_address_region
    WHERE postcode.customer_address_region_type = 4 group by 1) origin on origin.postcode = sa.postcode
left join (
    SELECT postcode.name AS postcode,city.name as city,state.name as state, case when state.name in ('sabah','sarawah','wp labuan') then 'EM' else 'WM' end as region
    FROM bob_live.customer_address_region postcode
    LEFT JOIN bob_live.customer_address_region city ON city.id_customer_address_region = postcode.fk_customer_address_region
    LEFT JOIN bob_live.customer_address_region state ON state.id_customer_address_region = city.fk_customer_address_region
    WHERE postcode.customer_address_region_type = 4 group by 1) destination on destination.postcode = icar.name

-- sku info from bob
left join bob_live.catalog_simple cs on cs.sku = soi.sku
left join bob_live.catalog_config cc on cc.id_catalog_config = cs.fk_catalog_config
left join bob_live.catalog_category cat on cat.id_catalog_category = cc.primary_category
left join bob_live.catalog_category cat1 on cat1.regional_key = rpad(left(cat.regional_key,2),12,'0')
left join bob_live.catalog_category cat2 on cat2.regional_key = rpad(left(cat.regional_key,4),12,'0') and cat2.id_catalog_category != cat1.id_catalog_category
left join bob_live.catalog_category cat3 on cat3.regional_key = rpad(left(cat.regional_key,6),12,'0') and cat3.id_catalog_category != cat2.id_catalog_category
left join bob_live.catalog_category cat4 on cat4.regional_key = rpad(left(cat.regional_key,8),12,'0') and cat4.id_catalog_category != cat3.id_catalog_category
left join bob_live.catalog_category cat5 on cat5.regional_key = rpad(left(cat.regional_key,10),12,'0') and cat5.id_catalog_category != cat4.id_catalog_category
left join bob_live.catalog_category cat6 on cat6.regional_key = rpad(left(cat.regional_key,12),12,'0') and cat6.id_catalog_category != cat5.id_catalog_category
left join (select fk_catalog_simple,max(nullif(weight,0)) as wh_weight from bob_live.catalog_simple_package_unit pu group by 1) pu on pu.fk_catalog_simple = cs.id_catalog_simple

-- complicated stuffs. trying to get group level info to item level
join (
    select soi.bob_id_sales_order_item,
        min(delivered.created_at) as delivered_created_at,
        min(returned.created_at) as returned_created_at,
        p_grp.*
    from oms_live.ims_sales_order_item soi
    left join oms_live.ims_sales_order_item_status_history delivered on delivered.fk_sales_order_item = soi.id_sales_order_item and delivered.fk_sales_order_item_status = (select id_sales_order_item_status from oms_live.ims_sales_order_item_status where name = 'delivered')
    left join oms_live.ims_sales_order_item_status_history returned on returned.fk_sales_order_item = soi.id_sales_order_item and returned.fk_sales_order_item_status = (select id_sales_order_item_status from oms_live.ims_sales_order_item_status where name = 'returned' and not deprecated)
    left join oms_live.oms_package_item pie on pie.fk_sales_order_item = soi.id_sales_order_item
    join (
        select id_package,
            count(distinct bob_id_sales_order_item) as number_of_item_package,
            sum(coalesce(wh_weight,cc.package_weight)) as package_weight,
            p_grp_status.*
        from oms_live.ims_sales_order_item soi
        left join oms_live.ims_sales_order so on so.id_sales_order = soi.fk_sales_order
        left join oms_live.oms_package_item pie on pie.fk_sales_order_item = soi.id_sales_order_item
        left join oms_live.oms_package p on p.id_package = pie.fk_package
        left join bob_live.catalog_simple cs on cs.sku = soi.sku
        left join bob_live.catalog_config cc on cc.id_catalog_config = cs.fk_catalog_config
        left join (select fk_catalog_simple,max(nullif(weight,0)) as wh_weight from bob_live.catalog_simple_package_unit pu group by 1) pu on pu.fk_catalog_simple = cs.id_catalog_simple
        join (
            select fk_package,
                count(distinct if(delivered.id_sales_order_item_status_history,bob_id_sales_order_item,NULL)) as number_of_item_package_delivered,
                so_grp.*
            from oms_live.ims_sales_order_item soi 
            left join oms_live.oms_package_item pie on pie.fk_sales_order_item = soi.id_sales_order_item
            left join oms_live.ims_sales_order_item_status_history delivered on delivered.fk_sales_order_item = soi.id_sales_order_item and delivered.fk_sales_order_item_status = (select id_sales_order_item_status from oms_live.ims_sales_order_item_status where name = 'delivered')
            join (
                select so.id_sales_order,
                    count(distinct soi.bob_id_sales_order_item) as number_of_item_order,
                    count(distinct pie.fk_package) as number_of_package_order,
                    count(distinct if(not soi.is_marketplace,bob_id_sales_order_item,null)) as number_of_item_order_retail,
                    count(distinct if(se.tax_class=0,bob_id_sales_order_item,null)) as number_of_item_order_local,
                    count(distinct if(se.tax_class=1,bob_id_sales_order_item,null)) as number_of_item_order_cb,
                    sum(if(soi.fk_shipping_type in (1,3),coalesce(wh_weight,cc.package_weight),0)) as warehouse_order_weight
                from oms_live.ims_sales_order_item soi
                left join oms_live.ims_sales_order so on so.id_sales_order = soi.fk_sales_order
                left join oms_live.oms_package_item pie on pie.fk_sales_order_item = soi.id_sales_order_item
                left join asc_live.seller se on se.src_id = soi.bob_id_supplier
                left join bob_live.catalog_simple cs on cs.sku = soi.sku
                left join bob_live.catalog_config cc on cc.id_catalog_config = cs.fk_catalog_config
                left join (select fk_catalog_simple,max(nullif(weight,0)) as wh_weight from bob_live.catalog_simple_package_unit pu group by 1) pu on pu.fk_catalog_simple = cs.id_catalog_simple
                join (
                    select so.id_sales_order
                    from oms_live.ims_sales_order_item soi
                    left join oms_live.ims_sales_order so on so.id_sales_order = soi.fk_sales_order
                    left join oms_live.ims_sales_order_item_status_history delivered on delivered.fk_sales_order_item = soi.id_sales_order_item and delivered.fk_sales_order_item_status = (select id_sales_order_item_status from oms_live.ims_sales_order_item_status where name = 'delivered')

                    -- filters
                    where true 
                        and delivered.created_at >= date_sub({0},interval 0 day)
                        and delivered.created_at < date_sub({1},interval 0 day)
                        -- and delivered.created_at >= 20170701 and delivered.created_at < 20170702
                        -- and cat2.id_catalog_category = (select id_catalog_category from bob_live.catalog_category where name = 'Exercise & Fitness')
                        -- and se.tax_class = 0
                        -- and soi.fk_shipping_type = 3
                        -- and so.order_nr in ('329287757','314291375')
                        -- and bob_id_sales_order_item in (20950726)
                    group by 1
                    -- limit 3
                ) filter on filter.id_sales_order = soi.fk_sales_order
                group by 1
            ) so_grp on so_grp.id_sales_order = soi.fk_sales_order
            group by 1
        ) p_grp_status on p_grp_status.fk_package = p.id_package
        group by 1
    ) p_grp on p_grp.id_package = pie.fk_package
    group by 1
) soi_grp on soi_grp.bob_id_sales_order_item = soi.bob_id_sales_order_item
where delivered_created_at >= {0} and delivered_created_at < {1}
group by bob_id_sales_order_item

