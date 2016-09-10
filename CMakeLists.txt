cmake_minimum_required(VERSION 2.8)
project( book-db-lite )
set(VERSION 0.0-pre-alpha)
find_library( sqlite3 libsqlite3.so "/usr/lib" "/usr/local/lib" "/usr/lib/x86_64-linux-gnu" )
add_executable( book-db-lite src/db_access.c src/main.c src/db_upgrade.c )
target_link_libraries( book-db-lite sqlite3 )

# Since there doesn't appear to be a built-in way to install a manpage, do it the hard way
# but only do it in linux and bsd
if (UNIX AND NOT APPLE)
    # TODO: Should this be its own build target?
    add_custom_command(
	TARGET book-db-lite
	POST_BUILD
	COMMAND sudo sh install_manpage.sh
    )
endif()
