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
int add(const char * const title, const char * const author, int year,
  const char * const owner_name, const char * const genre,
  const char * const binding_type, const char * const isbn){
    // TODO: Implement
    return -1;
}
