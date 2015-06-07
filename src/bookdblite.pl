#!/usr/bin/perl

#
# This program provides a command-line interface to a database for storing
# book information. It provides mechanisms to differentiate owners, book
# backing type (hardcover or softcover) and more.
#
# Author: Daniel Hawkins
# Last Modified: 2015-06-06
#

use strict;
use DBD::SQLite;

my $SCHEMA_VERSION = "0.0.1";
my $VERSION = "0.0.0-dev";

my $db_loc;
my $dbh;

my %attr = (
    RaiseError => 1,
    Autocommit => 0
);

# Parse the arguments passed to the program.
&parse_args;

# Load the database from the specified location.
&load_db;

&main_menu;

# Close the database connection. All non-temrinating code paths should leave it open up to here.
$dbh->disconnect();

#
# Functions
#

#
# yes_no_prompt
#
# Provides a consistent mechanism to give the user yes/no prompts.
#
# @param message The message to prompt the user with.
# Should be formatted as the user should see it.
#
# @return y or Y if yes, n or N if no
#
sub yes_no_prompt{
    if ($#_ ne 1){
        # Make sure to close the DB connection before terminating
        $dbh->disconnect();
        die("yes_no_prompt called with wrong number of parameters!\nExpected 1, got $#_.");
    }
    my $val;
    do{
        print "$_[0]";
        $val = <STDIN>;
    } while ($val != /^[YyNn]/);
    return $val;
}

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
    my $export = yes_no_prompt("Would you like to export any existing data in the table to a csv file (Y/N)? ");
    if ($export =~ /^[Yy]/){
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
                    OwnerFirst text NOT NULL,
                    OwnerMiddle text
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
    my $pcre_loc;
    # Try to open the file -- it should have been created from the install script
    my $loc_file = open(PCRE, "< ../etc/bookdblite_pcre_loc")
        || die ("Could not find file that tells where pcre library is located.");
    # Theoretically, there should only be one line in this file
    # If there's more, let's just use the first only.
    $pcre_loc = <PCRE>;
    # Close the file
    close(PCRE);
    # Remove trailing whitespace (there's at least a newline)
    chomp($pcre_loc);
    # Now we can load the database
    $dbh = DBI->connect("dbi:SQLite:dbname=$db_loc","","",\%attr)
        or die ("Failed to connect to database at $db_loc.");
    # Enforce foreign keys
    $dbh->do("PRAGMA foreign_keys = ON;");
    # Load SQLite Regex extension
    $dbh->do("SELECT load_extension('$pcre_loc');");
    # Check to see if db needs initialization. (Check for table Version).
    eval{
        my $vth = $dbh->prepare("SELECT SchemaVersion FROM Version;");
        my $result = $vth->execute();
        my $rownum = 0;
        while (my @row = $vth->fetchrow_array()){
            # If multiple rows in version, something's not right.
            if (++$rownum gt 1){
                print "Database $db_loc appears to be malformed.\n";
                my $sel = yes_no_prompt("Would you like to reinitialize the book database (Y/N)? ");
                if ($sel =~ /^[Yy]/){
                    &initialize_db;
                }
            }
            # If schema version is too old, ask to update.
            elsif ($row[0] < $SCHEMA_VERSION){
                print "Your book database may be out of date.\n";
                print "New versions of the database provide addtional features and optimizations.\n";
                print "Declining the upgrade will not affect program operation.\n";
                my $sel = yes_no_prompt("Would you like to update your database schema to a newer version (Y/N)? ");
                if ($sel =~ /^[Yy]/){
                    &initialize_db;
                }
            }
            # If schema version is too new, then don't even try to handle it.
            elsif ($row[0] > $SCHEMA_VERSION){
                print "Your database has a schema newer than this version of this program supports.\n";
                print "Please upgrade to a newer version to use this book database.\n";
                $dbh->disconnect();
                exit 1;
            }
        }
    };
    
    if ($@){
        print "Your database does not seem to be initialized.\n";
        print "You must initialize the database if you wish to use it.\n";
        my $sel = yes_no_prompt("Would you like to initialize the database (Y/N)? ");
        if ($sel =~ /^[Yy]/){
            &initialize_db;
        }
        else{
            $dbh->disconnect();
            exit;
        }
    }
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
    while ($selection != "6"){
        print "Main Menu\n";
        print " 1. Add a Book\n";
        print " 2. Remove a Book\n";
        print " 3. Perform a Query\n";
        print " 4. Import Data from CSV\n";
        print " 5. Export Data to CSV\n";
        print " 6. Exit\n";
        print "\nEnter your selection: ";
        # read selection from keyboard
        $selection = <STDIN>;
        # Remove trailing newline
        chomp($selection);
        if ($selection =~ "1"){
            &add_book;
        }
        elsif ($selection =~ "2"){
            &remove_book;
        }
        elsif ($selection =~ "3"){
            &query;
        }
        elsif ($selection =~ "4"){
            &import_csv;
        }
        elsif ($selection =~ "5"){
            &export_data;
        }
    }
}

#
# add_book
#
# Prompts the user to input required information,
# then gives the option to add additional information.
# When the user has supplied all desired data,
# adds records to the appropriate table(s).
#
sub add_book{
    # Store the book's data in a hashtable while we are gathering it.
    my %bookdata;
    # Start by gathering required information.
    print "Author's last name (first author if multiple authors): ";
    $bookdata{"Author.AuthorLast"} = <STDIN>;
    print "Author's first name: ";
    $bookdata{"Author.AuthorFirst"} = <STDIN>;
    print "Title of Book: ";
    $bookdata{"Book.Title"} = <STDIN>;
    # Query the database for book types
    my $vth;
    eval {
        $vth = $dbh->prepare("SELECT TypeID, TypeName FROM Type");
        $vth->execute();
    };
    # If we failed to fetch the type data, exit.
    if ($@){
        print "Failed to collect binding types, exiting.\n";
        $dbh->disconnect();
        exit 1;
    }
    print "Choose a book binding: ";
    # Store the valid IDs in an array
    my @opts;
    while (my @row = $vth->fetchrow_array()){
        print "  $row[0]. $row[1]\n";
        push(@opts, $row[0]);
    }
    my $sel;
    my $valid = 0;
    # Prompt the user to pick one of the types available.
    do{
        print "Enter your selection: ";
        $sel = <STDIN>;
        # Make sure the selection is valid.
        foreach my $element (@opts){
            $valid = 1 if ($sel =~ $element);
        }
    } while ($valid eq 0);
    $bookdata{"Book.TypeID"} = $sel;
    # Prompt the user for an owner.
    print "Owner's last name: ";
    $bookdata{"Owner.OwnerLast"} = <STDIN>;
    print "Owner's first name: ";
    $bookdata{"Owner.OwnerFirst"} = <STDIN>;
    # Give the entered data back to the user.
    print "Book: $bookdata{'Book.Title'}\n";
    print "Author: $bookdata{'Author.AuthorFirst'} $bookdata{'Author.AuthorLast'}\n";
    print "Owner: $bookdata{'Owner.OwnerFirst'} $bookdata{'Owner.OwnerLast'}\n\n";
    # Ask the user if he/she would like to add more data to the entry
    my $more = yes_no_prompt("Would you like to add more data to the entry (Y/N)? ");
    while ($more =~ /[Yy]/){
        # TODO: Implement additional data field entry system.
        
        # This is temporary to prevent an infinite loop
        $more = "n";
    }
    # Some sanity checks to ensure accurate entry
    # First, make sure no more than one author matches the author name
    eval{
        # TODO: Make this handle multiple authors in a book
        # TODO: Make this handle a specified middle name for author
        my $vth = $dbh->do(
            "SELECT AuthorID, AuthorFirst, AuthorMiddle, AuthorLast FROM Author " +
            "WHERE AuthorFirst=? AND AuthorLast=?;", undef,
            $bookdata{'Author.AuthorFirst'}, $bookdata{'Author.AuthorLast'}
        );
        $vth->execute();
        my $resultcount = 0;
        my @ids;
        my @firstnames;
        my @middlenames;
        my @lastnames;
        while (my @row = $vth->fetchrow_array()){
            ++$resultcount;
            push(@ids, $row[0]);
            push(@firstnames, $row[1]);
            push(@middlenames, $row[2]);
            push(@lastnames, $row[3]);
        }
        # Now that we have all the data, check for the right values.
        if ($resultcount gt 1){
            # If more than one result, prompt the user to choose an author.
            print "More than one author matches name $bookdata{'Author.AuthorFirst'}, $bookdata{'Author.AuthorLast'}!\n";
            print "Please select one of the following options:";
            # Since we have more than one row, we can check for more rows at the end
            my $index = 0;
            do{
                print "  "+ ($index + 1) + ". $firstnames[$index] ";
                print "$middlenames[$index] " if ($middlenames[$index]);
                print "$lastnames[$index]\n";
            } while (++$index < $resultcount);
            # Give the option to add a new author
            print "  " + ($index + 1) + ". Add as a new author\n";
            # Give the user a selection prompt
            do{
                print "Enter your selection: ";
                my $sel = <STDIN>;
                chomp($sel);
            } while ($sel < "1" || $sel > "" + ($index + 1) + "");
            # Then find the appropriate author and store the ID.
            # If we are adding a new author, do not store an ID.
            if (--$sel < $resultcount){
                $bookdata{"Author.AuthorID"} = $ids[$sel];
                # We no longer need author first and last, so unset them
                delete $bookdata{"Author.AuthorLast"};
                delete $bookdata{"Author.AuthorFirst"};
            }
        }
        # If we have one match, then that is the one we use.
        elsif ($resultcount eq 1){
            $bookdata{"Author.AuthorID"} = $ids[0];
            # We no longer need author first and last, so unset them
            delete $bookdata{"Author.AuthorLast"};
            delete $bookdata{"Author.AuthorFirst"};
        }
    };
    # Bail if an error happened
    if ($@){
        print "An error occurred accessing $db_loc, terminating.\n";
        $dbh->disconnect();
        exit 1;
    }
    # TODO: Next, we check the owner for matches
    
    # TODO: Finish implementation
}

#
# remove_book
#
# Prompts the user to select a book to remove from the database.
# Removes the book and all references in the bridge tables.
#
sub remove_book{
    # TODO: Implement
}

#
# query
#
# Allows the user to query the database for information.
# It will provide the option to export the results to a csv file.
#
# NOTE: The export feature for the query results is not designed to be
# used as a database backup. It loses the database structure in it's results.
#
sub query{
    # TODO: Implement
}

#
# import_csv
#
# Allows for a set of csv files from an export of the database to be imported
# into the database. Integral to database schema upgrades.
#
sub import_csv{
    # TODO: Implement
}

#
# export_data
#
# Exports the data in the database to a csv file.
# This allows for the data to either be imported into another application or
# transformed to a newer version of this program's schema.
# If nothing else, it allows for the data to be backed up in case of upgrade failure.
#
sub export_data{
    # TODO: Create a folder for the exported csv files to be stored
    
    # TODO: For each table in the database, SELECT all data.
    
    # TODO: Print a field name row to the csv file.
    
    # TODO: Output each row of the table to its corresponding csv file.
    
}
