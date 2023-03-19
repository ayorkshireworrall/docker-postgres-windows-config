mkdir -p ../backup_dumps

echo Creating sql backup from container $DOCKER_PG_NAME
docker exec -t $DOCKER_PG_NAME pg_dumpall -U root -f schema-backup.sql

echo Enter a name for the persisted SQL file ignoring the .sql extension: 
read FILE_NAME
echo Persisting schema backup from $DOCKER_PG_NAME to file backup_dumps/$FILE_NAME.sql
docker cp $DOCKER_PG_NAME:/schema-backup.sql ../backup_dumps/$FILE_NAME.sql

echo Backup Completed