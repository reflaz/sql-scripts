echo off
setlocal enabledelayedexpansion

echo.

"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "truncate table scgl.category_tree ;" -u Recon
echo TRUNCATE scgl.category_tree DONE
echo.

FOR %%f IN ("*.csv") DO (
  set old=%%~dpnxf
  set new=!old:\=\\!

  "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "load data local infile '"!new!"' IGNORE into table scgl.category_tree COLUMNS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"""' IGNORE 1 ROWS" -u Recon
  echo IMPORT %%~nxf DONE
)

echo.
"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql" -e "select count(*) AS 'Total Imported Data' from scgl.category_tree ;" -u Recon

pause