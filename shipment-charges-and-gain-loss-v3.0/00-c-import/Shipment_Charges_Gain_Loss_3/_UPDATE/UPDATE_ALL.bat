echo off
setlocal enabledelayedexpansion

echo.
echo ========================================deleting old mapping========================================
echo.

echo deleting campaign...
del /q "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN\*.csv"

echo deleting campaign mapping...
del /q "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN_MAPPING\*.csv"

echo deleting campaign shipment scheme...
del /q "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN_SHIPMENT_SCHEME\*.csv"

echo deleting campaign tracker...
del /q "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN_TRACKER\*.csv"

echo deleting category general commission...
del /q "C:\Shipment_Charges_Gain_Loss_3\CATEGORY_GENERAL_COMMISSION\*.csv"

echo deleting category tree...
del /q "C:\Shipment_Charges_Gain_Loss_3\CATEGORY_TREE\*.csv"

echo deleting charges scheme...
del /q "C:\Shipment_Charges_Gain_Loss_3\CHARGES_SCHEME\*.csv"

echo deleting insurance scheme...
del /q "C:\Shipment_Charges_Gain_Loss_3\INSURANCE_SCHEME\*.csv"

echo deleting payment cost mapping...
del /q "C:\Shipment_Charges_Gain_Loss_3\PAYMENT_COST_MAPPING\*.csv"

echo deleting rate card 3pl...
del /q "C:\Shipment_Charges_Gain_Loss_3\RATE_CARD_3PL\*.csv"

echo deleting rate card customer...
del /q "C:\Shipment_Charges_Gain_Loss_3\RATE_CARD_CUSTOMER\*.csv"

echo deleting rate card customer kg...
del /q "C:\Shipment_Charges_Gain_Loss_3\RATE_CARD_CUSTOMER_KG\*.csv"

echo deleting shipment scheme...
del /q "C:\Shipment_Charges_Gain_Loss_3\SHIPMENT_SCHEME\*.csv"

echo deleting tier mapping...
del /q "C:\Shipment_Charges_Gain_Loss_3\TIER_MAPPING\*.csv"

echo deleting weight threshold...
del /q "C:\Shipment_Charges_Gain_Loss_3\WEIGHT_THRESHOLD\*.csv"

echo deleting zone mapping...
del /q "C:\Shipment_Charges_Gain_Loss_3\ZONE_MAPPING\*.csv"

echo.
echo.

echo ========================================copying new mapping========================================

echo.
echo copying new campaign..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\campaign\*.csv" "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN\" >nul

echo copying new campaign mapping..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\campaign-mapping\*.csv" "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN_MAPPING\" >nul

echo copying new campaign shipment scheme..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\campaign-shipment-scheme\*.csv" "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN_SHIPMENT_SCHEME\" >nul

echo copying new campaign tracker..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\campaign-tracker\*.csv" "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN_TRACKER\" >nul

echo copying new category general commission..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\category-general-commission\*.csv" "C:\Shipment_Charges_Gain_Loss_3\CATEGORY_GENERAL_COMMISSION\" >nul

echo copying new category tree..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\category-tree\*.csv" "C:\Shipment_Charges_Gain_Loss_3\CATEGORY_TREE\" >nul

echo copying new charges scheme..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\charges-scheme\*.csv" "C:\Shipment_Charges_Gain_Loss_3\CHARGES_SCHEME\" >nul

echo copying new insurance scheme..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\insurance-scheme\*.csv" "C:\Shipment_Charges_Gain_Loss_3\INSURANCE_SCHEME\" >nul

echo copying new payment cost mapping..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\payment-cost-mapping\*.csv" "C:\Shipment_Charges_Gain_Loss_3\PAYMENT_COST_MAPPING\" >nul

echo copying new rate card 3pl..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\rate-card-3pl\*.csv" "C:\Shipment_Charges_Gain_Loss_3\RATE_CARD_3PL\" >nul

echo copying new rate card customer..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\rate-card-customer\*.csv" "C:\Shipment_Charges_Gain_Loss_3\RATE_CARD_CUSTOMER\" >nul

echo copying new rate card customer kg..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\rate-card-customer-kg\*.csv" "C:\Shipment_Charges_Gain_Loss_3\RATE_CARD_CUSTOMER_KG\" >nul

echo copying new shipment scheme..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\shipment-scheme\*.csv" "C:\Shipment_Charges_Gain_Loss_3\SHIPMENT_SCHEME\" >nul

echo copying new tier mapping..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\tier-mapping\*.csv" "C:\Shipment_Charges_Gain_Loss_3\TIER_MAPPING\" >nul

echo copying new weight threshold..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\weight-threshold\*.csv" "C:\Shipment_Charges_Gain_Loss_3\WEIGHT_THRESHOLD\" >nul

echo copying new zone mapping..
copy "C:\Shipment_Charges_Gain_Loss_3\_update\zone-mapping\*.csv" "C:\Shipment_Charges_Gain_Loss_3\ZONE_MAPPING\" >nul

echo.
echo.

echo ========================================importing new mapping========================================

echo.

cd "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN\"
call AA_Import_Campaign.bat

cd "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN_MAPPING\"
call AA_Import_Campaign_Mapping.bat

cd "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN_SHIPMENT_SCHEME\"
call AA_Import_Campaign_Shipment_Scheme.bat

cd "C:\Shipment_Charges_Gain_Loss_3\CAMPAIGN_TRACKER\"
call AA_Import_Campaign_Tracker.bat

cd "C:\Shipment_Charges_Gain_Loss_3\CATEGORY_GENERAL_COMMISSION\"
call AA_Import_General_Commission.bat

cd "C:\Shipment_Charges_Gain_Loss_3\CATEGORY_TREE\"
call AA_Import_Category_Tree.bat

cd "C:\Shipment_Charges_Gain_Loss_3\CHARGES_SCHEME\"
call AA_Import_Charges_Scheme.bat

cd "C:\Shipment_Charges_Gain_Loss_3\INSURANCE_SCHEME\"
call AA_Import_Insurance_Scheme.bat

cd "C:\Shipment_Charges_Gain_Loss_3\PAYMENT_COST_MAPPING\"
call AA_Import_Payment_Cost_Mapping.bat

cd "C:\Shipment_Charges_Gain_Loss_3\RATE_CARD_3PL\"
call AA_Import_Rate_Card.bat

cd "C:\Shipment_Charges_Gain_Loss_3\RATE_CARD_CUSTOMER\"
call AA_Import_Rate_Card_Customer.bat

cd "C:\Shipment_Charges_Gain_Loss_3\RATE_CARD_CUSTOMER_KG\"
call AA_Import_Rate_Card_Customer.bat

cd "C:\Shipment_Charges_Gain_Loss_3\SHIPMENT_SCHEME\"
call AA_Import_Shipment_Scheme.bat

cd "C:\Shipment_Charges_Gain_Loss_3\TIER_MAPPING\"
call AA_Import_Tier_Mapping.bat

cd "C:\Shipment_Charges_Gain_Loss_3\WEIGHT_THRESHOLD\"
call AA_Import_Weight_Threshold.bat

cd "C:\Shipment_Charges_Gain_Loss_3\ZONE_MAPPING\"
call AA_Import_Zone_Mapping.bat