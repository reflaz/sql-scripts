echo off
setlocal enabledelayedexpansion

"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "truncate table scglv3_qv.category_general_commission ;" -u Recon
echo TRUNCATE scglv3_qv.category_general_commission DONE
echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "load data local infile '"!new!"' IGNORE into table scglv3_qv.category_general_commission COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u Recon
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "select count(*) AS 'Total Imported Data' from scglv3_qv.category_general_commission ;" -u Recon

pause