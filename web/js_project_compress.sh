#!/bin/bash

appURL="http://apps.facebook.com/danidevlocal/"
appID="000000000000000"
appChannel="//facebook.localhost/channel.html"

YUICOMPRESSOR='/home/daniel/bin/yuicompressor-2.4.7.jar'

echo -n "Mergeando templates... "
cat views/*.htm > views/template.html
sed -e 's/^[ \t]*//g' -i views/template.html
sed -e ':a;N;$!ba;s/\n//g' -i views/template.html
echo "OK"

echo -n "Creando index.php... "
copy=`cp index.html index.php`

if [ $? -gt 0 ]; then
  echo "ERROR!"
else
  echo "OK"
fi

echo -n "Seteando vars de la app... "
sed -i s@APP_URL@${appURL}@g index.php
sed -i s@APP_ID@${appID}@g index.php
sed -i s@APP_CHANNEL@${appChannel}@g index.php
echo "OK"

exit;

scriptsDir="js/core/"

jss=`find ${scriptsDir} -maxdepth 1 -type f -name "*.js"`

for file in $jss
do
  output=`echo $file | sed s/.js/.min.js/g`
  
  output=`echo $output | sed s@${scriptsDir}@${scriptsDir}min/@g`
  
  echo -n "Procesando $output... "
  
  java -jar $YUICOMPRESSOR $file -o $output
  
  if [ $? -gt 0 ]; then
    echo "ERROR!"
  else
    echo "OK"
  fi
done
