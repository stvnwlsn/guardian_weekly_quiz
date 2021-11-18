#!/usr/bin/bash

while read line; do
  firefox --new-tab "$line"
done < skipped.txt
