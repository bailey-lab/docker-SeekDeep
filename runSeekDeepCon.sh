#!/usr/bin/env bash

# this assumes ""${NAME}"" is disposable!
# runs ${IMAGE} with external file systems mounted in.

#check args
if [ $# -ne 1 ] || [ $# -ne 2 ]; then
	echo "Need at least 1 argument"
	echo "1) directory where data to be analyzed is stored"
	echo "2) directory where install files for SeekDeep for the container are (default:/data/docker/seekdeep)"
	echo "e.g."
	echo "runSeekDeepCon.sh seqData"
	echo "runSeekDeepCon.sh seqData /home/user/docker/seekdeep"
exit
fi

export DATA=$1
export IMAGE="seekdeep"
export NAME="seekdeep"
export BASE="/data/docker/seekdeep"

if [ $# -eq 2 ]; then
	BASE=$2
exit
fi


if [ "X$1" != "Xyes" ]; then
	echo
	echo "--------------------------------------------------------------------"
	echo "This script destroys existing container with name \"${NAME}\" and"
	echo "starts a new instance based on ${IMAGE}."
	echo
	echo "Run as '$0 yes' if this is what you intend to do."
	echo "--------------------------------------------------------------------"
	echo
	exit 0
fi

docker stop "${NAME}"
docker rm "${NAME}"

docker run \
	-v "${BASE}/var/log:/var/log" \
	-v "${BASE}/root/SeekDeepHome:/root/SeekDeepHome" \
	-v "${DATA}:/root/data" \
	-P -p 127.0.0.1:8000:80 \
	-P -p 127.0.0.1:9881:9881 \
	-d --restart=always \
	--hostname="${NAME}" --name="${NAME}" "${IMAGE}"
