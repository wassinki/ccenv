#!/bin/sh

# Create a directory where you could manipulate the jar’s contents.
mkdir ./selenium101
# Copy your selenium-server.jar file in the newly created directory and cd into it.
cp $1 ./selenium101/.
cd ./selenium101

# Unzip the jar files contents here and delete the jar file.
unzip -q $1
rm $1
# First find all the *.rdf files – you should see 5 of them:

find . -name "*.rdf" | xargs sed -i "s/<em:maxVersion>.*<\/em:maxVersion>/<em:maxVersion>$2<\/em:maxVersion>/g"

#./customProfileDirCUSTFF/extensions/{538F0036-F358-4f84-A764-89FB437166B4}/install.rdf
#./customProfileDirCUSTFF/extensions/readystate@openqa.org/install.rdf
#./customProfileDirCUSTFFCHROME/extensions/{503A0CD4-EDC8-489b-853B-19E0BAA8F0A4}/install.rdf
#./customProfileDirCUSTFFCHROME/extensions/{538F0036-F358-4f84-A764-89FB437166B4}/install.rdf
#./customProfileDirCUSTFFCHROME/extensions/readystate@openqa.org/install.rdf

# In each of these files you will see
# <em:maxVersion>.*</em:maxVersion>/<em:maxVersion>$2</em:maxVersion>
# all the files are now patched. To jar them back up run the following steps:
zip -q -r selenium-server *
mv selenium-server.zip ../$1.$2.jar
cd ..
rm -rf ./selenium101
