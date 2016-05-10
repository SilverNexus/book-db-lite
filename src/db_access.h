/**
 * @file db_access.h
 * Defines several database-related constants and function prototypes.
 */

#ifndef DB_ACCESS_H
#define DB_ACCESS_H

#include <sqlite3.h>
#include "book.h"

/*
 * Define the schema version.
 * This should always be an integer and should never be decreased.
 */
#define DB_SCHEMA_VERSION 1

/*
 * Function prototypes
 */

int add(sqlite3 *db, const book * const book_info);

int remove(sqlite3 *db, const book * const book_info);

// An enum for the search function.
typedef enum {
    FIELD_TITLE = 1,
    FIELD_AUTHOR,
    FIELD_OWNER,
    FIELD_BINDING,
    FIELD_YEAR,
    FIELD_ISBN,
    FIELD_GENRE
} fields;

int search(sqlite3 *db, fields search_field, const char * const search_text);

#endif
