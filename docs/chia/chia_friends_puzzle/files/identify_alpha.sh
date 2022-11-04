#!/bin/bash

FRIENDSDIR='/home/rudi/git/blockchain-stuff/docs/chia/chia_friends_puzzle/files/bafybeigzcazxeu7epmm4vtkuadrvysv74lbzzbl2evphtae6k57yhgynp4'

for PNGNUM in {1..10000}
do
    PNGNAME=${FRIENDSDIR}/${PNGNUM}.png
    ISALPHA=`identify -format '%[channels]' ${PNGNAME};`
    if [[ $ISALPHA = *srgba* ]]; then
      echo $PNGNAME
    fi
done