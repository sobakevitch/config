#!/bin/sh

layout=$(setxkbmap -query | grep layout | cut -d ":" -f 2 | tr -d ' ')

if [ $layout = "us" ] ; then
  setxkbmap fr
else
  setxkbmap us intl
fi
