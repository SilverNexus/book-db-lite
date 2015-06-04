#!/usr/bin/perl

#
# File to streamline commits to go through the commit and push phases of
# the git interface. Since the program itself is written in Perl, there's
# not really any reason to not use perl for this as well.
#
# Author: Daniel Hawkins
# Last Modified: 2015-06-04
#

use strict;

# First, we take the message argument from the command line.

my $commit_message = shift;

if ($commit_message =~ "-h" || $commit_message =~ "--help"){
    &show_usage;
}

# Directly getting argv should work right.
# Also ensure it completed correctly.
`git commit -m "$commit_message" @ARGV` || die("Commit failed with status $?!\n");

# If we committed, push the commit to the remote master.
# Also, make sure it succeeds.
`git push` || die("Push failed with status $?!\n");

#
# show_usage
#
# This function prints the usage information for this script, then exits.
#
sub show_usage{
    print "Usage: $0 [message] [files]\n";
    print "       $0 [-h|--help]\n";
    print "    [message] is the commit message for the commit\n";
    print "    [files] is the list of files (separated by spaces) that are part of the commit.\n";
    print "    [-h] and [--help] print this usage information and exit.\n";
    exit;
}
