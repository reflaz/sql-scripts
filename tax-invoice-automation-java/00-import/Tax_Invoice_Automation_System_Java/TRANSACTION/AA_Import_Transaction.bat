echo off
setlocal enabledelayedexpansion

"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "truncate table tias_java.transaction ;" -u update_recon
echo TRUNCATE tias_java.transaction DONE
echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "load data local infile '"!new!"' IGNORE into table tias_java.transaction COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u update_recon
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "select count(*) AS 'Total Imported Data' from tias_java.transaction ;" -u Recon

pause