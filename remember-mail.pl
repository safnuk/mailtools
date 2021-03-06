#!/usr/bin/perl -w
#
# Helper for mutt to remember mails in Emacs' Org mode
#
# Copyright: Â© 2009-2010 Stefano Zacchiroli <zack@upsilon.cc> 
# License: GNU General Public License (GPL), version 3 or above
#
# Example of mutt macro to invoke this hitting ESC-R (to be put in ~/.muttrc):
#  macro index \eR "|~/bin/remember-mail\n"

use strict;
use Mail::Internet;
use URI::Escape;

my $msg = Mail::Internet->new(\*STDIN);
$msg->head->get('message-id') =~ /^<(.*)>$/;
my $mid = $1;
my $subject = $msg->head->get('subject') || "";
my $from = $msg->head->get('from') || "";
chomp ($subject, $from);
my $note_body = uri_escape("  Subject: $subject\n    From: $from");

exec "echo", "org-protocol:/capture:/m/mutt:$mid/mail/$note_body";
