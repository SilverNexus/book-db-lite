#!/bin/bash

#
# Note: This install script should be run as root to allow for this to
# be copied to /usr/local/bin
#
# Author: Daniel Hawkins
# Last Modified: 2015-06-03
#

cp src/bookdblite.pl /usr/local/bookdblite.pl
if [ $? != 0 ]; then
    echo "Failed to copy bookdblite.pl to /usr/local."
    echo "Are you running as root?"
    exit
fi
# Add a link so we can run with or with file extension
ln -s /usr/local/bookdblite.pl /usr/local/bookdblite
