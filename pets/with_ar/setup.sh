#!/bin/bash

db=vet_clinic3

dropdb $db
createdb $db

psql $db -f create_schema.sql
psql $db -f seeds.sql
psql $db -f print_data.sql
