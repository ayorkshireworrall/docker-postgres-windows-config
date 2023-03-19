@echo off
docker stop %DOCKER_PG_NAME%

docker rm %DOCKER_PG_NAME%

docker run -d -e POSTGRES_PASSWORD=sa -e POSTGRES_USER=root -e DOCKER_PG_DB=%DOCKER_PG_DB% --name=%DOCKER_PG_NAME% -p 5432:5432 postgres:%DOCKER_PG_VERSION%

docker cp ../init.sql %DOCKER_PG_NAME%:/init.sql
docker cp ../query_mode.sh %DOCKER_PG_NAME%:/query_mode.sh

echo Executing init sql (this command doesn't work from bat file, please copy the below text and execute manually)
echo ==============================================================================
echo docker exec -t %DOCKER_PG_NAME% psql -U root --dbname=postgres -f init.sql
echo ==============================================================================
