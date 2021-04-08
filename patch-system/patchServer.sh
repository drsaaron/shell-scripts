#! /bin/sh

while getopts :g: OPTION
do
    case $OPTION in
	g)
	    serverGroups=$OPTARG
	    ;;
	*)
	    echo "invalid option $OPTION" 1>&2
	    echo "usage: $0 [-g groups]" 1>&2
	    exit 1
    esac
done

# get the password
remoteUser=familyadmin
sudoPassword=$(pass localhost/$remoteUser)

# run
ansible-playbook -i patch-hosts patch-server.yml --user=$remoteUser -e 'ansible_python_interpreter=/usr/bin/python3' -e serverGroups=${serverGroups:-all} --extra-vars "ansible_become_pass='$sudoPassword'"
