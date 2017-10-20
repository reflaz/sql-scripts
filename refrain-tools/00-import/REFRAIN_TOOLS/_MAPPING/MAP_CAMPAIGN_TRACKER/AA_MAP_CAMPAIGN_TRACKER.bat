echo off
setlocal enabledelayedexpansion

echo.

"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "truncate table refrain.map_campaign_tracker ;" -u Recon
echo TRUNCATE refrain.map_campaign_tracker DONE
echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "load data local infile '"!new!"' IGNORE into table refrain.map_campaign_tracker COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u Recon
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "select count(*) AS 'Total Imported Data' from refrain.map_campaign_tracker ;" -u Recon

pause