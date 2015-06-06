#!/bin/bash

#
# Note: This install script should be run as root to allow for this to
# be copied to /usr/local/bin.
#
# Author: Daniel Hawkins
# Last Modified: 2015-06-05
#

# We need sqlite3-pcre to work, so check for it.
# We use find so that if it were to be installed in a nonstandard location,
# we can still find it. If the name has been changed, well, good luck then.
find /usr -name "pcre.so" > /usr/local/etc/bookdblite_pcre_loc
if [ $? != 0 ]; then
    echo "Failed to find pcre.so and store the result in /usr/local/etc."
    echo "Make sure sqlite3-pcre is installed and you are running this script as root."
    exit
fi

# Copy the perl script
cp src/bookdblite.pl /usr/local/bin/bookdblite.pl
if [ $? != 0 ]; then
    echo "Failed to copy bookdblite.pl to /usr/local/bin."
    echo "Are you running as root?"
    exit
fi
# Add a link so we can run with or with file extension
ln -s /usr/local/bin/bookdblite.pl /usr/local/bin/bookdblite
