#!/bin/bash

################################
# This script formats the files for processing by removing the first line movie_id:
# and adding it to each row in the file as the first column
################################

OUTPUT_DIR=../training_mod/
INPUT_FILES=*.txt

for f in $INPUT_FILES
do
  echo "Processing $f file..."
  movie_id=$(head -n 1 $f)
  movie_id="${movie_id/:/}"
  replacement_string="s/^/$movie_id,/"
  sed -e $replacement_string  $f | awk '{if(NR>1)print}' > $OUTPUT_DIR$f
  
  # take action on each file. $f store current file name
  #cat $f
done

