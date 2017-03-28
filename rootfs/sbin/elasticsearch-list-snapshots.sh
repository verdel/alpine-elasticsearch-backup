#!/bin/sh

cat <<EOF
Configuration:
 - host:     ${ELASTICSEARCH_HOST}
 - repository name: ${ELASTICSEARCH_REPOSITORY_NAME}
EOF

#
# List snapshots
#
echo "List snapshots from '${ELASTICSEARCH_REPOSITORY_NAME}'..."
curator_cli --config /etc/curator/curator.yml show_snapshots --repository "${ELASTICSEARCH_REPOSITORY_NAME}"

if [ $? -ne 0 ]; then
    echo -e "\nERROR: Could not list snapshots" >&2
    exit 1
fi
exit