#!/bin/bash

home=/Users/safnu1b
lbdbdir=$home/.lbdb
maildir=$home/.mailcache

find $maildir/*/cur -mtime -7 | while read zemessage
   do
      if [ -f "$zemessage" ]
         then
            cat "$zemessage" | lbdb-fetchaddr 
      fi
   done

