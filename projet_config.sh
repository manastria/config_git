#!/bin/bash

_DEBUG="off"

DEBUG()
{
	[ "$_DEBUG" == "on" ] &&  $@
}

# Retourne 0 si egale, 1 si sup, 2 si inf
vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}



SOURCE="${BASH_SOURCE[0]}"
SOURCEDIR="$(cd -P "$(dirname "$SOURCE")/.." && pwd)"
INSTALLDIR=${1:-$HOME}

GIT_VERSION=$(git --version | awk '{print $3}')

DEBUG echo "SOURCE : ${SOURCE}"
DEBUG echo "SOURCEDIR : ${SOURCEDIR}"
DEBUG echo "INSTALLDIR : ${INSTALLDIR}"

vercomp 2.6.0 ${GIT_VERSION}
res=$?
if [ $res -eq 2 ]
then
	GIT_VER_260=true
	DEBUG echo "GIT_VER_260" 
fi

vercomp 1.8.0 ${GIT_VERSION}
res=$?
if [ $res -eq 2 ]
then
	GIT_VER_180=true
	DEBUG echo "GIT_VER_180" 1>&2
fi

printf "Rep install : %s\n" $INSTALLDIR
printf "Rep source  : %s\n" $SOURCEDIR

if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ]; then
    echo "$0 <dotfiles install dir>"
    echo "Existing dotfiles will be moved to <filename>.old"
    exit
fi

echo "User : " $(git config user.name)
echo "Mail : " $(git config user.email)

echo -en "\nDo you want config author ? [N/y]"
read -n 1 config_author

if [ "$config_author" == "Y" ] || [ "$config_author" == "y" ]; then
    echo -e "\nGit config settings"
    echo -n "Name: "
    read git_name
    echo -ne "\nEmail: "
    read git_email

    #cp $PWD/.gitconfig $INSTALLDIR/.gitconfig
    #sed -i "s/%%GITNAME%%/$git_name/" $INSTALLDIR/.gitconfig
    #sed -i "s/%%GITEMAIL%%/$git_email/" $INSTALLDIR/.gitconfig
	git config user.name "${git_name}"
	git config user.email "${git_email}"
fi

echo -en "\nDo you want config alias ? [N/y]"
read -n 1 config_alias

if [ "$config_alias" == "Y" ] || [ "$config_alias" == "y" ]; then
    git config --global alias.auth 'shortlog -sne --all'
fi


echo -en "\nDo you want install hist ? [N/y]"
read -n 1 config_hist

if [ "$config_hist" == "Y" ] || [ "$config_hist" == "y" ]; then
    if [ -v GIT_VER_260 ]
    then
        git config --global alias.hist "log --graph --decorate --format=format:'%C(red)%h%C(reset) | %C(green)%ad%C(reset) | %C(magenta)%d%C(reset) %C(reset)%s %C(blue)[%aN]%C(reset)' --date=format:'%Y-%m-%d %H:%M:%S'"
    else
        git config --global alias.hist "log --graph --decorate --format=format:'%C(red)%h%C(reset) | %C(green)%ad%C(reset) | %C(magenta)%d%C(reset) %C(reset)%s %C(blue)[%aN]%C(reset)' --date=iso"
    fi
fi

# printf "\n"


echo -en "\nDo you want use notepad++ ? [N/y]"
read -n 1 config_nppp

if [ "$config_nppp" == "Y" ] || [ "$config_nppp" == "y" ]; then
    if [ -e 'c:\Program Files (x86)\Notepad++\notepad++.exe' ]; then
        echo "Editor : notepad++"
        if  [ -z "$CYGWIN" ]; then
            git config --global core.editor "'c:\Program Files (x86)\Notepad++\notepad++.exe' -multiInst -notabbar -nosession -noPlugin"
        else
            git config --global core.editor "~/configunix_gitconfig/install/bin/npp.sh"
        fi
    else
        echo "Editor : vim"
        git config --global core.editor "\"$(which vim)\""
    fi
fi



