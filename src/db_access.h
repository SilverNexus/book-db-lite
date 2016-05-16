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
 * Also, but the database pointer declaration out here.
 * It is needed for close_db() to work in atexit().
 */
extern sqlite3 *db;

/*
 * Function prototypes
 */

int add(sqlite3 *db, const book * const book_info);

int remove_book(sqlite3 *db, const book * const book_info);

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

int new_db(sqlite3 *db);

int open_db(const char * const path);

void close_db();

/* db_upgrade.c */
int db_upgrade(int old_version);

#endif
