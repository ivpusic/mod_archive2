#!/bin/sh

if ./make.sh; then
  for mod in ebin/test/unit/*_test.beam; do
    if [ "$1" == "xml" ]; then
      erl -pa ebin -pa ebin/test/unit -noinput -s `basename $mod .beam` eunit_xml_report "." -s init stop
    else
      erl -pa ebin -pa ebin/test/unit -noinput -s `basename $mod .beam` test -s init stop
    fi
  done
else
  echo "Make failed!"
fi
