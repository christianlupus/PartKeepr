#! /bin/bash

tag=$(git describe --abbrev=0 --exact-match 2> /dev/null)
ret=$?

host=docker.pkg.github.com
user=christianlupus
repo=partkeepr

url=$repo

if [ $ret -eq 0 ]; then

	# A valid tag was found
	
	docker build -t $url/production:latest --build-arg SRC_IMAGE=$url/base:$(git describe) $(dirname "$0")
	
	docker tag $url/production:latest $url/production:v$tag
	docker push $url/production:v$tag

else

	echo "Do not build as no tag was found"
	
fi

