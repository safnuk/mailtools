#!/bin/bash
#
# Fire up mutt on a given mail, located in some Maildir
# Mail can be specified either by path or by Messsage-ID; in the latter case
# file lookup is performed using some mail indexing tool.
#
# Copyright: Â© 2009-2014 Stefano Zacchiroli <zack@upsilon.cc>
# License: GNU General Public License (GPL), version 3 or above

# requires: notmuch | maildir-utils >= 0.7

MUTT=mutt
MAIL_INDEXER="mu"	# one of "notmuch", "mu"

MUTT_FLAGS="-R"
HIDE_SIDEBAR_CMD=""	# set to empty string if sidebar is not used

# Sample output of lookup command, which gets passed to mutt-open
#  /home/zack/Maildir/INBOX/cur/1256673179_0.8700.usha,U=37420,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,S

die_usage () {
    echo "Usage: mutt-open FILE" 1>&2
    echo "       mutt-open MESSAGE-ID" 1>&2
    echo 'E.g.:  mutt-open `notmuch search --output=files id:MESSAGE-ID`' 1>&2
    echo '       mutt-open `mu find -f l i:MESSAGE-ID`' 1>&2
    echo '       mutt-open 20091030112543.GA4230@usha.takhisis.invalid' 1>&2
    exit 3
}

# Lookup: Message-ID -> mail path. Store results in global $fname
lookup_msgid () {
    msgid_query="$1"
    case "$MAIL_INDEXER" in
	notmuch)
	    fname=$(notmuch search --output=files id:"$msgid_query" | head -n 1)
	    ;;
	mu)
	    fname=$(mu find -f l i:"$msgid_query" | head -n 1)
	    ;;
    esac
}

dump_info () {
    echo "fname: $fname"
    echo "msgid: $msgid"
}

if [ -z "$1" -o "$1" = "-h" -o "$1" = "-help" -o "$1" = "--help" ] ; then
    die_usage
fi
if (echo "$1" | grep -q /) && test -f "$1" ; then	# arg is a file
    fname="$1"
    msgid=$(egrep -i '^message-id:' "$fname" | cut -f 2 -d':' | sed 's/[ <>]//g')
elif ! (echo "$1" | grep -q /) ; then	# arg is a Message-ID
    msgid="$1"
    lookup_msgid "$msgid"	# side-effect: set $fname
fi
# dump_info ; exit 3
if ! dirname "$fname" | egrep -q '/(cur|new|tmp)$' ; then
    echo "Path not pointing inside a maildir: $fname" 1>&2
    exit 2
fi
maildir=$(dirname $(dirname "$fname"))

if ! [ -d "$maildir" ] ; then
    echo "Not a (mail)dir: $maildir" 1>&1
    exit 2
fi

# UGLY HACK: without sleep, push keys do not reach mutt, I _guess_ that there
# might be some terminal-related issue here, since also waiting for an input
# with "read" similarly "solves" the problem
sleep 0.1
mutt_keys="/=i$msgid\n\n$HIDE_SIDEBAR_CMD"
exec $MUTT $MUTT_FLAGS -f "$maildir/" -e "push $mutt_keys"
