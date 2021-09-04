#! /bin/sh

#export PATH=~/.local/bin:/bin:/usr/bin:/sbin:$HOME/shell:$PATH

cd $(dirname $0)

while getopts :g: OPTION
do
    case $OPTION in
	g)
	    serverGroups=$OPTARG
	    ;;
	*)
	    echo "invalid option $OPTARG" 1>&2
	    echo "usage: $0 [-g groups]" 1>&2
	    exit 1
    esac
done

# get the password
remoteUser=familyadmin
sudoPassword=$(pass localhost/$remoteUser)

# is docker.sock already running?
if docker ps -q
then
    echo "docker.sock already running."
    exit 0
fi

# run
ansible-playbook -i restart-docker.sock.hosts restart-docker.sock.yml --user=$remoteUser -e 'ansible_python_interpreter=/usr/bin/python3' -e serverGroups=${serverGroups:-all} --extra-vars "ansible_become_pass='$sudoPassword'"
