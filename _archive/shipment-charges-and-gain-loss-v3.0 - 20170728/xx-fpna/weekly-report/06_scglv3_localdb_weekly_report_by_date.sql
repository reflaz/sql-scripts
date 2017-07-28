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

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-07-01';
SET @extractend = '2017-07-17';-- This MUST be D + 1

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
        SUM(IF(ordered_flag = 1, orders, 0)) 'Total Order (Ordered)',
            SUM(IF(delivered_flag = 1, orders, 0)) 'Total Order (Delivered)',
            SUM(IF(delivered_flag = 1 AND bu = 'MA', orders, 0)) 'Order MA',
            SUM(IF(delivered_flag = 1 AND bu = 'MA' AND vip_flag = 1, orders, 0)) 'Order MA VIP',
            SUM(IF(delivered_flag = 1 AND bu = 'MA' AND vip_flag = 0, orders, 0)) 'Order MA Non VIP',
            SUM(IF(delivered_flag = 1 AND bu = 'DB', orders, 0)) 'Order DB',
            SUM(IF(delivered_flag = 1 AND bu = 'CB', orders, 0)) 'Order CB',
            SUM(IF(delivered_flag = 1 AND bu = 'Retail', orders, 0)) 'Order Retail',
            SUM(IF(delivered_flag = 1 AND bu = 'Digital', orders, 0)) 'Order Digital',
            
            
            
            SUM(IF(delivered_flag = 1, item, 0)) 'Total Item',
            SUM(IF(delivered_flag = 1 AND bu = 'MA', item, 0)) 'Item MA',
            SUM(IF(delivered_flag = 1 AND bu = 'MA' AND vip_flag = 1, item, 0)) 'Item MA VIP',
            SUM(IF(delivered_flag = 1 AND bu = 'MA' AND vip_flag = 0, item, 0)) 'Item MA Non VIP',
            SUM(IF(delivered_flag = 1 AND bu = 'DB', item, 0)) 'Item DB',
            SUM(IF(delivered_flag = 1 AND bu = 'CB', item, 0)) 'Item CB',
            SUM(IF(delivered_flag = 1 AND bu = 'Retail', item, 0)) 'Item Retail',
            SUM(IF(delivered_flag = 1 AND bu = 'Digital', item, 0)) 'Item Digital',
            
            
            
            SUM(IF(failed_flag = 1 AND bu = 'MA' AND vip_flag = 1, item, 0)) 'Failed Item MA VIP',
            SUM(IF(failed_flag = 1 AND bu = 'MA' AND vip_flag = 0, item, 0)) 'Failed Item MA Non VIP',
            SUM(IF(failed_flag = 1 AND bu = 'Retail', item, 0)) 'Failed Item Retail',
            
            
            
            SUM(IF(delivered_flag = 1, parcels, 0)) 'Total Parcel',
            SUM(IF(delivered_flag = 1 AND bu = 'MA', parcels, 0)) 'Parcel MA',
            SUM(IF(delivered_flag = 1 AND bu = 'DB', parcels, 0)) 'Parcel DB',
            SUM(IF(delivered_flag = 1 AND bu = 'CB', parcels, 0)) 'Parcel CB',
            SUM(IF(delivered_flag = 1 AND bu = 'Retail', parcels, 0)) 'Parcel Retail',
            SUM(IF(delivered_flag = 1 AND bu = 'Digital', parcels, 0)) 'Parcel Digital',
            
            
            
            SUM(IF(shipped_flag = 1, nmv, 0)) 'Total GMV (Shipment Date)',
            SUM(IF(shipped_flag = 1 AND bu = 'MA' AND vip_flag = 1, nmv, 0)) 'GMV MA VIP',
            SUM(IF(shipped_flag = 1 AND bu = 'MA' AND vip_flag = 0, nmv, 0)) 'GMV MA Non VIP',
            SUM(IF(shipped_flag = 1 AND bu = 'DB', nmv, 0)) 'GMV DB',
            SUM(IF(shipped_flag = 1 AND bu = 'CB', nmv, 0)) 'GMV CB',
            SUM(IF(shipped_flag = 1 AND bu = 'Retail', nmv, 0)) 'GMV Retail',
            SUM(IF(shipped_flag = 1 AND bu = 'Digital', nmv, 0)) 'GMV Digital',
            
            
            
            SUM(IF(ordered_flag = 1, nmv, 0)) 'Total NMV (Creation Date)',
            SUM(IF(ordered_flag = 1 AND bu = 'MA' AND vip_flag = 1, nmv, 0)) 'NMV MA VIP Created',
            SUM(IF(ordered_flag = 1 AND bu = 'MA' AND vip_flag = 0, nmv, 0)) 'NMV MA Non VIP Created',
            SUM(IF(ordered_flag = 1 AND bu = 'DB', nmv, 0)) 'NMV DB Created',
            SUM(IF(ordered_flag = 1 AND bu = 'CB', nmv, 0)) 'NMV CB Created',
            SUM(IF(ordered_flag = 1 AND bu = 'Retail', nmv, 0)) 'NMV Retail Created',
            SUM(IF(ordered_flag = 1 AND bu = 'Digital', nmv, 0)) 'NMV Digital Created',
            
            
            
            SUM(IF(delivered_flag = 1, nmv, 0)) 'Total NMV (Delivered Date)',
            SUM(IF(delivered_flag = 1 AND bu = 'MA' AND vip_flag = 1, nmv, 0)) 'NMV MA VIP Delivered',
            SUM(IF(delivered_flag = 1 AND bu = 'MA' AND vip_flag = 0, nmv, 0)) 'NMV MA Non VIP Delivered',
            SUM(IF(delivered_flag = 1 AND bu = 'DB', nmv, 0)) 'NMV DB Delivered',
            SUM(IF(delivered_flag = 1 AND bu = 'CB', nmv, 0)) 'NMV CB Delivered',
            SUM(IF(delivered_flag = 1 AND bu = 'Retail', nmv, 0)) 'NMV Retail Delivered',
            SUM(IF(delivered_flag = 1 AND bu = 'Digital', nmv, 0)) 'NMV Digital Delivered',
            
            
            
            SUM(IF(delivered_flag = 1 AND payment_method = 'cod', nmv, 0)) 'NMV COD',
            SUM(IF(delivered_flag = 1 AND payment_method = 'non_cod', nmv, 0)) 'NMV Non COD',
                
                
                
            SUM(IF(delivered_flag = 1 AND category = 'electronic', nmv, 0)) 'NMV EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion', nmv, 0)) 'NMV Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg', nmv, 0)) 'NMV FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home', nmv, 0)) 'NMV Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors', nmv, 0)) 'NMV Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others', nmv, 0)) 'NMV Others',
                
                
                
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) 'MP Commission EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) 'MP Commission Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) 'MP Commission FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) 'MP Commission Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) 'MP Commission Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) 'MP Commission Others',
                
                
                
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) 'MP NMV EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) 'MP NMV Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) 'MP NMV FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) 'MP NMV Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) 'MP NMV Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) 'MP NMV Others',
                
                
                
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) '% MP Commission EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) '% MP Commission Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) '% MP Commission FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home'AND (bu = 'MA' OR bu = 'DB'), commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) '% MP Commission Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) '% MP Commission Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND (bu = 'MA' OR bu = 'DB'), commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND (bu = 'MA' OR bu = 'DB'), nmv, 0)) '% MP Commission Others',
            
            
            
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'CB', commission, 0)) 'CB Commission EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'CB', commission, 0)) 'CB Commission Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'CB', commission, 0)) 'CB Commission FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'CB', commission, 0)) 'CB Commission Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'CB', commission, 0)) 'CB Commission Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'CB', commission, 0)) 'CB Commission Others',
                
                
                
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'CB', nmv, 0)) 'CB NMV EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'CB', nmv, 0)) 'CB NMV Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'CB', nmv, 0)) 'CB NMV FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'CB', nmv, 0)) 'CB NMV Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'CB', nmv, 0)) 'CB NMV Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'CB', nmv, 0)) 'CB NMV Others',
                
                
                
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'CB', nmv, 0)) '% CB Commission EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'CB', nmv, 0)) '% CB Commission Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'CB', nmv, 0)) '% CB Commission FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'CB', nmv, 0)) '% CB Commission Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'CB', nmv, 0)) '% CB Commission Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'CB', commission, 0)) / 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'CB', nmv, 0)) '% CB Commission Others',
                
                
                
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'Retail', cogs, 0)) 'Retail Margin EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'Retail', cogs, 0)) 'Retail Margin Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'Retail', cogs, 0)) 'Retail Margin FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'Retail', cogs, 0)) 'Retail Margin Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'Retail', cogs, 0)) 'Retail Margin Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'Retail', cogs, 0)) 'Retail Margin Others',
                
                
                
            SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'Retail', nmv, 0)) 'Retail NMV EL',
            SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'Retail', nmv, 0)) 'Retail NMV Fashion',
            SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'Retail', nmv, 0)) 'Retail NMV FMCG',
            SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'Retail', nmv, 0)) 'Retail NMV Home',
            SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'Retail', nmv, 0)) 'Retail NMV Motors',
            SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'Retail', nmv, 0)) 'Retail NMV Others',
                
                
                
            (SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'electronic' AND bu = 'Retail', nmv, 0)) '% Retail Margin EL',
            (SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'fashion' AND bu = 'Retail', nmv, 0)) '% Retail Margin Fashion',
            (SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'fmcg' AND bu = 'Retail', nmv, 0)) '% Retail Margin FMCG',
            (SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'home' AND bu = 'Retail', nmv, 0)) '% Retail Margin Home',
            (SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'motors' AND bu = 'Retail', nmv, 0)) '% Retail Margin Motors',
            (SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'Retail', price, 0)) - 
				SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'Retail', cogs, 0))) / 
                SUM(IF(delivered_flag = 1 AND category = 'others' AND bu = 'Retail', nmv, 0)) '% Retail Margin Others',
                
                
                
            SUM(IF(delivered_flag = 1 AND bu = 'MA' AND vip_flag = 1, commission, 0)) 'MA VIP Commission',
            SUM(IF(delivered_flag = 1 AND bu = 'MA' AND vip_flag = 0, commission, 0)) 'MA Non VIP Commission',
            SUM(IF(delivered_flag = 1 AND bu = 'DB', commission, 0)) 'DB Commission',
            SUM(IF(delivered_flag = 1 AND bu = 'Digital', commission, 0)) 'Digital Commission',
            SUM(IF(delivered_flag = 1 AND bu = 'CB', commission, 0)) 'CB Commission',
            
            
            
            0 'MP Local Pricing Subsidy',
            0 'CB Pricing Subsidy',
            
            
            
            SUM(IF(bu = 'MA' AND vip_flag = 1 AND (delivered_flag = 1 OR failed_flag = 1), seller_charges, 0)) 'Seller Charges MA VIP',
            SUM(IF(bu = 'MA' AND vip_flag = 0 AND (delivered_flag = 1 OR failed_flag = 1), seller_charges, 0)) 'Seller Charges MA Non VIP',
            SUM(IF(bu = 'MA' AND vip_flag = 1 AND delivered_flag = 1, customer_charges, 0)) 'Customer Charges MA VIP',
            SUM(IF(bu = 'MA' AND vip_flag = 0 AND delivered_flag = 1, customer_charges, 0)) 'Customer Charges MA Non VIP',
                
                
                
            - GREATEST(SUM(IF(bu = 'MA' AND vip_flag = 1 AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(bu = 'MA' AND vip_flag = 1 AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) 'Delivery Cost MA VIP',
            - GREATEST(SUM(IF(bu = 'MA' AND vip_flag = 0 AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(bu = 'MA' AND vip_flag = 0 AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) 'Delivery Cost MA NON VIP',
            - GREATEST(SUM(IF(bu = 'MA' AND vip_flag = 1 AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)), 
				SUM(IF(bu = 'MA' AND vip_flag = 1 AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0))) 'Pickup Cost MA VIP',
            - GREATEST(SUM(IF(bu = 'MA' AND vip_flag = 0 AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)), 
				SUM(IF(bu = 'MA' AND vip_flag = 0 AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0))) 'Pickup Cost MA Non VIP',
            - GREATEST(SUM(IF(bu = 'MA' AND vip_flag = 1 AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(bu = 'MA' AND vip_flag = 1 AND failed_flag = 1, shipment_cost, 0))) 'FD Cost MA VIP',
            - GREATEST(SUM(IF(bu = 'MA' AND vip_flag = 0 AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(bu = 'MA' AND vip_flag = 0 AND failed_flag = 1, shipment_cost, 0))) 'FD Cost MA Non VIP',
                
                
                
            - SUM(IF(bu = 'MA' AND vip_flag = 1 AND delivered_flag = 1, return_cost, 0)) 'Return Cost MA VIP',
            - SUM(IF(bu = 'MA' AND vip_flag = 0 AND delivered_flag = 1, return_cost, 0)) 'Return Cost MA Non VIP',
                
                
                
            SUM(IF(bu = 'DB' AND delivered_flag = 1, seller_charges, 0)) 'Seller Charges DB',
            SUM(IF(bu = 'DB' AND delivered_flag = 1, customer_charges, 0)) 'Customer Charges DB',
            - SUM(IF(bu = 'DB' AND delivered_flag = 1, delivery_cost, 0)) 'Delivery Cost DB',
            - SUM(IF(bu = 'DB' AND delivered_flag = 1, return_cost, 0)) 'DB Return Cost',
            
            
            
            SUM(IF(bu = 'MA' AND vip_flag = 1 AND delivered_flag = 1, payment_fee, 0)) 'Payment Charges MA VIP',
            SUM(IF(bu = 'MA' AND vip_flag = 0 AND delivered_flag = 1, payment_fee, 0)) 'Payment Charges MA Non VIP',
            SUM(IF(bu = 'DB' AND delivered_flag = 1, payment_fee, 0)) 'Payment Charges DB',
            SUM(IF(bu = 'Digital' AND delivered_flag = 1, payment_fee, 0)) 'Payment Charges Digital',
            0 'Payment Charges Retail',
            SUM(IF(bu = 'CB' AND delivered_flag = 1, payment_fee, 0)) 'CB Payment Charges',
            SUM(IF(bu = 'CB' AND (delivered_flag = 1 OR failed_flag = 1), cb_charges, 0)) 'CB Delivery Charges',
                
                
                
            SUM(IF(bu = 'MA' AND vip_flag = 1 AND delivered_flag = 1, other_charges, 0)) 'Other Charges MA VIP',
            SUM(IF(bu = 'MA' AND vip_flag = 0 AND delivered_flag = 1, other_charges, 0)) 'Other Charges MA Non VIP',
            SUM(IF(bu = 'DB' AND delivered_flag = 1, other_charges, 0)) 'Other Charges DB',
            SUM(IF(bu = 'Digital' AND delivered_flag = 1, other_charges, 0)) 'Other Charges Digital',
            SUM(IF(bu = 'CB' AND delivered_flag = 1, other_charges, 0)) 'Other Charges CB',
            
            
            
            SUM(IF(bu = 'Retail' AND delivered_flag = 1, price, 0)) 'Retail Unit Price',
            SUM(IF(bu = 'Retail' AND delivered_flag = 1, customer_charges, 0)) 'Retail Shipping Fee',
            
            
            
            @marketing_revenue_base * @day_accrual_basis 'Marketing Revenue',
            
            
            
            - SUM(IF(bu = 'Retail' AND delivered_flag = 1, cogs, 0)) 'Retail COGS',
            0 'Backmargin',
            - SUM(IF(bu = 'Retail' AND delivered_flag = 1, allowance_bad_goods, 0)) 'Allowance for Bad Goods',
            
            
            
            - @wh_handling_retail * SUM(IF(bu = 'Retail' AND shipped_flag = 1, item, 0)) 'WH Handling - Retail',
            - @wh_handling_fbl * SUM(IF((bu = 'MA' OR bu = 'DB') AND shipped_flag = 1 AND fbl_flag = 1, item, 0)) 'WH Handling - FBL',
                
                
                
            - GREATEST(SUM(IF(bu = 'CB' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(bu = 'CB' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) 'CB Delivery Cost',
            - SUM(IF(delivered_flag = 1 AND bu = 'CB', return_cost, 0)) 'CB Return Cost',
            - GREATEST(SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) 'Retail Delivery Cost',
            - GREATEST(SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost, 0))) 'Retail FD Cost',
            - SUM(IF(bu = 'Retail' AND delivered_flag = 1, return_cost, 0)) 'Retail Return Cost',
            
            
            SUM(''),
            
            0 'Payment Cost COD - MA VIP',
            0 'Payment Cost COD - MA Non VIP',
            0 'Payment Cost COD - DB',
            0 'Payment Cost COD - CB',
            0 'Payment Cost COD - Digital',
            0 'Payment Cost COD - Retail',
            
            
            
            0 'Payment Cost Non COD - MA VIP',
            0 'Payment Cost Non COD - MA Non VIP',
            0 'Payment Cost Non COD - DB',
            0 'Payment Cost Non COD - CB',
            0 'Payment Cost Non COD - Digital',
            0 'Payment Cost Non COD - Retail',
            
            
            
            - SUM(IF(bu = 'MA' AND vip_flag = 1 AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt MA VIP',
            - SUM(IF(bu = 'MA' AND vip_flag = 0 AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt MA Non VIP',
            - SUM(IF(bu = 'DB' AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt DB',
            - SUM(IF(bu = 'Digital' AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt Digital',
            - SUM(IF(bu = 'CB' AND delivered_flag = 1, bad_debt, 0)) 'Bad Debt CB',
            
            
            
            0 'CS Cost',
            - SUM(IF(bu = 'Retail' AND delivered_flag = 1, discount, 0)) 'Retail Voucher & Cart Rule',
            - SUM(IF(bu = 'MA' AND vip_flag = 1 AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule MA VIP',
            - SUM(IF(bu = 'MA' AND vip_flag = 0 AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule MA Non VIP',
            - SUM(IF(bu = 'DB' AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule DB',
            - SUM(IF(bu = 'Digital' AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule Digital',
            - SUM(IF(bu = 'CB' AND delivered_flag = 1, discount, 0)) 'Voucher & Cart Rule CB',
            
            
            
###########################################################################################################################################################################
		/*Lines below are for cost per item*/
###########################################################################################################################################################################
            
            
            
            SUM(IF(bu = 'Digital' AND ordered_flag = 1, item, 0)) '_Item Ordered Digital',
            SUM(IF(bu = 'Digital' AND shipped_flag = 1, item, 0)) '_Item Shipped Digital',
            SUM(IF(bu = 'Digital' AND delivered_flag = 1, item, 0)) '_Item Delivered Digital',
            SUM(IF(bu = 'Digital' AND failed_flag = 1, item, 0)) '_Item Failed Digital',
            
            
            
            SUM(IF(bu = 'MA' AND ordered_flag = 1, item, 0)) '_Item Ordered MA',
            SUM(IF(bu = 'MA' AND shipped_flag = 1, item, 0)) '_Item Shipped MA',
            SUM(IF(bu = 'MA' AND delivered_flag = 1, item, 0)) '_Item Delivered MA',
            SUM(IF(bu = 'MA' AND failed_flag = 1, item, 0)) '_Item Failed MA',
            
            
            
            /*SUM(if (bu = 'MA'AND ordered_flag = 1 AND vip_flag = 1,item,0)) '_Item Ordered MA VIP',
			SUM(if (bu = 'MA'AND shipped_flag = 1 AND vip_flag = 1,item,0)) '_Item Shipped MA VIP',
			SUM(if (bu = 'MA'AND delivered_flag = 1 AND vip_flag = 1,item,0)) '_Item Delivered MA VIP',
			SUM(if (bu = 'MA'AND failed_flag = 1 AND vip_flag = 1,item,0)) '_Item Failed MA VIP',
			
            
            
			SUM(if (bu = 'MA'AND ordered_flag = 1 AND vip_flag = 0,item,0)) '_Item Ordered MA Non VIP',
			SUM(if (bu = 'MA'AND shipped_flag = 1 AND vip_flag = 0,item,0)) '_Item Shipped MA Non VIP',
			SUM(if (bu = 'MA'AND delivered_flag = 1 AND vip_flag = 0,item,0)) '_Item Delivered MA Non VIP',
			SUM(if (bu = 'MA'AND failed_flag = 1 AND vip_flag = 0,item,0)) '_Item Failed MA Non VIP',*/
            
            
            
            SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), seller_charges, 0)) / 
				SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Seller Charges per Item MA',
            SUM(IF(bu = 'MA' AND delivered_flag = 1, customer_charges, 0)) / 
				SUM(IF(bu = 'MA' AND delivered_flag = 1, item, 0)) '_Customer Charges per Item MA',
            
            
            
            - GREATEST(SUM(IF(bu = 'MA'
                AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), SUM(IF(bu = 'MA'
                AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) / SUM(IF(bu = 'MA'
                AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item MA',
                
                
                
            - SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0)) / 
				SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item MA Script',
            - SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)) / 
				SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item MA Invoice',
                
                
                
            - GREATEST(SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)), 
				SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0))) / 
                SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item MA',
            - SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_temp, 0)) / 
				SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item MA Script',
            - SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), pickup_cost_invoice, 0)) / 
				SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Pickup Cost per Item MA Invoice',
                
                
                
            - GREATEST(SUM(IF(bu = 'MA' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(bu = 'MA' AND failed_flag = 1, shipment_cost, 0))) / 
				SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost MA per Item (Mix)',
            - SUM(IF(bu = 'MA' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost MA per Item Script (Mix)',
            - SUM(IF(bu = 'MA' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(bu = 'MA' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost MA per Item Invoice (Mix)',
                
                
                
            - GREATEST(SUM(IF(bu = 'MA' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(bu = 'MA' AND failed_flag = 1, shipment_cost, 0))) / 
				SUM(IF(bu = 'MA' AND failed_flag = 1, item, 0)) '_FD Cost MA per Item (FD Only)',
            - SUM(IF(bu = 'MA' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(bu = 'MA' AND failed_flag = 1, item, 0)) '_FD Cost MA per Item Script (FD Only)',
            - SUM(IF(bu = 'MA' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(bu = 'MA' AND failed_flag = 1, item, 0)) '_FD Cost MA per Item Invoice (FD Only)',
            
            
            
            SUM(IF(bu = 'DB' AND ordered_flag = 1, item, 0)) '_Item Ordered DB',
            SUM(IF(bu = 'DB' AND shipped_flag = 1, item, 0)) '_Item Shipped DB',
            SUM(IF(bu = 'DB' AND delivered_flag = 1, item, 0)) '_Item Delivered DB',
            SUM(IF(bu = 'DB' AND failed_flag = 1, item, 0)) '_Item Failed DB',
            
            
            
            - SUM(IF(bu = 'DB' AND delivered_flag = 1, delivery_cost, 0)) / 
				SUM(IF(bu = 'DB' AND delivered_flag = 1, item, 0)) '_Delivery Cost per Item DB',
            SUM(IF(bu = 'DB' AND delivered_flag = 1, seller_charges, 0)) / 
				SUM(IF(bu = 'DB' AND delivered_flag = 1, item, 0)) '_Seller Charges per Item DB',
            SUM(IF(bu = 'DB' AND delivered_flag = 1, customer_charges, 0)) / 
				SUM(IF(bu = 'DB' AND delivered_flag = 1, item, 0)) '_Customer Charges per Item DB',
            
            
            
            SUM(IF(bu = 'Retail' AND ordered_flag = 1, item, 0)) '_Item Ordered Retail',
            SUM(IF(bu = 'Retail' AND shipped_flag = 1, item, 0)) '_Item Shipped Retail',
            SUM(IF(bu = 'Retail' AND delivered_flag = 1, item, 0)) '_Item Delivered Retail',
            SUM(IF(bu = 'Retail' AND failed_flag = 1, item, 0)) '_Item Failed Retail',
            
            
            
            - GREATEST(SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)), 
				SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0))) / 
				SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item Retail',
            - SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost_invoice, 0)) / 
				SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item Retail Invoice',
            - SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), delivery_cost, 0)) / 
				SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_Delivery Cost per Item Retail Script',
            
            
            
            SUM(IF(bu = 'Retail' AND delivered_flag = 1, customer_charges, 0)) / 
				SUM(IF(bu = 'Retail' AND delivered_flag = 1, item, 0)) '_Customer Charges per Item Retail',
            
            
            
            - GREATEST(SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost, 0))) / 
				SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost per Item Retail (Mix)',
            - SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost per Item Retail Invoice (Mix)',
            - SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(bu = 'Retail' AND (delivered_flag = 1 OR failed_flag = 1), item, 0)) '_FD Cost per Item Retail Script (Mix)',
            
            
            
            - GREATEST(SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost_invoice, 0)), 
				SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost, 0))) / 
                SUM(IF(bu = 'Retail' AND failed_flag = 1, item, 0)) '_FD Cost per Item Retail (FD Only)',
            - SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost_invoice, 0)) / 
				SUM(IF(bu = 'Retail' AND failed_flag = 1, item, 0)) '_FD Cost per Item Retail Invoice (FD Only)',
            - SUM(IF(bu = 'Retail' AND failed_flag = 1, shipment_cost, 0)) / 
				SUM(IF(bu = 'Retail' AND failed_flag = 1, item, 0)) '_FD Cost per Item Retail Script (FD Only)',
                
                
                
            - @return_cost_per_item_ma 'Return Cost per Item MA',
            - @return_cost_per_item_db 'Return Cost per Item DB',
            - @return_cost_per_item_retail 'Return Cost per Item Retail',
            - @cb_delivery_cost 'Delivery Cost per Item CB',
            - @cb_delivery_charge 'Delivery Charges per Item CB',
            - @return_cost_per_item_cb 'Return Cost per Item CB',
            - @wh_handling_retail 'WH Handling Cost per Item Retail',
            - @wh_handling_fbl 'WH Handling Cost per Item FBL',
            - @cs_rate 'CS Cost per Order'
    FROM
        (SELECT 
        bu,
            category,
            payment_method_temp 'payment_method',
            vip_flag,
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
                WHEN bu = 'CB' THEN @cb_delivery_cost * COUNT(bob_id_sales_order_item)
                WHEN bu = 'MA' THEN SUM(IFNULL(delivery_cost_item, 0) + IFNULL(delivery_cost_discount_item, 0) + IFNULL(delivery_cost_vat_item, 0) + IFNULL(insurance_3pl_item, 0) + IFNULL(insurance_vat_3pl_item, 0))
                ELSE SUM(IFNULL(total_delivery_cost_item, 0))
            END 'delivery_cost',
            CASE
                WHEN bu = 'CB' THEN @cb_delivery_cost * COUNT(bob_id_sales_order_item)
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
                WHEN bu = 'CB' THEN @return_cost_per_item_cb * COUNT(bob_id_sales_order_item)
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
                WHEN bu = 'CB' THEN @cb_delivery_charge * COUNT(bob_id_sales_order_item)
                ELSE 0
            END 'cb_charges',
            SUM(IFNULL(shipment_fee_mp_seller_item, 0) + IFNULL(insurance_seller_item, 0) + IFNULL(insurance_vat_seller_item, 0)) 'seller_charges',
            SUM((IFNULL(shipping_amount, 0) + IFNULL(shipping_surcharge, 0)) / IF(is_marketplace = 0, 1.1, 1)) 'customer_charges',
            @other_charges_rate * SUM(IFNULL(nmv, 0)) 'other_charges',
            SUM(IFNULL(discount, 0)) 'discount',
            @bad_debt_rate * SUM(IFNULL(nmv, 0)) 'bad_debt'
    FROM
        (SELECT 
        ac.*,
            ct.level1,
            ct.level2,
            ct.level3,
            ct.level4,
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
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
                    shipment_scheme LIKE ('%EXPRESS%')
                        OR shipment_scheme LIKE ('%FBL%')
                THEN
                    CASE
                        WHEN tax_class = 'international' THEN 'CB'
                        WHEN is_marketplace = 0 THEN 'Retail'
                        ELSE 'MA'
                    END
            END 'bu',
            CASE
                WHEN campaign LIKE '%VIP%' THEN 1
                ELSE 0
            END 'vip_flag',
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
    LEFT JOIN scglv3.category_tree ct ON ac.primary_category = ct.id_primary_category
	WHERE
		(delivered_date >= @extractstart AND delivered_date < @extractend)
			OR (not_delivered_date >= @extractstart AND not_delivered_date < @extractend)
			OR (first_shipped_date >= @extractstart AND first_shipped_date < @extractend)
			OR (order_date >= @extractstart AND order_date < @extractend)
	HAVING pass = 1) ac
    GROUP BY bu , category , payment_method , ordered_flag , shipped_flag , delivered_flag , failed_flag , fbl_flag , vip_flag) ac) ac