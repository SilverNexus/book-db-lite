#!/usr/bin/perl

#
# This program provides a command-line interface to a database for storing
# book information. It provides mechanisms to differentiate owners, book
# backing type (hardcover or softcover) and more.
#
# Author: Daniel Hawkins
# Last Modified: 2015-06-03
#

use strict;
use DBD::SQLite3;

my VERSION = "0.0.0-dev";

my db_loc;

# Parse the arguments passed to the program.
&parse_args;

&main_menu;

#
# Functions
#

#
# parse_args
#
# Takes the arguments passed to the program and parses them.
# Handles help and version requests, as well as normal usage.
#
sub parse_args{
    #TODO: Actually parse the args.
    
}

sub usage_info{
    print "Usage: bookdblite [FLAGS] [path to db]\n";
    print "\n";
    print "Valid flags:\n";
    
    exit;
}

#
# initialize_db
#
# Initializes the database at the location in db_loc
# to a fresh database with empty tables.
#
sub initialize_db{
    
}

sub main_menu{
    my selection = 0;
    # The main menu will repeat until we exit
    while (selection != '4'){
        print "Main Menu\n";
        print " 1. Add a Book\n";
        print " 2. Remove a Book\n";
        print " 3. Perform a Query\n";
        print " 4. Exit\n"
        print "\nEnter your selection: ";
        read selection;
    }
    exit;
}
