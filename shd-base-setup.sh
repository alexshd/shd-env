#!/bin/sh

ubuntu_update() {
	sudo apt-get update -qq
	return 0
}

base_packages_yum() {
	sudo yum install tmux vim-enhanced git zsh mlocate curl unzip -y
	return 0
}

base_packages() {
	sudo apt-get install tmux vim git zsh mlocate httpie curl unzip -y -qq
	return 0
}

install_chef() {
	curl -L https://www.chef.io/chef/install.sh | sudo bash
	# curl -LO https://omnitruck.chef.io/install.sh && sudo bash ./install.sh -v 12.22.5
	return 0
}

setup_vim() {
	# clone Vundle to users home dir
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	# clone personal .vimrc
	curl \
		https://raw.githubusercontent.com/alexshd/shd-env/v4/vimrc \
		>~/.vimrc
	vim +PluginInstall +qall 2>&1

	return 0
}

install_zsh() {
	# Script for base install
	sh -c \
		"$(curl -fsSL \
			https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

config_zsh() {
	cat <<EOF >~/.zshrc
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="pygmalion"

plugins=(git tmux httpie ubuntu apt common-aliases cp extract gem history history-substring-search knife pip rake ruby vundle docker-compose colorize bower npm docker)

source "\${ZSH}/oh-my-zsh.sh"

# use ruby chef
export PATH=$PATH:/opt/chef/embedded/bin
export TERM=screen-256color
export LANG=en_US.UTF-8
export EDITOR=vim
EOF

	return 0
}

main() {
	ubuntu_update
	base_packages
	install_chef
	setup_vim
	install_zsh
	config_zsh
	return 0
}

main
