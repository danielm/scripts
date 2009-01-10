#!/bin/sh
#
# release.sh - Create a release Tarball
#
# Copyright 2009 - Daniel Morales <daniel@daniel.com.uy>
#

# Present the installer
echo -e "\n--------------------------------------"
echo -e "- BLOGY RELEASE MANAGER"
echo -e "-"

# Get and store current revision
echo -en "* Looking for current version... "
revision=`LC_ALL=C svn info | awk '/^Revision: / {printf "%04d\n", $2}'`

# Parse the version
let tokenversion=$revision/100
let macroversion=$tokenversion/10
let microversion=$tokenversion%10
let buildversion=$revision-$[$macroversion*1000]-$[$microversion*100]
version="${macroversion}.${microversion}.${buildversion}"

echo -e "Found ${version}"

echo -en "* Discovering current dir... "
currentdir=`pwd`
echo -e "Found ${currentdir}"

# Save build version
echo -en "* Saving current version... "
cp config.inc.php config.inc.php.in
sed -e "s/@SVN_VERSION@/${version}/g" < "config.inc.php.in" > "config.inc.php"
echo -e "Done!"

# Create the tarball
compreso="blogy-r${revision}.tar.gz"
echo -en "* Creating the tarball... "
tar -czf "$compreso" --exclude='.svn' --exclude='.git' --exclude='release.sh' --exclude='TODO' --exclude='config.inc.php.in' *
echo -e "Done!"

# Reset the config
mv config.inc.php.in config.inc.php

echo -e "-"
echo -e "* ${compreso} is ready to release."
echo -e "-"
echo -e "--------------------------------------\n"
