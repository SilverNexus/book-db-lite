#!/usr/bin/perl

#
# This program provides a command-line interface to a database for storing
# book information. It provides mechanisms to differentiate owners, book
# backing type (hardcover or softcover) and more.
#
# Author: Daniel Hawkins
# Last Modified: 2015-06-05
#

use strict;
use DBD::SQLite;

my $SCHEMA_VERSION = "0.0.1";
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
# Note: This method expects the database connection to already have been established.
#
sub initialize_db{
    my $export;
    do{
        print "Would you like to export any existing data in the table to a csv file (Y/N)? ";
        # TODO: Read input from the user.
    } while ($export != /[YyNn]/);
    if ($export =~ /[Yy]/){
        &export_data;
    }
    # By doing a drop and create, we can use this to update the schema
    eval {
        $dbh->begin_work();
        # Drop existing tables
        $dbh->do("DROP TABLE *");
        # Recreate the tables.
        # Make sure to create these in an order that allows for foreign key constraints to be applied.
        $dbh->do("CREATE TABLE Type (
                    TypeID integer PRIMARY KEY NOT NULL,
                    TypeName text
                  );");
        $dbh->do("CREATE TABLE Book (
                    BookID integer NOT NULL,
                    Title text NOT NULL,
                    Subtitle text,
                    Year integer,
                    TypeID integer NOT NULL,
                    ISBN text,
                    FOREIGN KEY TypeID REFERENCES Type(TypeID)
                  );");
        $dbh->do("CREATE TABLE Author (
                    AuthorID integer PRIMARY KEY NOT NULL,
                    AuthorLast text NOT NULL,
                    AuthorFirst text NOT NULL,
                    AuthorMiddle text
                  );");
        $dbh->do("CREATE TABLE BookAuthor (
                    BookID integer NOT NULL,
                    AuthorID integer NOT NULL,
                    AuthorOrder integer,
                    PRIMARY KEY(BookID, AuthorID),
                    FOREIGN KEY BookID REFERENCES Book(BookID),
                    FOREIGN KEY AuthorID REFERENCES Author(AuthorID)
                  );");
        $dbh->do("CREATE TABLE Genre (
                    GenreID integer PRIMARY KEY NOT NULL,
                    GenreName text NOT NULL
                  );");
        $dbh->do("CREATE TABLE BookGenre (
                    BookID integer NOT NULL,
                    GenreID integer NOT NULL,
                    PRIMARY KEY (BookID, GenreID),
                    FOREIGN KEY BookID REFERENCES Book(BookID),
                    FOREIGN KEY GenreID REFERENCES Genre(GenreID)
                  );");
        $dbh->do("CREATE TABLE Owner (
                    OwnerID integer PRIMARY KEY NOT NULL,
                    OwnerLast text NOT NULL.
                    OwnerFirst text NOT NULL
                  );");
        $dbh->do("CREATE TABLE BookOwner (
                    BookID integer NOT NULL,
                    OwnerID integer NOT NULL,
                    Quantity integer NOT NULL.
                    PRIMARY KEY (BookID, OwnerID),
                    FOREIGN KEY BookID REFERENCES Book(BookID),
                    FOREIGN KEY OwnerID REFERENCES Owner(OwnerID)
                  );");
        $dbh->do("CREATE TABLE Version(SchemaVersion text NOT NULL);");
        
        # Now set up some initial values
        
        # First we define the schema version
        $dbh->do("INSERT INTO Version VALUES (?);", undef, $SCHEMA_VERSION);
        
        # Then we set the book types to hardcover and softcover
        $dbh->do("INSERT INTO Type VALUES (?, ?);", undef, 1, "Hardcover");
        $dbh->do("INSERT INTO Type VALUES (?, ?);", undef, 2, "Softcover");
        
        # Commit the transaction
        $dbh->commit();
    };
    
    # If errors were encountered, the roll back and abort reset
    if ($@){
        print "Errors occurred while trying to initialize database.\n";
        print "Message: $DBI::errstr.\n";
        $dbh->rollback();
    }
}

#
# load_db
#
# Opens the database for read/write, and loads the pcre extension into the db.
#
sub load_db{
    $dbh = DBI->connect("dbi:SQLite:dbname=$db_name","","",\%attr)
        or die ("Failed to connect to database at $db_name.");
    # Enforce foreign keys
    $dbh->do("PRAGMA foreign_keys = ON;");
    # TODO: Load SQLite Regex extension
    
    # TODO: Check to see if db needs initialization. (Check for table Version).
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
