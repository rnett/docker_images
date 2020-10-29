#!/usr/bin/env bash

su jupyter

cd /home/jupyter || exit

cp -R /jupyter-home/. /home/jupyter/

OLD_HOME=$HOME
export HOME="/home/jupyter"

export ZSH="/home/jupyter/.oh-my-zsh"
export SHELL_CONFIG="/home/jupyter/.shell_config"


sh -c "$(curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended

. .shell_config/setup_links.sh
. .shell_config/setup_plugins.sh

sed -i 's/plugins=(poetry /plugins=(/' .zshrc

echo -e "\nconda activate base" >> .zshrc

export HOME="$OLD_HOME"