#!/bin/sh

for i in $(seq 130 800); do
  filelist=$(seq -f "file-%03.0f.cpp" 1; seq -f "    file-%03.0f.cpp" 2 $i)

  cat > bar/jamfile.v2 << __EOT__
project bar
  : requirements
    <include>.
  : source-location .
  : usage-requirements
    <include>.
  ;

lib bar
  : ${filelist}
  : <link>shared
  ;
__EOT__

  rm -rf bin foo/bin bar/bin

  if ( cd foo && b2 address-model=64 > run-$i.log); then
    echo "GOOD: $i"
  else
    echo "FAIL: $i"
    exit 1
  fi
done
