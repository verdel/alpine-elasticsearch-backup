#!/bin/sh

cat <<EOF
Configuration:
 - host:     ${ELASTICSEARCH_HOST}
 - repository name: ${ELASTICSEARCH_REPOSITORY_NAME}
 - index prefix name: ${ELASTICSEARCH_INDEX_PREFIX}
EOF


#
# Restore
#
echo "Restore indices from snapshot from '${ELASTICSEARCH_REPOSITORY_NAME}'..."
curator --config /etc/curator/curator.yml /etc/curator/restore.yml

if [ $? -ne 0 ]; then
    echo -e "\nERROR: Could not restore snapshot" >&2
    exit 1
fi

echo -e "\nRestoring snapshot completed"
exit