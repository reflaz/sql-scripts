echo off
setlocal enabledelayedexpansion

"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "truncate table zpcr.general_commission ;" -u update_recon
echo TRUNCATE zpcr.general_commission DONE
echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "load data local infile '"!new!"' IGNORE into table zpcr.general_commission COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u update_recon
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "select count(*) AS 'Total Imported Data' from zpcr.general_commission ;" -u Recon

pause