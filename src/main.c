/*
    BookDBLite, a book database management solution using SQLite.
    Copyright (C) 2015-2016  SilverNexus

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

/**
 * @file main.c
 * Houses the main entry point for the program.
 * Also handles argument parsing and database open/close.
 */

#include <sqlite3.h>
#include <stdio.h>
#include <stdlib.h>
#include "db_access.h"

static inline void print_help(){
    puts("You must provide the name of the database you wish to load.");
    exit(0);
}

static sqlite3 *db;

static void close_db(){
    sqlite3_close_v2(db);
}

int main(int argc, const char * const *argv){
    if (argc >= 2){
	print_help();
    }
    if (argc == 1){
	// argv[1] is the db path
	int result = sqlite3_open_v2(argv[1], &db, SQLITE_OPEN_READWRITE, 0);
	// Register a function to close the db on exit.
	// This is before the result check since we need to close the db even if we fail.
	atexit(close_db);
	if (result != SQLITE_OK){
	    printf("Failed to open database at %s.\n", argv[1]);
	    // Exit with a failure status
	    exit(1);
	}
    }
    else{
	// Give the user the choice of creating a new db or loading an existing one.
	// Use a GUI window for this.

	// TODO: Implement
    }
    // TODO: Finish initializing and begin implementing
    return 0;
}
