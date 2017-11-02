#!/bin/sh

# Get a list of all files in the project that we want to change
# and save in a temporary file /tmp/x
# 
# We will then use /tmp/x as the set of files to be changes

find . -type f -print | \
        grep -iv "/assets/"  | \
        grep -iv "/bin/" | \
        grep -iv "change.sh" | \
        grep -iv "change_files.sh" | \
        grep -iv ".doc$" | \
        grep -iv ".docx$" | \
        grep -iv ".gif$" | \
        grep -iv ".gitignore" | \
        grep -iv ".git/" | \
        grep -iv ".ico$" | \
        grep -iv ".jpg$" | \
        grep -iv ".keep$" | \
        grep -iv "/logs/"  | \
        grep -iv "/pids/"  | \
        grep -iv "/public/robots.txt"  | \
        grep -iv "/public/uploads/"  | \
        grep -iv ".png$"  | \
        grep -iv "rails.err"  | \
        grep -iv "rails.log"  | \
        grep -iv "sqlite3"  | \
        grep -iv "/tools_ajh/"  | \
        grep -iv "/tools/"  | \
        grep -iv "/tmp/"  | \
        grep -iv ".swp$" > /tmp/x

