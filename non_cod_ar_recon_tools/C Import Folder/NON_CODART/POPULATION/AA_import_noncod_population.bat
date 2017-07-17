echo off
setlocal enabledelayedexpansion

echo.

"C:\Program Files\MySQL\MySQL Workbench 6.3 CE\mysql" -e "truncate table non_cod_recon.ar_population ;" -u Recon 
echo TRUNCATE non_cod_recon.ar_population DONE
echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Workbench 6.3 CE\mysql" -e "load data local infile '"!new!"' IGNORE into table non_cod_recon.ar_population COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u Recon 
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Workbench 6.3 CE\mysql" -e "select count(*) AS 'Total Imported Data' from non_cod_recon.ar_population ;" -u Recon 

pause