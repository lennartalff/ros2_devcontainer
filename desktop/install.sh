#!/usr/bin/bash
DIR=$(dirname $(readlink -f $0))
cp -r $DIR/*.desktop $HOME/.local/share/applications/
