#! /bin/bash

tag=$(git describe --abbrev=0 --exact-match 2> /dev/null)
ret=$?

repo=partkeepr

url=$repo

CACHE_ARG=""

function check_docker_cache () {
	if [ -n "$CACHE_ARG" ]; then
		return
	fi
	
	docker pull "$1"
	local ret=$?
	
	if [ $ret -eq 0 ]; then
		CACHE_ARG="--cache-from $1"
	fi
}

if [ $ret -eq 0 ]; then

	# A valid tag was found
	
	# Try to fetch the latest build
	check_docker_cache partkeepr/production:latest
	check_docker_cache partkeepr/base:latest
	
	docker build -t $url/production:latest --build-arg SRC_IMAGE=$url/base:$(git describe) $CACHE_ARG $(dirname "$0")
	
	docker tag $url/production:latest $url/production:v$tag
	docker push $url/production:v$tag

else

	echo "Do not build as no tag was found"
	
fi

