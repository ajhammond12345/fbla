#!/bin/sh

# Given a file /tmp/x that contains a list of files to change
# we are going to change those files

cat /tmp/x | while read file
do
    echo "Processing $file"
    cat $file | sed -e "s/email_address/user_email_address/g" > /tmp/new_file
    mv /tmp/new_file $file
done


