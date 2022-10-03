#!/usr/bin/env bash

usage() {
	echo "$0 usage:"
	echo "-i: Do all tasks including update, upgrade & dependencies installation"
	echo "-p: Set project name: paper, waterfall or travertine"
	echo "-v: Set project version"
	echo "-b: Set build version"
}

install_deps() {
	printf "\n[script] updating stuff. root rights required"
	sudo apt update &> /dev/null
	sudo apt upgrade &> /dev/null
	printf "\n[script] installing packages if not installed: apt-transport-https, software-properties-common, gnupg, wget"
	sudo apt install apt-transport-https software-properties-common gnupg wget &> /dev/null
	printf "\n[script] AdoptOpenJDK: getting repo key... "
	wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
	printf "[script] AdoptOpenJDK: installing JDK..."
	sudo add-apt-repository https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ &> /dev/null
	sudo apt update &> /dev/null
	sudo apt install adoptopenjdk-16-hotspot &> /dev/null
	echo "\n[script] done installing packages"
}

installdeps=false
msproject="paper"
msversion="1.19.2"
msbuild="194"

while getopts hip:v:b: name
do
	case $name in
		i)
			installdeps=true
			;;
		p)
			msproject=${OPTARG}
			printf "\n[script] project set to: ${msproject}"
			;;
		v)
			msversion=${OPTARG}
                        printf "\n[script] project version set to: ${msversion}"
			;;
                b)
                        msbuild=${OPTARG}
                        printf "\n[script] build version set to: ${msbuild}"
                        ;;
		h | *)
			usage
			exit 0
			;;
	esac
done

if [[ $installdeps = true ]]
then
	install_deps
fi

msdownload="${msproject}-${msversion}-${msbuild}"
printf "\n[script] installing minecraft server: ${msdownload} ..."
wget https://api.papermc.io/v2/projects/${msproject}/versions/${msversion}/builds/${msbuild}/downloads/${msdownload}.jar &> /dev/null

printf "\n\n[script] job finished. Happy serving!\n\n"
exit 0;
