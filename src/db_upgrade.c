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
 * @file db_upgrade.c
 * Contains the schema upgrade path to ensure proper upgrades of the db.
 */

#include <sqlite3.h>
#include "db_access.h"

/**
 * Upgrades the schema from an old version to the new version.
 *
 * @param old_version
 * The schema version of the detected database.
 * Assumed to be less than DB_SCHEMA_VERSION.
 *
 * @retval 0
 * Upgrade successful
 *
 * @retval -1
 * Upgrade failed
 *
 * @note It is assumed that db is already open when this function is reached.
 */
int db_upgrade(int old_version){
    // Use a switch statement with fallthrough for upgrade.
    switch (old_version){
	// There are no upgrades at this time.
    }
    return 0;
}
