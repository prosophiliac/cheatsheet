#!/bin/bash

#Cache git credentials 
git config --global credential.helper 'cache --timeout=86400'

#Undo last commit before push
git reset HEAD~1
