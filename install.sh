#!/bin/bash

path=$(pwd)
GIT_SAVE=$HOME/.git-credentials

zsh_ret=0
####################################### func ################################################
print_usage(){
echo -e "Usage: 
	./install all			---- install all target
	./install [zsh] [bin] [...]	---- install the target which be choosed

	Target:\033[31mzsh bin theme environment \033[0m
	Please make sure you are \033[31mroot\033[0m or public user use \033[31msudo\033[0m to improve permissions
   "
	return 0   
}
set_vim(){
	grep "set ts=4" /etc/vim/vimrc >/dev/null 2>&1
	
	if [[ $? -ne 0 ]]; then
		echo "set ts=4" >> /etc/vim/vimrc
	fi

	return 0
}
set_git(){
	git config --global alias.st status
	git config --global alias.co checkout
	git config --global alias.ci commit
	git config --global alias.br branch
	git config --global credential.helper "store --file $GIT_SAVE"
	if [[ ! -f $GIT_SAVE ]]; then
		cp $path/tools/.git-credentials $GIT_SAVE -f
		chown $USER:$USER $GIT_SAVE
	fi

	cp $path/tools/pre-push $path/.git/hooks/
	return 0
}
set_zsh(){
	cd $path
    chsh -s /bin/zsh
    cur_usr=`echo $HOME | cut -d/ -f 3`
    su $cur_usr
    chsh -s /bin/zsh
}
####################################### target #################################################

install_environment(){
	grep "deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse" /etc/apt/sources.list >/dev/null 2>&1

	if [[ $? -ne 0 ]]; then
    	echo "deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse" >> /etc/apt/sources.list
    	apt update
	fi

	apt install gitk ubuntu-make make amule openjdk-8-jdk lib32ncurses5 git bc bison build-essential curl flex g++-multilib gcc-multilib gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc yasm zip zlib1g-dev python libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-dev g++-multilib git flex bison gperf build-essential libncurses5-dev:i386 tofrodos python-markdown libxml2-utils xsltproc zlib1g-dev:i386 dpkg-dev libsdl1.2-dev libesd0-dev git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev libgl1-mesa-dev libxml2-utils xsltproc unzip m4 lib32z-dev ccache dpkg-dev libsdl1.2-dev libesd0-dev samba
	return $?
}

install_mybin(){
	echo "===================================start install bin==============================="
	cd $path
	apt install astyle 
	if [[ $? -ne 0 ]]; then
		return 1
	fi

	apt install autojump
	if [[ $? -ne 0 ]]; then
        return 1
    fi

	apt install net-tools
	if [[ $? -ne 0 ]]; then
        return 1
    fi

	cp -rf mybin /usr/
	grep "/usr/mybin" $HOME/.bashrc >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		echo 'export PATH="/usr/mybin:$PATH"' >> $HOME/.bashrc
		echo 'source /usr/mybin/.jump' >> $HOME/.bashrc
    fi
	source $HOME/.bashrc


	#grep ":/usr/mybin" /etc/environment
	#if [[ $? -ne 0 ]]; then 
	#	echo 'PATH+=":/usr/mybin"' >> /etc/environment
	#fi
	#source /etc/environment

	#set vim
	set_vim
	#set git 
	set_git
	echo "===================================end==============================="
	return 0
}

install_zsh(){
	echo "===================================start install oh-my-zsh ==============================="
	cd $path
	apt install zsh
	if [[ $? -ne 0 ]]; then
        return 1
    fi

	apt install autojump
	if [[ $? -ne 0 ]]; then
        return 1
    fi

	#cd $path/ohmyzsh/tools && ./install.sh
	cd $path/ohmyzsh/config && cp .zshrc ${HOME}/ && cp -rf .oh-my-zsh ${HOME}/
	sed -i "s|`grep "export ZSH=" ${HOME}/.zshrc`| export ZSH="${HOME}/.oh-my-zsh"|g" ${HOME}/.zshrc
	sed -i "s#`grep $HOME /etc/passwd | cut -d: -f 7`#\/bin\/zsh#g" /etc/passwd
	sed -i "s#`grep ":root:/root" /etc/passwd | cut -d: -f 7`#\/bin\/zsh#g" /etc/passwd
	#sed -i 's/\/bin\/bash/\/bin\/zsh/g' /etc/passwd
	#sed -i 's/\/bin\/dash/\/bin\/zsh/g' /etc/passwd

	#disabled git information
	git config --global oh-my-zsh.hide-status 1

	source ${HOME}/.zshrc >/dev/null 2>&1

	echo "===================================end==============================="
	return 0
}

install_theme(){
	echo "===================================start install theme==============================="
	apt install gnome-tweak-tool
	if [[ $? -ne 0 ]]; then
        return 1
    fi
	apt install gnome-shell-extensions
	if [[ $? -ne 0 ]]; then
        return 1
    fi

	cd $path/package/vimix && tar -xvf vimix-gtk-themes-2020-02-24.tar.gz >/dev/null 2>&1 && tar -xvf $path/package/vimix/vimix-icon-theme-2020-07-10.tar.gz >/dev/null 2>&1
	cd $path/package/vimix/vimix-gtk-themes-2020-02-24 && ./install.sh >/dev/null
	cd $path/package/vimix/vimix-icon-theme-2020-07-10 && ./install.sh >/dev/null
	#cd $path/package/vimix/dash-to-dock && make clean && make && make install
	cp $path/package/dash-to-dock@micxgx.gmail.com $HOME/.local/share/gnome-shell/extensions/ -rf
	rm -rf $path/package/vimix/vimix-gtk-themes-2020-02-24 $path/package/vimix/vimix-icon-theme-2020-07-10

	echo "===================================end==============================="
	return 0
}


############################################## main ###########################################################



if [[ -z $1 || $(whoami) != "root" ]]; then
    print_usage
	exit 1
fi


for opt in $@
do
if [[ $opt == "all" ]]; then 
	install_mybin
	if [[ $? -ne 0 ]]; then
		echo "failed:install bin"
		exit 1
    fi

	install_theme
	if [[ $? -ne 0 ]]; then
		echo "failed:install theme"
        exit 1
    fi

	install_zsh
    if [[ $? -ne 0 ]]; then
        echo "failed:install zsh"
        exit 1
	else
		zsh_ret=1
	fi

	exit 0
fi
done

for opt in $@
do
if [[ $opt == "zsh" ]]; then
    install_zsh
	if [[ $? -ne 0 ]]; then
        echo "failed:install zsh"
        #exit 1
	else
		zsh_ret=1
	fi

elif [[ $opt == "bin" ]]; then
    install_mybin
	if [[ $? -ne 0 ]]; then
        echo "failed:install bin"
        #exit 1
    fi

elif [[ $opt == "theme" ]]; then
	install_theme
	if [[ $? -ne 0 ]]; then
        echo "failed:install theme"
        #exit 1
    fi

elif [[ $opt == "environment" ]]; then
    install_environment
    if [[ $? -ne 0 ]]; then
        echo "failed:install environment"
        #exit 1
    fi
else
	echo "ERROR: No such target $opt"
	print_usage
fi
done

if [[ $zsh_ret == 1 ]]; then
	set_zsh
fi
