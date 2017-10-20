echo off
setlocal enabledelayedexpansion

echo.
echo ========================================deleting old mapping========================================
echo.

echo deleting old API CONS Charge Type mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\API_CONS_CHARGE_TYPE\*.csv" >nul

echo deleting old API CONS Posting Type mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\API_CONS_POSTING_TYPE\*.csv" >nul

echo deleting old API CONS Status mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\API_CONS_STATUS\*.csv" >nul

echo deleting old ASC Transaction Type mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\ASC_TRANSACTION_TYPE\*.csv" >nul

echo deleting old MAP Campaign mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN\*.csv" >nul

echo deleting old MAP Campaign Access mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN_ACCESS\*.csv" >nul

echo deleting old MAP Campaign Override mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN_OVERRIDE\*.csv" >nul

echo deleting old MAP Campaign Tracker mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN_TRACKER\*.csv" >nul

echo deleting old MAP Default Charges mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_DEFAULT_CHARGES\*.csv" >nul

echo deleting old MAP Default Insurance mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_DEFAULT_INSURANCE\*.csv" >nul

echo deleting old MAP Origin mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_ORIGIN_MAPPING\*.csv" >nul

echo deleting old MAP Rate Card 3PL mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_RATE_CARD_3PL\*.csv" >nul

echo deleting old MAP Shipment Scheme mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_SHIPMENT_SCHEME\*.csv" >nul

echo deleting old MAP Weight Threshold Seller mapping...
del /q "C:\REFRAIN_TOOLS\_MAPPING\MAP_WEIGHT_THRESHOLD_SELLER\*.csv" >nul

echo.
echo.

echo ========================================copying new mapping========================================

echo copying new API CONS Charge Type mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\api-cons-charge-type\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\API_CONS_CHARGE_TYPE\" >nul

echo copying new API CONS Posting Type mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\api-cons-posting-type\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\API_CONS_POSTING_TYPE\" >nul

echo copying new API CONS Status mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\api-cons-status\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\API_CONS_STATUS\" >nul

echo copying new ASC Transaction Type mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\asc-transaction-type\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\ASC_TRANSACTION_TYPE\" >nul

echo copying new MAP Campaign mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-campaign\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN\" >nul

echo copying new MAP Campaign Access mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-campaign-access\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN_ACCESS\" >nul

echo copying new MAP Campaign Override mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-campaign-override\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN_OVERRIDE\" >nul

echo copying new MAP Campaign Tracker mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-campaign-tracker\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN_TRACKER\" >nul

echo copying new MAP Default Charges mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-default-charges\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_DEFAULT_CHARGES\" >nul

echo copying new MAP Default Insurance mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-default-insurance\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_DEFAULT_INSURANCE\" >nul

echo copying new MAP Origin mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-origin-mapping\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_ORIGIN_MAPPING\" >nul

echo copying new MAP Rate Card 3PL mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-rate-card-3pl\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_RATE_CARD_3PL\" >nul

echo copying new MAP Shipment Scheme mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-shipment-scheme\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_SHIPMENT_SCHEME\" >nul

echo copying new MAP Weight Threshold Seller mapping...
copy "C:\REFRAIN_TOOLS\_MAPPING\_UPDATE_ALL_MAPPING\map-weight-threshold-seller\*.csv" "C:\REFRAIN_TOOLS\_MAPPING\MAP_WEIGHT_THRESHOLD_SELLER\" >nul

echo.
echo.

echo ========================================importing new mapping========================================

echo.

cd "C:\REFRAIN_TOOLS\_MAPPING\API_CONS_CHARGE_TYPE\"
call AA_API_CONS_CHARGE_TYPE.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\API_CONS_POSTING_TYPE\"
call AA_API_CONS_POSTING_TYPE.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\API_CONS_STATUS\"
call AA_API_CONS_STATUS.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\ASC_TRANSACTION_TYPE\"
call AA_ASC_TRANSACTION_TYPE.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN\"
call AA_MAP_CAMPAIGN.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN_ACCESS\"
call AA_MAP_CAMPAIGN_ACCESS.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN_OVERRIDE\"
call AA_MAP_CAMPAIGN_OVERRIDE.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_CAMPAIGN_TRACKER\"
call AA_MAP_CAMPAIGN_TRACKER.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_DEFAULT_CHARGES\"
call AA_MAP_DEFAULT_CHARGES.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_DEFAULT_INSURANCE\"
call AA_MAP_DEFAULT_INSURANCE.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_ORIGIN_MAPPING\"
call AA_MAP_ORIGIN_MAPPING.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_RATE_CARD_3PL\"
call AA_MAP_RATE_CARD_3PL.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_SHIPMENT_SCHEME\"
call AA_MAP_SHIPMENT_SCHEME.bat

cd "C:\REFRAIN_TOOLS\_MAPPING\MAP_WEIGHT_THRESHOLD_SELLER\"
call AA_MAP_WEIGHT_THRESHOLD_SELLER.bat