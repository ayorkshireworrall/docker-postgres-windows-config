echo Enter the name for your container:
read DOCKER_PG_NAME

echo Enter the postgres version. This will search for the corresponding image on docker hub should it exist: 
read DOCKER_PG_VERSION

echo Enter the database name \(this should match the name you choose in your init.sql instructions\): 
read DOCKER_PG_DB

export DOCKER_PG_NAME=$DOCKER_PG_NAME
export DOCKER_PG_VERSION=$DOCKER_PG_VERSION
export DOCKER_PG_DB=$DOCKER_PG_DB