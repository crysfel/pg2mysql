=======
pg2mysql - Data migration
========
A small ruby program to get the data from a PosgreSQL database and then generates a MySQL dump.

I wrote this program to migrate my data from Postgresql to MySQL, it basically generates a MYSQL dump file with the data only, it doesn't create tables, it just gets the data.

Using it
========
First you need to change your database credential in *confg/database.yml*, you will find an example in the *config* folder. Once you have defined the postgresql credentials run the following commands.

    $ bundle install
    $ ruby migrate.rb

This will generate a dump mysql file under the *dumps* folder, from there you can load your data to MySQL like this.

    $ mysql -u root -p yourdatabase < dumps/data-2014-02-24.sql

Again, this dump file only contains the data, so make sure the MySQL database contain the equivalent tables with the same columns.
