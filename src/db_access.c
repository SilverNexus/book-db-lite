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

/**
 * Adds an entry to the database for the book specified in the arguments.
 *
 * @param db
 * Reference to the current database
 *
 * @param title
 * The title of the book
 *
 * @param author
 * The author of the book
 *
 * @param year
 * The year the book was published
 *
 * @param owner_name
 * The name of the book's owner
 *
 * @param genre
 * The book's genre
 *
 * @param binding_type
 * The book's binding type (e.g. softcover, hardcover)
 *
 * @param isbn
 * The ISBN of the book (prefer ISBN-13 over ISBN-10)
 *
 * @retval 0
 * Add was successful
 *
 * @retval -1
 * Add failed
 */
int add(sqlite3 *db, const char * const title, const char * const author,
  const int year, const char * const owner_name, const char * const genre,
  const char * const binding_type, const char * const isbn){
    if (!db)
	return -1;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, "SELECT BookID FROM Book WHERE Title = ? AND Year = ? AND ISBN = ?", -1, &stmt, 0) != SQLITE_OK){
	// TODO: Determine whether this should print an error message.
	return -1;
    }
    if (sqlite3_bind_text(stmt, 1, title, -1, 0) != SQLITE_OK){
	return -1;
    }
    if (sqlite3_bind_int(stmt, 2, year) != SQLITE_OK){
	return -1;
    }
    if (sqlite3_bind_text(stmt, 3, isbn, -1, 0) != SQLITE_OK){
	return -1;
    }
    // TODO: Implement
    return -1;
}

/**
 * Removes a specified quantity of a book from one owner.
 *
 * @param db
 * The database connection we are using
 *
 * @param title
 * The title of the book
 *
 * @param author
 * The author of the book
 *
 * @param owner_name
 * The name of the removed book's owner
 *
 * @param binding_type
 * The type of the book's binding
 *
 * @param quantity
 * The number of the book to remove
 *
 * @retval 0
 * Removal completed successfully
 *
 * @retval -1
 * Removal failed
 */
int remove(sqlite3 *db, const char * const title, const char * const author,
  const char * const owner_name, const char * const binding_type,
  unsigned int quantity){
    if (!db)
	return -1;
    // TODO: Implement
    return -1;
}

typedef enum {
    FIELD_TITLE = 1,
    FIELD_AUTHOR,
    FIELD_OWNER,
    FIELD_BINDING,
    FIELD_YEAR,
    FIELD_ISBN,
    FIELD_GENRE
} fields;

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
