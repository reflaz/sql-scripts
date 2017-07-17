echo off
setlocal enabledelayedexpansion

echo.

"C:\Program Files\MySQL\MySQL Workbench 6.3 CE\mysql" -e "truncate table cod_ar_recon.incoming_ar ;" -u Recon 
echo TRUNCATE cod_ar_recon.incoming_ar DONE
echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Workbench 6.3 CE\mysql" -e "load data local infile '"!new!"' IGNORE into table cod_ar_recon.incoming_ar COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u Recon 
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Workbench 6.3 CE\mysql" -e "select count(*) AS 'Total Imported Data' from cod_ar_recon.incoming_ar ;" -u Recon 

pause