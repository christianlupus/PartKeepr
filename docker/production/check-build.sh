#! /bin/bash

tag=$(git describe --abbrev=0 --exact-match 2> /dev/null)
ret=$?

host=docker.pkg.github.com
user=christianlupus
repo=partkeepr
url=$host/$user/$repo

if [ $ret -eq 0 ]; then

	# A valid tag was found
	
	docker tag $url/production:latest $url/production:v$tag
	docker push $url/production:v$tag
else

	echo "Do not build as no tag was found"
	
fi

