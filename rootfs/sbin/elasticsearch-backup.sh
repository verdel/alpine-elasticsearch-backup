#!/bin/sh

cat <<EOF
Configuration:
 - host:     ${ELASTICSEARCH_HOST}
 - repository name: ${ELASTICSEARCH_REPOSITORY_NAME}
 - index prefix name: ${ELASTICSEARCH_INDEX_PREFIX}
EOF

#
# BACKUP
#
echo "Snapshot indices to '${ELASTICSEARCH_REPOSITORY_NAME}'..."
curator --config /etc/curator/curator.yml /etc/curator/snapshot.yml

if [ $? -ne 0 ]; then
    echo -e "\nERROR: Could not create snapshot" >&2
    exit 1
fi

echo -e "\nSnapshot completed"
exit