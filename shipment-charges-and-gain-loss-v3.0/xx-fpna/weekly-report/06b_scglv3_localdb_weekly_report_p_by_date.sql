/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Weekly Report

Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-07-29';
SET @extractend = '2017-08-01';-- This MUST be D + 1

SET @day_accrual_basis = 16/30;#

SET @cb_delivery_cost =  38130.1497275483;#Item CB
SET @cb_delivery_charge = 38130.1497275483;#Item CB

SET @delivery_cost_per_item_ma = 13695.9056110694;#Item MA
SET @failed_delivery_cost_per_item_ma = 15548.2049036706;#Item MA
SET @pickup_cost_per_item_ma = 1082.88655831528;#Item MA
SET @return_cost_per_item_ma = 364.080177710181;#Item MA

SET @return_cost_per_item_db =  364.080177710181;#Item MA

SET @return_cost_per_item_cb =  322.192452812097;#Item MA

SET @delivery_cost_per_item_retail = 18885.5076081679;#Item Retail
SET @failed_delivery_cost_per_item_retail =  23332.5460179993;#Item Retail
SET @return_cost_per_item_retail =  300.74717190495;#Item MA

SET @allowance_bad_goods_rate = 0.00122008980528871;#% to COGS
-- SET @back_margin_base =  1961620623.2908500 ;#Day
-- SET @mp_pricing_subsidy_base = 3463762569.62256000;#Day
-- SET @cb_pricing_subsidy_base = 0;#Day
SET @marketing_revenue_base = 2663819490.34351;#Day
SET @other_charges_rate = 0.00184797273680737;#% to NMV
-- SET @cb_commission_rate =  0.03254946028657210;

SET @wh_handling_retail = 7316;#Item Retail
SET @wh_handling_fbl = 2500;#Item FBL

SET @bad_debt_rate =  0.000935233635075992;#%NMV
SET @cs_rate = 2691.98995482568;#Order

SET @adjustment_db = 0;# - means more subsidy
SET @adjustment_marketing_expense = 0;
SET @adjustment_marketing_revenue = 0;# - means less revenue
SET @adjustment_ma = 0;
SET @adjustment_pickup_cost = 0;

SELECT 
    *
FROM
    (SELECT 
        SUM(IF(ordered_flag = 1, orders, 0)) 'Total Order (Created Date)',
            SUM(IF(delivered_flag = 1, orders, 0)) 'Total Order (Delivered Date)',
            SUM(IF(delivered_flag = 1 AND p = '1P - Retail', orders, 0)) 'Delivered Order 1P - Retail',
            SUM(IF(delivered_flag = 1 AND p = '1P - MP BP', orders, 0)) 'Delivered Order 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND p = '2P - MP Non BP', orders, 0)) 'Delivered Order 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND p = '3P - TBC', orders, 0)) 'Delivered Order 3P - TBC',
            SUM(IF(delivered_flag = 1 AND p = '3P - CB', orders, 0)) 'Delivered Order 3P - CB',
            SUM(IF(delivered_flag = 1 AND p = 'Digital', orders, 0)) 'Delivered Order Digital',
            
            
            SUM(IF(delivered_flag = 1, item, 0)) 'Total Item (Delivered Date)',
            SUM(IF(delivered_flag = 1 AND p = '1P - Retail', item, 0)) 'Delivered Item 1P - Retail',
            SUM(IF(delivered_flag = 1 AND p = '1P - MP BP', item, 0)) 'Delivered Item 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND p = '2P - MP Non BP', item, 0)) 'Delivered Item 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND p = '3P - TBC', item, 0)) 'Delivered Item 3P - TBC',
            SUM(IF(delivered_flag = 1 AND p = '3P - CB', item, 0)) 'Delivered Item 3P - CB',
            SUM(IF(delivered_flag = 1 AND p = 'Digital', item, 0)) 'Delivered Item Digital',
            
            
            SUM(IF(failed_flag = 1, item, 0)) 'Total Item (Failed Date)',
            SUM(IF(failed_flag = 1 AND p = '1P - Retail', item, 0)) 'Failed Item 1P - Retail',
            SUM(IF(failed_flag = 1 AND p = '1P - MP BP', item, 0)) 'Failed Item 1P - MP BP',
            SUM(IF(failed_flag = 1 AND p = '2P - MP Non BP', item, 0)) 'Failed Item 2P - MP Non BP',
            SUM(IF(failed_flag = 1 AND p = '3P - TBC', item, 0)) 'Failed Item 3P - TBC',
            SUM(IF(failed_flag = 1 AND p = '3P - CB', item, 0)) 'Failed Item 3P - CB',
            SUM(IF(failed_flag = 1 AND p = 'Digital', item, 0)) 'Failed Item Digital',
            
            
            SUM(IF(delivered_flag = 1, parcels, 0)) 'Total Parcels (Delivered Date)',
            SUM(IF(delivered_flag = 1 AND p = '1P - Retail', parcels, 0)) 'Delivered Parcels 1P - Retail',
            SUM(IF(delivered_flag = 1 AND p = '1P - MP BP', parcels, 0)) 'Delivered Parcels 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND p = '2P - MP Non BP', parcels, 0)) 'Delivered Parcels 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND p = '3P - TBC', parcels, 0)) 'Delivered Parcels 3P - TBC',
            SUM(IF(delivered_flag = 1 AND p = '3P - CB', parcels, 0)) 'Delivered Parcels 3P - CB',
            SUM(IF(delivered_flag = 1 AND p = 'Digital', parcels, 0)) 'Delivered Parcels Digital',
            
            
            SUM(IF(shipped_flag = 1, nmv, 0)) 'Total GMV (Shipped Date)',
            SUM(IF(shipped_flag = 1 AND p = '1P - Retail', nmv, 0)) 'Shipped NMV 1P - Retail',
            SUM(IF(shipped_flag = 1 AND p = '1P - MP BP', nmv, 0)) 'Shipped NMV 1P - MP BP',
            SUM(IF(shipped_flag = 1 AND p = '2P - MP Non BP', nmv, 0)) 'Shipped NMV 2P - MP Non BP',
            SUM(IF(shipped_flag = 1 AND p = '3P - TBC', nmv, 0)) 'Shipped NMV 3P - TBC',
            SUM(IF(shipped_flag = 1 AND p = '3P - CB', nmv, 0)) 'Shipped NMV 3P - CB',
            SUM(IF(shipped_flag = 1 AND p = 'Digital', nmv, 0)) 'Shipped NMV Digital',
            
            
            SUM(IF(ordered_flag = 1, nmv, 0)) 'Total NMV (Created Date)',
            SUM(IF(ordered_flag = 1 AND p = '1P - Retail', nmv, 0)) 'Created NMV 1P - Retail',
            SUM(IF(ordered_flag = 1 AND p = '1P - MP BP', nmv, 0)) 'Created NMV 1P - MP BP',
            SUM(IF(ordered_flag = 1 AND p = '2P - MP Non BP', nmv, 0)) 'Created NMV 2P - MP Non BP',
            SUM(IF(ordered_flag = 1 AND p = '3P - TBC', nmv, 0)) 'Created NMV 3P - TBC',
            SUM(IF(ordered_flag = 1 AND p = '3P - CB', nmv, 0)) 'Created NMV 3P - CB',
            SUM(IF(ordered_flag = 1 AND p = 'Digital', nmv, 0)) 'Created NMV Digital',
            
            
            SUM(IF(delivered_flag = 1, nmv, 0)) 'Total NMV (Delivered Date)',
            SUM(IF(delivered_flag = 1 AND p = '1P - Retail', nmv, 0)) 'Delivered NMV 1P - Retail',
            SUM(IF(delivered_flag = 1 AND p = '1P - MP BP', nmv, 0)) 'Delivered NMV 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND p = '2P - MP Non BP', nmv, 0)) 'Delivered NMV 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND p = '3P - TBC', nmv, 0)) 'Delivered NMV 3P - TBC',
            SUM(IF(delivered_flag = 1 AND p = '3P - CB', nmv, 0)) 'Delivered NMV 3P - CB',
            SUM(IF(delivered_flag = 1 AND p = 'Digital', nmv, 0)) 'Delivered NMV Digital',
            
            
            SUM(IF(delivered_flag = 1 AND payment_method = 'cod', nmv, 0)) 'NMV COD',
            SUM(IF(delivered_flag = 1 AND payment_method = 'non_cod', nmv, 0)) 'NMV Non COD',
            
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic', nmv, 0)) 'NMV EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion', nmv, 0)) 'NMV Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg', nmv, 0)) 'NMV FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home', nmv, 0)) 'NMV Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors', nmv, 0)) 'NMV Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others', nmv, 0)) 'NMV Others',
            
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - MP BP', commission, 0)) 'Commission EL 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - MP BP', commission, 0)) 'Commission Fashion 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - MP BP', commission, 0)) 'Commission FMCG 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '1P - MP BP', commission, 0)) 'Commission Home 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - MP BP', commission, 0)) 'Commission Motors 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - MP BP', commission, 0)) 'Commission Others 1P - MP BP',
            
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - MP BP', nmv, 0)) 'NMV EL 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - MP BP', nmv, 0)) 'NMV Fashion 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - MP BP', nmv, 0)) 'NMV FMCG 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '1P - MP BP', nmv, 0)) 'NMV Home 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - MP BP', nmv, 0)) 'NMV Motors 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - MP BP', nmv, 0)) 'NMV Others 1P - MP BP',
            
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - MP BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - MP BP', nmv, 0)) '% Commission EL 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - MP BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - MP BP', nmv, 0)) '% Commission Fashion 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - MP BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - MP BP', nmv, 0)) '% Commission FMCG 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'home'AND p = '1P - MP BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '1P - MP BP', nmv, 0)) '% Commission Home 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - MP BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - MP BP', nmv, 0)) '% Commission Motors 1P - MP BP',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - MP BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - MP BP', nmv, 0)) '% Commission Others 1P - MP BP',
            
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '2P - MP Non BP', commission, 0)) 'Commission EL 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '2P - MP Non BP', commission, 0)) 'Commission Fashion 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '2P - MP Non BP', commission, 0)) 'Commission FMCG 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '2P - MP Non BP', commission, 0)) 'Commission Home 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '2P - MP Non BP', commission, 0)) 'Commission Motors 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '2P - MP Non BP', commission, 0)) 'Commission Others 2P - MP Non BP',
            
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '2P - MP Non BP', nmv, 0)) 'NMV EL 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '2P - MP Non BP', nmv, 0)) 'NMV Fashion 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '2P - MP Non BP', nmv, 0)) 'NMV FMCG 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '2P - MP Non BP', nmv, 0)) 'NMV Home 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '2P - MP Non BP', nmv, 0)) 'NMV Motors 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '2P - MP Non BP', nmv, 0)) 'NMV Others 2P - MP Non BP',
			
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '2P - MP Non BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '2P - MP Non BP', nmv, 0)) '% Commission EL 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '2P - MP Non BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '2P - MP Non BP', nmv, 0)) '% Commission Fashion 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '2P - MP Non BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '2P - MP Non BP', nmv, 0)) '% Commission FMCG 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'home'AND p = '2P - MP Non BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '2P - MP Non BP', nmv, 0)) '% Commission Home 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '2P - MP Non BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '2P - MP Non BP', nmv, 0)) '% Commission Motors 2P - MP Non BP',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '2P - MP Non BP', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '2P - MP Non BP', nmv, 0)) '% Commission Others 2P - MP Non BP',
			
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '3P - TBC', commission, 0)) 'Commission EL 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '3P - TBC', commission, 0)) 'Commission Fashion 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '3P - TBC', commission, 0)) 'Commission FMCG 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '3P - TBC', commission, 0)) 'Commission Home 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '3P - TBC', commission, 0)) 'Commission Motors 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '3P - TBC', commission, 0)) 'Commission Others 3P - TBC',
            
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '3P - TBC', nmv, 0)) 'NMV EL 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '3P - TBC', nmv, 0)) 'NMV Fashion 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '3P - TBC', nmv, 0)) 'NMV FMCG 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '3P - TBC', nmv, 0)) 'NMV Home 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '3P - TBC', nmv, 0)) 'NMV Motors 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '3P - TBC', nmv, 0)) 'NMV Others 3P - TBC',
			
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '3P - TBC', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '3P - TBC', nmv, 0)) '% Commission EL 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '3P - TBC', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '3P - TBC', nmv, 0)) '% Commission Fashion 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '3P - TBC', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '3P - TBC', nmv, 0)) '% Commission FMCG 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'home'AND p = '3P - TBC', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '3P - TBC', nmv, 0)) '% Commission Home 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '3P - TBC', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '3P - TBC', nmv, 0)) '% Commission Motors 3P - TBC',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '3P - TBC', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '3P - TBC', nmv, 0)) '% Commission Others 3P - TBC',
			
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '3P - CB', commission, 0)) 'Commission EL 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '3P - CB', commission, 0)) 'Commission Fashion 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '3P - CB', commission, 0)) 'Commission FMCG 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '3P - CB', commission, 0)) 'Commission Home 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '3P - CB', commission, 0)) 'Commission Motors 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '3P - CB', commission, 0)) 'Commission Others 3P - CB',
            
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '3P - CB', nmv, 0)) 'NMV EL 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '3P - CB', nmv, 0)) 'NMV Fashion 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '3P - CB', nmv, 0)) 'NMV FMCG 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '3P - CB', nmv, 0)) 'NMV Home 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '3P - CB', nmv, 0)) 'NMV Motors 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '3P - CB', nmv, 0)) 'NMV Others 3P - CB',
			
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '3P - CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '3P - CB', nmv, 0)) '% Commission EL 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '3P - CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '3P - CB', nmv, 0)) '% Commission Fashion 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '3P - CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '3P - CB', nmv, 0)) '% Commission FMCG 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'home'AND p = '3P - CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '3P - CB', nmv, 0)) '% Commission Home 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '3P - CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '3P - CB', nmv, 0)) '% Commission Motors 3P - CB',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '3P - CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '3P - CB', nmv, 0)) '% Commission Others 3P - CB',
			
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - Retail', cogs, 0)) 'Margin EL 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - Retail', cogs, 0)) 'Margin Fashion 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - Retail', cogs, 0)) 'Margin FMCG 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '1P - Retail', cogs, 0)) 'Margin Home 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - Retail', cogs, 0)) 'Margin Motors 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - Retail', cogs, 0)) 'Margin Others 1P - Retail',
			
			
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - Retail', nmv, 0)) 'NMV EL 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - Retail', nmv, 0)) 'NMV Fashion 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - Retail', nmv, 0)) 'NMV FMCG 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '1P - Retail', nmv, 0)) 'NMV Home 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - Retail', nmv, 0)) 'NMV Motors 1P - Retail',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - Retail', nmv, 0)) 'NMV Others 1P - Retail',
			
			
            (SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'electronic' AND p = '1P - Retail', nmv, 0)) '% Margin EL 1P - Retail',
            (SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'fashion' AND p = '1P - Retail', nmv, 0)) '% Margin Fashion 1P - Retail',
            (SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND p = '1P - Retail', nmv, 0)) '% Margin FMCG 1P - Retail',
            (SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '1P - Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'home' AND p = '1P - Retail', nmv, 0)) '% Margin Home 1P - Retail',
            (SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'motors' AND p = '1P - Retail', nmv, 0)) '% Margin Motors 1P - Retail',
            (SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'others' AND p = '1P - Retail', nmv, 0)) '% Margin Others 1P - Retail',
			
            
            0 'Pricing Subsidy 1P - MP BP',
            0 'Pricing Subsidy 2P - MP Non BP',
            0 'Pricing Subsidy 3P - TBC',
            0 'Pricing Subsidy 3P - CB',
            
            
            SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), seller_charges, 0)) 'Seller Charges 1P - MP BP',
            SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), seller_charges, 0)) 'Seller Charges 2P - MP Non BP',
            SUM(IF(p = '1P - MP BP' AND delivered_flag = 1, customer_charges, 0)) 'Customer Charges 1P - MP BP',
            SUM(IF(p = '2P - MP Non BP' AND delivered_flag = 1, customer_charges, 0)) 'Customer Charges 2P - MP Non BP',
            
            
            - GREATEST(SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) 'Delivery Cost 1P - MP BP',
            - GREATEST(SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)), 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0))) 'Pickup Cost 1P - MP BP',
            - GREATEST(SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost, 0))) 'FD Cost 1P - MP BP',
			
            
            - GREATEST(SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) 'Delivery Cost 2P - MP Non BP',
            - GREATEST(SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)), 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0))) 'Pickup Cost 2P - MP Non BP',
            - GREATEST(SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost, 0))) 'FD Cost 2P - MP Non BP',
			
            
            - SUM(IF(p = '1P - MP BP' AND delivered_flag = 1, return_cost, 0)) 'Return Cost 1P - MP BP',
            - SUM(IF(p = '2P - MP Non BP' AND delivered_flag = 1, return_cost, 0)) 'Return Cost 2P - MP Non BP',
            
            
            SUM(IF(p = '1P - MP BP' AND delivered_flag = 1, payment_fee, 0)) 'Payment Charges 1P - MP BP',
            SUM(IF(p = '2P - MP Non BP' AND delivered_flag = 1, payment_fee, 0)) 'Payment Charges 2P - MP Non BP',
            0 'Payment Charges 1P - Retail',
            SUM(IF(p = '3P - TBC' AND delivered_flag = 1, payment_fee, 0)) 'Payment Charges 3P - TBC',
            SUM(IF(p = '3P - TBC' AND (delivered_flag = 1 OR failed_flag = 1), cb_charges, 0)) 'Delivery Charges 3P - TBC',
            SUM(IF(p = '3P - CB' AND delivered_flag = 1, payment_fee, 0)) 'Payment Charges 3P - CB',
            SUM(IF(p = '3P - CB' AND (delivered_flag = 1 OR failed_flag = 1), cb_charges, 0)) 'Delivery Charges 3P - CB',
            
            
            SUM(IF(p = '1P - MP BP' AND delivered_flag = 1, other_charges, 0)) 'Other Charges 1P - MP BP',
            SUM(IF(p = '2P - MP Non BP' AND delivered_flag = 1, other_charges, 0)) 'Other Charges 2P - MP Non BP',
            SUM(IF(p = '3P - TBC' AND delivered_flag = 1, other_charges, 0)) 'Other Charges 3P - TBC',
            SUM(IF(p = '3P - CB' AND delivered_flag = 1, other_charges, 0)) 'Other Charges 3P - CB',
            SUM(IF(p = 'Digital' AND delivered_flag = 1, other_charges, 0)) 'Other Charges Digital',
            
            
            SUM(IF(p = '1P - Retail' AND delivered_flag = 1, price, 0)) 'Unit Price 1P - Retail',
            SUM(IF(p = '1P - Retail' AND delivered_flag = 1, customer_charges, 0)) 'Shipping Fee 1P - Retail',
            
            
            @marketing_revenue_base * @day_accrual_basis 'Marketing Revenue',
            
            
            - SUM(IF(p = '1P - Retail' AND delivered_flag = 1, cogs, 0)) 'Retail COGS',
            0 'Backmargin',
            - SUM(IF(p = '1P - Retail' AND delivered_flag = 1, allowance_bad_goods, 0)) 'Allowance for Bad Goods',
            
            
            - @wh_handling_retail * SUM(IF(p = '1P - Retail' AND shipped_flag = 1, item, 0)) 'WH Handling - Retail',
            - @wh_handling_fbl * SUM(IF(p = '1P - MP BP' AND shipped_flag = 1 AND fbl_flag = 1, item, 0)) 'WH Handling - 1P - MP BP',
            - @wh_handling_fbl * SUM(IF(p = '2P - MP Non BP' AND shipped_flag = 1 AND fbl_flag = 1, item, 0)) 'WH Handling - 2P - MP Non BP',
            
            
            - GREATEST(SUM(IF(p = '3P - TBC' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(p = '3P - TBC' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) 'Delivery Cost 3P - TBC',
			- GREATEST(SUM(IF(p = '3P - CB' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(p = '3P - CB' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) 'Delivery Cost 3P - CB',
            - SUM(IF(delivered_flag = 1 AND p = '3P - TBC', return_cost, 0)) 'Return Cost 3P - TBC',    
            - SUM(IF(delivered_flag = 1 AND p = '3P - CB', return_cost, 0)) 'Return Cost 3P - CB',
            
            
            - GREATEST(SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) 'Delivery Cost 1P - Retail',
            - GREATEST(SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost, 0))) 'FD Cost 1P - Retail',
            - SUM(IF(p = '1P - Retail' AND delivered_flag = 1, return_cost, 0)) 'Return Cost 1P - Retail',
            
            
            SUM(IFNULL(payment_cost, 0)) 'Total Payment Cost',
            
            
            SUM(IF(p = '1P - MP BP' AND payment_method = 'cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost COD 1P - MP BP',
            SUM(IF(p = '2P - MP Non BP' AND payment_method = 'cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost COD 2P - MP Non BP',
            SUM(IF(p = '3P - TBC' AND payment_method = 'cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost COD 3P - TBC',
            SUM(IF(p = '3P - CB' AND payment_method = 'cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost COD 3P - CB',
            SUM(IF(p = 'Digital' AND payment_method = 'cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost COD Digital',
            SUM(IF(p = '1P - Retail' AND payment_method = 'cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost 1P - Retail',
            
            
            SUM(IF(p = '1P - MP BP' AND payment_method = 'non_cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost Non-Cod 1P - MP BP',
            SUM(IF(p = '2P - MP Non BP' AND payment_method = 'non_cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost Non-Cod 2P - MP Non BP',
            SUM(IF(p = '3P - TBC' AND payment_method = 'non_cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost Non-Cod 3P - TBC',
            SUM(IF(p = '3P - CB' AND payment_method = 'non_cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost Non-Cod 3P - CB',
            SUM(IF(p = 'Digital' AND payment_method = 'non_cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost Non-Cod Digital',
            SUM(IF(p = '1P - Retail' AND payment_method = 'non_cod', IFNULL(payment_cost, 0), 0)) 'Payment Cost Non-Cod 1P - Retail',
            
            
            - SUM(IF(p = '1P - MP BP' AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt 1P - MP BP',
            - SUM(IF(p = '2P - MP Non BP' AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt 2P - MP Non BP',
            - SUM(IF(p = '3P - TBC' AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt 3P - TBC',
            - SUM(IF(p = '3P - CB' AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt 3P - CB',
            - SUM(IF(p = 'Digital' AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt Digital',
            - SUM(IF(p = '1P - Retail' AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt 1P - Retail',
            
            
            0 'CS Cost',
            - SUM(IF(p = '1P - Retail' AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule 1P - Retail',
            - SUM(IF(p = '1P - MP BP' AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule 1P - MP BP',
            - SUM(IF(p = '2P - MP Non BP' AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule 2P - MP Non BP',
            - SUM(IF(p = '3P - TBC' AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule 3P - TBC',
            - SUM(IF(p = '3P - CB' AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule 3P - CB',
            - SUM(IF(p = 'Digital' AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule Digital',


###########################################################################################################################################################################
		/*Lines below are for cost per item*/
###########################################################################################################################################################################


			SUM(IF(p = 'Digital' AND ordered_flag = 1, item, 0)) '_Item Ordered Digital',
            SUM(IF(p = 'Digital' AND shipped_flag = 1, item, 0)) '_Item Shipped Digital',
            SUM(IF(p = 'Digital' AND delivered_flag = 1, item, 0)) '_Item Delivered Digital',
            SUM(IF(p = 'Digital' AND failed_flag = 1, item, 0)) '_Item Failed Digital',
                        
            
            SUM(IF(p = '1P - MP BP' AND ordered_flag = 1, item, 0)) '_Item Ordered 1P - MP BP',
            SUM(IF(p = '1P - MP BP' AND shipped_flag = 1, item, 0)) '_Item Shipped 1P - MP BP',
            SUM(IF(p = '1P - MP BP' AND delivered_flag = 1, item, 0)) '_Item Delivered 1P - MP BP',
            SUM(IF(p = '1P - MP BP' AND failed_flag = 1, item, 0)) '_Item Failed 1P - MP BP',
            
            
            SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), seller_charges, 0)) / 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Seller Charges per Item 1P - MP BP',
            SUM(IF(p = '1P - MP BP' AND delivered_flag = 1, customer_charges, 0)) / 
				SUM(IF(p = '1P - MP BP' AND delivered_flag = 1, item, 0)) '_Customer Charges per Item 1P - MP BP',
			
            
            - GREATEST(SUM(IF(p = '1P - MP BP'
                AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), SUM(IF(p = '1P - MP BP'
                AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) / SUM(IF(p = '1P - MP BP'
                AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item 1P - MP BP',
			
            
            - SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0)) / 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item 1P - MP BP Script',
            - SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)) / 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item 1P - MP BP Invoice',
			
            
            - GREATEST(SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)), 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0))) / 
                SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item 1P - MP BP',
            - SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0)) / 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item 1P - MP BP Script',
            - SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)) / 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item 1P - MP BP Invoice',
			
            
            - GREATEST(SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost, 0))) / 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost 1P - MP BP per Item (Mix)',
            - SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost 1P - MP BP per Item Script (Mix)',
            - SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(p = '1P - MP BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost 1P - MP BP per Item Invoice (Mix)',
			
            
            - GREATEST(SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost, 0))) / 
				SUM(IF(p = '1P - MP BP' AND failed_flag = 1, item, 0)) '_FD Cost 1P - MP BP per Item (FD Only)',
            - SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(p = '1P - MP BP' AND failed_flag = 1, item, 0)) '_FD Cost 1P - MP BP per Item Script (FD Only)',
            - SUM(IF(p = '1P - MP BP' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(p = '1P - MP BP' AND failed_flag = 1, item, 0)) '_FD Cost 1P - MP BP per Item Invoice (FD Only)',
                        
            
            SUM(IF(p = '2P - MP Non BP' AND ordered_flag = 1, item, 0)) '_Item Ordered 2P - MP Non BP',
            SUM(IF(p = '2P - MP Non BP' AND shipped_flag = 1, item, 0)) '_Item Shipped 2P - MP Non BP',
            SUM(IF(p = '2P - MP Non BP' AND delivered_flag = 1, item, 0)) '_Item Delivered 2P - MP Non BP',
            SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, item, 0)) '_Item Failed 2P - MP Non BP',
            
            
            SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), seller_charges, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Seller Charges per Item 2P - MP Non BP',
            SUM(IF(p = '2P - MP Non BP' AND delivered_flag = 1, customer_charges, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND delivered_flag = 1, item, 0)) '_Customer Charges per Item 2P - MP Non BP',
			
            
            - GREATEST(SUM(IF(p = '2P - MP Non BP'
                AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), SUM(IF(p = '2P - MP Non BP'
                AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) / SUM(IF(p = '2P - MP Non BP'
                AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item 2P - MP Non BP',
			
            
            - SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item 2P - MP Non BP Script',
            - SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item 2P - MP Non BP Invoice',
			
            
            - GREATEST(SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)), 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0))) / 
                SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item 2P - MP Non BP',
            - SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item 2P - MP Non BP Script',
            - SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item 2P - MP Non BP Invoice',
			
            
            - GREATEST(SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost, 0))) / 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost 2P - MP Non BP per Item (Mix)',
            - SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost 2P - MP Non BP per Item Script (Mix)',
            - SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost 2P - MP Non BP per Item Invoice (Mix)',
			
            
            - GREATEST(SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost, 0))) / 
				SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, item, 0)) '_FD Cost 2P - MP Non BP per Item (FD Only)',
            - SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, item, 0)) '_FD Cost 2P - MP Non BP per Item Script (FD Only)',
            - SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(p = '2P - MP Non BP' AND failed_flag = 1, item, 0)) '_FD Cost 2P - MP Non BP per Item Invoice (FD Only)',
                        
            
            SUM(IF(p = '1P - Retail' AND ordered_flag = 1, item, 0)) '_Item Ordered 1P - Retail',
            SUM(IF(p = '1P - Retail' AND shipped_flag = 1, item, 0)) '_Item Shipped 1P - Retail',
            SUM(IF(p = '1P - Retail' AND delivered_flag = 1, item, 0)) '_Item Delivered 1P - Retail',
            SUM(IF(p = '1P - Retail' AND failed_flag = 1, item, 0)) '_Item Failed 1P - Retail',
            
            
            SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), seller_charges, 0)) / 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Seller Charges per Item 1P - Retail',
            SUM(IF(p = '1P - Retail' AND delivered_flag = 1, customer_charges, 0)) / 
				SUM(IF(p = '1P - Retail' AND delivered_flag = 1, item, 0)) '_Customer Charges per Item 1P - Retail',
			
            
            - GREATEST(SUM(IF(p = '1P - Retail'
                AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), SUM(IF(p = '1P - Retail'
                AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) / SUM(IF(p = '1P - Retail'
                AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item 1P - Retail',
			
            
            - SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0)) / 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item 1P - Retail Script',
            - SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)) / 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item 1P - Retail Invoice',
			
            
            - GREATEST(SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)), 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0))) / 
                SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item 1P - Retail',
            - SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0)) / 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item 1P - Retail Script',
            - SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)) / 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item 1P - Retail Invoice',
			
            
            - GREATEST(SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost, 0))) / 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost 1P - Retail per Item (Mix)',
            - SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost 1P - Retail per Item Script (Mix)',
            - SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(p = '1P - Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost 1P - Retail per Item Invoice (Mix)',
			
            
            - GREATEST(SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost, 0))) / 
				SUM(IF(p = '1P - Retail' AND failed_flag = 1, item, 0)) '_FD Cost 1P - Retail per Item (FD Only)',
            - SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(p = '1P - Retail' AND failed_flag = 1, item, 0)) '_FD Cost 1P - Retail per Item Script (FD Only)',
            - SUM(IF(p = '1P - Retail' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(p = '1P - Retail' AND failed_flag = 1, item, 0)) '_FD Cost 1P - Retail per Item Invoice (FD Only)',
			
            
            - @return_cost_per_item_ma 'Return Cost per Item MA',
            - @return_cost_per_item_db 'Return Cost per Item DB',
            - @return_cost_per_item_retail 'Return Cost per Item Retail',
            - @cb_delivery_cost 'Delivery Cost per Item CB',
            - @cb_delivery_charge 'Delivery Charges per Item CB',
            - @return_cost_per_item_cb 'Return Cost per Item CB',
            - @cb_delivery_cost 'Delivery Cost per Item TBC',
            - @cb_delivery_charge 'Delivery Charges per Item TBC',
            - @return_cost_per_item_cb 'Return Cost per Item TBC',
            - @wh_handling_retail 'WH Handling Cost per Item Retail',
            - @wh_handling_fbl 'WH Handling Cost per Item FBL',
            - @cs_rate 'CS Cost per Order',
            
            
            SUM(IF(p = '3P - TBC' AND ordered_flag = 1, item, 0)) '_Item Ordered 3P - TBC',
            SUM(IF(p = '3P - TBC' AND shipped_flag = 1, item, 0)) '_Item Shipped 3P - TBC',
            SUM(IF(p = '3P - TBC' AND delivered_flag = 1, item, 0)) '_Item Delivered 3P - TBC',
            SUM(IF(p = '3P - TBC' AND failed_flag = 1, item, 0)) '_Item Failed 3P - TBC',
            
            SUM(IF(p = '3P - CB' AND ordered_flag = 1, item, 0)) '_Item Ordered 3P - CB',
            SUM(IF(p = '3P - CB' AND shipped_flag = 1, item, 0)) '_Item Shipped 3P - CB',
            SUM(IF(p = '3P - CB' AND delivered_flag = 1, item, 0)) '_Item Delivered 3P - CB',
            SUM(IF(p = '3P - CB' AND failed_flag = 1, item, 0)) '_Item Failed 3P - CB'
    FROM 
        (SELECT 
        bu,
            p,
            category,
            payment_method_temp 'payment_method',
            fbl_flag,
            ordered_flag,
            shipped_flag,
            delivered_flag,
            failed_flag,
            SUM(IFNULL(nmv, 0)) 'nmv',
            COUNT(DISTINCT order_nr) 'orders',
            COUNT(DISTINCT package_number) 'parcels',
            COUNT(bob_id_sales_order_item) 'item',
            SUM(IFNULL(price, 0)) 'price',
            SUM(IFNULL(retail_cogs, 0)) 'cogs',
            @allowance_bad_goods_rate * SUM(IFNULL(retail_cogs, 0)) 'allowance_bad_goods',
            SUM(IFNULL(commission, 0)) 'commission',
            SUM(IFNULL(payment_fee, 0)) 'payment_fee',
            SUM(IFNULL(order_flat_item, 0) + IFNULL(mdr_item, 0) + IFNULL(ipp_item, 0)) 'payment_cost',
            CASE
                WHEN bu IN ('CB' , 'TBC') THEN @cb_delivery_cost * COUNT(bob_id_sales_order_item)
                WHEN bu = 'MA' THEN SUM(IFNULL(delivery_cost_item, 0) + IFNULL(delivery_cost_discount_item, 0) + IFNULL(delivery_cost_vat_item, 0) + IFNULL(insurance_3pl_item, 0) + IFNULL(insurance_vat_3pl_item, 0))
                ELSE SUM(IFNULL(total_delivery_cost_item, 0))
            END 'delivery_cost',
            CASE
                WHEN bu IN ('CB' , 'TBC') THEN @cb_delivery_cost * COUNT(bob_id_sales_order_item)
                WHEN bu = 'MA' THEN @delivery_cost_per_item_ma * COUNT(bob_id_sales_order_item)
                WHEN bu = 'Retail' THEN @delivery_cost_per_item_retail * COUNT(bob_id_sales_order_item)
                ELSE SUM(IFNULL(total_delivery_cost_item, 0))
            END 'delivery_cost_invoice',
            SUM(IFNULL(delivery_cost_item, 0) + IFNULL(delivery_cost_discount_item, 0) + IFNULL(delivery_cost_vat_item, 0)) 'shipment_cost',
            CASE
                WHEN failed_flag <> 1 THEN 0
                WHEN bu = 'MA' THEN @failed_delivery_cost_per_item_ma * COUNT(bob_id_sales_order_item)
                WHEN bu = 'Retail' THEN @failed_delivery_cost_per_item_retail * COUNT(bob_id_sales_order_item)
                ELSE SUM(IFNULL(delivery_cost_item, 0) + IFNULL(delivery_cost_discount_item, 0) + IFNULL(delivery_cost_vat_item, 0))
            END 'shipment_cost_invoice',
            CASE
                WHEN bu IN ('CB' , 'TBC') THEN @return_cost_per_item_cb * COUNT(bob_id_sales_order_item)
                WHEN bu = 'MA' THEN @return_cost_per_item_ma * COUNT(bob_id_sales_order_item)
                WHEN bu = 'DB' THEN @return_cost_per_item_db * COUNT(bob_id_sales_order_item)
                WHEN bu = 'Retail' THEN @return_cost_per_item_retail * COUNT(bob_id_sales_order_item)
                ELSE 0
            END 'return_cost',
            CASE
                WHEN bu = 'MA' THEN SUM(IFNULL(pickup_cost_item, 0) + IFNULL(pickup_cost_discount_item, 0) + IFNULL(pickup_cost_vat_item, 0))
                ELSE 0
            END 'pickup_cost_temp',
            CASE
                WHEN bu = 'MA' THEN @pickup_cost_per_item_ma * COUNT(bob_id_sales_order_item)
                ELSE 0
            END 'pickup_cost_invoice',
            CASE
                WHEN bu IN ('CB' , 'TBC') THEN @cb_delivery_charge * COUNT(bob_id_sales_order_item)
                ELSE 0
            END 'cb_charges',
            SUM(IFNULL(shipment_fee_mp_seller_item, 0) + IFNULL(insurance_seller_item, 0) + IFNULL(insurance_vat_seller_item, 0)) 'seller_charges',
            SUM((IFNULL(shipping_amount, 0) + IFNULL(shipping_surcharge, 0)) / IF(is_marketplace = 0, 1.1, 1)) 'customer_charges',
            @other_charges_rate * SUM(IFNULL(nmv, 0)) 'other_charges',
            SUM(IFNULL(discount, 0)) 'discount',
            @bad_debt_rate * SUM(IFNULL(nmv, 0)) 'bad_debt'
    FROM
        (SELECT 
        order_nr,
            package_number,
            bob_id_sales_order_item,
            retail_cogs,
            order_flat_item,
            mdr_item,
            ipp_item,
            delivery_cost_item,
            delivery_cost_discount_item,
            delivery_cost_vat_item,
            insurance_3pl_item,
            insurance_vat_3pl_item,
            total_delivery_cost_item,
            pickup_cost_item,
            pickup_cost_discount_item,
            pickup_cost_vat_item,
            shipment_fee_mp_seller_item,
            insurance_seller_item,
            insurance_vat_seller_item,
            shipping_amount,
            shipping_surcharge,
            is_marketplace,
            level1,
            level2,
            level3,
            level4,
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN ABS(total_delivery_cost_item / unit_price) > 5 THEN 0
                WHEN (shipping_amount + shipping_surcharge) > 40000000 THEN 0
                ELSE 1
            END 'pass',
            CASE
                WHEN shipment_scheme LIKE ('%DIGITAL%') THEN 'Digital'
                WHEN shipment_scheme LIKE ('%DIRECT BILLING%') THEN 'DB'
                WHEN shipment_scheme LIKE ('%MASTER ACCOUNT%') THEN 'MA'
                WHEN shipment_scheme LIKE ('%RETAIL%') THEN 'Retail'
                WHEN shipment_scheme LIKE ('%CROSS BORDER%') THEN 'CB'
                WHEN
                    shipment_scheme LIKE ('%GO-JEK%')
                        OR shipment_scheme LIKE ('%EXPRESS%')
                        OR shipment_scheme LIKE ('%FBL%')
                THEN
                    CASE
                        WHEN tax_class = 'international' THEN 'CB'
                        WHEN is_marketplace = 0 THEN 'Retail'
                        ELSE 'MA'
                    END
            END 'bu',
            CASE
                WHEN shipment_scheme LIKE ('%DIGITAL%') THEN 'Digital'
                WHEN bob_id_supplier IN (18358 , 74322, 118514, 121939, 127131) THEN '3P - TBC'
                WHEN tax_class = 'international' THEN '3P - CB'
                WHEN seller_type = 'supplier' THEN '1P - Retail'
                WHEN bpr.id_brand_partnership IS NOT NULL THEN '1P - MP BP'
                ELSE '2P - MP Non BP'
            END 'p',
            CASE
                WHEN shipping_type = 'warehouse' THEN 1
                ELSE 0
            END 'fbl_flag',
            CASE
                WHEN payment_method = 'CashOnDelivery' THEN 'cod'
                ELSE 'non_cod'
            END 'payment_method_temp',
            CASE
                WHEN
                    delivered_date >= @extractstart
                        AND delivered_date < @extractend
                THEN
                    1
                ELSE 0
            END 'delivered_flag',
            CASE
                WHEN
                    not_delivered_date >= @extractstart
                        AND not_delivered_date < @extractend
                THEN
                    1
                ELSE 0
            END 'failed_flag',
            CASE
                WHEN
                    first_shipped_date >= @extractstart
                        AND first_shipped_date < @extractend
                THEN
                    1
                ELSE 0
            END 'shipped_flag',
            CASE
                WHEN
                    order_date >= @extractstart
                        AND order_date < @extractend
                THEN
                    1
                ELSE 0
            END 'ordered_flag',
            CASE
                WHEN level1 = 'Fashion' THEN 'fashion'
                WHEN level1 = 'Computers & Laptops' THEN 'electronic'
                WHEN level1 = 'Cameras' THEN 'electronic'
                WHEN level1 = 'Mobiles & Tablets' THEN 'electronic'
                WHEN level1 = 'TV, Audio / Video, Gaming & Wearables' THEN 'electronic'
                WHEN level1 = 'Baby & Toddler' THEN 'fmcg'
                WHEN level1 = 'Travel & Luggage' THEN 'fashion'
                WHEN level1 = 'Groceries' THEN 'fmcg'
                WHEN level1 = 'Health & Beauty' THEN 'fmcg'
                WHEN level1 = 'Home & Living' THEN 'home'
                WHEN level1 = 'Home Appliances' THEN 'home'
                WHEN level1 = 'Media, Music & Books' THEN 'others'
                WHEN level1 = 'Motors' THEN 'motors'
                WHEN level1 = 'Pet Supplies' THEN 'fmcg'
                WHEN level1 = 'Sports & Outdoors' THEN 'fashion'
                WHEN level1 = 'Toys & Games' THEN 'fmcg'
                WHEN level1 = 'Vouchers and Services' THEN 'others'
                WHEN level1 = 'Watches Sunglasses Jewellery' THEN 'fashion'
                ELSE 'others'
            END 'category',
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv',
            unit_price / 1.1 'price',
            - marketplace_commission_fee / 1.1 'commission',
            CASE
                WHEN tax_class = 'international' THEN (0.020 * IFNULL(unit_price, 0))
                ELSE (0.013 * IFNULL(unit_price, 0))
            END / 1.1 'payment_fee',
            IF(coupon_type = 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) + cart_rule_discount 'discount'
    FROM
        scglv3.anondb_calculate ac
    LEFT JOIN seller_mapping.catalog_config cc ON SUBSTRING_INDEX(ac.sku, '-', 1) = cc.sku
    LEFT JOIN scglv3.category_tree ct ON cc.primary_category = ct.id_primary_category
    LEFT JOIN seller_mapping.catalog_brand cb ON cc.fk_catalog_brand = cb.id_catalog_brand
    LEFT JOIN seller_mapping.brand_partnership bpr ON ac.bob_id_supplier = bpr.id_supplier
        AND cb.id_catalog_brand = bpr.fk_catalog_brand
        AND ct.level1 = bpr.catalog_category
    WHERE
        (delivered_date >= @extractstart
            AND delivered_date < @extractend)
            OR (not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend)
            OR (first_shipped_date >= @extractstart
            AND first_shipped_date < @extractend)
            OR (order_date >= @extractstart
            AND order_date < @extractend)
    GROUP BY ac.bob_id_sales_order_item
    HAVING pass = 1) ac
    GROUP BY bu, p , fbl_flag , category , payment_method , ordered_flag , shipped_flag , delivered_flag , failed_flag) ac) ac