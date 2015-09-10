#!/bin/bash

home=/Users/safnu1b
lbdbdir=$home/.lbdb
maildir=$home/.mailcache

find $maildir/*/cur | while read zemessage
   do
      if [ -f "$zemessage" ]
         then
            cat "$zemessage" | lbdb-fetchaddr -a
      fi
   done

rm -f $lbdbdir/m_inmail.list.tmp

mv $lbdbdir/m_inmail.list $lbdbdir/m_inmail.list.tmp
sort -u -d -f -i -k 1,1 $lbdbdir/m_inmail.list.tmp > $lbdbdir/m_inmail.list

rm -f $lbdbdir/m_inmail.list.tmp
chmod 600 $lbdbdir/m_inmail.list

rm -f $lbdbdir/m_inmail.list.dirty
