#! /bin/bash

find books -type d | while read i; 
  do echo $i;
  IND="$i"/index.html;
  echo $IND;
  ./Listing "$i" > "$IND";
  done

