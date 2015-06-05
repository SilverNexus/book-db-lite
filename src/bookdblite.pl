#!/usr/bin/perl

#
# This program provides a command-line interface to a database for storing
# book information. It provides mechanisms to differentiate owners, book
# backing type (hardcover or softcover) and more.
#
# Author: Daniel Hawkins
# Last Modified: 2015-06-04
#

use strict;
use DBD::SQLite;

my $VERSION = "0.0.0-dev";

my $db_loc;
my $dbh;

my %connection_attributes{
    RaiseError => 1,
    Autocommit => 0
};

# Parse the arguments passed to the program.
&parse_args;

# Load the database from the specified location.
&load_db;

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
    if ($#ARGV eq -1){
        print "Not enough arguments supplied to $0.\n";
        &usage_info;
    }
    my $tmp_arg;
    while ($#ARGV gt -1){
        $tmp_arg = shift(@ARGV);
        if ($tmp_arg =~ "-h" || $tmp_arg =~ "--help"){
            &usage_info;
        }
        elsif ($tmp_arg =~ "-v" || $tmp_arg =~ "--version"){
            &ver_info;
        }
        else{
            # Assume it is the database name.
            $db_loc = $tmp_arg;
        }
    }
}

#
# usage_info
#
# Prints the help information associated with the program and exits.
#
sub usage_info{
    print "Usage: $0 [FLAGS] [path to db]\n";
    print "\n";
    print "Valid flags:\n";
    print "    -h --help     Prints this usage information and exits.\n";
    print "    -v --version  Prints version information and exits.\n";
    
    exit;
}

#
# ver_info
#
# Prints the version info and exits the program.
#
sub ver_info{
    print "$0 $VERSION\n";
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

#
# load_db
#
# Opens the database for read/write, and loads the pcre extension into the db.
#
sub load_db{
    $dbh = DBI->connect("dbi:SQLite:dbname=$db_name","","",\%attr)
        or die ("Failed to connect to database at $db_name.");
    # TODO: Load SQLite Regex extension
    
    # TODO: Check to see if db needs initialization. (Check for table Book or something).
}

#
# main_menu
#
# Prints the main menu to the screen and waits for the user to select an option.
# Directs the user to the correct function given their selection.
#
sub main_menu{
    my $selection = "0";
    # The main menu will repeat until we exit
    while ($selection != "4"){
        print "Main Menu\n";
        print " 1. Add a Book\n";
        print " 2. Remove a Book\n";
        print " 3. Perform a Query\n";
        print " 4. Exit\n";
        print "\nEnter your selection: ";
        # read selection;
        
        # This is temporary so we don't get an infinite loop
        $selection = "4"
    }
    exit;
}
