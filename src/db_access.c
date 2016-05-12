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
 * @file db_access.c
 * Defines functions to consistently interface with the database.
 */

#include <sqlite3.h>
#include "book.h"
#include "db_access.h"

/**
 * Adds an entry to the database for the book specified in the arguments.
 *
 * @param db
 * Reference to the current database
 *
 * @param book_info
 * Reference to the book structure to add
 *
 * @retval 0
 * Add was successful
 *
 * @retval -1
 * Add failed
 */
int add(sqlite3 *db, const book * const book_info){
    if (!db)
	return -1;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, "SELECT DISTINCT Book.BookID FROM Book"
    " JOIN Printing ON Book.BookID = Printing.BookID"
    " WHERE Title = ? AND Year = ? AND ISBN = ?", -1, &stmt, 0) != SQLITE_OK){
	// TODO: Determine whether this should print an error message.
	return -1;
    }
    if (sqlite3_bind_text(stmt, 1, book_info->title, -1, 0) != SQLITE_OK){
	return -1;
    }
    if (sqlite3_bind_int(stmt, 2, book_info->year) != SQLITE_OK){
	return -1;
    }
    if (sqlite3_bind_text(stmt, 3, book_info->ISBN, -1, 0) != SQLITE_OK){
	return -1;
    }
    // Unallocated array of book ids.
    int *book_id_list = 0;
    unsigned int id_list_len = 0;
    int result;
    while ((result = sqlite3_step(stmt)) == SQLITE_ROW){
	// We really only want one book. If we can't disambiguate, try harder in other tables.
	// TODO: This is not efficient, since we keep reallocing every time.
	book_id_list = realloc(book_id_list, sizeof(int) * ++id_list_len);
	book_id_list[id_list_len - 1] = sqlite3_column_int(stmt, 0);
    }
    sqlite3_finalize(stmt);
    if (result != SQLITE_DONE)
	return -1;
    if (id_list_len > 1){
	// TODO: Disambiguate

	// Keep performing result narrowing until one result remains.
	// TODO: More checks
    }

    // Okay, we have exactly one book, now we find the appropriate owner
    // TODO: Implement

    // With the appropriate owner, we add to the quantity.

    // TODO: Implement
    return -1;
}

/**
 * Removes a specified quantity of a book from one owner.
 *
 * @param db
 * The database connection we are using
 *
 * @param book_info
 * The book we wish to remove one from
 *
 * @retval 0
 * Removal completed successfully
 *
 * @retval -1
 * Removal failed
 */
int remove(sqlite3 *db, const book * const book_info){
    if (!db)
	return -1;
    // TODO: Implement
    return -1;
}

// Parallel array for the field name
static const char * const field_name[] = {
    "Title",
    "Author",
    "Owner",
    "TypeName",
    "Year",
    "ISBN",
    "Genre"
};

// Parallel array for the table the field is in.
static const char * const table_name[] = {
    "Book",
    "Author",
    "Owner",
    "Type",
    "Book",
    "Book",
    "Genre"
};

/**
 * Search using a given field
 *
 * @param db
 * The database we are using
 *
 * @param search_field
 * The field we will search for results
 *
 * @param search_text
 * The text we will search for in the specified field
 *
 * @todo
 * In which way do I intend to give back results?
 */
int search(sqlite3 *db, fields search_field, const char * const search_text){
    if (!db)
	return -1;
    // TODO: Implement
    return -1;
}

/**
 * Create a new book database.
 *
 * @param db
 * Reference to the database being created.
 *
 * @retval 0
 * Successfully created the database.
 *
 * @retval -1
 * Failed to create the database.
 */
int new_db(sqlite3 *db){
    if (!db)
	return -1;
    sqlite3_stmt *stmt;
    // TODO: Make this a transaction

    // Table creation.

    // Book
    if (sqlite3_prepare_v2(db, "CREATE TABLE Book("
	"BookID   INTEGER PRIMARY KEY,"
	"Title    TEXT NOT NULL,"
	"Subtitle TEXT)", -1, &stmt, 0) != SQLITE_OK)
	  return -1;
    if (sqlite3_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // Owner
    if (sqlite3_prepare_v2(db, "CREATE TABLE Owner("
	"OwnerID     INTEGER PRIMARY KEY,"
	"OwnerLast   TEXT NOT NULL,"
	"OwnerFirst  TEXT NOT NULL,"
	"OwnerMiddle TEXT,"
	"OwnerSuffix TEXT)", -1, &stmt, 0) != SQLITE_OK)
	  return -1;
    if (sqlite3_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // Type
    if (sqlite3_prepare_v2(db, "CREATE TABLE Type("
	"TypeID   INTEGER PRIMARY KEY,"
	"TypeName TEXT NOT NULL)", -1, &stmt, 0) != SQLITE_OK)
	  return -1;
    if (sqlite3_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // Genre
    if (sqlite3_prepare_v2(db, "CREATE TABLE Genre("
	"GenreID   INTEGER PRIMARY KEY,"
	"GenreName TEXT NOT NULL)", -1, &stmt, 0) != SQLITE_OK)
	  return -1;
    if (sqlite3_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // Author
    if (sqlite3_prepare_v2(db, "CREATE_TABLE Author("
	"AuthorID     INTEGER PRIMARY KEY,"
	"AuthorLast   TEXT NOT NULL,"
	"AuthorFirst  TEXT NOT NULL,"
	"AuthorMiddle TEXT,"
	"AuthorSuffix TEXT)", -1, &stmt, 0) != SQLITE_OK)
	  return -1;
    if (sqlite_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // Printing
    if (sqlite3_prepare_v2(db, "CREATE TABLE Printing("
	"PrintingID  INTEGER PRIMARY KEY,"
	"BookID      INTEGER REFERENCES Book(BookID),"
	"ISBN        TEXT,"
	"Year        INTEGER,"
	"TypeID      INTEGER REFERENCES Type(TypeID),"
	"PrintingNum INTEGER)", -1, &stmt, 0) != SQLITE_OK)
	  return -1;
    if (sqlite_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // BookOwner
    if (sqlite3_prepare_v2("CREATE TABLE BookOwner("
	"PrintingID INTEGER REFERENCES Printing(PrintingID),"
	"OwnerID    INTEGER REFERENCES Owner(OwnerID),"
	"Quantity   INTEGER NOT NULL),"
	"PRIMARY KEY(PrintingID, OwnerID))", -1, &stmt, 0) != SQLITE_OK)
	  return -1;
    if (sqlite3_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // BookGenre
    if (sqlite3_prepare_v2("CREATE TABLE BookGenre("
	"BookID  INTEGER REFERENCES Book(BookID),"
	"GenreID INTEGER REFERENCES Genre(GenreID),"
	"PRIMARY KEY(BookID, GenreID))", -1, &stmt, 0) != SQLITE_OK)
	  return -1;
    if (sqlite3_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // BookAuthor
    if (sqlite3_prepare_v2("CREATE TABLE BookAuthor("
	"BookID      INTEGER REFERENCES Book(BookID),"
	"AuthorID    INTEGER REFERENCES Author(AuthorID),"
	"AuthorOrder INTEGER,"
	"PRIMARY KEY(BookID, AuthorID))", -1, &stmt, 0) != SQLITE_OK)
	  return -1;
    if (sqlite3_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // Version
    if (sqlite3_prepare("CREATE TABLE Version("
	"SchemaVersion INTEGER NOT NULL)", -1, &stmt, 0) != SQLIE_OK)
	  return -1;
    if (sqlite3_step(stmt) != SQLITE_DONE)
	return -1;
    sqlite3_finalize(stmt);

    // Now we add the initial data

    // First, add the schema version
    // TODO: Implement
}
