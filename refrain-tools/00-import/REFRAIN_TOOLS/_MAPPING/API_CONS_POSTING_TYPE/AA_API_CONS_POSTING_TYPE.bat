echo off
setlocal enabledelayedexpansion

echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "load data local infile '"!new!"' IGNORE into table refrain.api_cons_posting_type COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u Recon
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "select count(*) AS 'Total Imported Data' from refrain.api_cons_posting_type ;" -u Recon

pause