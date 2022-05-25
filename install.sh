#!/bin/bash

cd `dirname $0`

CONFIG_PATH=$HOME/.config/nvim
DATA_PATH=$HOME/.local/share/nvim
CWD=`pwd`

mkdir -p $CONFIG_PATH
mkdir -p $CWD/nvim/lua/projects

if [[ -L $CONFIG_PATH ]]; then
  rm -f $CONFIG_PATH
elif [[ -d $CONFIG_PATH ]]; then
  mv -f $CONFIG_PATH $CONFIG_PATH.bak.`date "+%s"`
fi

if [[ -d $DATA_PATH ]]; then
  rm -rf $DATA_PATH
fi

rm -rf $HOME/.custom_projects.lua
rm -rf $HOME/.projects

cp -rfv $CWD/nvim $CONFIG_PATH
ln -fsv $CONFIG_PATH/lua/projects $HOME/.projects
ln -fsv $CONFIG_PATH/lua/custom_projects.lua $HOME/.custom_projects.lua

echo -e "\033[0;33mInstalled successfully!\033[0m"
