echo off
setlocal enabledelayedexpansion

echo.

"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "truncate table scgl.free_zone ;" -u Recon
echo TRUNCATE scgl.free_zone DONE
echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "load data local infile '"!new!"' IGNORE into table scgl.free_zone COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u Recon
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "select count(*) AS 'Total Imported Data' from scgl.free_zone ;" -u Recon

pause