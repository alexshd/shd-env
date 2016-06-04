#!/bin/sh

ubuntu_update() {
  sudo apt-get update -qq
}

base_packages() {
  for package_name in tmux vim git zsh mlocate httpie curl unzip
  do
    sudo apt-get install $package_name -y -qq
  done
}
install_chef() {

 curl -L https://www.chef.io/chef/install.sh \
    | sudo bash
}

setup_vim() {
  # clone Vundle to users home dir
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  # clone personal .vimrc
  curl \
    https://gist.githubusercontent.com/alexshd/756459d0e840c02d47ee/raw/d6235761fb360bad93db6017f3fedbd65a871ab1/.vimrc \
    > ~/.vimrc
	vim +PluginInstall +qall  2>&1
}

install_zsh() {
  # Script for base install
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

config_zsh() {
   cat <<EOF >~/.zshrc
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="pygmalion"

plugins=(git tmux httpie ubuntu apt \
          common-aliases cp \
          extract gem history \
          history-substring-search  \
          knife pip rake ruby vundle docker-compose\
          colorize bower npm docker)

source $ZSH/oh-my-zsh.sh

export TERM=screen-256color
export LANG=en_US.UTF-8
export EDITOR=vim
EOF
}

main() {
  ubuntu_update
  base_packages
	install_zsh
	config_zsh
  setup_vim
}

main
