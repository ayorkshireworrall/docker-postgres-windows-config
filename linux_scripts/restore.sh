echo Enter name of file to restore from ignoring the .sql extension:
read FILE_NAME

echo Stopping and deleting existing container
docker stop $DOCKER_PG_NAME
docker rm $DOCKER_PG_NAME

echo Starting new container $DOCKER_PG_NAME
docker run -d -e POSTGRES_PASSWORD=sa -e POSTGRES_USER=root -e DOCKER_PG_DB=$DOCKER_PG_DB --name=$DOCKER_PG_NAME -p 5432:5432 postgres:14

echo Copying backup sql to new container
docker cp ../backup_dumps/$FILE_NAME.sql $DOCKER_PG_NAME:/schema-backup.sql
docker cp ../query_mode.sh $DOCKER_PG_NAME:/query_mode.sh

echo Executing init sql, run below command manually
echo ==============================================================================
echo docker exec -t $DOCKER_PG_NAME psql -U root -f schema-backup.sql
echo ==============================================================================