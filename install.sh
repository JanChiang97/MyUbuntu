#!/bin/bash

ROOT_PATH=$(pwd)
GIT_SAVE=$HOME/.git-credentials
CUR_USR=`echo $HOME | cut -d/ -f 3`
RET_ZSH=0
ALL_FLAG=0
####################################### func ################################################
print_usage(){
echo -e "Usage: 
	sudo ./install all			---- install all target (can't choose environment)
	sudo ./install [zsh] [bin] [...]	---- install the target which be choosed

	Target:\033[31mzsh bin theme environment \033[0m
	Please make sure you are \033[31mroot\033[0m or public user use \033[31msudo\033[0m to improve permissions
   "
	return 0   
}
check(){
	if [[ -z $1 || $(whoami) != "root" ]]; then
    	print_usage
		exit 1
	elif [[ $1 == '-h' || $1 == '--help' ]]; then
		print_usage
        exit 0
	fi
}

set_vim(){
	
	if [[ ! -d $HOME/.vim.bak ]]; then
	if [[ ! -d $HOME/.vim ]]; then
		mv $HOME/.vimrc $HOME/.vimrc.bak
		cp $ROOT_PATH/tools/.vimrc $HOME
		cp $ROOT_PATH/tools/.vim $HOME -rf
	else
		mv $HOME/.vimrc $HOME/.vimrc.bak
        cp $ROOT_PATH/tools/.vimrc $HOME
        mv $HOME/.vim $HOME/.vim.bak
        cp $ROOT_PATH/tools/.vim $HOME -rf

	fi	
	fi	


	grep "\" ADD_BY_JAN" /etc/vim/vimrc >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		echo "\" ADD_BY_JAN" >> /etc/vim/vimrc
		echo "set ts=4" >> /etc/vim/vimrc
		echo "set tabstop=8" >> /etc/vim/vimrc
		echo "set shiftwidth=4" >> /etc/vim/vimrc
		echo "set softtabstop=4" >> /etc/vim/vimrc
		echo "set expandtab" >> /etc/vim/vimrc
		echo "set autoindent" >> /etc/vim/vimrc
		echo "\" END" >> /etc/vim/vimrc
		echo "" >> /etc/vim/vimrc
	fi

	return 0
}
set_git(){
	apt install exuberant-ctags cscope
	if [[ $? -ne 0 ]]; then
		exit 1
	fi
		
	git config --global alias.st status
	git config --global alias.co checkout
	git config --global alias.ci commit
	git config --global alias.br branch
	git config --global core.editor "vim"

	
	grep "[commit]" $HOME/.gitconfig >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		git config --global commit.template $HOME/.git-commit-template.txt
		touch $HOME/.git-commit-template.txt
	fi

	git config --global credential.helper "store --file $GIT_SAVE"
	if [[ ! -f $GIT_SAVE ]]; then
		cp $ROOT_PATH/tools/.git-credentials $GIT_SAVE -f
		chown $CUR_USR:root $GIT_SAVE
	else
		cat $ROOT_PATH/tools/.git-credentials >> $GIT_SAVE
	fi

	cp $ROOT_PATH/tools/pre-push $ROOT_PATH/.git/hooks/
	return 0
}
set_zsh(){
	cd $ROOT_PATH
    chsh -s /bin/zsh
	chown $CUR_USR:root $HOME/.local -R
	chown $CUR_USR:root $HOME/.oh-my-zsh -R
	#chown $CUR_USR:root $HOME/.zsh_history 
	chown $CUR_USR:root $HOME/.zshrc
    su $CUR_USR
    chsh -s /bin/zsh
}
####################################### target #################################################

install_environment(){
	grep "deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse" /etc/apt/sources.list >/dev/null 2>&1

	if [[ $? -ne 0 ]]; then
    	echo "deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse" >> /etc/apt/sources.list
    	apt update
	fi

	apt install gitk ubuntu-make make amule bc build-essential curl flex g++-multilib gcc-multilib gnupg gperf rsync zip python git bison tofrodos dpkg-dev git-core unzip m4 samba
	return $?
}

install_mybin(){
	echo "===================================start install bin==============================="
	cd $ROOT_PATH
	apt install astyle 
	if [[ $? -ne 0 ]]; then
		return 1
	fi

	apt install autojump
	if [[ $? -ne 0 ]]; then
        return 1
    fi

	apt install net-tools tree
	if [[ $? -ne 0 ]]; then
        return 1
    fi

	MV=`which mv`
	BA=`which bash`
	cp -rf mybin /usr/
	cp $MV /usr/mybin/ -f > /dev/null 2>&1
	cp $BA /usr/mybin/ -f > /dev/null 2>&1
	grep "#ADD BY JAN #" $HOME/.bashrc >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		echo '# ADD BY JAN #' >> $HOME/.bashrc
		echo 'export PATH="/usr/mybin:$PATH"' >> $HOME/.bashrc
		echo 'source /usr/mybin/.jump' >> $HOME/.bashrc
		echo 'source /usr/share/autojump/autojump.sh' >> $HOME/.bashrc
		echo 'alias sudo="sudo env PATH=$PATH"' >> $HOME/.bashrc
		echo 'OTHER_WRITABLE 01;34' >> $HOME/.dir_colors
		echo 'eval "$(dircolors -b $HOME/.dir_colors)"' >> $HOME/.bashrc
		echo '# END #' >> $HOME/.bashrc
    fi

	source $HOME/.bashrc

	#set vim
	set_vim
	#set git 
	set_git
	echo "===================================end==============================="
	return 0
}

install_zsh(){
	echo "===================================start install oh-my-zsh ==============================="
	cd $ROOT_PATH
	apt install zsh
	if [[ $? -ne 0 ]]; then
        return 1
    fi

	apt install autojump
	if [[ $? -ne 0 ]]; then
        return 1
    fi
	
	echo 'OTHER_WRITABLE 01;34' >> $HOME/.dir_colors

	cd $ROOT_PATH/ohmyzsh/config && cp .zshrc ${HOME}/ && cp -rf .oh-my-zsh ${HOME}/
	sed -i "s|`grep "export ZSH=" ${HOME}/.zshrc`| export ZSH="${HOME}/.oh-my-zsh"|g" ${HOME}/.zshrc
	sed -i "s#`grep $HOME /etc/passwd | cut -d: -f 7`#\/bin\/zsh#g" /etc/passwd
	sed -i "s#`grep ":root:/root" /etc/passwd | cut -d: -f 7`#\/bin\/zsh#g" /etc/passwd

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

	cd $ROOT_PATH/package/vimix && tar -xvf vimix-gtk-themes-2020-02-24.tar.gz >/dev/null 2>&1 && tar -xvf $ROOT_PATH/package/vimix/vimix-icon-theme-2020-07-10.tar.gz >/dev/null 2>&1
	cd $ROOT_PATH/package/vimix/vimix-gtk-themes-2020-02-24 && ./install.sh >/dev/null
	cd $ROOT_PATH/package/vimix/vimix-icon-theme-2020-07-10 && ./install.sh >/dev/null
	#cd $ROOT_PATH/package/vimix/dash-to-dock && make clean && make && make install
	cp $ROOT_PATH/package/dash-to-dock@micxgx.gmail.com $HOME/.local/share/gnome-shell/extensions/ -rf
	rm -rf $ROOT_PATH/package/vimix/vimix-gtk-themes-2020-02-24 $ROOT_PATH/package/vimix/vimix-icon-theme-2020-07-10

	echo "===================================end==============================="
	return 0
}


############################################## main ###########################################################

check $@

for opt in $@
do
if [[ $opt == "all" ]]; then 
	ALL_FLAG=1
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
		RET_ZSH=1
	fi
fi
done

for opt in $@
do
if [[ $ALL_FLAG -eq 0 ]]; then
if [[ $opt == "zsh" ]]; then
    install_zsh
	if [[ $? -ne 0 ]]; then
        echo "failed:install zsh"
        #exit 1
	else
		RET_ZSH=1
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
fi
done

if [[ "$RET_ZSH" == 1 ]]; then
	set_zsh
fi


