echo off
setlocal enabledelayedexpansion

echo.

"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "truncate table lel_invoice_tracker.lel_invoice ;" -u Recon 
echo TRUNCATE lel_invoice_tracker.lel_invoice DONE
echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "load data local infile '"!new!"' IGNORE into table lel_invoice_tracker.lel_invoice COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u Recon 
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "select count(*) AS 'Total Imported Data' from lel_invoice_tracker.lel_invoice ;" -u Recon 

pause