@echo off
if not exist ../backup_dumps mkdir ../backup_dumps

echo.
echo Creating sql backup from container %DOCKER_PG_NAME%
docker exec -t %DOCKER_PG_NAME% pg_dumpall -U root -f schema-backup.sql

echo.
set /p FILE_NAME="Persisted SQL File Name: "
echo Persisting schema backup from %DOCKER_PG_NAME% to file ../backup_dumps/%FILE_NAME%.sql
docker cp %DOCKER_PG_NAME%:/schema-backup.sql ../backup_dumps/%FILE_NAME%.sql

echo.
echo Backup Completed