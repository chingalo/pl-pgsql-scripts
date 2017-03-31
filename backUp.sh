#!/bin/bash
rm backup.7z
/usr/bin/pg_dump --host localhost --format plain --verbose --username ards --file '/home/chingalo/backup.sql' ards_upgrade
7z a -mx9 -t7z -mmt backup.7z backup.sql 
rm backup.sql
