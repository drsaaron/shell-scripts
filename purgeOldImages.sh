#! /bin/sh

imageName=$(dockerImageName.sh)

# keep the current and 4 previous versions.  This would be 7 lines in the
# docker images command: header, 5 versions, and the latest version.
for fullImageName in $imageName drsaaron/$imageName
do
    docker images $fullImageName | sed '1,7d' | awk '{ print $2 }' |
	while read version
	do
	    echo "purging version $version"
	    docker rmi $fullImageName:$version
	done
done

    
