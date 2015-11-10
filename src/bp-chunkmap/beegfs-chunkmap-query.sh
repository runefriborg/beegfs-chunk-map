#!/bin/sh


PID=$$

# Args
LEVELDB=""
BINDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Load configuration
. ${BINDIR}/beegfs-conf.sh

failed_params=0

# Parse params
while getopts "m:h" opt; do
        case $opt in
                m) LEVELDB=$OPTARG ;;
                h) failed_params=1 ;;
                *) failed_params=1 ;;
        esac
done


# Check params
if [ failed_params == 1 ] || [ $# -eq 0 ] || [ "$LEVELDB" == "" ]; then
        cat <<EOF
Version: 0.1
Author: Rune M. Friborg (runef@birc.au.dk)

Usage:
  bp-chunkmap-query -m <leveldb map>

Reads CHUNK IDs from STDIN and outputs the fetched filenames.

Parameters explained:
  -m    Chunk map in leveldb format
EOF
        exit 1
fi

PWD=`pwd`

# Get path for LEVELDB
if [ ! "${LEVELDB:0:1}" == "/" ]; then
        LEVELDB="${PWD}/${LEVELDB}"
fi

# Perform querying
LD_LIBRARY_PATH=${CONF_LEVELDB_LIBPATH} ${BINDIR}/bp-cm-query ${LEVELDB}
