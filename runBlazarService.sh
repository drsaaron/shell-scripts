#! /bin/sh 

die() {
    echo $1 >&2
    exit 1
}

while getopts :d:e: OPTION
do
    case $OPTION in
	d)
	    appDirectory=$OPTARG
	    [ -d "$appDirectory" ] || die "work directory $appDirectory not found"
	    ;;
	e)
	    ENVIRONMENT=$OPTARG
	    ;;
	*)
	    die "unkonwn option $OPTARG"
    esac
done

shift $((OPTIND - 1))

[ -z "$appDirectory" ] && appDirectory=$(pwd)

pomFile=$appDirectory/pom.xml
[ -f $pomFile ] || die "$appDirectory doesn't have a pom file"

appEnv=${ENVIRONMENT:-test}

artifact=$(getPomAttribute.sh -p $pomFile artifactId)
version=$(getPomAttribute.sh -p $pomFile version)

java -Dspring.config.name=application,$appEnv -jar $appDirectory/target/$artifact-$version.jar "$@"
