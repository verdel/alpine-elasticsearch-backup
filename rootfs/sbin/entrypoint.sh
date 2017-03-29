#!/bin/sh

ELASTICSEARCH_REPOSITORY_NAME=${ELASTICSEARCH_REPOSITORY_NAME:-"backup"}
export ELASTICSEARCH_REPOSITORY_NAME
ELASTICSEARCH_REPOSITORY_PATH=${ELASTICSEARCH_REPOSITORY_PATH:-"/usr/share/elasticsearch/backup"}
export ELASTICSEARCH_REPOSITORY_PATH

if [ ! -z $2 ];then
    ELASTICSEARCH_SNAPSHOT_NAME=$2
    export ELASTICSEARCH_SNAPSHOT_NAME
fi

# Create configuration files from templates
if [ -f /etc/curator/curator.yml.j2 ];then
    j2 /etc/curator/curator.yml.j2 > /etc/curator/curator.yml
    rm /etc/curator/curator.yml.j2
fi

if [ -f /etc/curator/snapshot.yml.j2 ];then
    j2 /etc/curator/snapshot.yml.j2 > /etc/curator/snapshot.yml
    rm /etc/curator/snapshot.yml.j2
fi

if [ -f /etc/curator/restore.yml.j2 ];then
    j2 /etc/curator/restore.yml.j2 > /etc/curator/restore.yml
    rm /etc/curator/restore.yml.j2
fi

# Create backup repository if not exist
es_repo_mgr --config /etc/curator/curator.yml show | grep '${ELASTICSEARCH_REPOSITORY_NAME}' &> /dev/null
if [ $? != 0 ]; then
    es_repo_mgr --config /etc/curator/curator.yml create fs --repository ${ELASTICSEARCH_REPOSITORY_NAME} --location ${ELASTICSEARCH_REPOSITORY_PATH} --compression true
fi

if [ "$1" = "backup" ]; then 
  exec /sbin/elasticsearch-backup.sh
  
elif [ "$1" = "restore" ]; then
  exec /sbin/elasticsearch-restore.sh

elif [ "$1" = "list" ]; then
  exec /sbin/elasticsearch-list-snapshots.sh
fi

exec "$@"