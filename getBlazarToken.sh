#! /bin/sh 

while getopts :u:th: OPTION
do
    case $OPTION in
	u)
	    user=$OPTARG
	    ;;
	t)
	    environ=test
	    ;;
	h)
	    host=$OPTARG
	    ;;
	*)
	    echo "invalid option $OPTARG" 1>&2
	    exit 1
    esac
done

me=${user:-$(whoami)}
password=$(pass blazar/$me)

[ ${environ:-prod} = "prod" ] && port=4500 || port=45000

curl -H 'Content-Type: application/json' -X POST -d '{"username": "'$me'", "password": "'$password'" }' http://${host:-localhost}:$port/authenticate 2>/dev/null | perl -MJSON -ne 'my $r = from_json($_); print $r->{jwttoken} . "\n"; '
