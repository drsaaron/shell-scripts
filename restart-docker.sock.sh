#! /bin/sh

export PATH=~/.local/bin:/bin:/usr/bin:/sbin:$HOME/shell:$PATH
export SSH_AUTH_SOCK=/run/user/$(id -u)/keyring/ssh

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

# determine localhost IP address.  ansible doesn't seem to like using localhost when
# run from cron
ip=$(ifconfig wlo1 | grep inet | awk '$1=="inet" {print $2}')

# run
ansible-playbook -i $ip, restart-docker.sock.yml --user=$remoteUser -e 'ansible_python_interpreter=/usr/bin/python3' -e serverGroups=${serverGroups:-all} --extra-vars "ansible_become_pass='$sudoPassword'"
