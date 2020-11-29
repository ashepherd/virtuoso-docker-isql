#!/bin/bash

############
#
# Load the RDF data in a specific /data/dumps/<graph name> directory into the given graph URI (clears and loads)
#
# Usage: void-loader.sh [graph name] [graph URI] [virtuoso pswd]
#
############


# Get input arguments
args=("$@")
if [ $# -ne 3 ]; then
    echo "Wrong number of arguments. Correct usage: \"void_loader \"[graph name]\" \"[graph URI]\" \"[virutoso pswd]\""
    exit 1
fi

GRAPH_NAME=$1
GRAPH_URI=$2
VIRT_DBA_PSWD=$3

LOCK_FILE="/data/dumps/${GRAPH_NAME}/locked"
READY_FILE="/data/dumps/${GRAPH_NAME}/ready"
GRAPH_DIR="dumps/${GRAPH_NAME}/void/"
LOGS="/logs/void-loader_${GRAPH_NAME}"

#### LOCK FILE CHECK ####
if [ -f $LOCK_FILE ]
then
  echo "${LOCK_FILE} exists"
  exit 1
fi
#### END OF LOCK FILE CHECK ####

#### READY FILE CHECK ####
if [ ! -f $READY_FILE ]
then
  echo "${READY_FILE} does not exist"
  exit 1
fi
#### END OF READY FILE CHECK ####

##### WRITE LOCK FILE ####
echo $$ > $LOCK_FILE
if [ $? -ne 0 ]
then
  echo "Could not create lock file"
  exit 1
fi

# Run the RDF loader on that directory
echo "Clear the graph: ${GRAPH_URI} ..."
DELETE_LOG="${LOGS}_vdelete.log"
echo "Delete Log: ${DELETE_LOG}"
./vdelete "${GRAPH_URI}" "${DELETE_LOG}" "${VIRT_DBA_PSWD}"
echo ${DELETE_LOG}

echo "Load the data into graph: ${GRAPH_URI}"
LOAD_LOG="${LOGS}_vload.log"
echo "Load Log: ${LOAD_LOG}"
./vload "${GRAPH_DIR}" "*.*" "${GRAPH_URI}" "${LOAD_LOG}" "${VIRT_DBA_PSWD}"
echo ${LOAD_LOG}

# Delete the date-specific directory
echo "Deleting the 'ready' file ..."
rm ${READY_FILE}
echo "Deleting the contents of directory ${GRAPH_DIR} ..."
rm -rf ${GRAPH_DIR}
echo "Deleting the 'lock' file ..."
rm ${LOCK_FILE}

if [ ${GRAPH_NAME} = "bcodmo" ]
then
  curl https://www.bco-dmo.org/osprey_rdf/void?recache=true
  echo "Reloaded the VoID doc for BCO-DMO..."
fi

echo "Done!"
