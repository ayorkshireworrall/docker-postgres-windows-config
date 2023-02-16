@echo off
set /p DOCKER_PG_NAME="Enter the name for your container: "
setx DOCKER_PG_NAME %DOCKER_PG_NAME%
set /p DOCKER_PG_VERSION="Enter the postgres version. This will search for the corresponding image on docker hub should it exist: "
setx DOCKER_PG_VERSION %DOCKER_PG_VERSION%
set /p DOCKER_PG_DB="Enter the database name (this should match the name you choose in your init.sql instructions)"
setx DOCKER_PG_DB %DOCKER_PG_DB%